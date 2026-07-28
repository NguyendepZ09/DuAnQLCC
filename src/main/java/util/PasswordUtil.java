package util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility mã hóa và kiểm tra mật khẩu sử dụng BCrypt (at.favre.lib:bcrypt)
 * Hỗ trợ fallback so sánh chuỗi plain-text nếu dữ liệu seed DB chứa mật khẩu thô.
 */
public class PasswordUtil {

    public static String hash(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.isEmpty()) {
            return null;
        }
        return BCrypt.withDefaults().hashToString(12, plainTextPassword.toCharArray());
    }

    public static boolean verify(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }

        // Nếu mật khẩu trong DB là chuỗi plain text (chưa hash BCrypt từ dữ liệu mẫu)
        if (!hashedPassword.startsWith("$2a$") && !hashedPassword.startsWith("$2b$") && !hashedPassword.startsWith("$2y$")) {
            return plainTextPassword.equals(hashedPassword);
        }

        try {
            BCrypt.Result result = BCrypt.verifyer().verify(plainTextPassword.toCharArray(), hashedPassword);
            return result.verified;
        } catch (Exception e) {
            System.err.println("Lỗi khi xác thực BCrypt: " + e.getMessage());
            return plainTextPassword.equals(hashedPassword);
        }
    }
}
