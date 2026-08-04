package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class NFCTheUtil {

    private static final String SECRET = "PolyBuilding-TheNFC-2026";

    public static String sinhToken(String soThe) {
        try {
            String input = SECRET + "|" + (soThe != null ? soThe.trim() : "");
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.substring(0, 8);
        } catch (Exception e) {
            throw new RuntimeException("Error generating NFC token", e);
        }
    }

    public static boolean kiemTraToken(String soThe, String token) {
        if (soThe == null || token == null || token.trim().isEmpty()) {
            return false;
        }
        String expected = sinhToken(soThe.trim());
        return expected.equalsIgnoreCase(token.trim());
    }

    public static String buildLoginUrl(String baseUrl, String soThe) {
        try {
            String cleanBase = (baseUrl != null) ? baseUrl.replaceAll("/+$", "") : "";
            String cleanSoThe = (soThe != null) ? soThe.trim() : "";
            String encodedSoThe = URLEncoder.encode(cleanSoThe, StandardCharsets.UTF_8);
            String token = sinhToken(cleanSoThe);
            return cleanBase + "/dang-nhap-the?soThe=" + encodedSoThe + "&token=" + token;
        } catch (Exception e) {
            throw new RuntimeException("Error building NFC login URL", e);
        }
    }
}
