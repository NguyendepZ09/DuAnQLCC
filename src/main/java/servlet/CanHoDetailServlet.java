package servlet;

import dao.CanHoDAO;
import entity.CanHo;
import entity.CuDan;
import entity.HoaDon;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Servlet AJAX tra ve JSON thong tin chi tiet 1 can ho + chu ho + cong no
 */
@WebServlet("/banquanly/can-ho-detail")
public class CanHoDetailServlet extends HttpServlet {

    private CanHoDAO canHoDAO = new CanHoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Thiếu mã căn hộ.\"}");
            return;
        }

        try {
            int canHoId = Integer.parseInt(idStr.trim());
            Map<String, Object> detail = canHoDAO.findDetailById(canHoId);
            
            CanHo ch = (CanHo) detail.get("canHo");
            if (ch == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy căn hộ.\"}");
                return;
            }

            CuDan cd = (CuDan) detail.get("cuDan");
            @SuppressWarnings("unchecked")
            List<CuDan> dsCuDan = (List<CuDan>) detail.get("dsCuDan");
            HoaDon hd = (HoaDon) detail.get("hoaDon");

            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"success\":true,");
            sb.append("\"id\":").append(ch.getId()).append(",");
            sb.append("\"soCanHo\":\"").append(escapeJson(ch.getSoCanHo())).append("\",");
            sb.append("\"tang\":").append(ch.getTang() != null ? ch.getTang() : 1).append(",");
            sb.append("\"dienTich\":").append(ch.getDienTich() != null ? ch.getDienTich() : 75.0).append(",");
            sb.append("\"trangThai\":\"").append(escapeJson(ch.getTrangThai())).append("\",");

            sb.append("\"dsCuDan\":[");
            if (dsCuDan != null) {
                for (int i = 0; i < dsCuDan.size(); i++) {
                    CuDan c = dsCuDan.get(i);
                    if (i > 0) sb.append(",");
                    sb.append("{");
                    sb.append("\"id\":").append(c.getId()).append(",");
                    sb.append("\"hoTen\":\"").append(escapeJson(c.getHoTen())).append("\",");
                    sb.append("\"soDienThoai\":\"").append(escapeJson(c.getSoDienThoai())).append("\",");
                    sb.append("\"loaiCuDan\":\"").append(escapeJson(c.getLoaiCuDan())).append("\",");
                    sb.append("\"loaiCuDanText\":\"").append(escapeJson(util.DisplayUtil.getLoaiCuDanText(c.getLoaiCuDan()))).append("\",");
                    sb.append("\"loaiCuDanBadgeClass\":\"").append(escapeJson(util.DisplayUtil.getLoaiCuDanBadgeClass(c.getLoaiCuDan()))).append("\"");
                    sb.append("}");
                }
            }
            sb.append("],");
            
            sb.append("\"chuHoTen\":\"").append(cd != null && cd.getHoTen() != null ? escapeJson(cd.getHoTen()) : "Chưa có cư dân").append("\",");
            sb.append("\"chuHoSdt\":\"").append(cd != null && cd.getSoDienThoai() != null ? escapeJson(cd.getSoDienThoai()) : "N/A").append("\",");
            sb.append("\"chuHoEmail\":\"").append(cd != null && cd.getEmail() != null ? escapeJson(cd.getEmail()) : "N/A").append("\",");

            sb.append("\"congNoTien\":").append(hd != null && hd.getTongTien() != null ? hd.getTongTien() : 0.0).append(",");
            sb.append("\"congNoTrangThai\":\"").append(hd != null && hd.getTrangThaiThanhToan() != null ? escapeJson(hd.getTrangThaiThanhToan()) : "Không có công nợ").append("\"");
            sb.append("}");

            out.print(sb.toString());

        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Mã căn hộ không hợp lệ.\"}");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
