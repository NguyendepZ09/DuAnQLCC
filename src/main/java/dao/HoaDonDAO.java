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

    // --- BỔ SUNG METHOD DÀNH CHO ROLE CƯ DÂN ---

    public List<Object[]> findHoaDonTheoCanHo(int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  h.id AS hoaDonId, " +
                "  h.thang, " +
                "  h.nam, " +
                "  h.tongTien, " +
                "  h.trangThaiThanhToan, " +
                "  ISNULL(SUM(CASE WHEN gd.trangThai = 'ThanhCong' THEN gd.soTien ELSE 0 END), 0) AS daThu, " +
                "  (h.tongTien - ISNULL(SUM(CASE WHEN gd.trangThai = 'ThanhCong' THEN gd.soTien ELSE 0 END), 0)) AS conNo, " +
                "  ISNULL(SUM(CASE WHEN gd.phuongThuc = 'QR' AND gd.trangThai = 'ChoXacNhan' THEN 1 ELSE 0 END), 0) AS countPendingQR " +
                "FROM dbo.hoaDon h " +
                "LEFT JOIN dbo.giaoDichThanhToan gd ON gd.maHoaDon = h.id " +
                "WHERE h.maCanHo = :maCanHo " +
                "GROUP BY h.id, h.thang, h.nam, h.tongTien, h.trangThaiThanhToan " +
                "ORDER BY h.nam DESC, h.thang DESC";

            return em.createNativeQuery(sql)
                    .setParameter("maCanHo", maCanHo)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public boolean hoaDonThuocCanHo(int maHoaDon, int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(h) FROM HoaDon h WHERE h.id = :maHoaDon AND h.maCanHo = :maCanHo", Long.class)
                    .setParameter("maHoaDon", maHoaDon)
                    .setParameter("maCanHo", maCanHo)
                    .getSingleResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> findChiTietChoCuDan(int maHoaDon) {
        Map<String, Object> result = findChiTietHoaDon(maHoaDon);
        if (result == null) return null;

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String gdSql = "SELECT " +
                "  gd.id, " +
                "  gd.soTien, " +
                "  gd.phuongThuc, " +
                "  gd.trangThai, " +
                "  gd.thoiGianTao, " +
                "  gd.maGiaoDichNganHang " +
                "FROM dbo.giaoDichThanhToan gd " +
                "WHERE gd.maHoaDon = :maHoaDon " +
                "ORDER BY gd.thoiGianTao DESC";

            List<Object[]> giaoDichList = em.createNativeQuery(gdSql)
                    .setParameter("maHoaDon", maHoaDon)
                    .getResultList();

            result.put("giaoDichList", giaoDichList);

            // Tính số tiền còn nợ và giao dịch QR đang chờ xác nhận
            GiaoDichThanhToanDAO gdDAO = new GiaoDichThanhToanDAO();
            result.put("soConNo", gdDAO.tinhSoConNo(maHoaDon));

            boolean hasPendingQR = false;
            for (Object[] gdRow : giaoDichList) {
                String pt = (String) gdRow[2];
                String tt = (String) gdRow[3];
                if ("QR".equalsIgnoreCase(pt) && "ChoXacNhan".equalsIgnoreCase(tt)) {
                    hasPendingQR = true;
                    result.put("pendingRefCode", gdRow[5]);
                    result.put("pendingAmount", gdRow[1]);
                    break;
                }
            }
            result.put("hasPendingQR", hasPendingQR);

            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return result;
        } finally {
            em.close();
        }
    }

    public List<Object[]> findCanHoConNo(int thang, int nam) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                    "  c.id AS maCanHo, " +
                    "  c.soPhong, " +
                    "  ISNULL(cd.hoTen, N'Chưa có chủ hộ') AS tenChuHo, " +
                    "  h.tongTien, " +
                    "  ISNULL(SUM(CASE WHEN g.trangThai = 'ThanhCong' THEN g.soTien ELSE 0 END), 0) AS daThu, " +
                    "  (h.tongTien - ISNULL(SUM(CASE WHEN g.trangThai = 'ThanhCong' THEN g.soTien ELSE 0 END), 0)) AS conNo " +
                    "FROM dbo.hoaDon h " +
                    "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                    "LEFT JOIN dbo.cuDan cd ON cd.maCanHo = c.id AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO' " +
                    "LEFT JOIN dbo.giaoDichThanhToan g ON g.maHoaDon = h.id " +
                    "WHERE h.thang = :thang AND h.nam = :nam " +
                    "GROUP BY c.id, c.soPhong, cd.hoTen, h.tongTien " +
                    "HAVING (h.tongTien - ISNULL(SUM(CASE WHEN g.trangThai = 'ThanhCong' THEN g.soTien ELSE 0 END), 0)) > 0.01 " +
                    "ORDER BY c.soPhong ASC";

            @SuppressWarnings("unchecked")
            List<Object[]> list = em.createNativeQuery(sql)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .getResultList();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public String guiNhacPhi(int thang, int nam, int maNhanVien) {
        List<Object[]> dsConNo = findCanHoConNo(thang, nam);
        if (dsConNo.isEmpty()) {
            return "Không có căn hộ nào còn nợ phí trong kỳ T" + thang + "/" + nam + ".";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        int sentCount = 0;
        int skippedCount = 0;

        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime sevenDaysAgo = now.minusDays(7);
        java.util.Date sevenDaysAgoDate = java.sql.Timestamp.valueOf(sevenDaysAgo);

        try {
            tx.begin();

            for (Object[] r : dsConNo) {
                int maCanHo = ((Number) r[0]).intValue();
                String soPhong = (String) r[1];
                double tongTien = ((Number) r[3]).doubleValue();
                double daThu = ((Number) r[4]).doubleValue();
                double conNo = ((Number) r[5]).doubleValue();

                // Anti-duplicate check within 7 days for same apartment and same period
                String checkSql = "SELECT COUNT(t.id) FROM dbo.thongBao t " +
                        "WHERE t.doiTuong = 'CanHo' AND t.maCanHo = :maCanHo " +
                        "  AND t.loaiThongBao = 'NhacPhi' " +
                        "  AND t.tieuDe LIKE :tieuDeKey " +
                        "  AND t.ngayTao >= :sevenDaysAgo";

                Number numExist = (Number) em.createNativeQuery(checkSql)
                        .setParameter("maCanHo", maCanHo)
                        .setParameter("tieuDeKey", "%Nhắc phí tháng " + thang + "/" + nam + "%")
                        .setParameter("sevenDaysAgo", sevenDaysAgoDate)
                        .getSingleResult();

                if (numExist != null && numExist.intValue() > 0) {
                    skippedCount++;
                    continue;
                }

                // Create new ThongBao record
                entity.ThongBao tb = new entity.ThongBao();
                tb.setMaNhanVien(maNhanVien);
                tb.setDoiTuong("CanHo");
                tb.setMaCanHo(maCanHo);
                tb.setLoaiThongBao("NhacPhi");
                tb.setTieuDe("Nhắc phí tháng " + thang + "/" + nam);

                String noiDung = "Kính gửi cư dân căn hộ " + soPhong + ",\n\n" +
                        "Ban Quản lý xin thông báo nhắc phí dịch vụ kỳ Tháng " + thang + "/" + nam + ":\n" +
                        "• Tổng tiền hóa đơn: " + util.DisplayUtil.formatTienDouble(tongTien) + "\n" +
                        "• Đã thanh toán: " + util.DisplayUtil.formatTienDouble(daThu) + "\n" +
                        "• Số tiền còn nợ: " + util.DisplayUtil.formatTienDouble(conNo) + "\n\n" +
                        "Rất mong Quý cư dân hoàn tất thanh toán để đảm bảo duy trì các dịch vụ tiện ích.";

                tb.setNoiDung(noiDung);
                tb.setNgayTao(new java.util.Date());

                em.persist(tb);
                sentCount++;
            }

            tx.commit();

            StringBuilder msg = new StringBuilder();
            msg.append("Đã gửi thành công ").append(sentCount).append(" thông báo nhắc phí cho kỳ T").append(thang).append("/").append(nam).append(".");
            if (skippedCount > 0) {
                msg.append(" (Bỏ qua ").append(skippedCount).append(" căn hộ do đã được gửi nhắc phí trong vòng 7 ngày qua).");
            }
            return msg.toString();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return "Lỗi khi gửi thông báo nhắc phí: " + extractRootMessage(e);
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
