package servlet;

import dao.BieuGiaDichVuDAO;
import entity.BieuGiaDichVu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet({"/ketoan/bieu-gia", "/ketoan/bieu-gia/them", "/ketoan/bieu-gia/sua", "/ketoan/bieu-gia/xoa"})
public class KeToanBieuGiaServlet extends HttpServlet {

    private final BieuGiaDichVuDAO bieuGiaDAO = new BieuGiaDichVuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<BieuGiaDichVu> allPrices = bieuGiaDAO.findAllSorted();
        Map<String, LocalDate> activeDates = bieuGiaDAO.findActiveHieuLucDates();
        List<String> warnings = bieuGiaDAO.checkTierGaps();

        req.setAttribute("allPrices", allPrices);
        req.setAttribute("activeDates", activeDates);
        req.setAttribute("warnings", warnings);
        req.setAttribute("today", LocalDate.now());
        req.setAttribute("activeMenu", "bieu-gia");

        req.getRequestDispatcher("/WEB-INF/views/ketoan/bieu-gia.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/xoa")) {
            xuLyXoa(req, resp);
        } else {
            xuLyLuu(req, resp);
        }
    }

    private void xuLyLuu(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String loaiDichVu = req.getParameter("loaiDichVu");
        String bacTuStr = req.getParameter("bacTu");
        String bacDenStr = req.getParameter("bacDen");
        String donGiaStr = req.getParameter("donGia");
        String hieuLucTuStr = req.getParameter("hieuLucTu");
        String nguonGia = req.getParameter("nguonGia");

        try {
            BieuGiaDichVu bg = new BieuGiaDichVu();
            if (idStr != null && !idStr.isBlank()) {
                bg.setId(Integer.parseInt(idStr.trim()));
            }

            bg.setLoaiDichVu(loaiDichVu != null ? loaiDichVu.trim() : null);
            bg.setBacTu(bacTuStr != null && !bacTuStr.isBlank() ? new BigDecimal(bacTuStr.trim()) : BigDecimal.ZERO);
            bg.setBacDen(bacDenStr != null && !bacDenStr.isBlank() ? new BigDecimal(bacDenStr.trim()) : null);
            bg.setDonGia(donGiaStr != null && !donGiaStr.isBlank() ? new BigDecimal(donGiaStr.trim()) : BigDecimal.ZERO);
            bg.setHieuLucTu(hieuLucTuStr != null && !hieuLucTuStr.isBlank() ? LocalDate.parse(hieuLucTuStr.trim()) : LocalDate.now());
            bg.setNguonGia(nguonGia != null ? nguonGia.trim() : null);

            String err = bieuGiaDAO.saveOrUpdate(bg);
            if (err == null) {
                String msg = URLEncoder.encode("Đã lưu biểu giá dịch vụ thành công!", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia?error=" + errMsg);
            }
        } catch (Exception e) {
            String errMsg = URLEncoder.encode("Lỗi nhập liệu: " + e.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia?error=" + errMsg);
        }
    }

    private void xuLyXoa(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            String err = bieuGiaDAO.deleteBieuGia(id);

            if (err == null) {
                String msg = URLEncoder.encode("Đã xóa biểu giá thành công!", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia?error=" + errMsg);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ketoan/bieu-gia");
        }
    }
}
