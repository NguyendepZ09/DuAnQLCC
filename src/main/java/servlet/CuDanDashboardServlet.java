package servlet;

import dao.CuDanDAO;
import entity.CanHo;
import entity.CuDan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet trang chu / dashboard danh cho role Cu Dan
 */
@WebServlet("/cudan/dashboard")
public class CuDanDashboardServlet extends HttpServlet {

    private CuDanDAO cuDanDAO = new CuDanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Integer idTaiKhoan = (session != null) ? (Integer) session.getAttribute("idTaiKhoan") : null;

        if (idTaiKhoan != null) {
            Map<String, Object> detailMap = cuDanDAO.findDetailWithCanHoByMaTaiKhoan(idTaiKhoan);
            CuDan cd = (CuDan) detailMap.get("cuDan");
            CanHo ch = (CanHo) detailMap.get("canHo");

            if (cd != null && ch != null) {
                request.setAttribute("cuDanInfo", cd);
                request.setAttribute("canHoInfo", ch);
                if (session != null) {
                    session.setAttribute("maCuDan", cd.getId());
                    session.setAttribute("maCanHo", cd.getMaCanHo());
                }
            }
        }

        request.setAttribute("activeMenu", "thong-bao");
        request.getRequestDispatcher("/WEB-INF/views/cudan/dashboard.jsp").forward(request, response);
    }
}
