package dao;

import entity.ThongBao;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * DAO quan ly thong bao toan toa nha
 */
public class ThongBaoDAO {

    public List<ThongBao> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT t FROM ThongBao t ORDER BY t.id DESC", ThongBao.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public List<ThongBao> findForCuDan(int page, int pageSize) {
        return findForCuDan(null, page, pageSize);
    }

    public List<ThongBao> findForCuDan(Integer maCanHo, int page, int pageSize) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<ThongBao> query = em.createQuery(
                "SELECT t FROM ThongBao t WHERE t.doiTuong IN ('CuDan', 'TatCa') " +
                "OR (t.doiTuong = 'CanHo' AND t.maCanHo = :mch) ORDER BY t.ngayTao DESC", ThongBao.class);
            query.setParameter("mch", maCanHo);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public long countForCuDan() {
        return countForCuDan(null);
    }

    public long countForCuDan(Integer maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT COUNT(t) FROM ThongBao t WHERE t.doiTuong IN ('CuDan', 'TatCa') " +
                "OR (t.doiTuong = 'CanHo' AND t.maCanHo = :mch)", Long.class)
                    .setParameter("mch", maCanHo)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            em.close();
        }
    }

    public boolean save(ThongBao tb) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (tb.getMaNhanVien() == null) tb.setMaNhanVien(1);
            if (tb.getNgayTao() == null) tb.setNgayTao(new Date());
            if (tb.getLoaiThongBao() == null || tb.getLoaiThongBao().isEmpty()) tb.setLoaiThongBao("ThongThuong");
            if (tb.getDoiTuong() == null || tb.getDoiTuong().isEmpty()) tb.setDoiTuong("TatCa");

            em.persist(tb);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Loi save ThongBao trong ThongBaoDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public List<Map<String, Object>> findThongBaoChoNhanVien(int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  t.id, " +
                "  t.tieuDe, " +
                "  t.noiDung, " +
                "  t.loaiThongBao, " +
                "  t.ngayTao, " +
                "  ISNULL(nv.hoTen, N'Ban Quản Lý') AS tenNguoiGui, " +
                "  CASE WHEN d.id IS NOT NULL THEN 1 ELSE 0 END AS daDoc " +
                "FROM dbo.thongBao t " +
                "LEFT JOIN dbo.nhanVien nv ON nv.id = t.maNhanVien " +
                "LEFT JOIN dbo.thongBao_DaDoc d ON d.maThongBao = t.id AND d.maNhanVien = :maNv " +
                "WHERE t.doiTuong IN ('TatCa', 'NhanVien') " +
                "ORDER BY t.ngayTao DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rawList = em.createNativeQuery(sql)
                    .setParameter("maNv", maNhanVien)
                    .getResultList();

            List<Map<String, Object>> result = new java.util.ArrayList<>();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");

            for (Object[] r : rawList) {
                Map<String, Object> map = new java.util.HashMap<>();
                int id = ((Number) r[0]).intValue();
                String tieuDe = r[1] != null ? r[1].toString() : "";
                String noiDung = r[2] != null ? r[2].toString() : "";
                String loaiThongBao = r[3] != null ? r[3].toString() : "ThongThuong";
                
                String ngayTaoText = "—";
                if (r[4] != null) {
                    if (r[4] instanceof Date) {
                        ngayTaoText = sdf.format((Date) r[4]);
                    } else if (r[4] instanceof java.sql.Timestamp) {
                        ngayTaoText = sdf.format(new Date(((java.sql.Timestamp) r[4]).getTime()));
                    }
                }

                String tenNguoiGui = r[5] != null ? r[5].toString() : "Ban Quản Lý";
                boolean daDoc = r[6] != null && ((Number) r[6]).intValue() == 1;

                String loaiThongBaoText = util.DisplayUtil.getLoaiThongBaoText(loaiThongBao);
                String loaiThongBaoBadgeClass = util.DisplayUtil.getLoaiThongBaoBadgeClass(loaiThongBao);

                map.put("id", id);
                map.put("tieuDe", tieuDe);
                map.put("noiDung", noiDung);
                map.put("loaiThongBao", loaiThongBao);
                map.put("loaiThongBaoText", loaiThongBaoText);
                map.put("loaiThongBaoBadgeClass", loaiThongBaoBadgeClass);
                map.put("ngayTaoText", ngayTaoText);
                map.put("tenNguoiGui", tenNguoiGui);
                map.put("daDoc", daDoc);

                result.add(map);
            }

            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public int countThongBaoChuaDocChoNhanVien(int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT COUNT(t.id) " +
                "FROM dbo.thongBao t " +
                "LEFT JOIN dbo.thongBao_DaDoc d ON d.maThongBao = t.id AND d.maNhanVien = :maNv " +
                "WHERE t.doiTuong IN ('TatCa', 'NhanVien') AND d.id IS NULL";

            Number count = (Number) em.createNativeQuery(sql)
                    .setParameter("maNv", maNhanVien)
                    .getSingleResult();
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public String danhDauDaDoc(int maThongBao, int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            String sqlCheck = "SELECT COUNT(d.id) FROM dbo.thongBao_DaDoc d WHERE d.maThongBao = :maTb AND d.maNhanVien = :maNv";
            Number count = (Number) em.createNativeQuery(sqlCheck)
                    .setParameter("maTb", maThongBao)
                    .setParameter("maNv", maNhanVien)
                    .getSingleResult();

            if (count == null || count.intValue() == 0) {
                em.createNativeQuery("INSERT INTO dbo.thongBao_DaDoc (maThongBao, maNhanVien, thoiGianDoc) VALUES (:maTb, :maNv, GETDATE())")
                        .setParameter("maTb", maThongBao)
                        .setParameter("maNv", maNhanVien)
                        .executeUpdate();
            }

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return e.getMessage();
        } finally {
            em.close();
        }
    }
}
