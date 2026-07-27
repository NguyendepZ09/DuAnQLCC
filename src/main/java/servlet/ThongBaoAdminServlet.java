package servlet;

import dao.ThongBaoDAO;
import entity.ThongBao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Servlet dang va quan ly thong bao cho Ban Quan Ly
 */
@WebServlet("/banquanly/thong-bao")
public class ThongBaoAdminServlet extends HttpServlet {

    private ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<ThongBao> danhSachThongBao = thongBaoDAO.findAll();
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
            System.err.println("Lỗi khi load dữ liệu trong ThongBaoAdminServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách thông báo: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/thong-bao.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String tieuDe = request.getParameter("tieuDe");
        String noiDung = request.getParameter("noiDung");
        String loaiThongBao = request.getParameter("loaiThongBao");

        try {
            if (tieuDe == null || tieuDe.trim().isEmpty() || noiDung == null || noiDung.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tiêu đề và nội dung thông báo.");
                response.sendRedirect(request.getContextPath() + "/banquanly/thong-bao");
                return;
            }

            ThongBao tb = new ThongBao();
            tb.setTieuDe(tieuDe.trim());
            tb.setNoiDung(noiDung.trim());
            tb.setLoaiThongBao(loaiThongBao != null ? loaiThongBao : "Thông thường");
            tb.setNgayTao(new Date());

            boolean saved = thongBaoDAO.save(tb);
            if (saved) {
                session.setAttribute("successMessage", "Phát hành thông báo mới thành công!");
            } else {
                System.err.println("thongBaoDAO.save tra ve false trong ThongBaoAdminServlet");
                session.setAttribute("errorMessage", "Lỗi DB: Không thể phát hành thông báo.");
            }

        } catch (Exception e) {
            System.err.println("Exception trong ThongBaoAdminServlet (doPost): " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/banquanly/thong-bao");
    }
}
