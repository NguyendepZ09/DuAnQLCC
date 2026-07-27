package util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility ma hoa va kiem tra mat khau su dung BCrypt (at.favre.lib:bcrypt)
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
        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                BCrypt.Result result = BCrypt.verifyer().verify(plainTextPassword.toCharArray(), hashedPassword);
                if (result.verified) {
                    return true;
                }
                try {
                    return org.mindrot.jbcrypt.BCrypt.checkpw(plainTextPassword, hashedPassword);
                } catch (Exception ignored) {
                    return false;
                }
            }
            return plainTextPassword.equals(hashedPassword);
        } catch (Exception e) {
            return plainTextPassword.equals(hashedPassword);
        }
    }
}
