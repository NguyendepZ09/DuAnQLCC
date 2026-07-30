package servlet;

import dao.DatLichTienIchDAO;
import entity.DanhMucTienIch;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@WebServlet({"/cudan/tien-ich", "/cudan/tien-ich/dat", "/cudan/tien-ich/huy"})
public class CuDanTienIchServlet extends HttpServlet {

    private final DatLichTienIchDAO datLichDAO = new DatLichTienIchDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer maCanHo = (Integer) req.getSession().getAttribute("maCanHo");
        if (maCanHo == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        List<DanhMucTienIch> amenities = datLichDAO.findAllAmenities();
        List<Object[]> historyList = datLichDAO.findBookingHistoryByCanHo(maCanHo);

        req.setAttribute("amenities", amenities);
        req.setAttribute("historyList", historyList);
        req.setAttribute("today", LocalDate.now());
        req.setAttribute("maxDate", LocalDate.now().plusDays(30));
        req.setAttribute("activeMenu", "tien-ich");

        req.getRequestDispatcher("/WEB-INF/views/cudan/tien-ich.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        Integer maCanHo = (Integer) req.getSession().getAttribute("maCanHo");
        Integer maCuDan = (Integer) req.getSession().getAttribute("maCuDan");
        if (maCanHo == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        if (uri.endsWith("/dat")) {
            xuLyDatLich(req, resp, maCanHo, maCuDan);
        } else if (uri.endsWith("/huy")) {
            xuLyHuyLich(req, resp, maCanHo);
        } else {
            resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich");
        }
    }

    private void xuLyDatLich(HttpServletRequest req, HttpServletResponse resp, int maCanHo, Integer maCuDan) throws ServletException, IOException {
        String maTienIchStr = req.getParameter("maTienIch");
        String ngayDatStr = req.getParameter("ngayDat");
        String khungGio = req.getParameter("khungGio");

        try {
            int maTienIch = Integer.parseInt(maTienIchStr.trim());
            LocalDate ngayDat = LocalDate.parse(ngayDatStr.trim());

            String err = datLichDAO.datLichTienIch(maCanHo, maCuDan, maTienIch, ngayDat, khungGio);

            if (err == null) {
                String msg = URLEncoder.encode("Đặt lịch tiện ích thành công! Đang chờ BQL xác nhận.", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich?error=" + errMsg);
            }
        } catch (Exception e) {
            String errMsg = URLEncoder.encode("Dữ liệu đặt lịch không hợp lệ: " + e.getMessage(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich?error=" + errMsg);
        }
    }

    private void xuLyHuyLich(HttpServletRequest req, HttpServletResponse resp, int maCanHo) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            String err = datLichDAO.huyDatLich(id, maCanHo);

            if ("FORBIDDEN".equals(err)) {
                // --- CHỐNG IDOR KHI HỦY LỊCH CỦA CĂN HỘ KHÁC ---
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.getRequestDispatcher("/WEB-INF/views/403.jsp").forward(req, resp);
                return;
            }

            if (err == null) {
                String msg = URLEncoder.encode("Đã hủy lượt đặt lịch tiện ích thành công!", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich?error=" + errMsg);
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cudan/tien-ich");
        }
    }
}
