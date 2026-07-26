package Servlets;

import DAOs.ThongBaoDAO;
import Entities.ThongBao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        
        List<ThongBao> danhSachThongBao = thongBaoDAO.findAll();
        request.setAttribute("danhSachThongBao", danhSachThongBao);
        
        request.getRequestDispatcher("/banquanly/thong-bao.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String tieuDe = request.getParameter("tieuDe");
        String noiDung = request.getParameter("noiDung");
        String loaiThongBao = request.getParameter("loaiThongBao");

        if (tieuDe != null && !tieuDe.trim().isEmpty() && noiDung != null && !noiDung.trim().isEmpty()) {
            ThongBao tb = new ThongBao();
            tb.setTieuDe(tieuDe.trim());
            tb.setNoiDung(noiDung.trim());
            tb.setLoaiThongBao(loaiThongBao != null ? loaiThongBao : "Thông thường");
            tb.setNgayTao(new Date());

            thongBaoDAO.save(tb);
        }

        response.sendRedirect(request.getContextPath() + "/banquanly/thong-bao");
    }
}
