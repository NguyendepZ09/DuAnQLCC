package dao;

import entity.GiaoDichThanhToan;
import entity.HoaDon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

public class GiaoDichThanhToanDAO {

    private static final Set<String> HOP_LE_PHUONG_THUC = Set.of("TienMat", "ChuyenKhoan", "QR");

    public List<Object[]> findPendingTransactions() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  gd.id, " +
                "  c.soPhong, " +
                "  h.thang, " +
                "  h.nam, " +
                "  gd.soTien, " +
                "  gd.phuongThuc, " +
                "  gd.maGiaoDichNganHang, " +
                "  gd.thoiGianTao, " +
                "  h.id AS maHoaDon, " +
                "  h.tongTien " +
                "FROM dbo.giaoDichThanhToan gd " +
                "JOIN dbo.hoaDon h ON h.id = gd.maHoaDon " +
                "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                "WHERE gd.trangThai = 'ChoXacNhan' " +
                "ORDER BY gd.thoiGianTao DESC";

            return em.createNativeQuery(sql).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public List<Object[]> findUnpaidInvoices(Integer thang, Integer nam) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  h.id AS maHoaDon, " +
                "  c.soPhong, " +
                "  cd.hoTen AS tenChuHo, " +
                "  h.thang, " +
                "  h.nam, " +
                "  h.tongTien, " +
                "  ISNULL(SUM(CASE WHEN gd.trangThai = 'ThanhCong' THEN gd.soTien ELSE 0 END), 0) AS daTra, " +
                "  (h.tongTien - ISNULL(SUM(CASE WHEN gd.trangThai = 'ThanhCong' THEN gd.soTien ELSE 0 END), 0)) AS conNo, " +
                "  h.trangThaiThanhToan, " +
                "  c.id AS maCanHo " +
                "FROM dbo.hoaDon h " +
                "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                "LEFT JOIN dbo.cuDan cd ON cd.maCanHo = c.id AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO' " +
                "LEFT JOIN dbo.giaoDichThanhToan gd ON gd.maHoaDon = h.id " +
                "WHERE h.trangThaiThanhToan IN ('ChuaThanhToan', 'QuaHan') " +
                "  AND (:thang IS NULL OR h.thang = :thang) " +
                "  AND (:nam IS NULL OR h.nam = :nam) " +
                "GROUP BY h.id, c.soPhong, cd.hoTen, h.thang, h.nam, h.tongTien, h.trangThaiThanhToan, c.id " +
                "ORDER BY h.nam DESC, h.thang DESC, c.soPhong ASC";

            return em.createNativeQuery(sql)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public Map<String, Object> getPaymentDashboardStats() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Map<String, Object> stats = new HashMap<>();

            // 1. Pending stats
            String pendingSql = "SELECT COUNT(gd.id), ISNULL(SUM(gd.soTien), 0) FROM dbo.giaoDichThanhToan gd WHERE gd.trangThai = 'ChoXacNhan'";
            Object[] pendingRow = (Object[]) em.createNativeQuery(pendingSql).getSingleResult();
            int soChoXacNhan = ((Number) pendingRow[0]).intValue();
            BigDecimal tongChoXacNhan = (BigDecimal) pendingRow[1];

            // 2. Unpaid stats
            String unpaidSql = "SELECT COUNT(h.id), ISNULL(SUM(h.tongTien - ISNULL(t.daTra, 0)), 0) FROM dbo.hoaDon h " +
                "OUTER APPLY (SELECT SUM(gd.soTien) AS daTra FROM dbo.giaoDichThanhToan gd WHERE gd.maHoaDon = h.id AND gd.trangThai = 'ThanhCong') t " +
                "WHERE h.trangThaiThanhToan IN ('ChuaThanhToan', 'QuaHan')";
            Object[] unpaidRow = (Object[]) em.createNativeQuery(unpaidSql).getSingleResult();
            int soHoaDonChuaThu = ((Number) unpaidRow[0]).intValue();
            BigDecimal tongCongNo = (BigDecimal) unpaidRow[1];

            stats.put("soChoXacNhan", soChoXacNhan);
            stats.put("tongChoXacNhan", tongChoXacNhan);
            stats.put("soHoaDonChuaThu", soHoaDonChuaThu);
            stats.put("tongCongNo", tongCongNo);

            return stats;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> defaultStats = new HashMap<>();
            defaultStats.put("soChoXacNhan", 0);
            defaultStats.put("tongChoXacNhan", BigDecimal.ZERO);
            defaultStats.put("soHoaDonChuaThu", 0);
            defaultStats.put("tongCongNo", BigDecimal.ZERO);
            return defaultStats;
        } finally {
            em.close();
        }
    }

    public String ghiNhanThanhToan(int maHoaDon, BigDecimal soTien, String phuongThuc, String maGiaoDichNganHang) {
        if (soTien == null || soTien.compareTo(BigDecimal.ZERO) <= 0) {
            return "Số tiền thanh toán phải lớn hơn 0.";
        }
        if (phuongThuc == null || !HOP_LE_PHUONG_THUC.contains(phuongThuc)) {
            return "Phương thức thanh toán không hợp lệ (Tiền mặt, Chuyển khoản, QR).";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            HoaDon h = em.find(HoaDon.class, maHoaDon);
            if (h == null) {
                tx.rollback();
                return "Không tìm thấy hóa đơn mã #" + maHoaDon;
            }

            if ("DaThanhToan".equalsIgnoreCase(h.getTrangThaiThanhToan())) {
                tx.rollback();
                return "Hóa đơn này đã được thanh toán hoàn tất.";
            }

            // Find resident ID (owner ChuHo)
            Integer maCuDan = null;
            List<Integer> cdList = em.createQuery(
                "SELECT c.id FROM CuDan c WHERE c.maCanHo = :maCanHo AND c.loaiCuDan = 'ChuHo' AND c.trangThai = 'DangO'", 
                Integer.class
            ).setParameter("maCanHo", h.getMaCanHo()).getResultList();
            if (!cdList.isEmpty()) {
                maCuDan = cdList.get(0);
            }

            GiaoDichThanhToan gd = new GiaoDichThanhToan();
            gd.setMaHoaDon(maHoaDon);
            gd.setMaCuDan(maCuDan);
            gd.setSoTien(soTien);
            gd.setPhuongThuc(phuongThuc);
            gd.setMaGiaoDichNganHang(maGiaoDichNganHang != null ? maGiaoDichNganHang.trim() : null);
            gd.setThoiGianTao(LocalDateTime.now());

            if ("TienMat".equalsIgnoreCase(phuongThuc)) {
                gd.setTrangThai("ThanhCong");
                gd.setThoiGianXacNhan(LocalDateTime.now());
                em.persist(gd);

                // Update invoice status if total paid >= invoice total
                updateHoaDonStatusIfPaid(em, h);
            } else {
                gd.setTrangThai("ChoXacNhan");
                gd.setThoiGianXacNhan(null);
                em.persist(gd);
            }

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[GiaoDichThanhToanDAO] ghiNhanThanhToan FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String xacNhanGiaoDich(int idGiaoDich) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            GiaoDichThanhToan gd = em.find(GiaoDichThanhToan.class, idGiaoDich);
            if (gd == null) {
                tx.rollback();
                return "Không tìm thấy giao dịch #" + idGiaoDich;
            }

            // Anti double-click check
            if (!"ChoXacNhan".equalsIgnoreCase(gd.getTrangThai())) {
                tx.rollback();
                return "Giao dịch này đã được xử lý.";
            }

            gd.setTrangThai("ThanhCong");
            gd.setThoiGianXacNhan(LocalDateTime.now());
            em.merge(gd);

            HoaDon h = em.find(HoaDon.class, gd.getMaHoaDon());
            if (h != null) {
                updateHoaDonStatusIfPaid(em, h);
            }

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[GiaoDichThanhToanDAO] xacNhanGiaoDich FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String tuChoiGiaoDich(int idGiaoDich) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            GiaoDichThanhToan gd = em.find(GiaoDichThanhToan.class, idGiaoDich);
            if (gd == null) {
                tx.rollback();
                return "Không tìm thấy giao dịch #" + idGiaoDich;
            }

            // Anti double-click check
            if (!"ChoXacNhan".equalsIgnoreCase(gd.getTrangThai())) {
                tx.rollback();
                return "Giao dịch này đã được xử lý.";
            }

            gd.setTrangThai("ThatBai");
            gd.setThoiGianXacNhan(LocalDateTime.now());
            em.merge(gd);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[GiaoDichThanhToanDAO] tuChoiGiaoDich FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    private void updateHoaDonStatusIfPaid(EntityManager em, HoaDon h) {
        List<BigDecimal> list = em.createQuery(
            "SELECT SUM(g.soTien) FROM GiaoDichThanhToan g WHERE g.maHoaDon = :maHoaDon AND g.trangThai = 'ThanhCong'", 
            BigDecimal.class
        ).setParameter("maHoaDon", h.getId()).getResultList();

        BigDecimal tongDaTra = (list != null && !list.isEmpty() && list.get(0) != null) ? list.get(0) : BigDecimal.ZERO;
        BigDecimal tongTienHn = (h.getTongTien() != null) ? BigDecimal.valueOf(h.getTongTien()) : BigDecimal.ZERO;
        if (tongDaTra.compareTo(tongTienHn) >= 0) {
            h.setTrangThaiThanhToan("DaThanhToan");
            em.merge(h);
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
