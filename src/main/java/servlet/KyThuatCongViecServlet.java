package servlet;

import dao.PhanAnhSuCoDAO;
import entity.LichSuXuLySuCo;
import entity.PhanAnhSuCo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Servlet nghiep vu Ky Thuat: Cong viec duoc giao, Cap nhat tien do va Hoan thanh cong viec
 */
@WebServlet(urlPatterns = {
    "/kythuat/cong-viec",
    "/kythuat/cong-viec/detail",
    "/kythuat/cong-viec/hoan-thanh",
    "/kythuat/cong-viec/cap-nhat-tien-do"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB
    maxFileSize = 5 * 1024 * 1024,          // 5 MB
    maxRequestSize = 10 * 1024 * 1024       // 10 MB
)
public class KyThuatCongViecServlet extends HttpServlet {

    private PhanAnhSuCoDAO phanAnhSuCoDAO = new PhanAnhSuCoDAO();
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idTaiKhoan") == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String vaiTro = (String) session.getAttribute("vaiTro");
        String boPhanCode = (String) session.getAttribute("boPhanCode");
        Integer maNhanVienSession = (Integer) session.getAttribute("maNhanVien");

        if (!"NV".equalsIgnoreCase(vaiTro) || !"KyThuat".equalsIgnoreCase(boPhanCode) || maNhanVienSession == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        String servletPath = request.getServletPath();

        // 1. XEM CHI TIET CONG VIEC DƯỢC GIAO
        if ("/kythuat/cong-viec/detail".equals(servletPath)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    PhanAnhSuCo pa = phanAnhSuCoDAO.findById(id);

                    // RANG BUOC BAO MAT: Kiem tra phieu duoc giao cho chinh maNhanVienSession
                    if (pa != null) {
                        if (!Objects.equals(pa.getMaNhanVien(), maNhanVienSession)) {
                            session.setAttribute("errorMessage", "Bạn không được phép truy cập hoặc xử lý phiếu công việc của kỹ thuật viên khác.");
                            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
                            return;
                        }

                        List<LichSuXuLySuCo> lichSuList = phanAnhSuCoDAO.findLichSuByPhanAnhId(id);
                        String tenNhanVien = phanAnhSuCoDAO.findTenNhanVien(pa.getMaNhanVien());

                        // Lay thong tin can ho va cu dan (neu co)
                        List<Map<String, Object>> list = phanAnhSuCoDAO.findAssignedForKyThuat(maNhanVienSession, null, null, 1, 100);
                        Map<String, Object> targetMap = null;
                        for (Map<String, Object> item : list) {
                            if (Objects.equals(item.get("id"), id)) {
                                targetMap = item;
                                break;
                            }
                        }

                        request.setAttribute("phanAnh", pa);
                        request.setAttribute("itemDetail", targetMap);
                        request.setAttribute("lichSuList", lichSuList);
                        request.setAttribute("tenNhanVien", tenNhanVien);
                        request.setAttribute("activeMenu", "cong-viec");

                        request.getRequestDispatcher("/WEB-INF/views/kythuat/cong-viec-chi-tiet.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        // 2. MAN HINH DANH SACH CONG VIEC DUOC GIAO
        String loaiSuCoFilter = request.getParameter("loaiSuCo");
        String mucDoUuTienFilter = request.getParameter("mucDoUuTien");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<Map<String, Object>> dsCongViec = phanAnhSuCoDAO.findAssignedForKyThuat(maNhanVienSession, loaiSuCoFilter, mucDoUuTienFilter, page, pageSize);
        long totalItems = phanAnhSuCoDAO.countAssignedForKyThuat(maNhanVienSession, loaiSuCoFilter, mucDoUuTienFilter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("dsCongViec", dsCongViec);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("loaiSuCoFilter", loaiSuCoFilter != null ? loaiSuCoFilter : "ALL");
        request.setAttribute("mucDoUuTienFilter", mucDoUuTienFilter != null ? mucDoUuTienFilter : "ALL");
        request.setAttribute("activeMenu", "cong-viec");

        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/kythuat/cong-viec.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idTaiKhoan") == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String vaiTro = (String) session.getAttribute("vaiTro");
        String boPhanCode = (String) session.getAttribute("boPhanCode");
        Integer maNhanVienSession = (Integer) session.getAttribute("maNhanVien"); // Luon lay tu Session, khong lay tu Form

        if (!"NV".equalsIgnoreCase(vaiTro) || !"KyThuat".equalsIgnoreCase(boPhanCode) || maNhanVienSession == null) {
            session.setAttribute("errorMessage", "Tài khoản của bạn chưa được xác thực hồ sơ Kỹ thuật.");
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String servletPath = request.getServletPath();
        String idStr = request.getParameter("id");

        if (idStr == null) {
            session.setAttribute("errorMessage", "Thiếu mã phản ánh sự cố.");
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        int maPhanAnh;
        try {
            maPhanAnh = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã phản ánh không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        // RÀNG BUỘC BẢO MẬT NGHIÊM TRỌNG (RULE 1): KIỂM TRA QUYỀN CHÍNH CHỦ VÀ TRẠNG THÁI DangXuLy NGAY ĐẦU HÀM POST
        PhanAnhSuCo paCheck = phanAnhSuCoDAO.findById(maPhanAnh);
        if (paCheck == null) {
            session.setAttribute("errorMessage", "Phản ánh không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        if (!Objects.equals(paCheck.getMaNhanVien(), maNhanVienSession)) {
            session.setAttribute("errorMessage", "Bạn không có quyền xem hoặc xử lý phiếu công việc của kỹ thuật viên khác.");
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        if (!"DangXuLy".equalsIgnoreCase(paCheck.getTrangThai())) {
            session.setAttribute("errorMessage", "Phản ánh đã hoàn thành hoặc đã hủy, không thể cập nhật.");
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec");
            return;
        }

        // 1. CẬP NHẬT TIẾN ĐỘ GIỮA CHỪNG (Khong doi trangThai)
        if ("/kythuat/cong-viec/cap-nhat-tien-do".equals(servletPath)) {
            String ghiChu = request.getParameter("ghiChu");
            String err = phanAnhSuCoDAO.capNhatTienDoKyThuat(maPhanAnh, maNhanVienSession, ghiChu);
            if (err == null) {
                session.setAttribute("successMessage", "Đã cập nhật tiến độ xử lý sự cố #" + maPhanAnh + " thành công!");
            } else {
                session.setAttribute("errorMessage", err);
            }
            response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec/detail?id=" + maPhanAnh);
            return;
        }

        // 2. HOÀN THÀNH CÔNG VIỆC (Upload anh nghiem thu bat buoc + Goi sp_CapNhatKetQuaSuCo)
        if ("/kythuat/cong-viec/hoan-thanh".equals(servletPath)) {
            String ghiChu = request.getParameter("ghiChu");
            File savedFile = null;
            File destSourceFile = null;
            String anhRelativePath = null;

            try {
                Part filePart = request.getPart("anhSauXuLy");
                if (filePart == null || filePart.getSize() <= 0) {
                    session.setAttribute("errorMessage", "Ảnh nghiệm thu sau xử lý là bắt buộc.");
                    response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec/detail?id=" + maPhanAnh);
                    return;
                }

                String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String ext = "";
                int dotIndex = submittedFileName.lastIndexOf('.');
                if (dotIndex >= 0) {
                    ext = submittedFileName.substring(dotIndex).toLowerCase();
                }

                String contentType = filePart.getContentType();
                if (!ALLOWED_EXTENSIONS.contains(ext) || contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    session.setAttribute("errorMessage", "File hình ảnh không hợp lệ! Chỉ chấp nhận .jpg, .jpeg, .png.");
                    response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec/detail?id=" + maPhanAnh);
                    return;
                }

                String uploadSubDir = "assets" + File.separator + "uploads" + File.separator + "suco";
                String realUploadPath = getServletContext().getRealPath("/") + uploadSubDir;

                File uploadDir = new File(realUploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String uniqueFileName = "suco_nghiemthu_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 6) + ext;
                savedFile = new File(uploadDir, uniqueFileName);
                filePart.write(savedFile.getAbsolutePath());

                anhRelativePath = "assets/uploads/suco/" + uniqueFileName;

                // Sync sang target source folder de ho tro hot reload
                try {
                    String sourcePath = "src" + File.separator + "main" + File.separator + "webapp" + File.separator + uploadSubDir;
                    File sourceDir = new File(sourcePath);
                    if (sourceDir.exists()) {
                        destSourceFile = new File(sourceDir, uniqueFileName);
                        java.nio.file.Files.copy(savedFile.toPath(), destSourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    }
                } catch (Exception ignored) {}

            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi tải ảnh nghiệm thu: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec/detail?id=" + maPhanAnh);
                return;
            }

            // Goi Stored Procedure sp_CapNhatKetQuaSuCo
            String err = phanAnhSuCoDAO.hoanThanhSuCoViaSP(maPhanAnh, maNhanVienSession, anhRelativePath, ghiChu);

            if (err != null) {
                // RULE 3: XÓA FILE NẾU TRANSACTION / STORED PROCEDURE THẤT BẠI
                if (savedFile != null && savedFile.exists()) {
                    savedFile.delete();
                }
                if (destSourceFile != null && destSourceFile.exists()) {
                    destSourceFile.delete();
                }
                session.setAttribute("errorMessage", err);
                response.sendRedirect(request.getContextPath() + "/kythuat/cong-viec/detail?id=" + maPhanAnh);
            } else {
                session.setAttribute("successMessage", "Đã nghiệm thu hoàn thành sự cố #" + maPhanAnh + " thành công!");
                response.sendRedirect(request.getContextPath() + "/kythuat/lich-su");
            }
        }
    }
}
