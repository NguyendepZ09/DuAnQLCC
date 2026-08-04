package filter;

import dao.TaiKhoanDAO;
import entity.TaiKhoan;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter bao ve toan bo he thong quan ly chung cu (Tomcat 11 / Jakarta EE)
 * Dang ky duy nhat trong web.xml voi dispatcher REQUEST.
 * Kiem tra Whitelist, Session, Database Lock status (trangThaiHoatDong) va Phân quyền theo Role.
 */
public class AuthFilter implements Filter {

    private static final String[] WHITELIST = {
        "/dang-nhap",
        "/dang-nhap-the",
        "/index.jsp",
        "/login",
        "/logout",
        "/css/",
        "/js/",
        "/assets/",
        "/favicon.ico"
    };

    private TaiKhoanDAO taiKhoanDAO;
    private dao.ThongBaoDAO thongBaoDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        taiKhoanDAO = new TaiKhoanDAO();
        thongBaoDAO = new dao.ThongBaoDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isWhitelisted(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Integer idTaiKhoan = (session != null) ? (Integer) session.getAttribute("idTaiKhoan") : null;
        String tenDangNhap = (session != null) ? (String) session.getAttribute("tenDangNhap") : null;
        String vaiTro = (session != null) ? (String) session.getAttribute("vaiTro") : null;
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (session == null || idTaiKhoan == null || tenDangNhap == null) {
            res.sendRedirect(contextPath + "/dang-nhap");
            return;
        }

        if (taiKhoanDAO == null) {
            taiKhoanDAO = new TaiKhoanDAO();
        }
        TaiKhoan tk = taiKhoanDAO.findByTenDangNhap(tenDangNhap);
        if (tk == null || tk.getTrangThaiHoatDong() == null || !"HoatDong".equalsIgnoreCase(tk.getTrangThaiHoatDong())) {
            session.invalidate();
            res.sendRedirect(contextPath + "/dang-nhap");
            return;
        }

        if (maNhanVien != null) {
            if (thongBaoDAO == null) thongBaoDAO = new dao.ThongBaoDAO();
            req.setAttribute("countThongBaoChuaDoc", thongBaoDAO.countThongBaoChuaDocChoNhanVien(maNhanVien));
        }

        if (path.startsWith("/banquanly/")) {
            if (!"BQL".equalsIgnoreCase(vaiTro)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/cudan/")) {
            if (!"CD".equalsIgnoreCase(vaiTro)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/letan/")) {
            String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;
            if (!"NV".equalsIgnoreCase(vaiTro) || !"LeTan".equalsIgnoreCase(boPhanCode)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/kythuat/")) {
            String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;
            if (!"NV".equalsIgnoreCase(vaiTro) || !"KyThuat".equalsIgnoreCase(boPhanCode)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/ketoan/")) {
            String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;
            if (!"NV".equalsIgnoreCase(vaiTro) || !"KeToan".equalsIgnoreCase(boPhanCode)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/baove/")) {
            String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;
            if (!"NV".equalsIgnoreCase(vaiTro) || !"BaoVe".equalsIgnoreCase(boPhanCode)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }
        else if (path.startsWith("/nhanvien/")) {
            if (!"NV".equalsIgnoreCase(vaiTro) && !"BQL".equalsIgnoreCase(vaiTro)) {
                res.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, res);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isWhitelisted(String path) {
        if (path == null || path.equals("/")) return true;
        for (String item : WHITELIST) {
            if (item.endsWith("/")) {
                if (path.startsWith(item)) return true;
            } else {
                if (path.equalsIgnoreCase(item)) return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}
