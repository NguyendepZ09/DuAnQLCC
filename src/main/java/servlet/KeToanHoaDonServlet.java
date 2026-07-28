package servlet;

import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet({"/ketoan/hoa-don", "/ketoan/hoa-don/chi-tiet", "/ketoan/hoa-don/xuat"})
public class KeToanHoaDonServlet extends HttpServlet {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/chi-tiet")) {
            hienThiChiTiet(req, resp);
        } else {
            hienThiDanhSach(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/xuat")) {
            xuatHoaDon(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don");
        }
    }

    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer thang = getNullableInt(req.getParameter("thang"));
        Integer nam = getNullableInt(req.getParameter("nam"));
        String trangThai = req.getParameter("trangThai");

        Map<String, Object> stats = hoaDonDAO.thongKeKy(thang, nam);
        List<Object[]> list = hoaDonDAO.findHoaDonTheoKy(thang, nam, trangThai);

        req.setAttribute("thang", thang);
        req.setAttribute("nam", nam);
        req.setAttribute("trangThai", (trangThai != null && !trangThai.isBlank()) ? trangThai : "ALL");
        req.setAttribute("stats", stats);
        req.setAttribute("hoaDonList", list);
        req.setAttribute("activeMenu", "hoa-don");

        req.getRequestDispatcher("/WEB-INF/views/ketoan/hoa-don.jsp").forward(req, resp);
    }

    private void hienThiChiTiet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don");
            return;
        }

        try {
            int maHoaDon = Integer.parseInt(idStr.trim());
            Map<String, Object> info = hoaDonDAO.findChiTietHoaDon(maHoaDon);

            if (info == null) {
                resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don?error=" + URLEncoder.encode("Không tìm thấy hóa đơn mã #" + maHoaDon, StandardCharsets.UTF_8));
                return;
            }

            req.setAttribute("hoaDonInfo", info);
            req.setAttribute("chiTietList", info.get("chiTietList"));
            req.setAttribute("activeMenu", "hoa-don");

            req.getRequestDispatcher("/WEB-INF/views/ketoan/hoa-don-chi-tiet.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don");
        }
    }

    private void xuatHoaDon(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int thang = 0;
        int nam = 0;
        try {
            thang = Integer.parseInt(req.getParameter("thang"));
            nam = Integer.parseInt(req.getParameter("nam"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don?error=" + URLEncoder.encode("Vui lòng chọn Tháng và Năm hợp lệ để xuất hóa đơn.", StandardCharsets.UTF_8));
            return;
        }

        String err = hoaDonDAO.xuatHoaDonHangLoat(thang, nam);

        if (err == null) {
            String msg = URLEncoder.encode("Đã chạy lệnh xuất hóa đơn hàng loạt cho Tháng " + thang + "/" + nam + " thành công!", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don?thang=" + thang + "&nam=" + nam + "&msg=" + msg);
        } else {
            String errMsg = URLEncoder.encode("Xuất hóa đơn thất bại: " + err, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/ketoan/hoa-don?thang=" + thang + "&nam=" + nam + "&error=" + errMsg);
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
