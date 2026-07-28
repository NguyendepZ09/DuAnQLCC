package servlet;

import dao.CuDanDAO;
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
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Servlet xu ly Phan Anh Su Co phia Cu Dan: Gui phan anh, xem danh sach, xem chi tiet, huy phan anh
 */
@WebServlet(urlPatterns = {"/cudan/phan-anh", "/cudan/phan-anh/detail", "/cudan/phan-anh/huy"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB
    maxFileSize = 5 * 1024 * 1024,          // 5 MB
    maxRequestSize = 10 * 1024 * 1024       // 10 MB
)
public class CuDanPhanAnhServlet extends HttpServlet {

    private PhanAnhSuCoDAO phanAnhSuCoDAO = new PhanAnhSuCoDAO();
    private CuDanDAO cuDanDAO = new CuDanDAO();

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png");

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
        String servletPath = request.getServletPath();

        // 1. XEM CHI TIET PHAN ANH
        if ("/cudan/phan-anh/detail".equals(servletPath)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    PhanAnhSuCo pa = phanAnhSuCoDAO.findById(id);
                    if (pa != null && java.util.Objects.equals(pa.getMaCanHo(), maCanHo)) {
                        List<LichSuXuLySuCo> lichSuList = phanAnhSuCoDAO.findLichSuByPhanAnhId(id);
                        String tenNhanVien = phanAnhSuCoDAO.findTenNhanVien(pa.getMaNhanVien());

                        request.setAttribute("phanAnh", pa);
                        request.setAttribute("lichSuList", lichSuList);
                        request.setAttribute("tenNhanVien", tenNhanVien);
                        request.setAttribute("activeMenu", "phan-anh");

                        request.getRequestDispatcher("/WEB-INF/views/cudan/phan-anh-chi-tiet.jsp").forward(request, response);
                        return;
                    } else {
                        session.setAttribute("errorMessage", "Phản ánh không tồn tại hoặc bạn không có quyền xem.");
                    }
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
            return;
        }

        // 2. XEM DANH SACH PHAN ANH CUA CAN HO
        int page = 1;
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<PhanAnhSuCo> danhSachPhanAnh = phanAnhSuCoDAO.findByCanHo(maCanHo, page, pageSize);
        long totalNotices = phanAnhSuCoDAO.countByCanHo(maCanHo);
        int totalPages = (int) Math.ceil((double) totalNotices / pageSize);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("danhSachPhanAnh", danhSachPhanAnh);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("activeMenu", "phan-anh");

        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }

        request.getRequestDispatcher("/WEB-INF/views/cudan/phan-anh.jsp").forward(request, response);
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

        // 1. HUY PHAN ANH
        if ("/cudan/phan-anh/huy".equals(servletPath)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    String err = phanAnhSuCoDAO.huyPhanAnh(id, maCanHo, maCuDan);
                    if (err == null) {
                        session.setAttribute("successMessage", "Đã hủy phản ánh sự cố thành công.");
                    } else {
                        session.setAttribute("errorMessage", err);
                    }
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Mã phản ánh không hợp lệ: " + e.getMessage());
                }
            }
            response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
            return;
        }

        // 2. GUI PHAN ANH MOI
        String tieuDe = request.getParameter("tieuDe");
        String moTa = request.getParameter("moTa");
        String loaiSuCo = request.getParameter("loaiSuCo");
        String mucDoUuTien = request.getParameter("mucDoUuTien");

        if (mucDoUuTien == null || mucDoUuTien.trim().isEmpty()) {
            mucDoUuTien = "TrungBinh";
        }

        // Validate bat buoc
        if (tieuDe == null || tieuDe.trim().isEmpty() || moTa == null || moTa.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tiêu đề và nội dung mô tả sự cố.");
            response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
            return;
        }

        // Validate enum loaiSuCo
        List<String> validLoai = Arrays.asList("Dien", "Nuoc", "ThangMay", "PCCC", "AnNinh", "VeSinh", "Khac");
        if (loaiSuCo == null || !validLoai.contains(loaiSuCo.trim())) {
            session.setAttribute("errorMessage", "Loại sự cố không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
            return;
        }

        // Validate enum mucDoUuTien
        List<String> validUuTien = Arrays.asList("Cao", "TrungBinh", "Thap");
        if (!validUuTien.contains(mucDoUuTien.trim())) {
            mucDoUuTien = "TrungBinh";
        }

        // Xu ly file upload anh (neu co)
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

                // Kiem tra Security: ext & MIME type
                if (!ALLOWED_EXTENSIONS.contains(ext) || contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    session.setAttribute("errorMessage", "File hình ảnh không hợp lệ! Chỉ chấp nhận định dạng .jpg, .jpeg, .png.");
                    response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
                    return;
                }

                // Tao thu muc va file duy nhat
                String uploadSubDir = "assets" + File.separator + "uploads" + File.separator + "suco";
                String realUploadPath = getServletContext().getRealPath("/") + uploadSubDir;

                File uploadDir = new File(realUploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String uniqueFileName = "suco_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 6) + ext;
                File savedFile = new File(uploadDir, uniqueFileName);
                filePart.write(savedFile.getAbsolutePath());

                // Luu duong dan tuong doi trong DB
                anhRelativePath = "assets/uploads/suco/" + uniqueFileName;

                // Đồng bộ file sang thư mục nguồn dự án nếu có
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
            System.err.println("Lỗi upload ảnh phản ánh: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi tải ảnh đính kèm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
            return;
        }

        // Tao entity va luu DB
        PhanAnhSuCo pa = new PhanAnhSuCo();
        pa.setMaCanHo(maCanHo);
        pa.setMaCuDan(maCuDan);
        pa.setTieuDe(tieuDe.trim());
        pa.setMoTa(moTa.trim());
        pa.setLoaiSuCo(loaiSuCo.trim());
        pa.setMucDoUuTien(mucDoUuTien.trim());
        pa.setAnhTruocXuLy(anhRelativePath);

        String err = phanAnhSuCoDAO.savePhanAnhVoiLichSu(pa);
        if (err == null) {
            session.setAttribute("successMessage", "Gửi phản ánh sự cố thành công! Ban Quản Lý sẽ sớm xử lý.");
        } else {
            session.setAttribute("errorMessage", "Lỗi DB: " + err);
        }

        response.sendRedirect(request.getContextPath() + "/cudan/phan-anh");
    }
}
