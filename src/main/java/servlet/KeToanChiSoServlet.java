package servlet;

import dao.ChiSoTieuThuDAO;
import dao.ChiSoTieuThuDAO.ChiSoInput;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/ketoan/chi-so", "/ketoan/chi-so/luu"})
public class KeToanChiSoServlet extends HttpServlet {

    private final ChiSoTieuThuDAO chiSoDAO = new ChiSoTieuThuDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int thang = getCurrentMonth(req);
        int nam = getCurrentYear(req);

        List<Object[]> list = chiSoDAO.findChiSoTheoKy(thang, nam);

        req.setAttribute("thang", thang);
        req.setAttribute("nam", nam);
        req.setAttribute("chiSoList", list);
        req.setAttribute("activeMenu", "chi-so");

        req.getRequestDispatcher("/WEB-INF/views/ketoan/chi-so.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int thang = getCurrentMonth(req);
        int nam = getCurrentYear(req);

        String[] maCanHoArr = req.getParameterValues("maCanHo");
        List<ChiSoInput> inputList = new ArrayList<>();

        if (maCanHoArr != null) {
            for (String idStr : maCanHoArr) {
                try {
                    int maCanHo = Integer.parseInt(idStr);
                    String dienStr = req.getParameter("chiSoDien_" + maCanHo);
                    String nuocStr = req.getParameter("chiSoNuoc_" + maCanHo);
                    String dienPrevStr = req.getParameter("chiSoDienKyTruoc_" + maCanHo);
                    String nuocPrevStr = req.getParameter("chiSoNuocKyTruoc_" + maCanHo);

                    Double chiSoDien = (dienStr != null && !dienStr.isBlank()) ? Double.parseDouble(dienStr.trim()) : null;
                    Double chiSoNuoc = (nuocStr != null && !nuocStr.isBlank()) ? Double.parseDouble(nuocStr.trim()) : null;
                    Double chiSoDienKyTruoc = (dienPrevStr != null && !dienPrevStr.isBlank()) ? Double.parseDouble(dienPrevStr.trim()) : null;
                    Double chiSoNuocKyTruoc = (nuocPrevStr != null && !nuocPrevStr.isBlank()) ? Double.parseDouble(nuocPrevStr.trim()) : null;

                    inputList.add(new ChiSoInput(maCanHo, chiSoDien, chiSoNuoc, chiSoDienKyTruoc, chiSoNuocKyTruoc));
                } catch (NumberFormatException ignored) {}
            }
        }

        String errorMsg = chiSoDAO.luuChiSoHangLoat(inputList, thang, nam);

        if (errorMsg == null) {
            String successMsg = URLEncoder.encode("Đã lưu chỉ số điện nước thành công cho Tháng " + thang + "/" + nam, StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/ketoan/chi-so?thang=" + thang + "&nam=" + nam + "&msg=" + successMsg);
        } else {
            req.setAttribute("error", errorMsg);
            req.setAttribute("thang", thang);
            req.setAttribute("nam", nam);
            req.setAttribute("chiSoList", chiSoDAO.findChiSoTheoKy(thang, nam));
            req.setAttribute("activeMenu", "chi-so");
            req.getRequestDispatcher("/WEB-INF/views/ketoan/chi-so.jsp").forward(req, resp);
        }
    }

    private int getCurrentMonth(HttpServletRequest req) {
        String p = req.getParameter("thang");
        if (p != null && !p.isBlank()) {
            try {
                int val = Integer.parseInt(p.trim());
                if (val >= 1 && val <= 12) return val;
            } catch (NumberFormatException ignored) {}
        }
        return LocalDate.now().getMonthValue();
    }

    private int getCurrentYear(HttpServletRequest req) {
        String p = req.getParameter("nam");
        if (p != null && !p.isBlank()) {
            try {
                int val = Integer.parseInt(p.trim());
                if (val >= 2000) return val;
            } catch (NumberFormatException ignored) {}
        }
        return LocalDate.now().getYear();
    }
}
