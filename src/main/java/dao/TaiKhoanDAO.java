package dao;

import entity.CuDan;
import entity.CanHo;
import entity.NhanVien;
import entity.TaiKhoan;
import util.JPAUtil;
import util.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * DAO quan ly tai khoan bang JPA / Hibernate 6 (Jakarta EE 10)
 */
public class TaiKhoanDAO {

    public TaiKhoan findById(Integer id) {
        if (id == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(TaiKhoan.class, id);
        } finally {
            em.close();
        }
    }

    public TaiKhoan findByTenDangNhap(String tenDangNhap) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<TaiKhoan> query = em.createQuery(
                "SELECT t FROM TaiKhoan t WHERE t.tenDangNhap = :ten", TaiKhoan.class);
            query.setParameter("ten", tenDangNhap);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<TaiKhoan> getAllAccounts() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT t FROM TaiKhoan t ORDER BY t.id DESC", TaiKhoan.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public boolean toggleAccountStatus(String tenDangNhap) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TaiKhoan tk = findByTenDangNhapEm(em, tenDangNhap);
            if (tk != null) {
                String current = tk.getTrangThaiHoatDong();
                tk.setTrangThaiHoatDong("HoatDong".equalsIgnoreCase(current) ? "Khoa" : "HoatDong");
                em.merge(tk);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean resetPassword(String tenDangNhap, String newPlainPassword) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TaiKhoan tk = findByTenDangNhapEm(em, tenDangNhap);
            if (tk != null) {
                // Generates a new BCrypt hash with random salt dynamically
                tk.setMatKhau(PasswordUtil.hash(newPlainPassword));
                em.merge(tk);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Tao tai khoan moi + tu dong sinh cuDan/nhanVien & cap nhat trangThai canHo trong cung transaction
     */
    public void createAccountFull(TaiKhoan tk, Integer maCanHo, String hoTen, String soDienThoai, String email, String loaiCuDan, String rawPassword) throws Exception {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            String vaiTro = tk.getVaiTro();
            String boPhanCode = tk.getBoPhanCode();

            // 1. Generate maTaiKhoan structured with 4-digit padding (cd_0001, nv_bv0001, bql_0001...)
            String prefix;
            if ("CD".equalsIgnoreCase(vaiTro)) {
                prefix = "cd_";
            } else if ("BQL".equalsIgnoreCase(vaiTro)) {
                prefix = "bql_";
            } else {
                String sub = "lt";
                if (boPhanCode != null) {
                    String bp = boPhanCode.toLowerCase();
                    if (bp.contains("baove") || bp.equals("bv")) sub = "bv";
                    else if (bp.contains("letan") || bp.equals("lt")) sub = "lt";
                    else if (bp.contains("ketoan") || bp.equals("kt")) sub = "kt";
                    else if (bp.contains("kythuat") || bp.equals("ktht") || bp.equals("nvkt")) sub = "ktht";
                    else sub = bp;
                }
                prefix = "nv_" + sub;
            }

            // Find maximum existing numeric sequence for this prefix
            List<String> existingCodes = em.createQuery(
                "SELECT t.maTaiKhoan FROM TaiKhoan t WHERE t.maTaiKhoan LIKE :pattern", String.class)
                .setParameter("pattern", prefix + "%")
                .getResultList();

            long maxSeq = 0;
            for (String code : existingCodes) {
                if (code != null && code.startsWith(prefix)) {
                    String numStr = code.substring(prefix.length());
                    try {
                        long seq = Long.parseLong(numStr);
                        if (seq > maxSeq) {
                            maxSeq = seq;
                        }
                    } catch (NumberFormatException ignored) {
                        // Skip unparseable legacy codes
                    }
                }
            }

            long nextSeq = maxSeq + 1;
            String candidateCode = prefix + String.format("%04d", nextSeq);

            // Ensure uniqueness of maTaiKhoan in DB as safety layer
            while (em.createQuery("SELECT COUNT(t) FROM TaiKhoan t WHERE t.maTaiKhoan = :mc", Long.class)
                     .setParameter("mc", candidateCode)
                     .getSingleResult() > 0) {
                nextSeq++;
                candidateCode = prefix + String.format("%04d", nextSeq);
            }

            tk.setMaTaiKhoan(candidateCode);

            if (tk.getTrangThaiHoatDong() == null || tk.getTrangThaiHoatDong().isEmpty()) {
                tk.setTrangThaiHoatDong("HoatDong");
            }

            // Always dynamically hash password with BCrypt (fresh salt)
            String passToHash = (rawPassword != null && !rawPassword.trim().isEmpty()) ? rawPassword.trim() : tk.getMatKhau();
            tk.setMatKhau(PasswordUtil.hash(passToHash));

            // Persist TaiKhoan
            em.persist(tk);
            em.flush();

            // 2. Persist CuDan if role CD
            if ("CD".equalsIgnoreCase(vaiTro)) {
                if (maCanHo != null && maCanHo > 0) {
                    Long countChuHo = em.createQuery("SELECT COUNT(c) FROM CuDan c WHERE c.maCanHo = :mch AND c.loaiCuDan = 'ChuHo'", Long.class)
                                        .setParameter("mch", maCanHo)
                                        .getSingleResult();
                    String finalLoaiCuDan = (countChuHo > 0 && "ChuHo".equalsIgnoreCase(loaiCuDan)) ? "KhachThue" : (loaiCuDan != null ? loaiCuDan : "ChuHo");

                    CuDan cd = new CuDan();
                    cd.setMaCanHo(maCanHo);
                    cd.setMaTaiKhoan(tk.getId());
                    cd.setHoTen(hoTen != null && !hoTen.trim().isEmpty() ? hoTen.trim() : "Cư dân " + tk.getTenDangNhap());
                    cd.setSoDienThoai(soDienThoai != null ? soDienThoai.trim() : null);
                    cd.setEmail(email != null ? email.trim() : null);
                    cd.setLoaiCuDan(finalLoaiCuDan);
                    cd.setTrangThai("DangO");

                    em.persist(cd);

                    // Update CanHo status to DangO
                    CanHo ch = em.find(CanHo.class, maCanHo);
                    if (ch != null) {
                        ch.setTrangThai("DangO");
                        em.merge(ch);
                    }
                }
            } else {
                // Persist NhanVien if role NV / BQL
                NhanVien nv = new NhanVien();
                nv.setMaTaiKhoan(tk.getId());
                nv.setHoTen(hoTen != null && !hoTen.trim().isEmpty() ? hoTen.trim() : tk.getTenDangNhap());
                nv.setSoDienThoai(soDienThoai != null ? soDienThoai.trim() : null);
                nv.setEmail(email != null ? email.trim() : null);
                nv.setBoPhan(boPhanCode != null ? boPhanCode : "BanQuanLy");

                em.persist(nv);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Loi createAccountFull trong TaiKhoanDAO: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<CuDan> getUnassignedCuDan() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM CuDan c WHERE c.maTaiKhoan IS NULL OR c.maTaiKhoan = 0", CuDan.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public List<NhanVien> getUnassignedNhanVien() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT n FROM NhanVien n WHERE n.maTaiKhoan IS NULL OR n.maTaiKhoan = 0", NhanVien.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    private TaiKhoan findByTenDangNhapEm(EntityManager em, String tenDangNhap) {
        try {
            TypedQuery<TaiKhoan> query = em.createQuery(
                "SELECT t FROM TaiKhoan t WHERE t.tenDangNhap = :ten", TaiKhoan.class);
            query.setParameter("ten", tenDangNhap);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
