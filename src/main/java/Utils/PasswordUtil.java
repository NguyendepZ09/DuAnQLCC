package Utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility ma hoa va kiem tra mat khau su dung jBCrypt
 */
public class PasswordUtil {

    /**
     * Bam mat khau bang BCrypt
     */
    public static String hash(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiem tra mat khau tho voi chuoi da bam BCrypt
     */
    public static boolean verify(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            // Neu mat khau trong DB bat dau bang $2a$ hoac $2b$ hoac $2y$ -> BCrypt verify
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainTextPassword, hashedPassword);
            }
            // Fallback so sanh chuoi tho (danh cho tai khoan test ban dau chua bam BCrypt)
            return plainTextPassword.equals(hashedPassword);
        } catch (Exception e) {
            return plainTextPassword.equals(hashedPassword);
        }
    }
}
