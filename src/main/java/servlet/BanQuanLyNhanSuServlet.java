package servlet;

import dao.NhanSuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

/**
 * Servlet giám sát nhân sự & nhật ký ca trực (Role Ban Quản Lý) — Chỉ đọc (doGet)
 */
@WebServlet("/banquanly/nhan-su")
public class BanQuanLyNhanSuServlet extends HttpServlet {

    private final NhanSuDAO nhanSuDAO = new NhanSuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String boPhan = request.getParameter("boPhan");
            if (boPhan != null && boPhan.trim().isEmpty()) {
                boPhan = null;
            }

            String tuNgayStr = request.getParameter("tuNgay");
            String denNgayStr = request.getParameter("denNgay");

            LocalDate tuNgay = null;
            LocalDate denNgay = null;

            if (tuNgayStr != null && !tuNgayStr.trim().isEmpty()) {
                try { tuNgay = LocalDate.parse(tuNgayStr.trim()); } catch (DateTimeParseException ignored) {}
            }
            if (denNgayStr != null && !denNgayStr.trim().isEmpty()) {
                try { denNgay = LocalDate.parse(denNgayStr.trim()); } catch (DateTimeParseException ignored) {}
            }

            // Default to last 7 days if dates not specified
            if (tuNgay == null && denNgay == null) {
                denNgay = LocalDate.now();
                tuNgay = denNgay.minusDays(6);
            }

            List<Object[]> dsChamCong = nhanSuDAO.findChamCong(boPhan, tuNgay, denNgay);
            Map<String, Object> thongKe = nhanSuDAO.thongKeNhanSu(tuNgay, denNgay);
            List<Object[]> dsCaTruc = nhanSuDAO.findCaTruc(tuNgay, denNgay);

            request.setAttribute("boPhanChon", boPhan);
            request.setAttribute("tuNgayChon", tuNgay != null ? tuNgay.toString() : "");
            request.setAttribute("denNgayChon", denNgay != null ? denNgay.toString() : "");

            request.setAttribute("dsChamCong", dsChamCong);
            request.setAttribute("thongKe", thongKe);
            request.setAttribute("dsCaTruc", dsCaTruc);

        } catch (Exception e) {
            System.err.println("Lỗi trong BanQuanLyNhanSuServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu chấm công: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/nhan-su.jsp").forward(request, response);
    }
}
