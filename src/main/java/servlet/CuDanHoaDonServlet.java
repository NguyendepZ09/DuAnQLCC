package servlet;

import dao.GiaoDichThanhToanDAO;
import dao.HoaDonDAO;
import util.DisplayUtil;
import util.QRConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet({"/cudan/hoa-don", "/cudan/hoa-don/chi-tiet", "/cudan/hoa-don/thanh-toan-qr"})
public class CuDanHoaDonServlet extends HttpServlet {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();
    private final GiaoDichThanhToanDAO giaoDichThanhToanDAO = new GiaoDichThanhToanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer maCanHo = (Integer) req.getSession().getAttribute("maCanHo");
        if (maCanHo == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String uri = req.getRequestURI();
        if (uri.endsWith("/chi-tiet")) {
            hienThiChiTiet(req, resp, maCanHo);
        } else if (uri.endsWith("/thanh-toan-qr")) {
            // GET request for QR -> check pending QR
            hienThiQRDangCho(req, resp, maCanHo);
        } else {
            hienThiDanhSach(req, resp, maCanHo);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Integer maCanHo = (Integer) req.getSession().getAttribute("maCanHo");
        Integer maCuDan = (Integer) req.getSession().getAttribute("maCuDan");

        if (maCanHo == null || maCuDan == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String uri = req.getRequestURI();
        if (uri.endsWith("/thanh-toan-qr")) {
            xuLyThanhToanQR(req, resp, maCanHo, maCuDan);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
        }
    }

    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        List<Object[]> list = hoaDonDAO.findHoaDonTheoCanHo(maCanHo);

        int tongSoHoaDon = list.size();
        int soChuaThanhToan = 0;
        BigDecimal tongCongNo = BigDecimal.ZERO;

        for (Object[] row : list) {
            String trangThai = (String) row[4];
            BigDecimal conNo = (BigDecimal) row[6];
            if (!"DaThanhToan".equalsIgnoreCase(trangThai)) {
                soChuaThanhToan++;
                if (conNo != null && conNo.compareTo(BigDecimal.ZERO) > 0) {
                    tongCongNo = tongCongNo.add(conNo);
                }
            }
        }

        req.setAttribute("hoaDonList", list);
        req.setAttribute("tongSoHoaDon", tongSoHoaDon);
        req.setAttribute("soChuaThanhToan", soChuaThanhToan);
        req.setAttribute("tongCongNo", tongCongNo);
        req.setAttribute("activeMenu", "hoa-don");

        req.getRequestDispatcher("/WEB-INF/views/cudan/hoa-don.jsp").forward(req, resp);
    }

    private void hienThiChiTiet(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        // --- KIỂM TRA CHỐNG IDOR (RẤT QUAN TRỌNG) ---
        boolean isOwner = hoaDonDAO.hoaDonThuocCanHo(id, maCanHo);
        if (!isOwner) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, resp);
            return;
        }

        Map<String, Object> data = hoaDonDAO.findChiTietChoCuDan(id);
        if (data == null) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        req.setAttribute("data", data);
        req.setAttribute("activeMenu", "hoa-don");

        // Flash message or modal data from session if any
        if (req.getSession().getAttribute("qrResultModal") != null) {
            req.setAttribute("qrResultModal", req.getSession().getAttribute("qrResultModal"));
            req.getSession().removeAttribute("qrResultModal");
        }
        if (req.getSession().getAttribute("errorMessage") != null) {
            req.setAttribute("errorMessage", req.getSession().getAttribute("errorMessage"));
            req.getSession().removeAttribute("errorMessage");
        }

        req.getRequestDispatcher("/WEB-INF/views/cudan/hoa-don-chi-tiet.jsp").forward(req, resp);
    }

    private void hienThiQRDangCho(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        String idStr = req.getParameter("maHoaDon");
        if (idStr == null || idStr.isBlank()) idStr = req.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        int maHoaDon;
        try {
            maHoaDon = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        Map<String, Object> qrResult = giaoDichThanhToanDAO.layGiaoDichQRDangCho(maHoaDon, maCanHo);
        
        resp.setContentType("application/json;charset=UTF-8");
        var out = resp.getWriter();

        if (qrResult == null) {
            out.print("{\"success\":false,\"loi\":\"Không tìm thấy giao dịch QR đang chờ nào cho hóa đơn này.\"}");
        } else {
            Number amtNum = (Number) qrResult.get("soTien");
            double amt = amtNum != null ? amtNum.doubleValue() : 0.0;
            out.print(String.format(
                "{\"success\":true,\"maGiaoDich\":%s,\"soTien\":%.2f,\"soTienFormatted\":\"%s\",\"noiDungChuyenKhoan\":\"%s\",\"qrUrl\":\"%s\",\"bankCode\":\"%s\",\"accountNo\":\"%s\",\"accountName\":\"%s\"}",
                qrResult.get("maGiaoDich"),
                amt,
                DisplayUtil.formatTienDouble(amt),
                escapeJson((String) qrResult.get("noiDungChuyenKhoan")),
                escapeJson((String) qrResult.get("qrUrl")),
                QRConfig.BANK_CODE,
                QRConfig.ACCOUNT_NO,
                escapeJson(QRConfig.ACCOUNT_NAME)
            ));
        }
    }

    private void xuLyThanhToanQR(HttpServletRequest req, HttpServletResponse resp, int maCanHo, int maCuDan) throws ServletException, IOException {
        String idStr = req.getParameter("maHoaDon");
        if (idStr == null || idStr.isBlank()) idStr = req.getParameter("id");

        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        int maHoaDon;
        try {
            maHoaDon = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        Map<String, Object> qrResult = giaoDichThanhToanDAO.taoGiaoDichQR(maHoaDon, maCanHo, maCuDan);

        String format = req.getParameter("format");
        String accept = req.getHeader("Accept");
        String requestedWith = req.getHeader("X-Requested-With");

        if ("json".equalsIgnoreCase(format) || (accept != null && accept.contains("application/json")) || "XMLHttpRequest".equalsIgnoreCase(requestedWith)) {
            resp.setContentType("application/json;charset=UTF-8");
            var out = resp.getWriter();
            if (qrResult.containsKey("loi")) {
                out.print("{\"success\":false,\"loi\":\"" + escapeJson((String) qrResult.get("loi")) + "\"}");
            } else {
                Number amtNum = (Number) qrResult.get("soTien");
                double amt = amtNum != null ? amtNum.doubleValue() : 0.0;
                out.print(String.format(
                    "{\"success\":true,\"maGiaoDich\":%s,\"soTien\":%.2f,\"soTienFormatted\":\"%s\",\"noiDungChuyenKhoan\":\"%s\",\"qrUrl\":\"%s\",\"bankCode\":\"%s\",\"accountNo\":\"%s\",\"accountName\":\"%s\"}",
                    qrResult.get("maGiaoDich"),
                    amt,
                    DisplayUtil.formatTienDouble(amt),
                    escapeJson((String) qrResult.get("noiDungChuyenKhoan")),
                    escapeJson((String) qrResult.get("qrUrl")),
                    QRConfig.BANK_CODE,
                    QRConfig.ACCOUNT_NO,
                    escapeJson(QRConfig.ACCOUNT_NAME)
                ));
            }
            return;
        }

        // Form POST fallback
        if (qrResult.containsKey("loi")) {
            req.getSession().setAttribute("errorMessage", qrResult.get("loi"));
        } else {
            req.getSession().setAttribute("qrResultModal", qrResult);
        }
        resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don/chi-tiet?id=" + maHoaDon);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
