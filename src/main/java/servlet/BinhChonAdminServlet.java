package servlet;

import dao.BinhChonDAO;
import dao.ThongBaoDAO;
import entity.BinhChon;
import entity.ThongBao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Servlet tao khao sat/binh chon kem cac phuong an (dung JPA Transaction)
 */
@WebServlet("/banquanly/binh-chon")
public class BinhChonAdminServlet extends HttpServlet {

    private BinhChonDAO binhChonDAO = new BinhChonDAO();
    private ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<BinhChon> danhSachBinhChon = binhChonDAO.findAll();
            List<ThongBao> danhSachThongBao = thongBaoDAO.findAll();

            request.setAttribute("danhSachBinhChon", danhSachBinhChon);
            request.setAttribute("danhSachThongBao", danhSachThongBao);

            HttpSession session = request.getSession(false);
            if (session != null) {
                if (session.getAttribute("errorMessage") != null) {
                    request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                    session.removeAttribute("errorMessage");
                }
                if (session.getAttribute("successMessage") != null) {
                    request.setAttribute("successMessage", session.getAttribute("successMessage"));
                    session.removeAttribute("successMessage");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi load dữ liệu trong BinhChonAdminServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu bình chọn: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/binh-chon.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String cauHoi = request.getParameter("cauHoi");
        String maThongBaoStr = request.getParameter("maThongBao");
        String[] phuongAnArray = request.getParameterValues("phuongAn");

        try {
            if (cauHoi == null || cauHoi.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập câu hỏi bình chọn.");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }

            Integer maThongBaoId = null;
            if (maThongBaoStr != null && !maThongBaoStr.trim().isEmpty()) {
                try {
                    maThongBaoId = Integer.parseInt(maThongBaoStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            // Fallback neu nguoi dung khong chon maThongBao: Lay id thong bao dau tien
            if (maThongBaoId == null) {
                List<ThongBao> dsThongBao = thongBaoDAO.findAll();
                if (!dsThongBao.isEmpty()) {
                    maThongBaoId = dsThongBao.get(0).getId();
                } else {
                    session.setAttribute("errorMessage", "Hệ thống chưa có thông báo nào để tạo khảo sát liên quan. Vui lòng phát hành thông báo trước.");
                    response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                    return;
                }
            }

            BinhChon bc = new BinhChon();
            bc.setCauHoi(cauHoi.trim());
            bc.setMaThongBao(maThongBaoId);
            bc.setNgayBatDau(new Date());
            bc.setTrangThai("Mở");
            bc.setTyLeTucSo(0.0);

            List<String> phuongAnList = phuongAnArray != null ? Arrays.asList(phuongAnArray) : List.of();
            boolean success = binhChonDAO.saveBinhChonVoiPhuongAn(bc, phuongAnList);

            if (success) {
                session.setAttribute("successMessage", "Tạo cuộc bình chọn mới thành công!");
            } else {
                System.err.println("binhChonDAO.saveBinhChonVoiPhuongAn tra ve false");
                session.setAttribute("errorMessage", "Lỗi DB: Không thể tạo cuộc bình chọn. Vui lòng kiểm tra lại dữ liệu.");
            }

        } catch (Exception e) {
            System.err.println("Exception trong BinhChonAdminServlet (doPost): " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
    }
}
