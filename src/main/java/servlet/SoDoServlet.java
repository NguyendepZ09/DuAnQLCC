package servlet;

import dao.CanHoDAO;
import entity.CanHo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet hien thi so do 200 can ho 25 tang x 8 can (grouped by tang)
 */
@WebServlet("/banquanly/so-do")
public class SoDoServlet extends HttpServlet {

    private CanHoDAO canHoDAO = new CanHoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Map<Integer, List<CanHo>> mapTangCanHo = canHoDAO.findAllMappedByTang();
        request.setAttribute("mapTangCanHo", mapTangCanHo);
        
        request.getRequestDispatcher("/WEB-INF/views/banquanly/so-do-can-ho.jsp").forward(request, response);
    }
}
