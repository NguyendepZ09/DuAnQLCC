package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet kiểm tra Session và trả về trang đăng nhập hoặc điều hướng về Dashboard nếu đã đăng nhập.
 */
@WebServlet("/dang-nhap")
public class DangNhapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer idTaiKhoan = (session != null) ? (Integer) session.getAttribute("idTaiKhoan") : null;
        String vaiTro = (session != null) ? (String) session.getAttribute("vaiTro") : null;
        String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;

        String errorParam = req.getParameter("error");
        boolean hasError = (errorParam != null && !errorParam.trim().isEmpty());

        if (!hasError && session != null && idTaiKhoan != null && vaiTro != null) {
            String redirectUrl = LoginServlet.calculateRedirectUrl(req.getContextPath(), vaiTro, boPhanCode);
            resp.sendRedirect(redirectUrl);
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/dang-nhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
