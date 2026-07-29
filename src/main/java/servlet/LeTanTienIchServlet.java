package servlet;

import dao.DatLichTienIchDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@WebServlet({
    "/letan/duyet-tien-ich",
    "/letan/duyet-tien-ich/duyet",
    "/letan/duyet-tien-ich/tu-choi",
    "/letan/duyet-tien-ich/hoan-thanh"
})
public class LeTanTienIchServlet extends HttpServlet {

    private final DatLichTienIchDAO dao = new DatLichTienIchDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String trangThaiChon = req.getParameter("trangThai");
        if (trangThaiChon == null || trangThaiChon.isBlank()) {
            trangThaiChon = "ChoDuyet"; // Mặc định hiện các lượt ChoDuyet trước
        }

        String tuNgayStr = req.getParameter("tuNgay");
        String denNgayStr = req.getParameter("denNgay");

        LocalDate tuNgay = null;
        LocalDate denNgay = null;

        if (tuNgayStr != null && !tuNgayStr.isBlank()) {
            try { tuNgay = LocalDate.parse(tuNgayStr.trim()); } catch (Exception ignored) {}
        }
        if (denNgayStr != null && !denNgayStr.isBlank()) {
            try { denNgay = LocalDate.parse(denNgayStr.trim()); } catch (Exception ignored) {}
        }

        // Lấy tất cả lượt đặt để tính 4 thẻ thống kê
        List<Object[]> allBookings = dao.findTatCaLuotDat("ALL", null, null);
        int soChoDuyet = 0;
        int soDaDuyet = 0;
        int soHoanThanh = 0;
        int soDaHuy = 0;

        for (Object[] r : allBookings) {
            String st = (String) r[7];
            if ("ChoDuyet".equalsIgnoreCase(st)) soChoDuyet++;
            else if ("DaDuyet".equalsIgnoreCase(st)) soDaDuyet++;
            else if ("HoanThanh".equalsIgnoreCase(st)) soHoanThanh++;
            else if ("DaHuy".equalsIgnoreCase(st)) soDaHuy++;
        }

        // Lấy danh sách lượt đặt theo bộ lọc
        List<Object[]> dsLuotDat = dao.findTatCaLuotDat(trangThaiChon, tuNgay, denNgay);

        req.setAttribute("dsLuotDat", dsLuotDat);
        req.setAttribute("soChoDuyet", soChoDuyet);
        req.setAttribute("soDaDuyet", soDaDuyet);
        req.setAttribute("soHoanThanh", soHoanThanh);
        req.setAttribute("soDaHuy", soDaHuy);
        req.setAttribute("trangThaiChon", trangThaiChon);
        req.setAttribute("tuNgayChon", tuNgayStr != null ? tuNgayStr : "");
        req.setAttribute("denNgayChon", denNgayStr != null ? denNgayStr : "");
        req.setAttribute("activeMenu", "duyet-tien-ich");

        req.getRequestDispatcher("/WEB-INF/views/letan/duyet-tien-ich.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;
        if (maNhanVien == null) {
            maNhanVien = 1; // Fallback demo
        }

        String uri = req.getRequestURI();
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/letan/duyet-tien-ich");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/letan/duyet-tien-ich");
            return;
        }

        if (uri.endsWith("/duyet")) {
            String err = dao.duyetLuotDat(id, maNhanVien);
            if (err != null) {
                redirectWithError(req, resp, err);
            } else {
                redirectWithMsg(req, resp, "Đã duyệt thành công lượt đặt tiện ích #" + id);
            }
        } else if (uri.endsWith("/tu-choi")) {
            String err = dao.tuChoiLuotDat(id, maNhanVien);
            if (err != null) {
                redirectWithError(req, resp, err);
            } else {
                redirectWithMsg(req, resp, "Đã từ chối lượt đặt tiện ích #" + id);
            }
        } else if (uri.endsWith("/hoan-thanh")) {
            String err = dao.hoanThanhLuotDat(id);
            if (err != null) {
                redirectWithError(req, resp, err);
            } else {
                redirectWithMsg(req, resp, "Đã xác nhận hoàn thành lượt đặt tiện ích #" + id);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/letan/duyet-tien-ich");
        }
    }

    private void redirectWithMsg(HttpServletRequest req, HttpServletResponse resp, String msg) throws IOException {
        String encoded = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/letan/duyet-tien-ich?msg=" + encoded);
    }

    private void redirectWithError(HttpServletRequest req, HttpServletResponse resp, String error) throws IOException {
        String encoded = URLEncoder.encode(error, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/letan/duyet-tien-ich?error=" + encoded);
    }
}
