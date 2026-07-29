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

    public static String formatDateOnly(Date date) {
        if (date == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy").format(date);
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

    public static String getDonViGiaText(String loaiDichVu) {
        if (loaiDichVu == null) return "";
        switch (loaiDichVu) {
            case "Dien": return "đ/kWh";
            case "Nuoc": return "đ/m³";
            case "PhiQuanLy": return "đ/m²/tháng";
            case "GuiXeOTo":
            case "GuiXeMay": return "đ/xe/tháng";
            default: return "";
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

    public static String getPhuongThucText(String code) {
        if (code == null) return "";
        switch (code) {
            case "TienMat": return "Tiền mặt";
            case "ChuyenKhoan": return "Chuyển khoản";
            case "QR": return "Quét mã QR";
            default: return code;
        }
    }

    public static String getTrangThaiGiaoDichText(String code) {
        if (code == null) return "";
        switch (code) {
            case "ChoXacNhan": return "Chờ xác nhận";
            case "ThanhCong": return "Thành công";
            case "ThatBai": return "Thất bại";
            default: return code;
        }
    }

    public static String getTrangThaiGiaoDichBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "ChoXacNhan": return "bg-warning text-dark";
            case "ThanhCong": return "bg-success";
            case "ThatBai": return "bg-danger";
            default: return "bg-secondary";
        }
    }

    // --- BỔ SUNG CÁC HÀM CHO ROLE CƯ DÂN (ĐẶT TIỆN ÍCH) ---

    public static String getTrangThaiDatLichText(String code) {
        if (code == null) return "";
        switch (code) {
            case "ChoDuyet": return "Chờ duyệt";
            case "DaDuyet": return "Đã duyệt";
            case "HoanThanh": return "Hoàn thành";
            case "DaHuy": return "Đã hủy";
            default: return code;
        }
    }

    public static String getTrangThaiDatLichBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "ChoDuyet": return "bg-warning text-dark";
            case "DaDuyet": return "bg-success";
            case "HoanThanh": return "bg-secondary";
            case "DaHuy": return "bg-danger bg-opacity-75";
            default: return "bg-secondary";
        }
    }

    public static String getTrangThaiTienIchText(String code) {
        if (code == null) return "";
        switch (code) {
            case "HoatDong": return "Đang hoạt động";
            case "TamNgung": return "Tạm ngưng";
            case "BaoTri": return "Đang bảo trì";
            default: return code;
        }
    }

    // --- BỔ SUNG CÁC HÀM CHO ROLE BẢO VỆ ---

    public static String getCaTrucText(String code) {
        if (code == null) return "";
        switch (code) {
            case "Sang": return "Ca sáng (06:00-14:00)";
            case "Chieu": return "Ca chiều (14:00-22:00)";
            case "Dem": return "Ca đêm (22:00-06:00)";
            default: return code;
        }
    }

    public static String getCaTrucBadgeClass(String code) {
        if (code == null) return "bg-secondary";
        switch (code) {
            case "Sang": return "bg-warning text-dark";
            case "Chieu": return "bg-info text-dark";
            case "Dem": return "bg-dark text-white";
            default: return "bg-secondary";
        }
    }

    public static String getTrangThaiTheText(String code) {
        if (code == null) return "";
        switch (code) {
            case "DangSuDung": return "Đang sử dụng";
            case "TamKhoa": return "Tạm khóa";
            case "DaThuHoi": return "Đã thu hồi";
            default: return code;
        }
    }

    public static String getLoaiXeText(String code) {
        if (code == null) return "";
        switch (code) {
            case "OTo": return "Ô tô";
            case "XeMay": return "Xe máy";
            case "XeDap": return "Xe đạp";
            default: return code;
        }
    }

    public static String getChucNangTheText(String code) {
        if (code == null) return "";
        switch (code) {
            case "CuaChinh": return "Cửa chính";
            case "ThangMay": return "Thang máy";
            case "BaiXeOTo": return "Bãi xe ô tô";
            case "BaiXeMay": return "Bãi xe máy";
            case "HoBoi": return "Hồ bơi";
            case "PhongGym": return "Phòng Gym";
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

    public static String formatTienDouble(Double tien) {
        if (tien == null) return "0đ";
        return formatTien(BigDecimal.valueOf(tien));
    }
}
