package Servlets;

import DAOs.CuDanDAO;
import DAOs.NhanVienDAO;
import DAOs.TaiKhoanDAO;
import Entities.CuDan;
import Entities.NhanVien;
import Entities.TaiKhoan;
import Utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet xu ly dang nhap, kiem tra phan quyen & tra JSON dieu phoi trang (Tomcat 11 / Jakarta EE)
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private TaiKhoanDAO taiKhoanDAO = new TaiKhoanDAO();
    private CuDanDAO cuDanDAO = new CuDanDAO();
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String clientRole = request.getParameter("vaiTro");

        if (tenDangNhap == null || tenDangNhap.trim().isEmpty() ||
            matKhau == null || matKhau.trim().isEmpty()) {
            out.print(buildJson(false, "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.", null, null));
            return;
        }

        // 1. Kiem tra tai khoan ton tai
        TaiKhoan tk = taiKhoanDAO.findByTenDangNhap(tenDangNhap.trim());
        if (tk == null) {
            out.print(buildJson(false, "Tên đăng nhập không tồn tại trong hệ thống.", null, null));
            return;
        }

        // 2. Kiem tra mat khau (BCrypt)
        if (!PasswordUtil.verify(matKhau, tk.getMatKhau())) {
            out.print(buildJson(false, "Mật khẩu không chính xác.", null, null));
            return;
        }

        // 3. Kiem tra trang thai hoat dong
        if (tk.getTrangThaiHoatDong() == null || !"HoatDong".equalsIgnoreCase(tk.getTrangThaiHoatDong())) {
            out.print(buildJson(false, "Tài khoản của bạn đã bị khóa hoặc tạm ngưng hoạt động.", null, null));
            return;
        }

        // 4. Kiem tra vai tro client gui len co khop DB
        String expectedDbRole = mapClientRoleToDb(clientRole);
        if (expectedDbRole != null && !expectedDbRole.equalsIgnoreCase(tk.getVaiTro())) {
            out.print(buildJson(false, "Tài khoản không đúng vai trò bạn đang chọn đăng nhập.", null, null));
            return;
        }

        // 5. Lay hoTen tu CuDan hoac NhanVien
        String hoTen = tk.getTenDangNhap();
        String vaiTroDb = tk.getVaiTro();
        if ("CD".equalsIgnoreCase(vaiTroDb)) {
            CuDan cd = cuDanDAO.findByMaTaiKhoan(tk.getId());
            if (cd != null && cd.getHoTen() != null) {
                hoTen = cd.getHoTen();
            }
        } else {
            NhanVien nv = nhanVienDAO.findByMaTaiKhoan(tk.getId());
            if (nv != null && nv.getHoTen() != null) {
                hoTen = nv.getHoTen();
            }
        }

        // 6. Luu Session
        HttpSession session = request.getSession();
        session.setAttribute("idTaiKhoan", tk.getId());
        session.setAttribute("tenDangNhap", tk.getTenDangNhap());
        session.setAttribute("vaiTro", tk.getVaiTro());
        session.setAttribute("boPhanCode", tk.getBoPhanCode());
        session.setAttribute("hoTen", hoTen);

        // 7. Xac dinh trang dich theo Bang dieu phoi
        String contextPath = request.getContextPath();
        String redirectUrl = calculateRedirectUrl(contextPath, tk.getVaiTro(), tk.getBoPhanCode());

        // 8. Tra JSON phan hoi cho AJAX
        out.print(buildJson(true, "Đăng nhập thành công!", redirectUrl, hoTen));
    }

    private String mapClientRoleToDb(String clientRole) {
        if (clientRole == null) return null;
        switch (clientRole.toLowerCase()) {
            case "cudan":
            case "cd":
                return "CD";
            case "banquanly":
            case "bql":
                return "BQL";
            case "nhanvien":
            case "nv":
            case "letan":
            case "ketoan":
            case "kythuat":
            case "baove":
                return "NV";
            default:
                return null;
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
                switch (boPhanCode.toUpperCase()) {
                    case "LT":
                        return contextPath + "/nhanvien/letan/dashboard";
                    case "KT":
                        return contextPath + "/nhanvien/ketoan/dashboard";
                    case "NVKT":
                        return contextPath + "/nhanvien/kythuat/dashboard";
                    case "BV":
                        return contextPath + "/nhanvien/baove/dashboard";
                    case "MAIN":
                        return contextPath + "/banquanly/dashboard";
                }
            }
            return contextPath + "/nhanvien/dashboard";
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
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
