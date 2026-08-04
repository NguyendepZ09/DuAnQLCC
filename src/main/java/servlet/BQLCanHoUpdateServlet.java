package servlet;

import dao.CanHoDAO;
import entity.CanHo;
import entity.CuDan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Set;

/**
 * Servlet cap nhat thong tin can ho (dien tich, trang thai) cho Ban Quan Ly
 */
@WebServlet("/banquanly/can-ho/cap-nhat")
public class BQLCanHoUpdateServlet extends HttpServlet {

    private final CanHoDAO canHoDAO = new CanHoDAO();
    private static final Set<String> TRANG_THAI_HOP_LE = Set.of("DangO", "TrongChoThue", "BaoTri");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String dienTichStr = req.getParameter("dienTich");
        String trangThaiStr = req.getParameter("trangThai");

        if (idStr == null || idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/banquanly/so-do");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            // 1. Validate dienTich > 0
            double dienTich = 0;
            if (dienTichStr != null && !dienTichStr.isBlank()) {
                dienTich = Double.parseDouble(dienTichStr.trim());
            }
            if (dienTich <= 0) {
                String errMsg = URLEncoder.encode("Diện tích căn hộ phải là số dương (> 0).", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
                return;
            }

            // 2. Validate trangThai
            if (trangThaiStr == null || !TRANG_THAI_HOP_LE.contains(trangThaiStr.trim())) {
                String errMsg = URLEncoder.encode("Trạng thái căn hộ không hợp lệ.", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
                return;
            }
            String trangThaiMoi = trangThaiStr.trim();

            // 3. Tim can ho
            CanHo canHo = canHoDAO.findById(id);
            if (canHo == null) {
                String errMsg = URLEncoder.encode("Không tìm thấy thông tin căn hộ mã #" + id, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
                return;
            }

            // 4. Quy tac nghiep vu: Căn hộ đang có cư dân sinh sống không được đổi sang Trống chờ thuê hoặc Bảo trì
            List<CuDan> dsCuDan = canHoDAO.findCuDanDangO(id);
            if (!dsCuDan.isEmpty() && ("TrongChoThue".equalsIgnoreCase(trangThaiMoi) || "BaoTri".equalsIgnoreCase(trangThaiMoi))) {
                String errMsg = URLEncoder.encode("Căn hộ đang có cư dân sinh sống, không thể đổi trạng thái. Hãy chuyển cư dân đi trước.", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
                return;
            }

            // 5. Cap nhat va luu DB
            canHo.setDienTich(dienTich);
            canHo.setTrangThai(trangThaiMoi);

            String err = canHoDAO.updateCanHo(canHo);
            if (err == null) {
                String msg = URLEncoder.encode("Cập nhật thông tin căn hộ " + canHo.getSoPhong() + " thành công!", StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?msg=" + msg);
            } else {
                String errMsg = URLEncoder.encode(err, StandardCharsets.UTF_8);
                resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
            }

        } catch (NumberFormatException e) {
            String errMsg = URLEncoder.encode("Dữ liệu nhập vào không đúng định dạng.", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/banquanly/so-do?error=" + errMsg);
        }
    }
}
