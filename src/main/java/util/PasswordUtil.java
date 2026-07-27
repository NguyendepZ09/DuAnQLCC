package util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility ma hoa va kiem tra mat khau su dung duy nhat BCrypt (at.favre.lib:bcrypt)
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

        // Dam bao chuoi hash phai thuoc dinh dang BCrypt hop le ($2a$, $2b$, $2y$)
        if (!hashedPassword.startsWith("$2a$") && !hashedPassword.startsWith("$2b$") && !hashedPassword.startsWith("$2y$")) {
            System.err.println("CANH BAO BAO MAT: Mat khau trong DB khong phai dinh dang BCrypt hash hop le! Tu choi xac thuc.");
            return false;
        }

        try {
            BCrypt.Result result = BCrypt.verifyer().verify(plainTextPassword.toCharArray(), hashedPassword);
            return result.verified;
        } catch (Exception e) {
            System.err.println("Loi khi xac thuc BCrypt: " + e.getMessage());
            return false;
        }
    }
}
