package servlet;

import dao.CanHoDAO;
import dao.TheTuDAO;
import entity.CanHo;
import entity.CuDan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cudan/can-ho")
public class CuDanCanHoServlet extends HttpServlet {

    private final CanHoDAO canHoDAO = new CanHoDAO();
    private final TheTuDAO theTuDAO = new TheTuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maCanHo = (session != null) ? (Integer) session.getAttribute("maCanHo") : null;

        if (maCanHo == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        CanHo canHo = canHoDAO.findById(maCanHo);
        List<CuDan> dsCuDan = canHoDAO.findCuDanDangO(maCanHo);
        List<Object[]> dsTheTu = theTuDAO.findTheTheoCanHo(maCanHo);
        List<Object[]> dsXe = theTuDAO.findXeTheoCanHo(maCanHo);

        req.setAttribute("canHo", canHo);
        req.setAttribute("dsCuDan", dsCuDan);
        req.setAttribute("dsTheTu", dsTheTu);
        req.setAttribute("dsXe", dsXe);
        req.setAttribute("activeMenu", "can-ho");

        req.getRequestDispatcher("/WEB-INF/views/cudan/can-ho.jsp").forward(req, resp);
    }
}
