package dao;

import util.JPAUtil;
import util.SaoKeParser.DongSaoKe;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DoiSoatDAO {

    private static final Pattern PATTERN_MA_THAM_CHIEU = Pattern.compile("PB\\d{4}T\\d{5,6}-\\d+", Pattern.CASE_INSENSITIVE);
    private static final DateTimeFormatter FMT_DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> doiChieu(List<DongSaoKe> dsSaoKe) {
        List<Map<String, Object>> ketQuaList = new ArrayList<>();
        if (dsSaoKe == null || dsSaoKe.isEmpty()) {
            return ketQuaList;
        }

        EntityManager em = JPAUtil.getEntityManager();
        try {
            NumberFormat currencyFmt = NumberFormat.getInstance(new Locale("vi", "VN"));

            for (DongSaoKe dong : dsSaoKe) {
                Map<String, Object> item = new HashMap<>();
                item.put("ngayGiaoDichText", dong.getNgayGiaoDich() != null ? dong.getNgayGiaoDich().format(FMT_DATE) : "—");
                item.put("soTienSaoKe", dong.getSoTien());
                item.put("soTienSaoKeFmt", dong.getSoTien() != null ? currencyFmt.format(dong.getSoTien()) + " đ" : "0 đ");
                item.put("noiDung", dong.getNoiDung());
                item.put("soThamChieuSaoKe", dong.getSoThamChieu());

                // 1. Trích mã tham chiếu từ noiDung qua Regex
                String maThamChieu = null;
                if (dong.getNoiDung() != null) {
                    Matcher matcher = PATTERN_MA_THAM_CHIEU.matcher(dong.getNoiDung());
                    if (matcher.find()) {
                        maThamChieu = matcher.group().toUpperCase();
                    }
                }

                item.put("maThamChieu", maThamChieu != null ? maThamChieu : "—");

                if (maThamChieu == null) {
                    item.put("ketQua", "KhongTimThayMa");
                    item.put("messageDetail", "Nội dung chuyển khoản không chứa mã GD tham chiếu (dạng PB...T...)");
                    ketQuaList.add(item);
                    continue;
                }

                // 2. Tìm giao dịch trong DB khớp maGiaoDichNganHang
                String sqlGd = "SELECT gd.id, gd.maHoaDon, gd.soTien, gd.trangThai, gd.soThamChieuSaoKe, " +
                               "       c.soPhong, h.thang, h.nam, h.tongTien " +
                               "FROM dbo.giaoDichThanhToan gd " +
                               "JOIN dbo.hoaDon h ON h.id = gd.maHoaDon " +
                               "JOIN dbo.canHo c ON c.id = h.maCanHo " +
                               "WHERE UPPER(gd.maGiaoDichNganHang) = :maCode";

                List<Object[]> rows = em.createNativeQuery(sqlGd)
                        .setParameter("maCode", maThamChieu)
                        .getResultList();

                if (rows.isEmpty()) {
                    item.put("ketQua", "KhongCoGiaoDich");
                    item.put("messageDetail", "Mã tham chiếu " + maThamChieu + " không khớp với bất kỳ giao dịch nào trong DB");
                    ketQuaList.add(item);
                    continue;
                }

                Object[] row = rows.get(0);
                int idGiaoDich = ((Number) row[0]).intValue();
                int maHoaDon = ((Number) row[1]).intValue();
                BigDecimal soTienGiaoDich = (BigDecimal) row[2];
                String trangThai = (String) row[3];
                String existingSoThamChieuSaoKe = (String) row[4];
                String soPhong = (String) row[5];
                int thang = ((Number) row[6]).intValue();
                int nam = ((Number) row[7]).intValue();

                item.put("idGiaoDich", idGiaoDich);
                item.put("maHoaDon", maHoaDon);
                item.put("soPhong", "P." + (soPhong != null ? soPhong.trim() : ""));
                item.put("kyHoaDon", "Tháng " + thang + "/" + nam);
                item.put("soTienGiaoDich", soTienGiaoDich);
                item.put("soTienGiaoDichFmt", currencyFmt.format(soTienGiaoDich) + " đ");

                // 3. Giao dịch đã xử lý trước đó (ThanhCong hoặc ThatBai)
                if ("ThanhCong".equalsIgnoreCase(trangThai) || "ThatBai".equalsIgnoreCase(trangThai)) {
                    item.put("ketQua", "DaXuLy");
                    item.put("messageDetail", "Giao dịch đã ở trạng thái [" + trangThai + "] từ trước");
                    ketQuaList.add(item);
                    continue;
                }

                // 4. Kiểm tra soThamChieuSaoKe đã tồn tại trong DB chưa
                if (existingSoThamChieuSaoKe != null && !existingSoThamChieuSaoKe.trim().isEmpty()) {
                    item.put("ketQua", "DaDoiSoatTruocDo");
                    item.put("messageDetail", "Giao dịch đã được đối soát với mã sao kê [" + existingSoThamChieuSaoKe + "]");
                    ketQuaList.add(item);
                    continue;
                }

                // Nếu file sao kê có số tham chiếu ngân hàng, check xem có trùng DB không
                if (dong.getSoThamChieu() != null && !dong.getSoThamChieu().trim().isEmpty()) {
                    String checkRefSql = "SELECT COUNT(*) FROM dbo.giaoDichThanhToan WHERE soThamChieuSaoKe = :ref";
                    Number countRef = (Number) em.createNativeQuery(checkRefSql)
                            .setParameter("ref", dong.getSoThamChieu().trim())
                            .getSingleResult();
                    if (countRef.intValue() > 0) {
                        item.put("ketQua", "DaDoiSoatTruocDo");
                        item.put("messageDetail", "Mã sao kê ngân hàng [" + dong.getSoThamChieu() + "] đã đối soát trước đó");
                        ketQuaList.add(item);
                        continue;
                    }
                }

                // 5. Kiểm tra chênh lệch số tiền
                if (dong.getSoTien() == null || dong.getSoTien().compareTo(soTienGiaoDich) != 0) {
                    BigDecimal diff = dong.getSoTien().subtract(soTienGiaoDich);
                    item.put("ketQua", "LechTien");
                    item.put("messageDetail", "Lệch tiền: Sao kê " + currencyFmt.format(dong.getSoTien()) + " đ vs DB " + currencyFmt.format(soTienGiaoDich) + " đ (Chênh lệch: " + currencyFmt.format(diff) + " đ)");
                    ketQuaList.add(item);
                    continue;
                }

                // 6. Khớp hoàn toàn
                item.put("ketQua", "Khop");
                item.put("messageDetail", "Khớp hoàn toàn thông tin & số tiền");
                ketQuaList.add(item);
            }

            return ketQuaList;

        } finally {
            em.close();
        }
    }

    public Map<String, Object> xacNhanHangLoat(List<Integer> dsMaGiaoDich, Map<Integer, String> mapThamChieuSaoKe, int maNhanVien) {
        Map<String, Object> res = new HashMap<>();
        int soThanhCong = 0;
        int soBoQua = 0;
        List<String> dsLoi = new ArrayList<>();

        if (dsMaGiaoDich == null || dsMaGiaoDich.isEmpty()) {
            res.put("soThanhCong", 0);
            res.put("soBoQua", 0);
            res.put("dsLoi", List.of("Không có giao dịch nào được chọn để xác nhận."));
            return res;
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        tx.begin();

        try {
            LocalDateTime now = LocalDateTime.now();
            String dateText = now.format(FMT_DATE);
            Set<Integer> setHoaDonNeedsCheck = new HashSet<>();

            for (Integer idGd : dsMaGiaoDich) {
                if (idGd == null) continue;

                // 1. Kiem tra lai trang thai phai la 'ChoXacNhan'
                String checkSql = "SELECT gd.trangThai, gd.maHoaDon FROM dbo.giaoDichThanhToan gd WHERE gd.id = :id";
                @SuppressWarnings("unchecked")
                List<Object[]> checkRows = em.createNativeQuery(checkSql)
                        .setParameter("id", idGd)
                        .getResultList();

                if (checkRows.isEmpty()) {
                    soBoQua++;
                    dsLoi.add("Giao dịch #" + idGd + " không tồn tại.");
                    continue;
                }

                Object[] row = checkRows.get(0);
                String trangThaiHienTai = (String) row[0];
                int maHoaDon = ((Number) row[1]).intValue();

                if (!"ChoXacNhan".equalsIgnoreCase(trangThaiHienTai)) {
                    soBoQua++;
                    dsLoi.add("Giao dịch #" + idGd + " đã chuyển trạng thái [" + trangThaiHienTai + "] trước đó.");
                    continue;
                }

                // Layer 2: Hard Block check - Tổng đã thu không bao giờ được vượt tongTien
                String sqlCheckDebt = "SELECT h.tongTien, " +
                        "  ISNULL((SELECT SUM(g.soTien) FROM dbo.giaoDichThanhToan g WHERE g.maHoaDon = h.id AND g.trangThai = 'ThanhCong'), 0), " +
                        "  gd.soTien " +
                        "FROM dbo.giaoDichThanhToan gd " +
                        "JOIN dbo.hoaDon h ON h.id = gd.maHoaDon " +
                        "WHERE gd.id = :id";
                @SuppressWarnings("unchecked")
                List<Object[]> debtRows = em.createNativeQuery(sqlCheckDebt).setParameter("id", idGd).getResultList();

                if (!debtRows.isEmpty()) {
                    Object[] dRow = debtRows.get(0);
                    BigDecimal tongTienHn = (BigDecimal) dRow[0];
                    BigDecimal daThu = (BigDecimal) dRow[1];
                    BigDecimal gdSoTien = (BigDecimal) dRow[2];
                    BigDecimal conNo = tongTienHn.subtract(daThu);
                    if (conNo.compareTo(BigDecimal.ZERO) < 0) conNo = BigDecimal.ZERO;

                    if (gdSoTien != null && gdSoTien.compareTo(conNo) > 0) {
                        soBoQua++;
                        java.text.NumberFormat curFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                        dsLoi.add("Giao dịch #" + idGd + ": Không thể xác nhận — Hóa đơn còn nợ " + curFmt.format(conNo) + "đ nhưng giao dịch là " + curFmt.format(gdSoTien) + "đ.");
                        continue;
                    }
                }

                String refSaoKe = mapThamChieuSaoKe != null ? mapThamChieuSaoKe.get(idGd) : null;
                String ghiChu = "Đối soát tự động từ sao kê ngày " + dateText;

                try {
                    String updateGdSql = "UPDATE dbo.giaoDichThanhToan " +
                            "SET trangThai = 'ThanhCong', thoiGianXacNhan = :now, soThamChieuSaoKe = :ref, ghiChuDoiSoat = :ghiChu " +
                            "WHERE id = :id AND trangThai = 'ChoXacNhan'";

                    int updated = em.createNativeQuery(updateGdSql)
                            .setParameter("now", now)
                            .setParameter("ref", (refSaoKe != null && !refSaoKe.trim().isEmpty()) ? refSaoKe.trim() : null)
                            .setParameter("ghiChu", ghiChu)
                            .setParameter("id", idGd)
                            .executeUpdate();

                    if (updated > 0) {
                        soThanhCong++;
                        setHoaDonNeedsCheck.add(maHoaDon);
                    } else {
                        soBoQua++;
                    }

                } catch (Exception ex) {
                    // Neu gap loi UNIQUE index tren soThamChieuSaoKe -> ghi nhan va bo qua
                    soBoQua++;
                    dsLoi.add("Giao dịch #" + idGd + ": Mã sao kê [" + refSaoKe + "] đã được đối soát trước đó.");
                }
            }

            // 2. Cap nhat trang thai hoa don & Layer 3 tu dong huy cac giao dich pending phu
            for (Integer maHd : setHoaDonNeedsCheck) {
                String sqlSum = "SELECT SUM(soTien) FROM dbo.giaoDichThanhToan WHERE maHoaDon = :maHd AND trangThai = 'ThanhCong'";
                Object sumObj = em.createNativeQuery(sqlSum).setParameter("maHd", maHd).getSingleResult();
                BigDecimal tongDaThanhToan = sumObj != null ? new BigDecimal(sumObj.toString()) : BigDecimal.ZERO;

                String sqlHd = "SELECT tongTien FROM dbo.hoaDon WHERE id = :maHd";
                Object tongTienObj = em.createNativeQuery(sqlHd).setParameter("maHd", maHd).getSingleResult();
                BigDecimal tongTienHoaDon = tongTienObj != null ? new BigDecimal(tongTienObj.toString()) : BigDecimal.ZERO;

                if (tongDaThanhToan.compareTo(tongTienHoaDon) >= 0) {
                    em.createNativeQuery("UPDATE dbo.hoaDon SET trangThaiThanhToan = 'DaThanhToan' WHERE id = :maHd")
                            .setParameter("maHd", maHd)
                            .executeUpdate();

                    // Layer 3: Tự động hủy các giao dịch 'ChoXacNhan' còn lại của hóa đơn
                    em.createNativeQuery(
                        "UPDATE dbo.giaoDichThanhToan " +
                        "SET trangThai = 'ThatBai', ghiChuDoiSoat = N'Tự động hủy — hóa đơn đã thanh toán đủ' " +
                        "WHERE maHoaDon = :maHd AND trangThai = 'ChoXacNhan'"
                    ).setParameter("maHd", maHd).executeUpdate();
                }
            }

            tx.commit();

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Lỗi trong xacNhanHangLoat: " + e.getMessage());
            e.printStackTrace();
            dsLoi.add("Lỗi hệ thống: " + e.getMessage());
        } finally {
            em.close();
        }

        res.put("soThanhCong", soThanhCong);
        res.put("soBoQua", soBoQua);
        res.put("dsLoi", dsLoi);

        return res;
    }
}
