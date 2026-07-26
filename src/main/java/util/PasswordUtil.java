package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility ma hoa va kiem tra mat khau su dung jBCrypt
 */
public class PasswordUtil {

    public static String hash(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(12));
    }

    public static boolean verify(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(plainTextPassword, hashedPassword);
            }
            return plainTextPassword.equals(hashedPassword);
        } catch (Exception e) {
            return plainTextPassword.equals(hashedPassword);
        }
    }
}
