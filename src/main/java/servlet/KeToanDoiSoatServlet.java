package servlet;

import dao.DoiSoatDAO;
import dao.GiaoDichThanhToanDAO;
import util.SaoKeParser;
import util.SaoKeParser.ParseResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;

@WebServlet({"/ketoan/doi-soat", "/ketoan/doi-soat/tai-len", "/ketoan/doi-soat/xac-nhan"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class KeToanDoiSoatServlet extends HttpServlet {

    private final DoiSoatDAO doiSoatDAO = new DoiSoatDAO();
    private final GiaoDichThanhToanDAO gdttDAO = new GiaoDichThanhToanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        List<Map<String, Object>> pendingList = gdttDAO.findPendingTransactionsMapped();
        req.setAttribute("pendingList", pendingList);
        req.setAttribute("activeMenu", "doi-soat");

        req.getRequestDispatcher("/WEB-INF/views/ketoan/doi-soat.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/ketoan/doi-soat/tai-len".equals(path)) {
            xuLyTaiLen(req, resp);
        } else if ("/ketoan/doi-soat/xac-nhan".equals(path)) {
            xuLyXacNhan(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/ketoan/doi-soat");
        }
    }

    private void xuLyTaiLen(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("activeMenu", "doi-soat");
        List<Map<String, Object>> pendingList = gdttDAO.findPendingTransactionsMapped();
        req.setAttribute("pendingList", pendingList);

        try {
            Part filePart = req.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                req.setAttribute("msgError", "Vui lòng chọn file sao kê CSV để tải lên.");
                req.getRequestDispatcher("/WEB-INF/views/ketoan/doi-soat.jsp").forward(req, resp);
                return;
            }

            try (InputStream is = filePart.getInputStream()) {
                ParseResult parseResult = SaoKeParser.parse(is);

                List<Map<String, Object>> ketQuaDoiChieu = doiSoatDAO.doiChieu(parseResult.getDanhSach());

                int countKhop = 0;
                int countLechTien = 0;
                int countDaXuLy = 0;
                int countKhongMa = 0;

                for (Map<String, Object> r : ketQuaDoiChieu) {
                    String kq = (String) r.get("ketQua");
                    if ("Khop".equalsIgnoreCase(kq)) countKhop++;
                    else if ("LechTien".equalsIgnoreCase(kq)) countLechTien++;
                    else if ("DaXuLy".equalsIgnoreCase(kq) || "DaDoiSoatTruocDo".equalsIgnoreCase(kq)) countDaXuLy++;
                    else countKhongMa++;
                }

                Map<String, Integer> summary = new HashMap<>();
                summary.put("tongDong", parseResult.getTongSoDong());
                summary.put("soKhop", countKhop);
                summary.put("soLechTien", countLechTien);
                summary.put("soDaXuLy", countDaXuLy);
                summary.put("soKhongMa", countKhongMa);

                req.setAttribute("ketQuaDoiChieu", ketQuaDoiChieu);
                req.setAttribute("summaryInfo", summary);
                req.setAttribute("parsedData", true);
                req.setAttribute("fileName", filePart.getSubmittedFileName());

            } catch (Exception parseEx) {
                req.setAttribute("msgError", "Lỗi đọc file sao kê: " + parseEx.getMessage());
            }

        } catch (Exception e) {
            req.setAttribute("msgError", "Lỗi xử lý file tải lên: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/ketoan/doi-soat.jsp").forward(req, resp);
    }

    private void xuLyXacNhan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer maNhanVien = (session != null && session.getAttribute("maNhanVien") != null) 
                ? (Integer) session.getAttribute("maNhanVien") : 1;

        String[] selectedIdsStr = req.getParameterValues("selectedGdId");
        if (selectedIdsStr == null || selectedIdsStr.length == 0) {
            session.setAttribute("msgError", "Vui lòng tích chọn ít nhất một giao dịch để xác nhận.");
            resp.sendRedirect(req.getContextPath() + "/ketoan/doi-soat");
            return;
        }

        List<Integer> dsMaGiaoDich = new ArrayList<>();
        Map<Integer, String> mapThamChieu = new HashMap<>();

        for (String idStr : selectedIdsStr) {
            try {
                int id = Integer.parseInt(idStr.trim());
                dsMaGiaoDich.add(id);
                String refVal = req.getParameter("ref_" + id);
                if (refVal != null) {
                    mapThamChieu.put(id, refVal.trim());
                }
            } catch (NumberFormatException ignored) {}
        }

        Map<String, Object> result = doiSoatDAO.xacNhanHangLoat(dsMaGiaoDich, mapThamChieu, maNhanVien);

        int soThanhCong = (int) result.getOrDefault("soThanhCong", 0);
        int soBoQua = (int) result.getOrDefault("soBoQua", 0);
        @SuppressWarnings("unchecked")
        List<String> dsLoi = (List<String>) result.get("dsLoi");

        StringBuilder sb = new StringBuilder();
        sb.append("Đã đối soát thành công ").append(soThanhCong).append(" giao dịch.");
        if (soBoQua > 0) {
            sb.append(" Bỏ qua/bị trùng: ").append(soBoQua).append(" giao dịch.");
        }

        session.setAttribute("msgSuccess", sb.toString());
        if (dsLoi != null && !dsLoi.isEmpty()) {
            session.setAttribute("msgErrorList", dsLoi);
        }

        resp.sendRedirect(req.getContextPath() + "/ketoan/doi-soat");
    }
}
