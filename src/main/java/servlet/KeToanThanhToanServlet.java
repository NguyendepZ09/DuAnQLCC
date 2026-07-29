package servlet;

import dao.GiaoDichThanhToanDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet({"/ketoan/thanh-toan", "/ketoan/thanh-toan/ghi-nhan", "/ketoan/thanh-toan/xac-nhan", "/ketoan/thanh-toan/tu-choi"})
public class KeToanThanhToanServlet extends HttpServlet {

    private final GiaoDichThanhToanDAO thanhToanDAO = new GiaoDichThanhToanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer thang = getNullableInt(req.getParameter("thang"));
        Integer nam = getNullableInt(req.getParameter("nam"));

        List<Object[]> pendingList = thanhToanDAO.findPendingTransactions();
        List<Object[]> unpaidList = thanhToanDAO.findUnpaidInvoices(thang, nam);
        Map<String, Object> stats = thanhToanDAO.getPaymentDashboardStats();

        req.setAttribute("thang", thang);
        req.setAttribute("nam", nam);
        req.setAttribute("pendingList", pendingList);
        req.setAttribute("unpaidList", unpaidList);
        req.setAttribute("stats", stats);
        req.setAttribute("activeMenu", "xac-nhan");

        req.getRequestDispatcher("/WEB-INF/views/ketoan/thanh-toan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/ghi-nhan")) {
            xuLyGhiNhan(req, resp);
        } else if (uri.endsWith("/xac-nhan")) {
            xuLyXacNhan(req, resp);
        } else if (uri.endsWith("/tu-choi")) {
            xuLyTuChoi(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan");
        }
    }

    private void xuLyGhiNhan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String maHoaDonStr = req.getParameter("maHoaDon");
        String soTienStr = req.getParameter("soTien");
        String phuongThuc = req.getParameter("phuongThuc");
        String maGiaoDichNganHang = req.getParameter("maGiaoDichNganHang");

        try {
            int maHoaDon = Integer.parseInt(maHoaDonStr.trim());
            BigDecimal soTien = new BigDecimal(soTienStr.trim());

            String err = thanhToanDAO.ghiNhanThanhToan(maHoaDon, soTien, phuongThuc, maGiaoDichNganHang);
            if (err == null) {
                String msg = URLEncoder.encode("Ghi nhận giao dịch thanh toán thành công!", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?msg=" + msg);
            } else if (err.startsWith("⚠️")) {
                String msg = URLEncoder.encode("Ghi nhận giao dịch thành công! " + err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?error=" + errMsg);
            }
        } catch (Exception e) {
            String errMsg = URLEncoder.encode("Dữ liệu nhập không hợp lệ: " + e.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?error=" + errMsg);
        }
    }

    private void xuLyXacNhan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            String err = thanhToanDAO.xacNhanGiaoDich(id);

            if (err == null) {
                String msg = URLEncoder.encode("Đã xác nhận thanh toán thành công cho giao dịch #" + id, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?error=" + errMsg);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan");
        }
    }

    private void xuLyTuChoi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            String err = thanhToanDAO.tuChoiGiaoDich(id);

            if (err == null) {
                String msg = URLEncoder.encode("Đã từ chối giao dịch #" + id, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan?error=" + errMsg);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/thanh-toan");
        }
    }

    private Integer getNullableInt(String param) {
        if (param == null || param.isBlank() || "ALL".equalsIgnoreCase(param)) {
            return null;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
