package servlet;

import dao.CuDanDAO;
import dao.NhanVienDAO;
import dao.TaiKhoanDAO;
import entity.CuDan;
import entity.NhanVien;
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

        request.getRequestDispatcher("/WEB-INF/views/banquanly/quan-ly-tai-khoan.jsp").forward(request, response);
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

            if (taiKhoanDAO.findByTenDangNhap(tenDangNhap.trim()) != null) {
                out.print("{\"success\":false, \"message\":\"Tên đăng nhập '" + escapeJson(tenDangNhap) + "' đã tồn tại trong hệ thống!\"}");
                return;
            }

            String finalVaiTro = vaiTro.trim();
            String finalBoPhanCode = null;

            if ("CD".equalsIgnoreCase(finalVaiTro)) {
                finalBoPhanCode = null;
            } else if ("BQL".equalsIgnoreCase(finalVaiTro)) {
                finalBoPhanCode = "MAIN";
            } else if ("NV".equalsIgnoreCase(finalVaiTro)) {
                if (boPhanCode != null && !boPhanCode.trim().isEmpty()) {
                    finalBoPhanCode = boPhanCode.trim();
                } else {
                    finalBoPhanCode = "LT";
                }
            }

            TaiKhoan tk = new TaiKhoan();
            tk.setMaTaiKhoan("TK" + (System.currentTimeMillis() % 100000));
            tk.setTenDangNhap(tenDangNhap.trim());
            tk.setMatKhau(PasswordUtil.hash(matKhau.trim()));
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
