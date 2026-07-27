package servlet;

import dao.BinhChonDAO;
import dao.CuDanBinhChonDAO;
import dao.ThongBaoDAO;
import entity.BinhChon;
import entity.PhuongAnBinhChon;
import entity.ThongBao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet tao, quan ly va dong cuoc binh chon danh cho Ban Quan Ly
 */
@WebServlet(urlPatterns = {"/banquanly/binh-chon", "/banquanly/dong-binh-chon"})
public class BinhChonAdminServlet extends HttpServlet {

    private BinhChonDAO binhChonDAO = new BinhChonDAO();
    private ThongBaoDAO thongBaoDAO = new ThongBaoDAO();
    private CuDanBinhChonDAO cuDanBinhChonDAO = new CuDanBinhChonDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<BinhChon> danhSachBinhChon = binhChonDAO.findAll();
            List<ThongBao> danhSachThongBao = thongBaoDAO.findAll();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

            List<Map<String, Object>> pollViews = new ArrayList<>();
            for (BinhChon bc : danhSachBinhChon) {
                Map<String, Object> view = new HashMap<>();
                view.put("binhChon", bc);
                view.put("hanChotFormatted", (bc.getHanChot() != null) ? sdf.format(bc.getHanChot()) : "");
                
                // Thong ke tham gia thuc te (so can da bau / tong can DangO)
                Map<String, Object> stats = binhChonDAO.getParticipationStats(bc.getId());
                view.put("stats", stats);

                // Danh sach phuong an
                List<PhuongAnBinhChon> options = cuDanBinhChonDAO.findPhuongAnByBinhChonId(bc.getId());
                view.put("phuongAnList", options);

                // Neu cuoc binh chon da dong/khong du tuc so -> Lay ket qua chi tiet tu view v_KetQuaBinhChon
                if ("DaDong".equalsIgnoreCase(bc.getTrangThai()) || "KhongDuTucSo".equalsIgnoreCase(bc.getTrangThai())) {
                    List<Map<String, Object>> ketQuaList = cuDanBinhChonDAO.findKetQuaBinhChonFromView(bc.getId());
                    view.put("ketQuaViewList", ketQuaList);
                }

                pollViews.add(view);
            }

            request.setAttribute("pollViews", pollViews);
            request.setAttribute("danhSachBinhChon", danhSachBinhChon);
            request.setAttribute("danhSachThongBao", danhSachThongBao);
            request.setAttribute("activeMenu", "binh-chon");

            HttpSession session = request.getSession(false);
            if (session != null) {
                if (session.getAttribute("errorMessage") != null) {
                    request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                    session.removeAttribute("errorMessage");
                }
                if (session.getAttribute("successMessage") != null) {
                    request.setAttribute("successMessage", session.getAttribute("successMessage"));
                    session.removeAttribute("successMessage");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi load dữ liệu trong BinhChonAdminServlet (doGet): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu bình chọn: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/banquanly/binh-chon.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String path = request.getServletPath();

        // 1. XU LY DONG BINH CHON (Goi sp_DongBinhChon)
        if ("/banquanly/dong-binh-chon".equals(path)) {
            String maBinhChonStr = request.getParameter("maBinhChon");
            if (maBinhChonStr != null) {
                try {
                    int maBinhChon = Integer.parseInt(maBinhChonStr.trim());
                    String err = binhChonDAO.dongBinhChon(maBinhChon);
                    if (err == null) {
                        session.setAttribute("successMessage", "Đã đóng cuộc bình chọn và tổng kết kết quả thành công!");
                    } else {
                        session.setAttribute("errorMessage", "Lỗi khi đóng bình chọn: " + err);
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Mã bình chọn không hợp lệ: " + e.getMessage());
                }
            } else {
                session.setAttribute("errorMessage", "Chưa chọn cuộc bình chọn để đóng.");
            }
            response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
            return;
        }

        // 2. XU LY TAO CUOC BINH CHON MOI
        String cauHoi = request.getParameter("cauHoi");
        String maThongBaoStr = request.getParameter("maThongBao");
        String hanChotStr = request.getParameter("hanChot");
        String tyLeTucSoStr = request.getParameter("tyLeTucSo");
        String[] phuongAnArray = request.getParameterValues("phuongAn");

        try {
            if (cauHoi == null || cauHoi.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập câu hỏi bình chọn.");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }

            // Parse hanChot: input type="datetime-local" gui dang yyyy-MM-ddTHH:mm
            Date hanChot = null;
            if (hanChotStr == null || hanChotStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập hạn chót bỏ phiếu.");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }
            try {
                hanChot = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(hanChotStr.trim());
                if (!hanChot.after(new Date())) {
                    session.setAttribute("errorMessage", "Hạn chót phải sau thời điểm hiện tại.");
                    response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                    return;
                }
            } catch (ParseException pe) {
                session.setAttribute("errorMessage", "Định dạng hạn chót không hợp lệ (yyyy-MM-ddTHH:mm).");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }

            // Parse tyLeTucSo (bat buoc, 1–100)
            double tyLeTucSo = 50.0;
            if (tyLeTucSoStr == null || tyLeTucSoStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập tỷ lệ túc số.");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }
            try {
                tyLeTucSo = Double.parseDouble(tyLeTucSoStr.trim());
                if (tyLeTucSo < 1 || tyLeTucSo > 100) {
                    session.setAttribute("errorMessage", "Tỷ lệ túc số phải từ 1 đến 100.");
                    response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                    return;
                }
            } catch (NumberFormatException nfe) {
                session.setAttribute("errorMessage", "Tỷ lệ túc số không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                return;
            }

            Integer maThongBaoId = null;
            if (maThongBaoStr != null && !maThongBaoStr.trim().isEmpty()) {
                try {
                    maThongBaoId = Integer.parseInt(maThongBaoStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            if (maThongBaoId == null) {
                List<ThongBao> dsThongBao = thongBaoDAO.findAll();
                if (!dsThongBao.isEmpty()) {
                    maThongBaoId = dsThongBao.get(0).getId();
                } else {
                    session.setAttribute("errorMessage", "Hệ thống chưa có thông báo nào để tạo khảo sát liên quan. Vui lòng phát hành thông báo trước.");
                    response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
                    return;
                }
            }

            BinhChon bc = new BinhChon();
            bc.setCauHoi(cauHoi.trim());
            bc.setMaThongBao(maThongBaoId);
            bc.setNgayBatDau(new Date());
            bc.setHanChot(hanChot);
            bc.setTrangThai("DangMo");
            bc.setTyLeTucSo(tyLeTucSo);

            List<String> phuongAnList = phuongAnArray != null ? Arrays.asList(phuongAnArray) : List.of();
            String dbError = binhChonDAO.saveBinhChonVoiPhuongAnGetError(bc, phuongAnList);

            if (dbError == null) {
                session.setAttribute("successMessage", "Tạo cuộc bình chọn mới thành công!");
            } else {
                session.setAttribute("errorMessage", "Lỗi DB: " + dbError);
            }

        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            System.err.println("[BinhChonAdminServlet.doPost] EXCEPTION:\n" + sw);
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
    }
}
