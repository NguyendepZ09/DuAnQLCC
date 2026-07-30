package servlet;

import dao.PhanAnhSuCoDAO;
import entity.CanHo;
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
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Servlet nghiep vu Le Tan: Tiep nhan, Giao viec, Huy phan anh, Ghi nhan ho va xem chi tiet su co
 */
@WebServlet(urlPatterns = {
    "/letan/su-co",
    "/letan/su-co/tiep-nhan",
    "/letan/su-co/giao-viec",
    "/letan/su-co/huy",
    "/letan/su-co/create-ho",
    "/letan/su-co/detail"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB
    maxFileSize = 5 * 1024 * 1024,          // 5 MB
    maxRequestSize = 10 * 1024 * 1024       // 10 MB
)
public class LeTanSuCoServlet extends HttpServlet {

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
        if (!"NV".equalsIgnoreCase(vaiTro) || !"LeTan".equalsIgnoreCase(boPhanCode)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        String servletPath = request.getServletPath();

        // 1. XEM CHI TIET PHAN ANH
        if ("/letan/su-co/detail".equals(servletPath)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    PhanAnhSuCo pa = phanAnhSuCoDAO.findById(id);
                    if (pa != null) {
                        List<LichSuXuLySuCo> lichSuList = phanAnhSuCoDAO.findLichSuByPhanAnhId(id);
                        String tenNhanVien = phanAnhSuCoDAO.findTenNhanVien(pa.getMaNhanVien());
                        List<Map<String, Object>> dsNhanVien = phanAnhSuCoDAO.findAllNhanVienWithDepartment();

                        // Lay thong tin can ho va cu dan (neu co)
                        List<Map<String, Object>> list = phanAnhSuCoDAO.findAllForLeTan(null, null, null, null, null, 1, 100);
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
                        request.setAttribute("dsNhanVien", dsNhanVien);
                        request.setAttribute("activeMenu", "su-co");

                        request.getRequestDispatcher("/WEB-INF/views/letan/su-co-chi-tiet.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/letan/su-co");
            return;
        }

        // 2. MAN HINH CHINH TIEP NHAN & DIEU PHOI SU CO
        String trangThaiFilter = request.getParameter("trangThai");
        String loaiSuCoFilter = request.getParameter("loaiSuCo");
        String mucDoUuTienFilter = request.getParameter("mucDoUuTien");
        String tuNgayStr = request.getParameter("tuNgay");
        String denNgayStr = request.getParameter("denNgay");

        Date tuNgay = null;
        Date denNgay = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if (tuNgayStr != null && !tuNgayStr.isBlank()) {
                tuNgay = sdf.parse(tuNgayStr.trim());
            }
            if (denNgayStr != null && !denNgayStr.isBlank()) {
                Date parsedDenNgay = sdf.parse(denNgayStr.trim());
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(parsedDenNgay);
                cal.set(java.util.Calendar.HOUR_OF_DAY, 23);
                cal.set(java.util.Calendar.MINUTE, 59);
                cal.set(java.util.Calendar.SECOND, 59);
                cal.set(java.util.Calendar.MILLISECOND, 999);
                denNgay = cal.getTime();
            }
        } catch (Exception ignored) {}

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<Map<String, Object>> dsPhanAnh = phanAnhSuCoDAO.findAllForLeTan(trangThaiFilter, loaiSuCoFilter, mucDoUuTienFilter, tuNgay, denNgay, page, pageSize);
        long totalItems = phanAnhSuCoDAO.countForLeTan(trangThaiFilter, loaiSuCoFilter, mucDoUuTienFilter, tuNgay, denNgay);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        List<Map<String, Object>> dsNhanVien = phanAnhSuCoDAO.findAllNhanVienWithDepartment();
        List<CanHo> dsCanHoDangO = phanAnhSuCoDAO.findAllCanHoDangO();

        request.setAttribute("dsPhanAnh", dsPhanAnh);
        request.setAttribute("dsNhanVien", dsNhanVien);
        request.setAttribute("dsCanHoDangO", dsCanHoDangO);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("trangThaiFilter", trangThaiFilter != null ? trangThaiFilter : "ALL");
        request.setAttribute("loaiSuCoFilter", loaiSuCoFilter != null ? loaiSuCoFilter : "ALL");
        request.setAttribute("mucDoUuTienFilter", mucDoUuTienFilter != null ? mucDoUuTienFilter : "ALL");
        request.setAttribute("tuNgayFilter", tuNgayStr != null ? tuNgayStr : "");
        request.setAttribute("denNgayFilter", denNgayStr != null ? denNgayStr : "");
        request.setAttribute("activeMenu", "su-co");

        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/letan/su-co.jsp").forward(request, response);
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
        Integer maNhanVien = (Integer) session.getAttribute("maNhanVien");
        String tenLeTan = (String) session.getAttribute("hoTen");

        if (!"NV".equalsIgnoreCase(vaiTro) || !"LeTan".equalsIgnoreCase(boPhanCode) || maNhanVien == null) {
            session.setAttribute("errorMessage", "Tài khoản của bạn chưa được xác thực hồ sơ Lễ tân.");
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String servletPath = request.getServletPath();
        String requestedTrangThai = request.getParameter("trangThai");

        // RÀNG BUỘC CHẶN CỨNG BACKEND: LỄ TÂN KHÔNG ĐƯỢC CHUYỂN TRẠNG THÁI HOÀN THÀNH
        if ("HoanThanh".equalsIgnoreCase(requestedTrangThai)) {
            session.setAttribute("errorMessage", "Lễ tân không có quyền chuyển trạng thái Hoàn thành. Việc này do bộ phận Kỹ thuật xử lý.");
            response.sendRedirect(request.getContextPath() + "/letan/su-co");
            return;
        }

        // 1. TIEP NHAN PHAN ANH (MoiTiepNhan -> DaTiepNhan)
        if ("/letan/su-co/tiep-nhan".equals(servletPath)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    String err = phanAnhSuCoDAO.tiepNhanPhanAnh(id, maNhanVien, tenLeTan);
                    if (err == null) {
                        session.setAttribute("successMessage", "Đã tiếp nhận phản ánh sự cố #" + id + " thành công!");
                    } else {
                        session.setAttribute("errorMessage", err);
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Mã phản ánh không hợp lệ: " + e.getMessage());
                }
            }
            response.sendRedirect(request.getContextPath() + "/letan/su-co");
            return;
        }

        // 2. GIAO VIEC CHO NHAN VIEN (Goi sp_GiaoViecSuCo)
        if ("/letan/su-co/giao-viec".equals(servletPath)) {
            String idStr = request.getParameter("id");
            String maNhanVienGiaoStr = request.getParameter("maNhanVienGiao");
            String mucDoUuTien = request.getParameter("mucDoUuTien");

            if (idStr != null && maNhanVienGiaoStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    int maNhanVienGiao = Integer.parseInt(maNhanVienGiaoStr.trim());
                    String err = phanAnhSuCoDAO.giaoViecSuCo(id, maNhanVienGiao, mucDoUuTien);
                    if (err == null) {
                        session.setAttribute("successMessage", "Đã giao việc xử lý sự cố #" + id + " cho nhân viên thành công!");
                    } else {
                        session.setAttribute("errorMessage", err);
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Mã nhân viên hoặc sự cố không hợp lệ: " + e.getMessage());
                }
            } else {
                session.setAttribute("errorMessage", "Vui lòng chọn nhân viên để giao việc.");
            }
            response.sendRedirect(request.getContextPath() + "/letan/su-co");
            return;
        }

        // 3. HUY PHAN ANH BOI LE TAN (Kem ly do bat buoc)
        if ("/letan/su-co/huy".equals(servletPath)) {
            String idStr = request.getParameter("id");
            String lyDoHuy = request.getParameter("lyDoHuy");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    String err = phanAnhSuCoDAO.huyPhanAnhBoiLeTan(id, maNhanVien, lyDoHuy);
                    if (err == null) {
                        session.setAttribute("successMessage", "Đã hủy phản ánh sự cố #" + id + " thành công!");
                    } else {
                        session.setAttribute("errorMessage", err);
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Lỗi hủy phản ánh: " + e.getMessage());
                }
            }
            response.sendRedirect(request.getContextPath() + "/letan/su-co");
            return;
        }

        // 4. LE TAN GHI NHAN SU CO HO CU DAN
        if ("/letan/su-co/create-ho".equals(servletPath)) {
            String maCanHoStr = request.getParameter("maCanHo");
            String tieuDe = request.getParameter("tieuDe");
            String moTa = request.getParameter("moTa");
            String loaiSuCo = request.getParameter("loaiSuCo");
            String mucDoUuTien = request.getParameter("mucDoUuTien");

            if (maCanHoStr == null || tieuDe == null || tieuDe.trim().isEmpty() || moTa == null || moTa.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn căn hộ và nhập đầy đủ tiêu đề, mô tả sự cố.");
                response.sendRedirect(request.getContextPath() + "/letan/su-co");
                return;
            }

            Integer maCanHo = null;
            try {
                maCanHo = Integer.parseInt(maCanHoStr.trim());
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Căn hộ không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/letan/su-co");
                return;
            }

            // Upload anh (neu co)
            String anhRelativePath = null;
            try {
                Part filePart = request.getPart("anhTruocXuLy");
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dotIndex = submittedFileName.lastIndexOf('.');
                    if (dotIndex >= 0) {
                        ext = submittedFileName.substring(dotIndex).toLowerCase();
                    }

                    String contentType = filePart.getContentType();
                    if (!ALLOWED_EXTENSIONS.contains(ext) || contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                        session.setAttribute("errorMessage", "File hình ảnh không hợp lệ! Chỉ chấp nhận .jpg, .jpeg, .png.");
                        response.sendRedirect(request.getContextPath() + "/letan/su-co");
                        return;
                    }

                    String uploadSubDir = "assets" + File.separator + "uploads" + File.separator + "suco";
                    String realUploadPath = getServletContext().getRealPath("/") + uploadSubDir;

                    File uploadDir = new File(realUploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String uniqueFileName = "suco_letan_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 6) + ext;
                    File savedFile = new File(uploadDir, uniqueFileName);
                    filePart.write(savedFile.getAbsolutePath());

                    anhRelativePath = "assets/uploads/suco/" + uniqueFileName;

                    try {
                        String sourcePath = "src" + File.separator + "main" + File.separator + "webapp" + File.separator + uploadSubDir;
                        File sourceDir = new File(sourcePath);
                        if (sourceDir.exists()) {
                            File destSourceFile = new File(sourceDir, uniqueFileName);
                            java.nio.file.Files.copy(savedFile.toPath(), destSourceFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                        }
                    } catch (Exception ignored) {}
                }
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Lỗi tải ảnh đính kèm: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/letan/su-co");
                return;
            }

            PhanAnhSuCo pa = new PhanAnhSuCo();
            pa.setMaCanHo(maCanHo);
            pa.setTieuDe(tieuDe.trim());
            pa.setMoTa(moTa.trim());
            pa.setLoaiSuCo(loaiSuCo != null ? loaiSuCo.trim() : "Khac");
            pa.setMucDoUuTien(mucDoUuTien != null ? mucDoUuTien.trim() : "TrungBinh");
            pa.setAnhTruocXuLy(anhRelativePath);

            String err = phanAnhSuCoDAO.taoPhanAnhHoCuDan(pa, maNhanVien, tenLeTan);
            if (err == null) {
                session.setAttribute("successMessage", "Đã ghi nhận sự cố hộ cư dân thành công!");
            } else {
                session.setAttribute("errorMessage", "Lỗi DB: " + err);
            }

            response.sendRedirect(request.getContextPath() + "/letan/su-co");
        }
    }
}
