package Filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter bao ve tat ca các URL /banquanly/*
 * Yeu cau Session bat buoc co vaiTro = 'BQL'
 */
@WebFilter("/banquanly/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String vaiTro = (session != null) ? (String) session.getAttribute("vaiTro") : null;

        // Kiem tra quyen Ban Quan Ly (BQL)
        if (session != null && "BQL".equalsIgnoreCase(vaiTro)) {
            chain.doFilter(request, response);
        } else {
            // Un-authorized -> Redirect den trang dang nhap
            res.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}
