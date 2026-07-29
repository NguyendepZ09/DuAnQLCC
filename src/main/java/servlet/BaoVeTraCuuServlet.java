package servlet;

import dao.QuanLyXeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/baove/tra-cuu")
public class BaoVeTraCuuServlet extends HttpServlet {

    private final QuanLyXeDAO quanLyXeDAO = new QuanLyXeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        String tuKhoa = req.getParameter("tuKhoa");
        List<Object[]> ketQuaList = null;

        if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
            ketQuaList = quanLyXeDAO.traCuuTheoBienSo(tuKhoa.trim());
        }

        req.setAttribute("activeMenu", "tra-cuu");
        req.setAttribute("tuKhoa", tuKhoa != null ? tuKhoa.trim() : "");
        req.setAttribute("ketQuaList", ketQuaList);

        req.getRequestDispatcher("/WEB-INF/views/baove/tra-cuu.jsp").forward(req, resp);
    }
}
