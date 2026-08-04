package servlet;

import dao.CuDanDAO;
import dao.TaiKhoanDAO;
import dao.TheTuDAO;
import entity.CuDan;
import entity.TaiKhoan;
import entity.TheTu;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import util.NFCTheUtil;

@WebServlet("/dang-nhap-the")
public class DangNhapTheServlet extends HttpServlet {

    private final TheTuDAO theTuDAO = new TheTuDAO();
    private final CuDanDAO cuDanDAO = new CuDanDAO();
    private final TaiKhoanDAO taiKhoanDAO = new TaiKhoanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String soThe = req.getParameter("soThe");
        String token = req.getParameter("token");

        if (soThe == null || soThe.trim().isEmpty() || token == null || token.trim().isEmpty()) {
            redirectWithError(req, resp, "Thiếu thông tin thẻ NFC.");
            return;
        }

        soThe = soThe.trim();

        if (!NFCTheUtil.kiemTraToken(soThe, token)) {
            redirectWithError(req, resp, "Thẻ không hợp lệ hoặc đã bị giả mạo.");
            return;
        }

        TheTu theTu = theTuDAO.findBySoThe(soThe);
        if (theTu == null) {
            redirectWithError(req, resp, "Thẻ chưa được đăng ký trong hệ thống.");
            return;
        }

        String trangThai = theTu.getTrangThai();
        if ("TamKhoa".equalsIgnoreCase(trangThai)) {
            redirectWithError(req, resp, "Thẻ đang bị tạm khóa.");
            return;
        } else if ("DaThuHoi".equalsIgnoreCase(trangThai)) {
            redirectWithError(req, resp, "Thẻ đã bị thu hồi.");
            return;
        } else if (!"DangSuDung".equalsIgnoreCase(trangThai)) {
            redirectWithError(req, resp, "Thẻ không thể sử dụng.");
            return;
        }

        if (theTu.getNgayHetHan() != null) {
            LocalDate hetHanLocalDate = theTu.getNgayHetHan();
            if (hetHanLocalDate.isBefore(LocalDate.now())) {
                Date hetHanDate = Date.from(hetHanLocalDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
                String dateStr = new SimpleDateFormat("dd/MM/yyyy").format(hetHanDate);
                redirectWithError(req, resp, "Thẻ đã hết hạn ngày " + dateStr + ".");
                return;
            }
        }

        Integer maCuDan = theTu.getMaCuDan();
        if (maCuDan == null || maCuDan <= 0) {
            redirectWithError(req, resp, "Thẻ chưa gắn với cư dân nào.");
            return;
        }

        CuDan cuDan = cuDanDAO.findById(maCuDan);
        if (cuDan == null || cuDan.getMaTaiKhoan() == null) {
            redirectWithError(req, resp, "Tài khoản cư dân không tồn tại.");
            return;
        }

        TaiKhoan taiKhoan = taiKhoanDAO.findById(cuDan.getMaTaiKhoan());
        if (taiKhoan == null || !"HoatDong".equalsIgnoreCase(taiKhoan.getTrangThaiHoatDong())) {
            redirectWithError(req, resp, "Tài khoản đã bị khóa.");
            return;
        }

        // Dang nhap thanh cong -> invalid session cu, tao session moi
        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("idTaiKhoan", taiKhoan.getId());
        session.setAttribute("tenDangNhap", taiKhoan.getTenDangNhap());
        session.setAttribute("vaiTro", taiKhoan.getVaiTro());
        session.setAttribute("boPhanCode", taiKhoan.getBoPhanCode());
        session.setAttribute("hoTen", cuDan.getHoTen());
        session.setAttribute("maCuDan", cuDan.getId());
        session.setAttribute("maCanHo", cuDan.getMaCanHo());
        session.setAttribute("maNhanVien", null);

        String redirectUrl = LoginServlet.calculateRedirectUrl(req.getContextPath(), taiKhoan.getVaiTro(), taiKhoan.getBoPhanCode());
        resp.sendRedirect(redirectUrl);
    }

    private void redirectWithError(HttpServletRequest req, HttpServletResponse resp, String errorMsg)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        String encodedMsg = URLEncoder.encode(errorMsg, StandardCharsets.UTF_8);
        resp.sendRedirect(req.getContextPath() + "/dang-nhap?error=" + encodedMsg);
    }
}
