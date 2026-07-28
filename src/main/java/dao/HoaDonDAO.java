package dao;

import entity.ChiTietHoaDon;
import entity.HoaDon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HoaDonDAO {

    public String xuatHoaDonHangLoat(int thang, int nam) {
        if (thang < 1 || thang > 12) {
            return "Tháng phải nằm trong khoảng từ 1 đến 12.";
        }
        if (nam < 2000) {
            return "Năm không hợp lệ.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.unwrap(org.hibernate.Session.class).doWork(connection -> {
                try (java.sql.CallableStatement cs = connection.prepareCall("{call dbo.sp_XuatHoaDonHangLoat(?, ?)}")) {
                    cs.setInt(1, thang);
                    cs.setInt(2, nam);
                    cs.execute();
                }
            });
            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[HoaDonDAO] xuatHoaDonHangLoat FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public List<Object[]> findHoaDonTheoKy(Integer thang, Integer nam, String trangThai) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  h.id AS hoaDonId, " +
                "  c.soPhong, " +
                "  cd.hoTen AS tenChuHo, " +
                "  h.thang, " +
                "  h.nam, " +
                "  h.tongTien, " +
                "  h.trangThaiThanhToan " +
                "FROM dbo.hoaDon h " +
                "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                "LEFT JOIN dbo.cuDan cd ON cd.maCanHo = c.id AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO' " +
                "WHERE 1=1 " +
                "  AND (:thang IS NULL OR h.thang = :thang) " +
                "  AND (:nam IS NULL OR h.nam = :nam) " +
                "  AND (:trangThai IS NULL OR :trangThai = '' OR :trangThai = 'ALL' OR h.trangThaiThanhToan = :trangThai) " +
                "ORDER BY h.nam DESC, h.thang DESC, c.soPhong ASC";

            return em.createNativeQuery(sql)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .setParameter("trangThai", (trangThai != null && trangThai.isBlank()) ? null : trangThai)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public Map<String, Object> findChiTietHoaDon(int maHoaDon) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Map<String, Object> result = new HashMap<>();

            String headerSql = "SELECT " +
                "  h.id AS hoaDonId, " +
                "  c.soPhong, " +
                "  c.dienTich, " +
                "  cd.hoTen AS tenChuHo, " +
                "  h.thang, " +
                "  h.nam, " +
                "  h.tongTien, " +
                "  h.trangThaiThanhToan " +
                "FROM dbo.hoaDon h " +
                "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                "LEFT JOIN dbo.cuDan cd ON cd.maCanHo = c.id AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO' " +
                "WHERE h.id = :maHoaDon";

            List<Object[]> list = em.createNativeQuery(headerSql)
                    .setParameter("maHoaDon", maHoaDon)
                    .getResultList();

            if (list.isEmpty()) {
                return null;
            }

            Object[] header = list.get(0);
            result.put("hoaDonId", header[0]);
            result.put("soPhong", header[1]);
            result.put("dienTich", header[2]);
            result.put("tenChuHo", header[3]);
            result.put("thang", header[4]);
            result.put("nam", header[5]);
            result.put("tongTien", header[6]);
            result.put("trangThaiThanhToan", header[7]);

            List<ChiTietHoaDon> chiTietList = em.createQuery(
                "SELECT ct FROM ChiTietHoaDon ct WHERE ct.maHoaDon = :maHoaDon ORDER BY ct.id ASC", ChiTietHoaDon.class)
                    .setParameter("maHoaDon", maHoaDon)
                    .getResultList();

            result.put("chiTietList", chiTietList);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> thongKeKy(Integer thang, Integer nam) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Map<String, Object> stats = new HashMap<>();
            String sql = "SELECT " +
                "  COUNT(h.id) AS soHoaDon, " +
                "  ISNULL(SUM(h.tongTien), 0) AS tongPhaiThu, " +
                "  ISNULL(SUM(CASE WHEN h.trangThaiThanhToan = 'DaThanhToan' THEN h.tongTien ELSE 0 END), 0) AS tongDaThu, " +
                "  ISNULL(SUM(CASE WHEN h.trangThaiThanhToan <> 'DaThanhToan' THEN h.tongTien ELSE 0 END), 0) AS tongConNo " +
                "FROM dbo.hoaDon h " +
                "WHERE (:thang IS NULL OR h.thang = :thang) " +
                "  AND (:nam IS NULL OR h.nam = :nam)";

            Object[] row = (Object[]) em.createNativeQuery(sql)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .getSingleResult();

            stats.put("soHoaDon", ((Number) row[0]).intValue());
            stats.put("tongPhaiThu", (BigDecimal) row[1]);
            stats.put("tongDaThu", (BigDecimal) row[2]);
            stats.put("tongConNo", (BigDecimal) row[3]);

            return stats;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> defaultStats = new HashMap<>();
            defaultStats.put("soHoaDon", 0);
            defaultStats.put("tongPhaiThu", BigDecimal.ZERO);
            defaultStats.put("tongDaThu", BigDecimal.ZERO);
            defaultStats.put("tongConNo", BigDecimal.ZERO);
            return defaultStats;
        } finally {
            em.close();
        }
    }

    private String extractRootMessage(Throwable e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        String msg = cause.getMessage();
        if (msg == null || msg.isBlank()) msg = e.getMessage();
        if (msg == null) msg = e.getClass().getSimpleName();
        return msg.length() > 500 ? msg.substring(0, 500) + "..." : msg;
    }
}
