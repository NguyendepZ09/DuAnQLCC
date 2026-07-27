package servlet;

import dao.BinhChonDAO;
import dao.CuDanBinhChonDAO;
import dao.CuDanDAO;
import dao.ThongBaoDAO;
import dao.ThongBaoDaDocDAO;
import entity.BinhChon;
import entity.CanHo;
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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Servlet xem danh sach thong bao va tham gia bo phieu danh cho Cu Dan
 */
@WebServlet(urlPatterns = {"/cudan/thong-bao", "/cudan/bo-phieu", "/cudan/mark-read"})
public class CuDanThongBaoBinhChonServlet extends HttpServlet {

    private ThongBaoDAO thongBaoDAO = new ThongBaoDAO();
    private ThongBaoDaDocDAO thongBaoDaDocDAO = new ThongBaoDaDocDAO();
    private BinhChonDAO binhChonDAO = new BinhChonDAO();
    private CuDanBinhChonDAO cuDanBinhChonDAO = new CuDanBinhChonDAO();
    private CuDanDAO cuDanDAO = new CuDanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("maCuDan") == null || session.getAttribute("maCanHo") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer idTaiKhoan = (Integer) session.getAttribute("idTaiKhoan");
        if (idTaiKhoan != null) {
            Map<String, Object> detailMap = cuDanDAO.findDetailWithCanHoByMaTaiKhoan(idTaiKhoan);
            CanHo ch = (CanHo) detailMap.get("canHo");
            request.setAttribute("canHoInfo", ch);
        }

        Integer maCuDan = (Integer) session.getAttribute("maCuDan");
        Integer maCanHo = (Integer) session.getAttribute("maCanHo");

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        // 1. Xu ly phan trang thong bao (doiTuong IN ('CuDan', 'TatCa'))
        int page = 1;
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<ThongBao> rawNotices = thongBaoDAO.findForCuDan(page, pageSize);
        List<Map<String, Object>> danhSachThongBao = new ArrayList<>();
        for (ThongBao tb : rawNotices) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", tb.getId());
            map.put("tieuDe", tb.getTieuDe());
            map.put("noiDung", tb.getNoiDung());
            map.put("loaiThongBao", tb.getLoaiThongBao());
            map.put("doiTuong", tb.getDoiTuong());
            map.put("ngayTaoFormatted", (tb.getNgayTao() != null) ? sdf.format(tb.getNgayTao()) : "");
            danhSachThongBao.add(map);
        }

        long totalNotices = thongBaoDAO.countForCuDan();
        int totalPages = (int) Math.ceil((double) totalNotices / pageSize);
        if (totalPages < 1) totalPages = 1;

        Set<Integer> readNoticeIds = thongBaoDaDocDAO.getReadNoticeIds(maCuDan);
        long unreadCount = thongBaoDaDocDAO.countUnreadForCuDan(maCuDan);

        request.setAttribute("danhSachThongBao", danhSachThongBao);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("readNoticeIds", readNoticeIds);
        request.setAttribute("unreadCount", unreadCount);

        // 2. Xu ly danh sach binh chon
        List<BinhChon> allBinhChon = binhChonDAO.findAll();
        List<Map<String, Object>> pollViews = new ArrayList<>();

        for (BinhChon bc : allBinhChon) {
            Map<String, Object> view = new HashMap<>();
            view.put("binhChon", bc);
            view.put("hanChotFormatted", (bc.getHanChot() != null) ? sdf.format(bc.getHanChot()) : "");

            List<PhuongAnBinhChon> options = cuDanBinhChonDAO.findPhuongAnByBinhChonId(bc.getId());
            view.put("phuongAnList", options);

            // Kiem tra xem can ho da bo phieu hay chưa
            Map<String, Object> votedDetail = cuDanBinhChonDAO.findPhieuBauByCanHo(bc.getId(), maCanHo);
            view.put("votedDetail", votedDetail);

            // Neu cuoc binh chon da dong/khong du tuc so -> Lay ket qua view v_KetQuaBinhChon
            if ("DaDong".equalsIgnoreCase(bc.getTrangThai()) || "KhongDuTucSo".equalsIgnoreCase(bc.getTrangThai())) {
                List<Map<String, Object>> ketQuaList = cuDanBinhChonDAO.findKetQuaBinhChonFromView(bc.getId());
                view.put("ketQuaViewList", ketQuaList);
            }

            pollViews.add(view);
        }

        request.setAttribute("pollViews", pollViews);
        request.setAttribute("activeMenu", "thong-bao");

        // Lay message tu session neu co
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/cudan/thong-bao-binh-chon.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("maCuDan") == null || session.getAttribute("maCanHo") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer maCuDan = (Integer) session.getAttribute("maCuDan");
        Integer maCanHo = (Integer) session.getAttribute("maCanHo");

        String servletPath = request.getServletPath();

        if ("/cudan/mark-read".equals(servletPath)) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            String idStr = request.getParameter("maThongBao");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    boolean ok = thongBaoDaDocDAO.markAsRead(id, maCuDan);
                    out.print("{\"success\":" + ok + "}");
                    return;
                } catch (Exception ignored) {}
            }
            out.print("{\"success\":false}");
            return;
        }

        if ("/cudan/bo-phieu".equals(servletPath)) {
            String maBinhChonStr = request.getParameter("maBinhChon");
            String maPhuongAnStr = request.getParameter("maPhuongAn");

            if (maBinhChonStr == null || maPhuongAnStr == null) {
                session.setAttribute("errorMessage", "Vui lòng chọn phương án trước khi bấm Bỏ phiếu.");
                response.sendRedirect(request.getContextPath() + "/cudan/thong-bao");
                return;
            }

            try {
                int maBinhChon = Integer.parseInt(maBinhChonStr);
                int maPhuongAn = Integer.parseInt(maPhuongAnStr);

                CuDanBinhChonDAO.VotingResult result = cuDanBinhChonDAO.boPhieu(maBinhChon, maPhuongAn, maCuDan, maCanHo);

                if (result.isSuccess()) {
                    session.setAttribute("successMessage", result.getMessage());
                } else {
                    session.setAttribute("errorMessage", result.getMessage());
                }

            } catch (Exception e) {
                System.err.println("Loi bo phieu trong CuDanThongBaoBinhChonServlet: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi xử lý bỏ phiếu: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/cudan/thong-bao");
        }
    }
}
