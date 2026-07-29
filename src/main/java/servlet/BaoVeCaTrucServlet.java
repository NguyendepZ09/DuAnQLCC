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
import java.util.List;

@WebServlet({"/baove/ca-truc", "/baove/ca-truc/ghi", "/baove/ca-truc/ban-giao"})
public class BaoVeCaTrucServlet extends HttpServlet {

    private final BaoVeDAO baoVeDAO = new BaoVeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        List<Object[]> caTrucCuaToiList = baoVeDAO.findCaTrucCuaToi(maNhanVien);
        List<Object[]> caChoNhanList = baoVeDAO.findCaTrucChoNhanBanGiao(maNhanVien);
        List<Object[]> dsBaoVeKhac = baoVeDAO.findDanhSachBaoVeKhac(maNhanVien);

        req.setAttribute("activeMenu", "ca-truc");
        req.setAttribute("caTrucCuaToiList", caTrucCuaToiList);
        req.setAttribute("caChoNhanList", caChoNhanList);
        req.setAttribute("dsBaoVeKhac", dsBaoVeKhac);

        req.getRequestDispatcher("/WEB-INF/views/baove/ca-truc.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap.jsp");
            return;
        }

        String path = req.getServletPath();
        if ("/baove/ca-truc/ghi".equals(path)) {
            String caTruc = req.getParameter("caTruc");
            String ngayTrucStr = req.getParameter("ngayTruc");
            String noiDung = req.getParameter("noiDung");

            LocalDate ngayTruc = LocalDate.now();
            if (ngayTrucStr != null && !ngayTrucStr.trim().isEmpty()) {
                try {
                    ngayTruc = LocalDate.parse(ngayTrucStr.trim());
                } catch (DateTimeParseException e) {
                    ngayTruc = LocalDate.now();
                }
            }

            String err = baoVeDAO.ghiNhatKyCaTruc(maNhanVien, caTruc, ngayTruc, noiDung);
            if (err == null) {
                String msg = java.net.URLEncoder.encode("Ghi nhật ký ca trực thành công!", "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/ca-truc?msg=" + msg);
            } else {
                String errMsg = java.net.URLEncoder.encode(err, "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/ca-truc?error=" + errMsg);
            }

        } else if ("/baove/ca-truc/ban-giao".equals(path)) {
            String idStr = req.getParameter("maCaTruc");
            String nguoiNhanStr = req.getParameter("maNguoiNhanCa");
            String luuYBanGiao = req.getParameter("luuYBanGiao");

            int maCaTruc = 0;
            int maNguoiNhanCa = 0;
            try {
                maCaTruc = Integer.parseInt(idStr);
                maNguoiNhanCa = Integer.parseInt(nguoiNhanStr);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/baove/ca-truc?error=" + java.net.URLEncoder.encode("Thông tin bàn giao không hợp lệ.", "UTF-8"));
                return;
            }

            String err = baoVeDAO.banGiaoCa(maCaTruc, maNhanVien, maNguoiNhanCa, luuYBanGiao);
            if (err == null) {
                String msg = java.net.URLEncoder.encode("Bàn giao ca trực thành công!", "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/ca-truc?msg=" + msg);
            } else {
                String errMsg = java.net.URLEncoder.encode(err, "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/baove/ca-truc?error=" + errMsg);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/baove/ca-truc");
        }
    }
}
