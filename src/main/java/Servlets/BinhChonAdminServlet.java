package Servlets;

import DAOs.BinhChonDAO;
import Entities.BinhChon;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Servlet tao khao sat/binh chon kem cac phuong an (dung JPA Transaction)
 */
@WebServlet("/banquanly/binh-chon")
public class BinhChonAdminServlet extends HttpServlet {

    private BinhChonDAO binhChonDAO = new BinhChonDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<BinhChon> danhSachBinhChon = binhChonDAO.findAll();
        request.setAttribute("danhSachBinhChon", danhSachBinhChon);

        request.getRequestDispatcher("/WEB-INF/views/banquanly/binh-chon.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String cauHoi = request.getParameter("cauHoi");
        String maThongBaoStr = request.getParameter("maThongBao");
        String[] phuongAnArray = request.getParameterValues("phuongAn");

        if (cauHoi != null && !cauHoi.trim().isEmpty()) {
            BinhChon bc = new BinhChon();
            bc.setCauHoi(cauHoi.trim());
            bc.setNgayBatDau(new Date());
            bc.setTrangThai("Mở");
            bc.setTyLeTucSo(0.0);

            if (maThongBaoStr != null && !maThongBaoStr.trim().isEmpty()) {
                try {
                    bc.setMaThongBao(Integer.parseInt(maThongBaoStr.trim()));
                } catch (NumberFormatException e) {
                    bc.setMaThongBao(1);
                }
            } else {
                bc.setMaThongBao(1);
            }

            List<String> phuongAnList = phuongAnArray != null ? Arrays.asList(phuongAnArray) : List.of();
            binhChonDAO.saveBinhChonVoiPhuongAn(bc, phuongAnList);
        }

        response.sendRedirect(request.getContextPath() + "/banquanly/binh-chon");
    }
}
