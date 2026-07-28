package util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Utility class hỗ trợ hiển thị nhãn tiếng Việt và CSS Badge cho các Enum trong hệ thống.
 */
public class DisplayUtil {

    public static String getLoaiSuCoText(String code) {
        if (code == null) return "";
        switch (code) {
            case "Dien": return "Điện";
            case "Nuoc": return "Nước";
            case "ThangMay": return "Thang máy";
            case "PCCC": return "PCCC";
            case "AnNinh": return "An ninh";
            case "VeSinh": return "Vệ sinh";
            case "Khac": return "Khác";
            default: return code;
        }
    }

    public static String getMucDoUuTienText(String code) {
        if (code == null) return "";
        switch (code) {
            case "Cao": return "Cao (khẩn)";
            case "TrungBinh": return "Trung bình";
            case "Thap": return "Thấp";
            default: return code;
        }
    }

    public static String getMucDoUuTienBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "Cao": return "bg-danger";
            case "TrungBinh": return "bg-warning text-dark";
            case "Thap": return "bg-info text-dark";
            default: return "bg-secondary";
        }
    }

    public static String getTrangThaiSuCoText(String code) {
        if (code == null) return "";
        switch (code) {
            case "MoiTiepNhan": return "Mới tiếp nhận";
            case "DaTiepNhan": return "Đã tiếp nhận";
            case "DangXuLy": return "Đang xử lý";
            case "HoanThanh": return "Hoàn thành";
            case "Huy": return "Đã hủy";
            case "DaPhanCong": return "Đã phân công";
            default: return code;
        }
    }

    public static String getTrangThaiSuCoBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "MoiTiepNhan": return "bg-secondary";
            case "DaTiepNhan": return "bg-info text-dark";
            case "DaPhanCong": return "bg-info text-dark";
            case "DangXuLy": return "bg-primary";
            case "HoanThanh": return "bg-success";
            case "Huy": return "bg-danger bg-opacity-75";
            default: return "bg-secondary";
        }
    }

    public static String formatDate(Date date) {
        if (date == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(date);
    }

    // --- BỔ SUNG CÁC HÀM CHO ROLE KẾ TOÁN ---

    public static String getLoaiDichVuText(String code) {
        if (code == null) return "";
        switch (code) {
            case "Dien": return "Điện";
            case "Nuoc": return "Nước";
            case "PhiQuanLy": return "Phí quản lý";
            case "GuiXeOTo": return "Gửi xe ô tô";
            case "GuiXeMay": return "Gửi xe máy";
            case "DatTienIch": return "Đặt tiện ích";
            default: return code;
        }
    }

    public static String getTrangThaiThanhToanText(String code) {
        if (code == null) return "";
        switch (code) {
            case "ChuaThanhToan": return "Chưa thanh toán";
            case "DaThanhToan": return "Đã thanh toán";
            case "QuaHan": return "Quá hạn";
            default: return code;
        }
    }

    public static String getTrangThaiThanhToanBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "ChuaThanhToan": return "bg-warning text-dark";
            case "DaThanhToan": return "bg-success";
            case "QuaHan": return "bg-danger";
            default: return "bg-secondary";
        }
    }

    public static String getDonViTinhText(String code) {
        if (code == null) return "";
        switch (code) {
            case "kWh": return "kWh";
            case "m3": return "m³";
            case "m2": return "m²";
            case "xe": return "xe";
            case "luot": return "lượt";
            default: return code;
        }
    }

    public static String formatTien(BigDecimal tien) {
        if (tien == null) return "0đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(tien) + "đ";
    }
}
