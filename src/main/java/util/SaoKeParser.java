package util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class SaoKeParser {

    public static class DongSaoKe {
        private LocalDate ngayGiaoDich;
        private BigDecimal soTien;
        private String noiDung;
        private String soThamChieu;
        private int lineNum;

        public DongSaoKe() {}

        public DongSaoKe(LocalDate ngayGiaoDich, BigDecimal soTien, String noiDung, String soThamChieu) {
            this.ngayGiaoDich = ngayGiaoDich;
            this.soTien = soTien;
            this.noiDung = noiDung;
            this.soThamChieu = soThamChieu;
        }

        public LocalDate getNgayGiaoDich() { return ngayGiaoDich; }
        public void setNgayGiaoDich(LocalDate ngayGiaoDich) { this.ngayGiaoDich = ngayGiaoDich; }

        public BigDecimal getSoTien() { return soTien; }
        public void setSoTien(BigDecimal soTien) { this.soTien = soTien; }

        public String getNoiDung() { return noiDung; }
        public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

        public String getSoThamChieu() { return soThamChieu; }
        public void setSoThamChieu(String soThamChieu) { this.soThamChieu = soThamChieu; }

        public int getLineNum() { return lineNum; }
        public void setLineNum(int lineNum) { this.lineNum = lineNum; }
    }

    public static class ParseResult {
        private List<DongSaoKe> danhSach = new ArrayList<>();
        private int tongSoDong = 0;
        private int soDongLoi = 0;
        private int soDongBoQua = 0; // Số tiền <= 0 hoặc rỗng

        public List<DongSaoKe> getDanhSach() { return danhSach; }
        public int getTongSoDong() { return tongSoDong; }
        public int getSoDongLoi() { return soDongLoi; }
        public int getSoDongBoQua() { return soDongBoQua; }
    }

    private static final DateTimeFormatter FMT_DDMMYYYY = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FMT_YYYYMMDD = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static ParseResult parse(InputStream inputStream) throws Exception {
        ParseResult result = new ParseResult();
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));

        String line = reader.readLine();
        if (line == null) {
            throw new Exception("File sao kê rỗng, không có dữ liệu!");
        }

        // Xử lý BOM character \uFEFF ở đầu file
        if (line.startsWith("\uFEFF")) {
            line = line.substring(1);
        }

        // Tự động nhận diện dấu phân cách (thử ',' trước, nếu < 3 cột thì thử ';')
        String delimiter = ",";
        String[] headers = splitCsvLine(line, ",");
        if (headers.length < 3) {
            String[] headersSemi = splitCsvLine(line, ";");
            if (headersSemi.length >= 3) {
                delimiter = ";";
                headers = headersSemi;
            }
        }

        int colNgay = -1;
        int colSoTien = -1;
        int colNoiDung = -1;
        int colThamChieu = -1;

        for (int i = 0; i < headers.length; i++) {
            String h = normalizeText(headers[i]);
            if (colNgay == -1 && (h.contains("ngay") || h.contains("date"))) {
                colNgay = i;
            } else if (colSoTien == -1 && (h.contains("ghi co") || h.contains("credit") || h.contains("so tien") || h.contains("amount"))) {
                colSoTien = i;
            } else if (colNoiDung == -1 && (h.contains("noi dung") || h.contains("mo ta") || h.contains("description") || h.contains("detail"))) {
                colNoiDung = i;
            } else if (colThamChieu == -1 && (h.contains("tham chieu") || h.contains("reference") || h.contains("ma gd"))) {
                colThamChieu = i;
            }
        }

        if (colNgay == -1) {
            throw new Exception("Không tìm thấy cột Ngày giao dịch trong file sao kê!");
        }
        if (colSoTien == -1) {
            throw new Exception("Không tìm thấy cột Số tiền / Ghi có trong file sao kê!");
        }
        if (colNoiDung == -1) {
            throw new Exception("Không tìm thấy cột Nội dung chuyển khoản trong file sao kê!");
        }

        int currentLineNum = 1;
        while ((line = reader.readLine()) != null) {
            currentLineNum++;
            if (line.trim().isEmpty()) {
                continue;
            }

            result.tongSoDong++;
            String[] tokens = splitCsvLine(line, delimiter);

            try {
                String strNgay = getSafeToken(tokens, colNgay);
                String strSoTien = getSafeToken(tokens, colSoTien);
                String strNoiDung = getSafeToken(tokens, colNoiDung);
                String strThamChieu = colThamChieu != -1 ? getSafeToken(tokens, colThamChieu) : "";

                if (strNgay.isEmpty() || strSoTien.isEmpty()) {
                    result.soDongLoi++;
                    continue;
                }

                // Parse Ngày
                LocalDate ngay = parseDate(strNgay);
                if (ngay == null) {
                    result.soDongLoi++;
                    continue;
                }

                // Parse Số tiền (bỏ dấu chấm, phẩy, ký tự không phải số)
                BigDecimal soTien = parseAmount(strSoTien);
                if (soTien == null || soTien.compareTo(BigDecimal.ZERO) <= 0) {
                    result.soDongBoQua++;
                    continue; // Bỏ qua tiền âm hoặc 0
                }

                DongSaoKe dong = new DongSaoKe(ngay, soTien, strNoiDung, strThamChieu);
                dong.setLineNum(currentLineNum);
                result.getDanhSach().add(dong);

            } catch (Exception e) {
                result.soDongLoi++;
            }
        }

        return result;
    }

    private static String[] splitCsvLine(String line, String delimiter) {
        List<String> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (line.startsWith(delimiter, i) && !inQuotes) {
                list.add(sb.toString().trim().replaceAll("^\"|\"$", ""));
                sb.setLength(0);
                i += delimiter.length() - 1;
            } else {
                sb.append(c);
            }
        }
        list.add(sb.toString().trim().replaceAll("^\"|\"$", ""));
        return list.toArray(new String[0]);
    }

    private static String getSafeToken(String[] tokens, int index) {
        if (index >= 0 && index < tokens.length) {
            return tokens[index].trim();
        }
        return "";
    }

    private static String normalizeText(String text) {
        if (text == null) return "";
        String normalized = Normalizer.normalize(text.toLowerCase(), Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(normalized).replaceAll("");
    }

    private static LocalDate parseDate(String text) {
        if (text == null || text.trim().isEmpty()) return null;
        String clean = text.trim();
        try {
            if (clean.contains("/")) {
                return LocalDate.parse(clean, FMT_DDMMYYYY);
            } else if (clean.contains("-")) {
                return LocalDate.parse(clean, FMT_YYYYMMDD);
            }
        } catch (Exception ignored) {}
        return null;
    }

    private static BigDecimal parseAmount(String text) {
        if (text == null || text.trim().isEmpty()) return null;
        // Loại bỏ mọi ký tự không phải số (giữ lại chỉ các chữ số)
        String clean = text.replaceAll("[^0-9]", "");
        if (clean.isEmpty()) return null;
        return new BigDecimal(clean);
    }
}
