package servlet;

import dao.QuanLyXeDAO;
import dao.TheTuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet({"/letan/quan-ly-xe", "/letan/quan-ly-xe/them", "/letan/quan-ly-xe/sua", "/letan/quan-ly-xe/xoa", "/letan/quan-ly-xe/the-tu"})
public class LeTanQuanLyXeServlet extends HttpServlet {

    private final QuanLyXeDAO quanLyXeDAO = new QuanLyXeDAO();
    private final TheTuDAO theTuDAO = new TheTuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/letan/quan-ly-xe/the-tu".equals(path)) {
            // Helper JSON for active cards of apartment
            resp.setContentType("application/json;charset=UTF-8");
            String canHoIdStr = req.getParameter("maCanHo");
            int maCanHo = 0;
            try { maCanHo = Integer.parseInt(canHoIdStr); } catch (Exception ignored) {}

            List<Object[]> cards = quanLyXeDAO.findTheDangSuDungTheoCanHo(maCanHo);
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < cards.size(); i++) {
                Object[] c = cards.get(i);
                if (i > 0) sb.append(",");
                sb.append("{\"id\":").append(c[0]).append(",\"soThe\":\"").append(c[1]).append("\"}");
            }
            sb.append("]");
            resp.getWriter().print(sb.toString());
            return;
        }

        String tuKhoa = req.getParameter("tuKhoa");
        String loaiXe = req.getParameter("loaiXe");

        List<Object[]> xeList = quanLyXeDAO.findAllXe(tuKhoa, loaiXe);
        List<Object[]> dsCanHo = theTuDAO.findCanHoDangO();

        req.setAttribute("activeMenu", "quan-ly-xe");
        req.setAttribute("xeList", xeList);
        req.setAttribute("dsCanHo", dsCanHo);
        req.setAttribute("tuKhoa", tuKhoa != null ? tuKhoa.trim() : "");
        req.setAttribute("loaiXeChon", loaiXe != null ? loaiXe.trim() : "");

        req.getRequestDispatcher("/WEB-INF/views/letan/quan-ly-xe.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/letan/quan-ly-xe/them".equals(path)) {
            String maCanHoStr = req.getParameter("maCanHo");
            String maTheStr = req.getParameter("maThe");
            String bienSoXe = req.getParameter("bienSoXe");
            String loaiXe = req.getParameter("loaiXe");

            int maCanHo = 0;
            try { maCanHo = Integer.parseInt(maCanHoStr); } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode("Căn hộ không hợp lệ.", "UTF-8"));
                return;
            }

            Integer maThe = null;
            if (maTheStr != null && !maTheStr.trim().isEmpty()) {
                try { maThe = Integer.parseInt(maTheStr.trim()); } catch (Exception ignored) {}
            }

            String err = quanLyXeDAO.themXe(maCanHo, maThe, bienSoXe, loaiXe);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?msg=" + URLEncoder.encode("Thêm phương tiện mới thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/quan-ly-xe/sua".equals(path)) {
            String idStr = req.getParameter("id");
            String maTheStr = req.getParameter("maThe");
            String bienSoXe = req.getParameter("bienSoXe");
            String loaiXe = req.getParameter("loaiXe");

            int id = 0;
            try { id = Integer.parseInt(idStr); } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode("Phương tiện không hợp lệ.", "UTF-8"));
                return;
            }

            Integer maThe = null;
            if (maTheStr != null && !maTheStr.trim().isEmpty()) {
                try { maThe = Integer.parseInt(maTheStr.trim()); } catch (Exception ignored) {}
            }

            String err = quanLyXeDAO.suaXe(id, maThe, bienSoXe, loaiXe);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?msg=" + URLEncoder.encode("Cập nhật thông tin phương tiện thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/quan-ly-xe/xoa".equals(path)) {
            String idStr = req.getParameter("id");
            int id = 0;
            try { id = Integer.parseInt(idStr); } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode("Phương tiện không hợp lệ.", "UTF-8"));
                return;
            }

            String err = quanLyXeDAO.xoaXe(id);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?msg=" + URLEncoder.encode("Xóa phương tiện thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe?error=" + URLEncoder.encode(err, "UTF-8"));
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/letan/quan-ly-xe");
        }
    }
}
