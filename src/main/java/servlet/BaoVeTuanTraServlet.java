package servlet;

import dao.BaoVeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet({"/baove/tuan-tra", "/baove/tuan-tra/ghi"})
public class BaoVeTuanTraServlet extends HttpServlet {

    private final BaoVeDAO baoVeDAO = new BaoVeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String ngayStr = req.getParameter("ngay");
        LocalDate ngayLocalDate = LocalDate.now();
        if (ngayStr != null && !ngayStr.trim().isEmpty()) {
            try {
                ngayLocalDate = LocalDate.parse(ngayStr.trim());
            } catch (DateTimeParseException e) {
                ngayLocalDate = LocalDate.now();
            }
        }

        List<Object[]> tuanTraList = baoVeDAO.findTuanTraTheoNgay(maNhanVien, ngayLocalDate);
        List<Integer> tangChuaTuanTraList = baoVeDAO.findTangChuaTuanTra24h();
        Set<Integer> tangChuaTuanTraSet = new HashSet<>(tangChuaTuanTraList);

        req.setAttribute("activeMenu", "tuan-tra");
        req.setAttribute("ngayChon", ngayLocalDate.toString());
        req.setAttribute("tuanTraList", tuanTraList);
        req.setAttribute("tangChuaTuanTraSet", tangChuaTuanTraSet);

        req.getRequestDispatcher("/WEB-INF/views/baove/tuan-tra.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        String path = req.getServletPath();
        if ("/baove/tuan-tra/ghi".equals(path)) {
            String soTangStr = req.getParameter("soTang");
            String anhMinhChung = req.getParameter("anhMinhChung");

            int soTang = 0;
            try {
                soTang = Integer.parseInt(soTangStr);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/baove/tuan-tra?error=" + java.net.URLEncoder.encode("Số tầng không hợp lệ.", "UTF-8"));
                return;
            }

            String err = baoVeDAO.ghiNhanTuanTra(maNhanVien, soTang, anhMinhChung);
            if (err == null) {
                String msg = java.net.URLEncoder.encode("Ghi nhận tuần tra Tầng " + soTang + " thành công!", "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/tuan-tra?msg=" + msg);
            } else {
                String errMsg = java.net.URLEncoder.encode(err, "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/tuan-tra?error=" + errMsg);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/baove/tuan-tra");
        }
    }
}
