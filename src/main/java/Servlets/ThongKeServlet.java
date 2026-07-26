package Servlets;

import DAOs.ThongKeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet xu ly du lieu dong va tinh toan cac chi so thong ke Dashboard Ban Quan Ly
 */
@WebServlet({"/banquanly/dashboard", "/banquanly/thong-ke"})
public class ThongKeServlet extends HttpServlet {

    private ThongKeDAO thongKeDAO = new ThongKeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lay thong ke tai chinh tu DAO
        Map<String, Double> taiChinhMap = thongKeDAO.getTongDoanhThuByTrangThai();
        double daThanhToan = taiChinhMap.getOrDefault("Đã thanh toán", 0.0);
        double chuaThanhToan = taiChinhMap.getOrDefault("Chưa thanh toán", 0.0);
        double tongDoanhThu = daThanhToan + chuaThanhToan;
        double tyLeThu = (tongDoanhThu > 0) ? (daThanhToan / tongDoanhThu) * 100 : 0;

        // 2. Lay thong ke su co tu DAO
        Map<String, Long> suCoMap = thongKeDAO.getThongKeSuCo();
        long soCaCho = suCoMap.getOrDefault("Chờ tiếp nhận", 0L);
        long soCaDangXuLy = suCoMap.getOrDefault("Đang xử lý", 0L);
        long soCaHoanThanh = suCoMap.getOrDefault("Đã hoàn thành", 0L);

        // 3. Lay nhan vien xuat sac tu DAO
        String topNhanVien = thongKeDAO.getTopNhanVienXuatSac();

        // 4. Set Request Attributes
        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("daThanhToan", daThanhToan);
        request.setAttribute("chuaThanhToan", chuaThanhToan);
        request.setAttribute("tyLeThu", Math.round(tyLeThu));

        request.setAttribute("soCaCho", soCaCho);
        request.setAttribute("soCaDangXuLy", soCaDangXuLy);
        request.setAttribute("soCaHoanThanh", soCaHoanThanh);

        request.setAttribute("topNhanVien", topNhanVien);

        // Forward sang WEB-INF/views/banquanly/dashboard.jsp
        request.getRequestDispatcher("/WEB-INF/views/banquanly/dashboard.jsp").forward(request, response);
    }
}
