package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class QRTuanTraUtil {

    private static final String SECRET = "PolyBuilding-TuanTra-2026";
    public static final int SO_TANG = 25;

    public static String sinhToken(int soTang) {
        try {
            String input = SECRET + "|" + soTang;
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
            throw new RuntimeException("Error generating patrol QR token", e);
        }
    }

    public static boolean kiemTraToken(int soTang, String token) {
        if (token == null || token.trim().isEmpty()) {
            return false;
        }
        String expected = sinhToken(soTang);
        return expected.equalsIgnoreCase(token.trim());
    }

    public static String buildScanUrl(String baseUrl, int soTang) {
        String token = sinhToken(soTang);
        String cleanBase = (baseUrl != null) ? baseUrl.replaceAll("/+$", "") : "";
        return cleanBase + "/baove/tuan-tra/quet?tang=" + soTang + "&token=" + token;
    }

    public static String buildQRImageUrl(String baseUrl, int soTang) {
        String scanUrl = buildScanUrl(baseUrl, soTang);
        String encodedUrl = URLEncoder.encode(scanUrl, StandardCharsets.UTF_8);
        return "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=" + encodedUrl;
    }
}
