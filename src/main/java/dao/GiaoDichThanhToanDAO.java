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
                "  h.tongTien, " +
                "  gd.maCuDan " +
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

    public List<Map<String, Object>> findPendingTransactionsMapped() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  gd.id, " +
                "  c.soPhong, " +
                "  cd.hoTen AS tenCuDan, " +
                "  h.thang, " +
                "  h.nam, " +
                "  gd.soTien, " +
                "  gd.phuongThuc, " +
                "  gd.maGiaoDichNganHang, " +
                "  gd.thoiGianTao " +
                "FROM dbo.giaoDichThanhToan gd " +
                "JOIN dbo.hoaDon h ON h.id = gd.maHoaDon " +
                "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                "LEFT JOIN dbo.cuDan cd ON cd.id = gd.maCuDan " +
                "WHERE gd.trangThai = 'ChoXacNhan' " +
                "ORDER BY gd.thoiGianTao DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rawList = em.createNativeQuery(sql).getResultList();
            List<Map<String, Object>> result = new ArrayList<>();
            java.text.NumberFormat currencyFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
            java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            for (Object[] r : rawList) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", r[0]);
                map.put("soPhong", "P." + (r[1] != null ? r[1].toString().trim() : ""));
                map.put("tenCuDan", (r[2] != null && !r[2].toString().trim().isEmpty()) ? r[2].toString().trim() : "—");
                
                int thang = r[3] != null ? ((Number) r[3]).intValue() : 0;
                int nam = r[4] != null ? ((Number) r[4]).intValue() : 0;
                map.put("kyHoaDon", "Tháng " + thang + "/" + nam);

                BigDecimal soTien = (r[5] instanceof BigDecimal) ? (BigDecimal) r[5] : (r[5] != null ? new BigDecimal(r[5].toString()) : BigDecimal.ZERO);
                map.put("soTien", soTien);
                map.put("soTienText", currencyFmt.format(soTien) + "đ");

                String pt = r[6] != null ? r[6].toString().trim() : "";
                map.put("phuongThuc", pt);
                map.put("phuongThucText", util.DisplayUtil.getPhuongThucText(pt));

                map.put("maGiaoDichNganHang", r[7] != null ? r[7].toString().trim() : "—");

                String tgText = "—";
                if (r[8] instanceof java.time.LocalDateTime) {
                    tgText = ((java.time.LocalDateTime) r[8]).format(dtf);
                } else if (r[8] instanceof java.sql.Timestamp) {
                    tgText = ((java.sql.Timestamp) r[8]).toLocalDateTime().format(dtf);
                }
                map.put("thoiGianTaoText", tgText);

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

    public BigDecimal tinhSoConNo(int maHoaDon) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            HoaDon h = em.find(HoaDon.class, maHoaDon);
            if (h == null) return BigDecimal.ZERO;
            return tinhSoConNo(em, h);
        } finally {
            em.close();
        }
    }

    private BigDecimal tinhSoConNo(EntityManager em, HoaDon h) {
        if (h == null) return BigDecimal.ZERO;
        List<BigDecimal> list = em.createQuery(
            "SELECT SUM(g.soTien) FROM GiaoDichThanhToan g WHERE g.maHoaDon = :maHoaDon AND g.trangThai = 'ThanhCong'", 
            BigDecimal.class
        ).setParameter("maHoaDon", h.getId()).getResultList();

        BigDecimal tongDaTra = (list != null && !list.isEmpty() && list.get(0) != null) ? list.get(0) : BigDecimal.ZERO;
        BigDecimal tongTienHn = (h.getTongTien() != null) ? BigDecimal.valueOf(h.getTongTien()) : BigDecimal.ZERO;
        BigDecimal conNo = tongTienHn.subtract(tongDaTra);
        return conNo.compareTo(BigDecimal.ZERO) > 0 ? conNo : BigDecimal.ZERO;
    }

    public Map<String, Object> taoGiaoDichQR(int maHoaDon, int maCanHoSession, int maCuDanSession) {
        Map<String, Object> res = new HashMap<>();
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            HoaDon h = em.find(HoaDon.class, maHoaDon);
            if (h == null) {
                res.put("loi", "Không tìm thấy hóa đơn mã #" + maHoaDon);
                return res;
            }

            // CHỐNG IDOR: Kiểm tra hóa đơn thuộc đúng căn hộ cư dân đăng nhập
            if (h.getMaCanHo() == null || h.getMaCanHo().intValue() != maCanHoSession) {
                res.put("loi", "Bạn không có quyền thanh toán cho hóa đơn của căn hộ khác.");
                return res;
            }

            // Kiểm tra số nợ còn lại
            BigDecimal soConNo = tinhSoConNo(em, h);
            if (soConNo.compareTo(BigDecimal.ZERO) <= 0) {
                res.put("loi", "Hóa đơn này đã được thanh toán xong.");
                return res;
            }

            // TÁI SỬ DỤNG GIAO DỊCH ĐANG CHỜ (tránh tạo trùng lặp mỗi lần bấm)
            List<GiaoDichThanhToan> pendingList = em.createQuery(
                "SELECT g FROM GiaoDichThanhToan g WHERE g.maHoaDon = :mhd AND g.phuongThuc = 'QR' AND g.trangThai = 'ChoXacNhan' ORDER BY g.id DESC",
                GiaoDichThanhToan.class
            ).setParameter("mhd", maHoaDon).getResultList();

            if (!pendingList.isEmpty()) {
                GiaoDichThanhToan oldGd = pendingList.get(0);
                String qrUrl = util.QRConfig.buildQRUrl(oldGd.getSoTien(), oldGd.getMaGiaoDichNganHang());
                res.put("maGiaoDich", oldGd.getId());
                res.put("soTien", oldGd.getSoTien());
                res.put("noiDungChuyenKhoan", oldGd.getMaGiaoDichNganHang());
                res.put("qrUrl", qrUrl);
                res.put("isOld", true);
                return res;
            }

            // TẠO GIAO DỊCH MỚI
            tx.begin();

            entity.CanHo ch = em.find(entity.CanHo.class, h.getMaCanHo());
            String soPhongClean = (ch != null && ch.getSoPhong() != null) ? ch.getSoPhong().replaceAll("[^a-zA-Z0-9]", "") : "CH";

            // Kiểm tra FK maCuDan hợp lệ trong DB
            Integer validMaCuDan = null;
            if (maCuDanSession > 0) {
                Long countCd = em.createQuery("SELECT COUNT(c) FROM CuDan c WHERE c.id = :id", Long.class)
                        .setParameter("id", maCuDanSession)
                        .getSingleResult();
                if (countCd != null && countCd > 0) {
                    validMaCuDan = maCuDanSession;
                }
            }
            if (validMaCuDan == null) {
                List<Integer> cdList = em.createQuery(
                    "SELECT c.id FROM CuDan c WHERE c.maCanHo = :maCanHo AND c.loaiCuDan = 'ChuHo' AND c.trangThai = 'DangO'", 
                    Integer.class
                ).setParameter("maCanHo", h.getMaCanHo()).getResultList();
                if (!cdList.isEmpty()) {
                    validMaCuDan = cdList.get(0);
                }
            }

            GiaoDichThanhToan newGd = new GiaoDichThanhToan();
            newGd.setMaHoaDon(maHoaDon);
            newGd.setMaCuDan(validMaCuDan);
            newGd.setSoTien(soConNo);
            newGd.setPhuongThuc("QR");
            newGd.setTrangThai("ChoXacNhan");
            newGd.setThoiGianTao(LocalDateTime.now());
            newGd.setThoiGianXacNhan(null);

            em.persist(newGd);

            // Mã tham chiếu VietQR dạng: PB0101T82026-12
            String refCode = String.format("PB%sT%d%d-%d", soPhongClean, h.getThang(), h.getNam(), newGd.getId());
            newGd.setMaGiaoDichNganHang(refCode);
            em.merge(newGd);

            tx.commit();

            String qrUrl = util.QRConfig.buildQRUrl(soConNo, refCode);
            res.put("maGiaoDich", newGd.getId());
            res.put("soTien", soConNo);
            res.put("noiDungChuyenKhoan", refCode);
            res.put("qrUrl", qrUrl);
            res.put("isOld", false);
            return res;

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            res.put("loi", "Lỗi tạo mã QR thanh toán: " + e.getMessage());
            return res;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> layGiaoDichQRDangCho(int maHoaDon, int maCanHoSession) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            HoaDon h = em.find(HoaDon.class, maHoaDon);
            if (h == null || h.getMaCanHo() == null || h.getMaCanHo().intValue() != maCanHoSession) {
                return null;
            }

            List<GiaoDichThanhToan> pendingList = em.createQuery(
                "SELECT g FROM GiaoDichThanhToan g WHERE g.maHoaDon = :mhd AND g.phuongThuc = 'QR' AND g.trangThai = 'ChoXacNhan' ORDER BY g.id DESC",
                GiaoDichThanhToan.class
            ).setParameter("mhd", maHoaDon).getResultList();

            if (pendingList.isEmpty()) return null;

            GiaoDichThanhToan oldGd = pendingList.get(0);
            String qrUrl = util.QRConfig.buildQRUrl(oldGd.getSoTien(), oldGd.getMaGiaoDichNganHang());

            Map<String, Object> res = new HashMap<>();
            res.put("maGiaoDich", oldGd.getId());
            res.put("soTien", oldGd.getSoTien());
            res.put("noiDungChuyenKhoan", oldGd.getMaGiaoDichNganHang());
            res.put("qrUrl", qrUrl);
            return res;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
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

            // Layer 1: Cảnh báo nếu hóa đơn đó ĐÃ CÓ giao dịch 'ChoXacNhan'
            List<GiaoDichThanhToan> pendingList = em.createQuery(
                "SELECT g FROM GiaoDichThanhToan g WHERE g.maHoaDon = :mhd AND g.trangThai = 'ChoXacNhan' ORDER BY g.id DESC",
                GiaoDichThanhToan.class
            ).setParameter("mhd", maHoaDon).getResultList();

            String warningMsg = null;
            if (!pendingList.isEmpty()) {
                GiaoDichThanhToan pGd = pendingList.get(0);
                int pId = pGd.getId();
                String pPt = util.DisplayUtil.getPhuongThucText(pGd.getPhuongThuc());
                BigDecimal pSt = pGd.getSoTien();
                java.text.NumberFormat curFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                warningMsg = "⚠️ Cảnh báo: Hóa đơn này đã có giao dịch #" + pId + " (" + pPt + ", " + curFmt.format(pSt) + "đ) đang chờ xác nhận. Kiểm tra lại trước khi tạo thêm.";
            }

            // Calculate remaining debt
            List<BigDecimal> listDaThu = em.createQuery(
                "SELECT SUM(g.soTien) FROM GiaoDichThanhToan g WHERE g.maHoaDon = :mhd AND g.trangThai = 'ThanhCong'", 
                BigDecimal.class
            ).setParameter("mhd", h.getId()).getResultList();
            BigDecimal daThu = (listDaThu != null && !listDaThu.isEmpty() && listDaThu.get(0) != null) ? listDaThu.get(0) : BigDecimal.ZERO;
            BigDecimal tongTienHn = (h.getTongTien() != null) ? BigDecimal.valueOf(h.getTongTien()) : BigDecimal.ZERO;
            BigDecimal conNo = tongTienHn.subtract(daThu);
            if (conNo.compareTo(BigDecimal.ZERO) < 0) conNo = BigDecimal.ZERO;

            // Layer 2: Hard Block check if direct confirmation (TienMat)
            if ("TienMat".equalsIgnoreCase(phuongThuc)) {
                if (soTien.compareTo(conNo) > 0) {
                    tx.rollback();
                    java.text.NumberFormat curFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                    return "Không thể xác nhận: hóa đơn còn nợ " + curFmt.format(conNo) + "đ nhưng giao dịch này là " + curFmt.format(soTien) + "đ. Hóa đơn đã được thanh toán đủ hoặc số tiền không khớp.";
                }
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
                em.flush();

                // Update invoice status if total paid >= invoice total
                updateHoaDonStatusIfPaid(em, h);
            } else {
                gd.setTrangThai("ChoXacNhan");
                gd.setThoiGianXacNhan(null);
                em.persist(gd);
                em.flush();
            }

            tx.commit();
            return warningMsg;
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

            HoaDon h = em.find(HoaDon.class, gd.getMaHoaDon());
            if (h == null) {
                tx.rollback();
                return "Không tìm thấy hóa đơn mã #" + gd.getMaHoaDon();
            }

            // Layer 2: Hard Block - Tổng đã thu không bao giờ được vượt tongTien
            List<BigDecimal> listDaThu = em.createQuery(
                "SELECT SUM(g.soTien) FROM GiaoDichThanhToan g WHERE g.maHoaDon = :mhd AND g.trangThai = 'ThanhCong'", 
                BigDecimal.class
            ).setParameter("mhd", h.getId()).getResultList();

            BigDecimal daThu = (listDaThu != null && !listDaThu.isEmpty() && listDaThu.get(0) != null) ? listDaThu.get(0) : BigDecimal.ZERO;
            BigDecimal tongTienHn = (h.getTongTien() != null) ? BigDecimal.valueOf(h.getTongTien()) : BigDecimal.ZERO;
            BigDecimal conNo = tongTienHn.subtract(daThu);
            if (conNo.compareTo(BigDecimal.ZERO) < 0) conNo = BigDecimal.ZERO;

            if (gd.getSoTien() != null && gd.getSoTien().compareTo(conNo) > 0) {
                tx.rollback();
                java.text.NumberFormat curFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                return "Không thể xác nhận: hóa đơn còn nợ " + curFmt.format(conNo) + "đ nhưng giao dịch này là " + curFmt.format(gd.getSoTien()) + "đ. Hóa đơn đã được thanh toán đủ hoặc số tiền không khớp.";
            }

            gd.setTrangThai("ThanhCong");
            gd.setThoiGianXacNhan(LocalDateTime.now());
            em.merge(gd);
            em.flush();

            updateHoaDonStatusIfPaid(em, h);

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
            em.flush();

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
        em.flush();
        List<BigDecimal> list = em.createQuery(
            "SELECT SUM(g.soTien) FROM GiaoDichThanhToan g WHERE g.maHoaDon = :maHoaDon AND g.trangThai = 'ThanhCong'", 
            BigDecimal.class
        ).setParameter("maHoaDon", h.getId()).getResultList();

        BigDecimal tongDaTra = (list != null && !list.isEmpty() && list.get(0) != null) ? list.get(0) : BigDecimal.ZERO;
        BigDecimal tongTienHn = (h.getTongTien() != null) ? BigDecimal.valueOf(h.getTongTien()) : BigDecimal.ZERO;
        if (tongDaTra.compareTo(tongTienHn) >= 0) {
            h.setTrangThaiThanhToan("DaThanhToan");
            em.merge(h);
            em.flush();

            // Layer 3: Tự động hủy các giao dịch 'ChoXacNhan' còn lại của hóa đơn
            em.createQuery(
                "UPDATE GiaoDichThanhToan g SET g.trangThai = 'ThatBai', g.ghiChuDoiSoat = 'Tự động hủy — hóa đơn đã thanh toán đủ' WHERE g.maHoaDon = :mhd AND g.trangThai = 'ChoXacNhan'"
            ).setParameter("mhd", h.getId()).executeUpdate();
            em.flush();
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
