package servlet;

import dao.TaiKhoanDAO;
import entity.TaiKhoan;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet dang nhap he thong va tinh toan dieu huong theo Role / Bo phan
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private TaiKhoanDAO taiKhoanDAO = new TaiKhoanDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");

        if (tenDangNhap == null || tenDangNhap.trim().isEmpty() || matKhau == null || matKhau.trim().isEmpty()) {
            out.print(buildJson(false, "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.", null, null));
            return;
        }

        tenDangNhap = tenDangNhap.trim();

        try {
            TaiKhoan tk = taiKhoanDAO.findByTenDangNhap(tenDangNhap);

            if (tk == null) {
                out.print(buildJson(false, "Tên đăng nhập không tồn tại.", null, null));
                return;
            }

            if ("Khoa".equalsIgnoreCase(tk.getTrangThaiHoatDong())) {
                out.print(buildJson(false, "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Ban quản lý.", null, null));
                return;
            }

            if (!PasswordUtil.verify(matKhau, tk.getMatKhau())) {
                out.print(buildJson(false, "Mật khẩu không chính xác.", null, null));
                return;
            }

            // Dang nhap thanh cong -> Tao Session
            HttpSession session = request.getSession(true);
            session.setAttribute("idTaiKhoan", tk.getId());
            session.setAttribute("tenDangNhap", tk.getTenDangNhap());
            session.setAttribute("vaiTro", tk.getVaiTro());
            session.setAttribute("boPhanCode", tk.getBoPhanCode());
            session.setAttribute("hoTen", tk.getTenDangNhap());

            String redirectUrl = calculateRedirectUrl(request.getContextPath(), tk.getVaiTro(), tk.getBoPhanCode());
            out.print(buildJson(true, "Đăng nhập thành công!", redirectUrl, tk.getTenDangNhap()));

        } catch (Exception e) {
            System.err.println("Lỗi trong LoginServlet: " + e.getMessage());
            e.printStackTrace();
            out.print(buildJson(false, "Lỗi hệ thống: " + e.getMessage(), null, null));
        }
    }

    private String calculateRedirectUrl(String contextPath, String vaiTro, String boPhanCode) {
        if ("CD".equalsIgnoreCase(vaiTro)) {
            return contextPath + "/cudan/dashboard";
        }
        if ("BQL".equalsIgnoreCase(vaiTro)) {
            return contextPath + "/banquanly/dashboard";
        }
        if ("NV".equalsIgnoreCase(vaiTro)) {
            if (boPhanCode != null) {
                switch (boPhanCode) {
                    case "LeTan":
                    case "LT":
                        return contextPath + "/nhanvien/letan/dashboard";
                    case "KeToan":
                    case "KT":
                        return contextPath + "/nhanvien/ketoan/dashboard";
                    case "KyThuat":
                    case "NVKT":
                        return contextPath + "/nhanvien/kythuat/dashboard";
                    case "BaoVe":
                    case "BV":
                        return contextPath + "/nhanvien/baove/dashboard";
                    case "BanQuanLy":
                    case "MAIN":
                        return contextPath + "/banquanly/dashboard";
                }
            }
            return contextPath + "/nhanvien/dang-phat-trien";
        }
        return contextPath + "/index.jsp";
    }

    private String buildJson(boolean success, String message, String redirectUrl, String hoTen) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"success\":").append(success).append(",");
        sb.append("\"message\":\"").append(escapeJson(message)).append("\"");
        if (redirectUrl != null) {
            sb.append(",\"redirectUrl\":\"").append(escapeJson(redirectUrl)).append("\"");
        }
        if (hoTen != null) {
            sb.append(",\"hoTen\":\"").append(escapeJson(hoTen)).append("\"");
        }
        sb.append("}");
        return sb.toString();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
