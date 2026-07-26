package filter;

import jakarta.servlet.*;
import java.io.IOException;

/**
 * Filter set UTF-8 encoding cho tat ca Request va Response (Dang ky duy nhat trong web.xml)
 */
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
