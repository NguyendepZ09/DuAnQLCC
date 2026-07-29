package servlet;

import dao.ThongKeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Servlet xu ly du lieu dong va tinh toan cac chi so thong ke Dashboard Ban Quan Ly
 */
@WebServlet({"/banquanly/dashboard", "/banquanly/thong-ke"})
public class ThongKeServlet extends HttpServlet {

    private final ThongKeDAO thongKeDAO = new ThongKeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            LocalDate now = LocalDate.now();
            int thang = now.getMonthValue();
            int nam = now.getYear();

            String thangParam = request.getParameter("thang");
            String namParam = request.getParameter("nam");

            if (thangParam != null && !thangParam.trim().isEmpty()) {
                try { thang = Integer.parseInt(thangParam.trim()); } catch (Exception ignored) {}
            }
            if (namParam != null && !namParam.trim().isEmpty()) {
                try { nam = Integer.parseInt(namParam.trim()); } catch (Exception ignored) {}
            }

            Map<String, Object> thongKeKy = thongKeDAO.thongKeThuPhiTheoKy(thang, nam);
            List<Map<String, Object>> doanhThu6Thang = thongKeDAO.getDoanhThu6ThangGanNhat();
            Map<String, Long> suCoDetailed = thongKeDAO.getThongKeSuCoDetailed();

            Map<String, Double> taiChinhMap = thongKeDAO.getTongDoanhThuByTrangThai();
            double daThanhToan = taiChinhMap.getOrDefault("DaThanhToan", 0.0);
            double chuaThanhToan = taiChinhMap.getOrDefault("ChuaThanhToan", 0.0);
            double quaHan = taiChinhMap.getOrDefault("QuaHan", 0.0);
            double tongDoanhThu = daThanhToan + chuaThanhToan + quaHan;
            double tyLeThu = (tongDoanhThu > 0) ? (daThanhToan / tongDoanhThu) * 100 : 0;

            Map<String, Long> suCoMap = thongKeDAO.getThongKeSuCo();
            long soCaCho = suCoMap.getOrDefault("Chờ tiếp nhận", 0L);
            long soCaDangXuLy = suCoMap.getOrDefault("Đang xử lý", 0L);
            long soCaHoanThanh = suCoMap.getOrDefault("Đã hoàn thành", 0L);

            String topNhanVien = thongKeDAO.getTopNhanVienXuatSac();

            request.setAttribute("thangChon", thang);
            request.setAttribute("namChon", nam);
            request.setAttribute("thongKeKy", thongKeKy);
            request.setAttribute("doanhThu6Thang", doanhThu6Thang);
            request.setAttribute("suCoDetailed", suCoDetailed);

            request.setAttribute("tongDoanhThu", tongDoanhThu);
            request.setAttribute("daThanhToan", daThanhToan);
            request.setAttribute("chuaThanhToan", chuaThanhToan);
            request.setAttribute("tyLeThu", Math.round(tyLeThu));

            request.setAttribute("soCaCho", soCaCho);
            request.setAttribute("soCaDangXuLy", soCaDangXuLy);
            request.setAttribute("soCaHoanThanh", soCaHoanThanh);

            request.setAttribute("topNhanVien", topNhanVien);

        } catch (Exception e) {
            System.err.println("Lỗi trong ThongKeServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu thống kê: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/dashboard.jsp").forward(request, response);
    }
}
