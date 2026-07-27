package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet hien thi trang thong bao chuc nang dang phat trien cho cac role Nhan Vien
 */
@WebServlet({
    "/nhanvien/dashboard",
    "/nhanvien/letan/dashboard",
    "/nhanvien/ketoan/dashboard",
    "/nhanvien/kythuat/dashboard",
    "/nhanvien/baove/dashboard",
    "/nhanvien/dang-phat-trien"
})
public class NhanVienDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/nhanvien/dang-phat-trien.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
