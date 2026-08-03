package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import util.QRTuanTraUtil;

@WebServlet("/banquanly/qr-tuan-tra")
public class BQLQrTuanTraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer idTaiKhoan = (session != null) ? (Integer) session.getAttribute("idTaiKhoan") : null;

        if (idTaiKhoan == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String defaultBaseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        String paramBaseUrl = req.getParameter("baseUrl");

        String baseUrl = (paramBaseUrl != null && !paramBaseUrl.trim().isEmpty())
                ? paramBaseUrl.trim()
                : defaultBaseUrl;

        List<Object[]> dsQR = new ArrayList<>();
        for (int tang = 1; tang <= 25; tang++) {
            String qrImageUrl = QRTuanTraUtil.buildQRImageUrl(baseUrl, tang);
            dsQR.add(new Object[]{tang, qrImageUrl});
        }

        req.setAttribute("baseUrl", baseUrl);
        req.setAttribute("dsQR", dsQR);

        req.getRequestDispatcher("/WEB-INF/views/banquanly/qr-tuan-tra.jsp").forward(req, resp);
    }
}
