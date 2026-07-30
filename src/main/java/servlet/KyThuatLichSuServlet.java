package servlet;

import dao.PhanAnhSuCoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet xem lich su cac cong viec da hoan thanh cua Ky thuat vien
 */
@WebServlet("/kythuat/lich-su")
public class KyThuatLichSuServlet extends HttpServlet {

    private PhanAnhSuCoDAO phanAnhSuCoDAO = new PhanAnhSuCoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idTaiKhoan") == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String vaiTro = (String) session.getAttribute("vaiTro");
        String boPhanCode = (String) session.getAttribute("boPhanCode");
        Integer maNhanVienSession = (Integer) session.getAttribute("maNhanVien");

        if (!"NV".equalsIgnoreCase(vaiTro) || !"KyThuat".equalsIgnoreCase(boPhanCode) || maNhanVienSession == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<Map<String, Object>> dsLichSu = phanAnhSuCoDAO.findHistoryForKyThuat(maNhanVienSession, page, pageSize);
        long totalItems = phanAnhSuCoDAO.countHistoryForKyThuat(maNhanVienSession);
        long tongDangXuLy = phanAnhSuCoDAO.countAssignedForKyThuat(maNhanVienSession, null, null);
        double avgDays = phanAnhSuCoDAO.calculateAvgProcessingDaysForKyThuat(maNhanVienSession);

        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("dsLichSu", dsLichSu);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("tongDangXuLy", tongDangXuLy);
        request.setAttribute("avgDays", String.format("%.1f", avgDays));
        request.setAttribute("activeMenu", "lich-su");

        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/kythuat/lich-su.jsp").forward(request, response);
    }
}
