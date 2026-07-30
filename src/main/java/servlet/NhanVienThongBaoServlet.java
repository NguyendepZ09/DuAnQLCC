package servlet;

import dao.ThongBaoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet dung chung de hien thi thong bao cho 4 bo phan Nhan vien: Le tan, Ky thuat, Ke toan, Bao ve.
 */
@WebServlet({"/letan/thong-bao", "/kythuat/thong-bao",
             "/ketoan/thong-bao", "/baove/thong-bao",
             "/letan/thong-bao/da-doc", "/kythuat/thong-bao/da-doc",
             "/ketoan/thong-bao/da-doc", "/baove/thong-bao/da-doc"})
public class NhanVienThongBaoServlet extends HttpServlet {

    private ThongBaoDAO thongBaoDAO = new ThongBaoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null || maNhanVien <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        List<Map<String, Object>> dsThongBao = thongBaoDAO.findThongBaoChoNhanVien(maNhanVien);
        int countChuaDoc = thongBaoDAO.countThongBaoChuaDocChoNhanVien(maNhanVien);

        req.setAttribute("dsThongBao", dsThongBao);
        req.setAttribute("countThongBaoChuaDoc", countChuaDoc);

        String path = req.getServletPath();
        String forwardPath = "/WEB-INF/views/letan/thong-bao.jsp";
        if (path.startsWith("/kythuat/")) {
            forwardPath = "/WEB-INF/views/kythuat/thong-bao.jsp";
        } else if (path.startsWith("/ketoan/")) {
            forwardPath = "/WEB-INF/views/ketoan/thong-bao.jsp";
        } else if (path.startsWith("/baove/")) {
            forwardPath = "/WEB-INF/views/baove/thong-bao.jsp";
        }

        req.getRequestDispatcher(forwardPath).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null || maNhanVien <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String maThongBaoStr = req.getParameter("maThongBao");
        if (maThongBaoStr != null && !maThongBaoStr.trim().isEmpty()) {
            try {
                int maThongBao = Integer.parseInt(maThongBaoStr.trim());
                thongBaoDAO.danhDauDaDoc(maThongBao, maNhanVien);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String path = req.getServletPath();
        String redirectUrl = req.getContextPath() + "/letan/thong-bao";
        if (path.startsWith("/kythuat/")) {
            redirectUrl = req.getContextPath() + "/kythuat/thong-bao";
        } else if (path.startsWith("/ketoan/")) {
            redirectUrl = req.getContextPath() + "/ketoan/thong-bao";
        } else if (path.startsWith("/baove/")) {
            redirectUrl = req.getContextPath() + "/baove/thong-bao";
        }

        resp.sendRedirect(redirectUrl);
    }
}
