package servlet;

import dao.NhanSuDAO;
import entity.ChamCong;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet({
    "/kythuat/cham-cong", "/baove/cham-cong", "/letan/cham-cong", "/ketoan/cham-cong",
    "/kythuat/cham-cong/ghi", "/baove/cham-cong/ghi", "/letan/cham-cong/ghi", "/ketoan/cham-cong/ghi"
})
public class NhanVienChamCongServlet extends HttpServlet {

    private final NhanSuDAO nhanSuDAO = new NhanSuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer maNhanVien = (session != null) ? (Integer) session.getAttribute("maNhanVien") : null;

        if (maNhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/dang-nhap");
            return;
        }

        // Xử lý khoảng ngày lọc (mặc định 30 ngày gần nhất)
        String tuNgayStr = req.getParameter("tuNgay");
        String denNgayStr = req.getParameter("denNgay");

        LocalDate denNgay = LocalDate.now();
        LocalDate tuNgay = denNgay.minusDays(30);

        if (tuNgayStr != null && !tuNgayStr.isBlank()) {
            try { tuNgay = LocalDate.parse(tuNgayStr.trim()); } catch (Exception ignored) {}
        }
        if (denNgayStr != null && !denNgayStr.isBlank()) {
            try { denNgay = LocalDate.parse(denNgayStr.trim()); } catch (Exception ignored) {}
        }

        List<Object[]> dsChamCong = nhanSuDAO.findChamCongCuaToi(maNhanVien, tuNgay, denNgay);
        Map<String, Object> thongKe = nhanSuDAO.thongKeCuaToi(maNhanVien, tuNgay, denNgay);

        // Tính toán trạng thái chấm công hôm nay ở Java truyền xuống JSP dạng String/boolean
        ChamCong homNayCC = nhanSuDAO.findChamCongHomNay(maNhanVien);
        String trangThaiHomNayText = "Chưa chấm công hôm nay";
        String gioVaoHomNayText = "";
        String gioRaHomNayText = "";
        String tongGioHomNayText = "";
        boolean daChamVao = false;
        boolean daChamRa = false;
        String caLamHomNay = "Sang";

        DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");

        if (homNayCC != null) {
            if (homNayCC.getCaLam() != null && !homNayCC.getCaLam().isBlank()) {
                caLamHomNay = homNayCC.getCaLam();
            }

            if (homNayCC.getGioVao() != null) {
                daChamVao = true;
                gioVaoHomNayText = homNayCC.getGioVao().format(timeFmt);
                trangThaiHomNayText = "Đã chấm công vào lúc " + gioVaoHomNayText;
            }

            if (homNayCC.getGioRa() != null) {
                daChamRa = true;
                gioRaHomNayText = homNayCC.getGioRa().format(timeFmt);
                trangThaiHomNayText = "Đã chấm công ra lúc " + gioRaHomNayText;
            }

            if (homNayCC.getGioVao() != null && homNayCC.getGioRa() != null) {
                long phut = java.time.temporal.ChronoUnit.MINUTES.between(homNayCC.getGioVao(), homNayCC.getGioRa());
                if (phut < 0) phut += 24 * 60;
                double hours = Math.round((phut / 60.0) * 10.0) / 10.0;
                tongGioHomNayText = String.format(java.util.Locale.US, "%.1f", hours) + " giờ";
                trangThaiHomNayText = "Đã hoàn thành ca làm (" + gioVaoHomNayText + " - " + gioRaHomNayText + ", " + tongGioHomNayText + ")";
            }
        }

        req.setAttribute("dsChamCong", dsChamCong);
        req.setAttribute("thongKe", thongKe);
        req.setAttribute("tuNgayChon", tuNgay != null ? tuNgay.toString() : "");
        req.setAttribute("denNgayChon", denNgay != null ? denNgay.toString() : "");

        req.setAttribute("trangThaiHomNayText", trangThaiHomNayText);
        req.setAttribute("gioVaoHomNayText", gioVaoHomNayText);
        req.setAttribute("gioRaHomNayText", gioRaHomNayText);
        req.setAttribute("tongGioHomNayText", tongGioHomNayText);
        req.setAttribute("daChamVao", daChamVao);
        req.setAttribute("daChamRa", daChamRa);
        req.setAttribute("caLamHomNay", caLamHomNay);
        req.setAttribute("activeMenu", "cham-cong");

        // Forward tới đúng file JSP theo role dựa vào servletPath
        String path = req.getServletPath();
        String jspPath = "/WEB-INF/views/kythuat/cham-cong.jsp";

        if (path.startsWith("/baove")) {
            jspPath = "/WEB-INF/views/baove/cham-cong.jsp";
        } else if (path.startsWith("/letan")) {
            jspPath = "/WEB-INF/views/letan/cham-cong.jsp";
        } else if (path.startsWith("/ketoan")) {
            jspPath = "/WEB-INF/views/ketoan/cham-cong.jsp";
        }

        req.getRequestDispatcher(jspPath).forward(req, resp);
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

        // Suy đường dẫn redirect bằng cách bỏ hậu tố /ghi từ servletPath
        String servletPath = req.getServletPath();
        String redirectPath = req.getContextPath() + servletPath.replaceAll("/ghi$", "");

        String hanhDong = req.getParameter("hanhDong");
        String caLamParam = req.getParameter("caLam");

        DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
        ChamCong homNayCC = nhanSuDAO.findChamCongHomNay(maNhanVien);

        if ("vao".equalsIgnoreCase(hanhDong)) {
            if (homNayCC != null && homNayCC.getGioVao() != null) {
                String gioVaoStr = homNayCC.getGioVao().format(timeFmt);
                String errMsg = URLEncoder.encode("Bạn đã chấm công vào lúc " + gioVaoStr + " hôm nay rồi.", StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?error=" + errMsg);
                return;
            }

            if (homNayCC == null) {
                homNayCC = new ChamCong();
                homNayCC.setMaNhanVien(maNhanVien);
                homNayCC.setNgayLam(LocalDate.now());
            }
            homNayCC.setGioVao(LocalDateTime.now());
            homNayCC.setCaLam(caLamParam != null && !caLamParam.isBlank() ? caLamParam.trim() : "Sang");

            String err = nhanSuDAO.saveChamCong(homNayCC);
            if (err == null) {
                String gioVaoStr = homNayCC.getGioVao().format(timeFmt);
                String msg = URLEncoder.encode("Chấm công vào thành công lúc " + gioVaoStr + "!", StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?error=" + errMsg);
            }
            return;
        }

        if ("ra".equalsIgnoreCase(hanhDong)) {
            if (homNayCC == null || homNayCC.getGioVao() == null) {
                String errMsg = URLEncoder.encode("Bạn chưa chấm công vào hôm nay.", StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?error=" + errMsg);
                return;
            }

            if (homNayCC.getGioRa() != null) {
                String gioRaStr = homNayCC.getGioRa().format(timeFmt);
                String errMsg = URLEncoder.encode("Bạn đã chấm công ra lúc " + gioRaStr + " rồi.", StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?error=" + errMsg);
                return;
            }

            homNayCC.setGioRa(LocalDateTime.now());
            String err = nhanSuDAO.saveChamCong(homNayCC);
            if (err == null) {
                String gioRaStr = homNayCC.getGioRa().format(timeFmt);
                String msg = URLEncoder.encode("Chấm công ra thành công lúc " + gioRaStr + "!", StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(redirectPath + "?error=" + errMsg);
            }
            return;
        }

        resp.sendRedirect(redirectPath);
    }
}
