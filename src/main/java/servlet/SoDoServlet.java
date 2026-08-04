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
        
        try {
            Map<Integer, List<CanHo>> mapTangCanHo = canHoDAO.findAllMappedByTang();
            Map<Integer, String> tinhTrangMap = canHoDAO.getTinhTrangMap();
            request.setAttribute("mapTangCanHo", mapTangCanHo);
            request.setAttribute("tinhTrangMap", tinhTrangMap);

            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null && !msg.isBlank()) {
                request.setAttribute("msg", msg);
            }
            if (error != null && !error.isBlank()) {
                request.setAttribute("error", error);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong SoDoServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải sơ đồ căn hộ: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/so-do-can-ho.jsp").forward(request, response);
    }
}
