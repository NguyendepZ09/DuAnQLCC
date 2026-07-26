package DAOs;

import Entities.CuDan;
import Entities.NhanVien;
import Entities.TaiKhoan;
import Utils.JPAUtil;
import Utils.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * DAO quan ly tai khoan bang JPA / Hibernate 6 (Jakarta EE 10)
 */
public class TaiKhoanDAO {

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
     * Tao tai khoan moi (Nem Exception ra ngoai de Servlet doc chi tiet loi)
     */
    public void createAccount(TaiKhoan tk, Integer maCuDan, Integer maNhanVien) throws Exception {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            if (tk.getMaTaiKhoan() == null || tk.getMaTaiKhoan().isEmpty()) {
                tk.setMaTaiKhoan("TK" + (System.currentTimeMillis() % 100000));
            }
            if (tk.getTrangThaiHoatDong() == null || tk.getTrangThaiHoatDong().isEmpty()) {
                tk.setTrangThaiHoatDong("HoatDong");
            }

            em.persist(tk);
            em.flush();

            // Neu co maCuDan
            if (maCuDan != null && maCuDan > 0) {
                CuDan cd = em.find(CuDan.class, maCuDan);
                if (cd != null) {
                    cd.setMaTaiKhoan(tk.getId());
                    em.merge(cd);
                }
            }

            // Neu co maNhanVien
            if (maNhanVien != null && maNhanVien > 0) {
                NhanVien nv = em.find(NhanVien.class, maNhanVien);
                if (nv != null) {
                    nv.setMaTaiKhoan(tk.getId());
                    em.merge(nv);
                }
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Loi createAccount trong TaiKhoanDAO: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw to expose exact error to servlet
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
