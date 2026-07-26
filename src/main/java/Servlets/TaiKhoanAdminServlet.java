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
import java.util.List;

/**
 * Servlet quan ly danh sach tai khoan, reset mat khau, khoa/mo khoa AJAX va cap tai khoan
 */
@WebServlet("/banquanly/tai-khoan")
public class TaiKhoanAdminServlet extends HttpServlet {

    private TaiKhoanDAO taiKhoanDAO = new TaiKhoanDAO();
    private CuDanDAO cuDanDAO = new CuDanDAO();
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<TaiKhoan> danhSachTaiKhoan = taiKhoanDAO.getAllAccounts();
        List<CuDan> danhSachCuDanChuaCoTK = taiKhoanDAO.getUnassignedCuDan();
        List<NhanVien> danhSachNhanVienChuaCoTK = taiKhoanDAO.getUnassignedNhanVien();

        request.setAttribute("danhSachTaiKhoan", danhSachTaiKhoan);
        request.setAttribute("danhSachCuDanChuaCoTK", danhSachCuDanChuaCoTK);
        request.setAttribute("danhSachNhanVienChuaCoTK", danhSachNhanVienChuaCoTK);

        request.getRequestDispatcher("/banquanly/quan-ly-tai-khoan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        String currentSessionUser = (session != null) ? (String) session.getAttribute("tenDangNhap") : null;

        // 1. Action Toggle Status (Khoa / Mo khoa)
        if ("toggle".equalsIgnoreCase(action)) {
            String tenDangNhap = request.getParameter("tenDangNhap");
            if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
                out.print("{\"success\":false, \"message\":\"Tên đăng nhập không hợp lệ.\"}");
                return;
            }

            if (currentSessionUser != null && currentSessionUser.equalsIgnoreCase(tenDangNhap.trim())) {
                out.print("{\"success\":false, \"message\":\"Không thể tự khóa tài khoản Admin đang đăng nhập!\"}");
                return;
            }

            boolean updated = taiKhoanDAO.toggleAccountStatus(tenDangNhap.trim());
            if (updated) {
                out.print("{\"success\":true, \"message\":\"Đã thay đổi trạng thái tài khoản thành công.\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Không tìm thấy tài khoản để đổi trạng thái.\"}");
            }
            return;
        }

        // 2. Action Reset Password
        if ("resetPassword".equalsIgnoreCase(action)) {
            String tenDangNhap = request.getParameter("tenDangNhap");
            String newPass = request.getParameter("newPassword");
            if (newPass == null || newPass.trim().isEmpty()) {
                newPass = "123456";
            }

            if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
                out.print("{\"success\":false, \"message\":\"Tên đăng nhập không hợp lệ.\"}");
                return;
            }

            boolean res = taiKhoanDAO.resetPassword(tenDangNhap.trim(), newPass.trim());
            if (res) {
                out.print("{\"success\":true, \"message\":\"Đã reset mật khẩu tài khoản '" + escapeJson(tenDangNhap) + "' về '" + escapeJson(newPass) + "' thành công.\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Reset mật khẩu thất bại.\"}");
            }
            return;
        }

        // 3. Action Create Account
        if ("create".equalsIgnoreCase(action)) {
            String tenDangNhap = request.getParameter("tenDangNhap");
            String matKhau = request.getParameter("matKhau");
            String vaiTro = request.getParameter("vaiTro");
            String boPhanCode = request.getParameter("boPhanCode");
            
            String maCuDanStr = request.getParameter("maCuDan");
            String maNhanVienStr = request.getParameter("maNhanVien");

            if (tenDangNhap == null || tenDangNhap.trim().isEmpty() ||
                matKhau == null || matKhau.trim().isEmpty() ||
                vaiTro == null || vaiTro.trim().isEmpty()) {
                out.print("{\"success\":false, \"message\":\"Vui lòng điền đầy đủ Tên đăng nhập, Mật khẩu và Vai trò.\"}");
                return;
            }

            // Kiem tra trung tenDangNhap
            if (taiKhoanDAO.findByTenDangNhap(tenDangNhap.trim()) != null) {
                out.print("{\"success\":false, \"message\":\"Tên đăng nhập '" + escapeJson(tenDangNhap) + "' đã tồn tại trong hệ thống!\"}");
                return;
            }

            String finalVaiTro = vaiTro.trim();
            String finalBoPhanCode = null;

            // Enforce SQL Server Constraint CK_taiKhoan_boPhan_theoVaiTro:
            // If CD -> boPhanCode MUST be null
            // If BQL -> boPhanCode MUST be 'MAIN'
            // If NV -> boPhanCode MUST be one of ('LT', 'KT', 'NVKT', 'BV')
            if ("CD".equalsIgnoreCase(finalVaiTro)) {
                finalBoPhanCode = null;
            } else if ("BQL".equalsIgnoreCase(finalVaiTro)) {
                finalBoPhanCode = "MAIN";
            } else if ("NV".equalsIgnoreCase(finalVaiTro)) {
                if (boPhanCode != null && !boPhanCode.trim().isEmpty()) {
                    finalBoPhanCode = boPhanCode.trim();
                } else {
                    finalBoPhanCode = "LT"; // Default staff department
                }
            }

            TaiKhoan tk = new TaiKhoan();
            tk.setMaTaiKhoan("TK" + (System.currentTimeMillis() % 100000));
            tk.setTenDangNhap(tenDangNhap.trim());
            tk.setMatKhau(PasswordUtil.hash(matKhau.trim())); // Hash BCrypt
            tk.setVaiTro(finalVaiTro);
            tk.setBoPhanCode(finalBoPhanCode);
            tk.setTrangThaiHoatDong("HoatDong");

            Integer maCuDan = null;
            if ("CD".equalsIgnoreCase(finalVaiTro) && maCuDanStr != null && !maCuDanStr.trim().isEmpty()) {
                try { maCuDan = Integer.parseInt(maCuDanStr.trim()); } catch (NumberFormatException ignored) {}
            }

            Integer maNhanVien = null;
            if (!"CD".equalsIgnoreCase(finalVaiTro) && maNhanVienStr != null && !maNhanVienStr.trim().isEmpty()) {
                try { maNhanVien = Integer.parseInt(maNhanVienStr.trim()); } catch (NumberFormatException ignored) {}
            }

            try {
                taiKhoanDAO.createAccount(tk, maCuDan, maNhanVien);
                out.print("{\"success\":true, \"message\":\"Tạo tài khoản mới thành công!\"}");
            } catch (Exception e) {
                e.printStackTrace();
                String rootMsg = e.getCause() != null ? e.getCause().getMessage() : e.getMessage();
                out.print("{\"success\":false, \"message\":\"Lỗi DB SQL Server: " + escapeJson(rootMsg) + "\"}");
            }
            return;
        }

        out.print("{\"success\":false, \"message\":\"Action không hợp lệ.\"}");
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
