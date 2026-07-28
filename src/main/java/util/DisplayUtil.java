package util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class ho tro hien thi nhan tieng Viet va CSS Badge cho cac Enum trong he thong.
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
            // Hop le voi ca lich su xu ly:
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
}
