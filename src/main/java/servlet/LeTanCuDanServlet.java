package servlet;

import dao.CuDanQuanLyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

@WebServlet({"/letan/cu-dan", "/letan/cu-dan/them", "/letan/cu-dan/sua", "/letan/cu-dan/chuyen-di"})
public class LeTanCuDanServlet extends HttpServlet {

    private final CuDanQuanLyDAO cuDanDAO = new CuDanQuanLyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tuKhoa = req.getParameter("tuKhoa");
        String loaiCuDan = req.getParameter("loaiCuDan");
        String trangThai = req.getParameter("trangThai");

        List<Object[]> cuDanList = cuDanDAO.timCuDan(tuKhoa, loaiCuDan, trangThai);
        Map<String, Integer> stats = cuDanDAO.thongKeCuDan();
        List<Object[]> dsCanHo = cuDanDAO.findCanHoChoDropDown();

        req.setAttribute("activeMenu", "cu-dan");
        req.setAttribute("cuDanList", cuDanList);
        req.setAttribute("stats", stats);
        req.setAttribute("dsCanHo", dsCanHo);
        req.setAttribute("tuKhoa", tuKhoa != null ? tuKhoa.trim() : "");
        req.setAttribute("loaiCuDanChon", loaiCuDan != null ? loaiCuDan.trim() : "");
        req.setAttribute("trangThaiChon", trangThai != null ? trangThai.trim() : "");

        req.getRequestDispatcher("/WEB-INF/views/letan/cu-dan.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/letan/cu-dan/them".equals(path)) {
            String maCanHoStr = req.getParameter("maCanHo");
            String hoTen = req.getParameter("hoTen");
            String soDienThoai = req.getParameter("soDienThoai");
            String cccd = req.getParameter("cccd");
            String loaiCuDan = req.getParameter("loaiCuDan");
            String ngayChuyenDenStr = req.getParameter("ngayChuyenDen");

            int maCanHo = 0;
            try {
                maCanHo = Integer.parseInt(maCanHoStr);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode("Căn hộ không hợp lệ.", "UTF-8"));
                return;
            }

            LocalDate ngayChuyenDen = null;
            if (ngayChuyenDenStr != null && !ngayChuyenDenStr.trim().isEmpty()) {
                try { ngayChuyenDen = LocalDate.parse(ngayChuyenDenStr.trim()); } catch (DateTimeParseException ignored) {}
            }

            String err = cuDanDAO.themCuDan(maCanHo, hoTen, soDienThoai, cccd, loaiCuDan, ngayChuyenDen);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?msg=" + URLEncoder.encode("Thêm cư dân mới thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/cu-dan/sua".equals(path)) {
            String idStr = req.getParameter("id");
            String hoTen = req.getParameter("hoTen");
            String soDienThoai = req.getParameter("soDienThoai");
            String cccd = req.getParameter("cccd");
            String loaiCuDan = req.getParameter("loaiCuDan");
            String ngayChuyenDenStr = req.getParameter("ngayChuyenDen");

            int id = 0;
            try {
                id = Integer.parseInt(idStr);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode("Cư dân không hợp lệ.", "UTF-8"));
                return;
            }

            LocalDate ngayChuyenDen = null;
            if (ngayChuyenDenStr != null && !ngayChuyenDenStr.trim().isEmpty()) {
                try { ngayChuyenDen = LocalDate.parse(ngayChuyenDenStr.trim()); } catch (DateTimeParseException ignored) {}
            }

            String err = cuDanDAO.capNhatCuDan(id, hoTen, soDienThoai, cccd, loaiCuDan, ngayChuyenDen);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?msg=" + URLEncoder.encode("Cập nhật thông tin cư dân thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/cu-dan/chuyen-di".equals(path)) {
            String idStr = req.getParameter("id");
            int id = 0;
            try {
                id = Integer.parseInt(idStr);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode("Cư dân không hợp lệ.", "UTF-8"));
                return;
            }

            String err = cuDanDAO.chuyenDi(id);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?msg=" + URLEncoder.encode("Đã xử lý chuyển đi cho cư dân, tự động thu hồi thẻ từ và gỡ liên kết xe!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/cu-dan?error=" + URLEncoder.encode(err, "UTF-8"));
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/letan/cu-dan");
        }
    }
}
