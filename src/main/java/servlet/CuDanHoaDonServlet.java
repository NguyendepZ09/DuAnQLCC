package servlet;

import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@WebServlet({"/cudan/hoa-don", "/cudan/hoa-don/chi-tiet"})
public class CuDanHoaDonServlet extends HttpServlet {

    private final HoaDonDAO hoaDonDAO = new HoaDonDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer maCanHo = (Integer) req.getSession().getAttribute("maCanHo");
        if (maCanHo == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        String uri = req.getRequestURI();
        if (uri.endsWith("/chi-tiet")) {
            hienThiChiTiet(req, resp, maCanHo);
        } else {
            hienThiDanhSach(req, resp, maCanHo);
        }
    }

    private void hienThiDanhSach(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        List<Object[]> list = hoaDonDAO.findHoaDonTheoCanHo(maCanHo);

        int tongSoHoaDon = list.size();
        int soChuaThanhToan = 0;
        BigDecimal tongCongNo = BigDecimal.ZERO;

        for (Object[] row : list) {
            String trangThai = (String) row[4];
            BigDecimal conNo = (BigDecimal) row[6];
            if (!"DaThanhToan".equalsIgnoreCase(trangThai)) {
                soChuaThanhToan++;
                if (conNo != null && conNo.compareTo(BigDecimal.ZERO) > 0) {
                    tongCongNo = tongCongNo.add(conNo);
                }
            }
        }

        req.setAttribute("hoaDonList", list);
        req.setAttribute("tongSoHoaDon", tongSoHoaDon);
        req.setAttribute("soChuaThanhToan", soChuaThanhToan);
        req.setAttribute("tongCongNo", tongCongNo);
        req.setAttribute("activeMenu", "hoa-don");

        req.getRequestDispatcher("/WEB-INF/views/cudan/hoa-don.jsp").forward(req, resp);
    }

    private void hienThiChiTiet(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        // --- KIỂM TRA CHỐNG IDOR (RẤT QUAN TRỌNG) ---
        boolean isOwner = hoaDonDAO.hoaDonThuocCanHo(id, maCanHo);
        if (!isOwner) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, resp);
            return;
        }

        Map<String, Object> data = hoaDonDAO.findChiTietChoCuDan(id);
        if (data == null) {
            resp.sendRedirect(req.getContextPath() + "/cudan/hoa-don");
            return;
        }

        req.setAttribute("data", data);
        req.setAttribute("activeMenu", "hoa-don");
        req.getRequestDispatcher("/WEB-INF/views/cudan/hoa-don-chi-tiet.jsp").forward(req, resp);
    }
}
