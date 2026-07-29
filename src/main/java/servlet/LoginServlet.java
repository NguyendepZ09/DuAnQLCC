package servlet;

import dao.CuDanDAO;
import dao.TaiKhoanDAO;
import entity.CuDan;
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
    private CuDanDAO cuDanDAO = new CuDanDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String roleChon = request.getParameter("vaiTro");

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

            // Kiem tra role chon tu tab dang nhap phai khop voi VaiTro / BoPhan trong DB
            if (!khopVaiTro(roleChon, tk.getVaiTro(), tk.getBoPhanCode())) {
                System.err.println("[LoginServlet] Role mismatch for user '" + tenDangNhap + "': selected role='" + roleChon 
                        + "', DB vaiTro='" + tk.getVaiTro() + "', DB boPhanCode='" + tk.getBoPhanCode() + "'");
                out.print(buildJson(false, "Tên đăng nhập hoặc mật khẩu không đúng!", null, null));
                return;
            }

            // Neu la CD -> Kiem tra phai co ban ghi cuDan va maCanHo
            Integer maCuDan = null;
            Integer maCanHo = null;
            Integer maNhanVien = null;
            String userHoTen = tk.getTenDangNhap();

            if ("CD".equalsIgnoreCase(tk.getVaiTro())) {
                CuDan cd = cuDanDAO.findByMaTaiKhoan(tk.getId());
                if (cd == null || cd.getMaCanHo() == null) {
                    out.print(buildJson(false, "Tài khoản cư dân chưa được gán với căn hộ nào. Vui lòng liên hệ Ban quản lý!", null, null));
                    return;
                }
                maCuDan = cd.getId();
                maCanHo = cd.getMaCanHo();
                if (cd.getHoTen() != null && !cd.getHoTen().trim().isEmpty()) {
                    userHoTen = cd.getHoTen().trim();
                }
            } else if ("NV".equalsIgnoreCase(tk.getVaiTro()) || "BQL".equalsIgnoreCase(tk.getVaiTro())) {
                // Kiem tra phai co ho so nhanVien trong DB
                jakarta.persistence.EntityManager em = util.JPAUtil.getEntityManager();
                try {
                    java.util.List<Object[]> nvRows = em.createNativeQuery("SELECT id, hoTen FROM nhanVien WHERE maTaiKhoan = ?")
                            .setParameter(1, tk.getId())
                            .getResultList();
                    if (nvRows.isEmpty() && "NV".equalsIgnoreCase(tk.getVaiTro())) {
                        out.print(buildJson(false, "Tài khoản nhân viên chưa được gán thông tin Hồ sơ Nhân viên. Vui lòng liên hệ Ban quản lý!", null, null));
                        return;
                    }
                    if (!nvRows.isEmpty()) {
                        Object[] row = nvRows.get(0);
                        maNhanVien = ((Number) row[0]).intValue();
                        if (row[1] != null && !row[1].toString().trim().isEmpty()) {
                            userHoTen = row[1].toString().trim();
                        }
                    }
                } finally {
                    em.close();
                }
            }

            // Dang nhap thanh cong -> Tao Session
            HttpSession session = request.getSession(true);
            session.setAttribute("idTaiKhoan", tk.getId());
            session.setAttribute("tenDangNhap", tk.getTenDangNhap());
            session.setAttribute("vaiTro", tk.getVaiTro());
            session.setAttribute("boPhanCode", tk.getBoPhanCode());
            session.setAttribute("hoTen", userHoTen);
            if (maCuDan != null) session.setAttribute("maCuDan", maCuDan);
            if (maCanHo != null) session.setAttribute("maCanHo", maCanHo);
            if (maNhanVien != null) session.setAttribute("maNhanVien", maNhanVien);

            String redirectUrl = calculateRedirectUrl(request.getContextPath(), tk.getVaiTro(), tk.getBoPhanCode());
            out.print(buildJson(true, "Đăng nhập thành công!", redirectUrl, userHoTen));

        } catch (Exception e) {
            System.err.println("Lỗi trong LoginServlet: " + e.getMessage());
            e.printStackTrace();
            out.print(buildJson(false, "Lỗi hệ thống: " + e.getMessage(), null, null));
        }
    }

    private boolean khopVaiTro(String roleChon, String vaiTroDB, String boPhanDB) {
        if (roleChon == null || roleChon.trim().isEmpty()) {
            return true; // Khong truyen vaiTro -> bo qua kiem tra (dam bao backward compatibility)
        }
        String role = roleChon.trim();
        String vDB = (vaiTroDB != null) ? vaiTroDB.trim() : "";
        String bDB = (boPhanDB != null) ? boPhanDB.trim() : "";

        if ("cudan".equalsIgnoreCase(role)) {
            return "CD".equalsIgnoreCase(vDB);
        }
        if ("banquanly".equalsIgnoreCase(role)) {
            return "BQL".equalsIgnoreCase(vDB);
        }
        if ("letan".equalsIgnoreCase(role)) {
            return "NV".equalsIgnoreCase(vDB) && ("LeTan".equalsIgnoreCase(bDB) || "LT".equalsIgnoreCase(bDB));
        }
        if ("kythuat".equalsIgnoreCase(role)) {
            return "NV".equalsIgnoreCase(vDB) && ("KyThuat".equalsIgnoreCase(bDB) || "NVKT".equalsIgnoreCase(bDB));
        }
        if ("ketoan".equalsIgnoreCase(role)) {
            return "NV".equalsIgnoreCase(vDB) && ("KeToan".equalsIgnoreCase(bDB) || "KT".equalsIgnoreCase(bDB));
        }
        if ("baove".equalsIgnoreCase(role)) {
            return "NV".equalsIgnoreCase(vDB) && ("BaoVe".equalsIgnoreCase(bDB) || "BV".equalsIgnoreCase(bDB));
        }
        return false;
    }

    private String calculateRedirectUrl(String contextPath, String vaiTro, String boPhanCode) {
        if ("CD".equalsIgnoreCase(vaiTro)) {
            return contextPath + "/cudan/thong-bao";
        }
        if ("BQL".equalsIgnoreCase(vaiTro)) {
            return contextPath + "/banquanly/binh-chon";
        }
        if ("NV".equalsIgnoreCase(vaiTro)) {
            if (boPhanCode != null) {
                String code = boPhanCode.trim();
                switch (code) {
                    case "LeTan":
                    case "LT":
                        return contextPath + "/letan/su-co";
                    case "KyThuat":
                    case "NVKT":
                        return contextPath + "/kythuat/cong-viec";
                    case "KeToan":
                    case "KT":
                        return contextPath + "/ketoan/chi-so";
                    case "BaoVe":
                    case "BV":
                        return contextPath + "/baove/dashboard";
                    case "BanQuanLy":
                    case "MAIN":
                        return contextPath + "/banquanly/binh-chon";
                }
            }
            return contextPath + "/dang-nhap.jsp";
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
