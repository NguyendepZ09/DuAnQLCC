package servlet;

import util.JPAUtil;
import util.NFCTheUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/letan/nfc-the")
public class LeTanNFCServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer idTaiKhoan = (session != null) ? (Integer) session.getAttribute("idTaiKhoan") : null;
        String vaiTro = (session != null) ? (String) session.getAttribute("vaiTro") : null;
        String boPhanCode = (session != null) ? (String) session.getAttribute("boPhanCode") : null;

        if (idTaiKhoan == null || !"NV".equalsIgnoreCase(vaiTro) || !"LeTan".equalsIgnoreCase(boPhanCode)) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        int port = req.getServerPort();
        String scheme = req.getScheme();
        String portStr = ((("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443) || port == 80 || port == 443)) ? "" : ":" + port;
        String defaultBaseUrl = scheme + "://" + req.getServerName() + portStr + req.getContextPath();

        String paramBaseUrl = req.getParameter("baseUrl");
        String baseUrl = (paramBaseUrl != null && !paramBaseUrl.trim().isEmpty())
                ? paramBaseUrl.trim()
                : defaultBaseUrl;

        EntityManager em = JPAUtil.getEntityManager();
        List<Object[]> dsTheNFC = new ArrayList<>();
        try {
            String sql = "SELECT t.soThe, c.soPhong, ISNULL(cd.hoTen, N'Chưa gán') AS tenCuDan " +
                         "FROM dbo.theTu t " +
                         "JOIN dbo.canHo c ON c.id = t.maCanHo " +
                         "LEFT JOIN dbo.cuDan cd ON cd.id = t.maCuDan " +
                         "WHERE t.trangThai = 'DangSuDung' " +
                         "ORDER BY t.id DESC";

            @SuppressWarnings("unchecked")
            List<Object[]> rawList = em.createNativeQuery(sql).getResultList();

            for (Object[] r : rawList) {
                String soThe = r[0] != null ? r[0].toString() : "";
                String soPhong = r[1] != null ? r[1].toString() : "";
                String tenCuDan = r[2] != null ? r[2].toString() : "Chưa gán";

                String loginUrl = NFCTheUtil.buildLoginUrl(baseUrl, soThe);
                dsTheNFC.add(new Object[]{soThe, soPhong, tenCuDan, loginUrl});
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }

        req.setAttribute("baseUrl", baseUrl);
        req.setAttribute("dsTheNFC", dsTheNFC);
        req.setAttribute("activeMenu", "nfc-the");

        req.getRequestDispatcher("/WEB-INF/views/letan/nfc-the.jsp").forward(req, resp);
    }
}
