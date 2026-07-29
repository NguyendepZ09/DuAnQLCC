package servlet;

import dao.CanHoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet({"", "/trang-chu"})
public class TrangChuServlet extends HttpServlet {

    private final CanHoDAO canHoDAO = new CanHoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Integer> stats = canHoDAO.getThongKeTongHop();

        req.setAttribute("tongCan", stats.getOrDefault("tongCan", 200));
        req.setAttribute("dangO", stats.getOrDefault("dangO", 150));
        req.setAttribute("trong", stats.getOrDefault("trong", 40));
        req.setAttribute("baoTri", stats.getOrDefault("baoTri", 10));

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
