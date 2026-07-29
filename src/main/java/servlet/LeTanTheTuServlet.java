package servlet;

import dao.TheTuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@WebServlet({"/letan/the-tu", "/letan/the-tu/cap", "/letan/the-tu/sua", "/letan/the-tu/doi-trang-thai", "/letan/the-tu/cu-dan"})
public class LeTanTheTuServlet extends HttpServlet {

    private final TheTuDAO theTuDAO = new TheTuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/letan/the-tu/cu-dan".equals(path)) {
            resp.setContentType("application/json;charset=UTF-8");
            String canHoIdStr = req.getParameter("maCanHo");
            int maCanHo = 0;
            try { maCanHo = Integer.parseInt(canHoIdStr); } catch (Exception ignored) {}

            List<Object[]> cuDans = theTuDAO.findCuDanTheoCanHo(maCanHo);
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < cuDans.size(); i++) {
                Object[] cd = cuDans.get(i);
                if (i > 0) sb.append(",");
                sb.append("{\"id\":").append(cd[0])
                  .append(",\"hoTen\":\"").append(cd[1])
                  .append("\",\"loaiCuDan\":\"").append(cd[2])
                  .append("\"}");
            }
            sb.append("]");
            resp.getWriter().print(sb.toString());
            return;
        }

        String tuKhoa = req.getParameter("tuKhoa");
        String trangThai = req.getParameter("trangThai");

        List<Object[]> theTuList = theTuDAO.findAllThe(tuKhoa, trangThai);
        Map<String, Integer> stats = theTuDAO.thongKeTheTu();
        List<Object[]> dsCanHo = theTuDAO.findCanHoDangO();

        req.setAttribute("activeMenu", "the-tu");
        req.setAttribute("theTuList", theTuList);
        req.setAttribute("stats", stats);
        req.setAttribute("dsCanHo", dsCanHo);
        req.setAttribute("tuKhoa", tuKhoa != null ? tuKhoa.trim() : "");
        req.setAttribute("trangThaiChon", trangThai != null ? trangThai.trim() : "");

        req.getRequestDispatcher("/WEB-INF/views/letan/the-tu.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/letan/the-tu/cap".equals(path)) {
            String maCanHoStr = req.getParameter("maCanHo");
            String maCuDanStr = req.getParameter("maCuDan");
            String soThe = req.getParameter("soThe");
            String ngayHetHanStr = req.getParameter("ngayHetHan");
            String[] chucNangArr = req.getParameterValues("chucNang");

            int maCanHo = 0;
            try {
                maCanHo = Integer.parseInt(maCanHoStr);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode("Căn hộ không hợp lệ.", "UTF-8"));
                return;
            }

            Integer maCuDan = null;
            if (maCuDanStr != null && !maCuDanStr.trim().isEmpty()) {
                try { maCuDan = Integer.parseInt(maCuDanStr.trim()); } catch (Exception ignored) {}
            }

            LocalDate ngayHetHan = null;
            if (ngayHetHanStr != null && !ngayHetHanStr.trim().isEmpty()) {
                try { ngayHetHan = LocalDate.parse(ngayHetHanStr.trim()); } catch (DateTimeParseException ignored) {}
            }

            List<String> dsChucNang = chucNangArr != null ? Arrays.asList(chucNangArr) : null;

            String err = theTuDAO.capTheMoi(maCanHo, maCuDan, soThe, ngayHetHan, dsChucNang);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?msg=" + URLEncoder.encode("Cấp thẻ từ mới thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/the-tu/sua".equals(path)) {
            String idStr = req.getParameter("id");
            String maCuDanStr = req.getParameter("maCuDan");
            String ngayHetHanStr = req.getParameter("ngayHetHan");
            String[] chucNangArr = req.getParameterValues("chucNang");

            int id = 0;
            try { id = Integer.parseInt(idStr); } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode("Thẻ không hợp lệ.", "UTF-8"));
                return;
            }

            Integer maCuDan = null;
            if (maCuDanStr != null && !maCuDanStr.trim().isEmpty()) {
                try { maCuDan = Integer.parseInt(maCuDanStr.trim()); } catch (Exception ignored) {}
            }

            LocalDate ngayHetHan = null;
            if (ngayHetHanStr != null && !ngayHetHanStr.trim().isEmpty()) {
                try { ngayHetHan = LocalDate.parse(ngayHetHanStr.trim()); } catch (DateTimeParseException ignored) {}
            }

            List<String> dsChucNang = chucNangArr != null ? Arrays.asList(chucNangArr) : null;

            String err = theTuDAO.capNhatThe(id, maCuDan, ngayHetHan, dsChucNang);
            if (err == null) {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?msg=" + URLEncoder.encode("Cập nhật thông tin thẻ từ thành công!", "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode(err, "UTF-8"));
            }

        } else if ("/letan/the-tu/doi-trang-thai".equals(path)) {
            String idStr = req.getParameter("id");
            String trangThaiMoi = req.getParameter("trangThaiMoi");

            int id = 0;
            try { id = Integer.parseInt(idStr); } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode("Thẻ không hợp lệ.", "UTF-8"));
                return;
            }

            String err = theTuDAO.doiTrangThaiThe(id, trangThaiMoi);
            if (err == null) {
                String label = "Thay đổi trạng thái thẻ thành công!";
                if ("DaThuHoi".equalsIgnoreCase(trangThaiMoi)) {
                    label = "Thu hồi thẻ từ thành công và đã tự động gỡ liên kết các xe đang gắn thẻ!";
                }
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?msg=" + URLEncoder.encode(label, "UTF-8"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/letan/the-tu?error=" + URLEncoder.encode(err, "UTF-8"));
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/letan/the-tu");
        }
    }
}
