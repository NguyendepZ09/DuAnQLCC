package util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Cấu hình tài khoản ngân hàng nhận tiền của Ban Quản Lý (Mô phỏng VietQR / NAPAS).
 * GHI CHÚ: Đây là tài khoản DEMO phục vụ đồ án tốt nghiệp.
 * Trong thực tế (Production), thông tin này phải đưa vào file cấu hình hệ thống
 * (application.properties hoặc bảng system_config trong DB), không hardcode rải rác.
 */
public class QRConfig {

    public static final String BANK_CODE = "970436"; // Vietcombank - Mã NAPAS
    public static final String ACCOUNT_NO = "1234567890"; // Số tài khoản demo của BQL
    public static final String ACCOUNT_NAME = "BAN QUAN LY CHUNG CU POLYBUILDING";

    /**
     * Sinh URL ảnh QR theo chuẩn VietQR API
     */
    public static String buildQRUrl(BigDecimal soTien, String noiDung) {
        if (soTien == null || soTien.compareTo(BigDecimal.ZERO) <= 0) {
            soTien = BigDecimal.ZERO;
        }

        // Số tiền phải là số nguyên không phần thập phân (VND không có xu)
        String amountStr = soTien.setScale(0, RoundingMode.DOWN).toPlainString();

        String encodedInfo = noiDung != null ? URLEncoder.encode(noiDung.trim(), StandardCharsets.UTF_8) : "";
        String encodedName = URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8);

        return String.format(
            "https://img.vietqr.io/image/%s-%s-compact2.png?amount=%s&addInfo=%s&accountName=%s",
            BANK_CODE,
            ACCOUNT_NO,
            amountStr,
            encodedInfo,
            encodedName
        );
    }
}
