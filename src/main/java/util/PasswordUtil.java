package util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility mã hóa và kiểm tra mật khẩu sử dụng BCrypt (at.favre.lib:bcrypt).
 * Đảm bảo xác thực nghiêm ngặt BCrypt, không chấp nhận mật khẩu thô trong DB.
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

        // Hash phải đúng định dạng BCrypt ($2a$, $2b$, $2y$)
        if (!hashedPassword.startsWith("$2a$") && !hashedPassword.startsWith("$2b$") && !hashedPassword.startsWith("$2y$")) {
            System.err.println("[PasswordUtil] WARN: Mật khẩu trong DB không đúng định dạng BCrypt hợp lệ.");
            return false;
        }

        try {
            BCrypt.Result result = BCrypt.verifyer().verify(plainTextPassword.toCharArray(), hashedPassword);
            return result.verified;
        } catch (Exception e) {
            System.err.println("[PasswordUtil] ERROR: Lỗi khi xác thực BCrypt: " + e.getMessage());
            return false;
        }
    }
}
