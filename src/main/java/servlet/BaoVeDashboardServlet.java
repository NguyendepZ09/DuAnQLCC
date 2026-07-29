package servlet;

import dao.BaoVeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/baove/dashboard")
public class BaoVeDashboardServlet extends HttpServlet {

    private final BaoVeDAO baoVeDAO = new BaoVeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        Map<String, Object> stats = baoVeDAO.thongKeDashboardBaoVe(maNhanVien);

        req.setAttribute("activeMenu", "dashboard");
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/WEB-INF/views/baove/dashboard.jsp").forward(req, resp);
    }
}
