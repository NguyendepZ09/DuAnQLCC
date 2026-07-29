package servlet;

import dao.NhanSuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet({"/kythuat/cham-cong", "/baove/cham-cong", "/letan/cham-cong", "/ketoan/cham-cong"})
public class NhanVienChamCongServlet extends HttpServlet {

    private final NhanSuDAO nhanSuDAO = new NhanSuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        // Xử lý khoảng ngày lọc (mặc định 30 ngày gần nhất)
        String tuNgayStr = req.getParameter("tuNgay");
        String denNgayStr = req.getParameter("denNgay");

        LocalDate denNgay = LocalDate.now();
        LocalDate tuNgay = denNgay.minusDays(30);

        if (tuNgayStr != null && !tuNgayStr.isBlank()) {
            try { tuNgay = LocalDate.parse(tuNgayStr.trim()); } catch (Exception ignored) {}
        }
        if (denNgayStr != null && !denNgayStr.isBlank()) {
            try { denNgay = LocalDate.parse(denNgayStr.trim()); } catch (Exception ignored) {}
        }

        List<Object[]> dsChamCong = nhanSuDAO.findChamCongCuaToi(maNhanVien, tuNgay, denNgay);
        Map<String, Object> thongKe = nhanSuDAO.thongKeCuaToi(maNhanVien, tuNgay, denNgay);

        req.setAttribute("dsChamCong", dsChamCong);
        req.setAttribute("thongKe", thongKe);
        req.setAttribute("tuNgayChon", tuNgay != null ? tuNgay.toString() : "");
        req.setAttribute("denNgayChon", denNgay != null ? denNgay.toString() : "");
        req.setAttribute("activeMenu", "cham-cong");

        // Forward tới đúng file JSP theo role dựa vào servletPath
        String path = req.getServletPath();
        String jspPath = "/WEB-INF/views/kythuat/cham-cong.jsp";

        if (path.startsWith("/baove")) {
            jspPath = "/WEB-INF/views/baove/cham-cong.jsp";
        } else if (path.startsWith("/letan")) {
            jspPath = "/WEB-INF/views/letan/cham-cong.jsp";
        } else if (path.startsWith("/ketoan")) {
            jspPath = "/WEB-INF/views/ketoan/cham-cong.jsp";
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}
