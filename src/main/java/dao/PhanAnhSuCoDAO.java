package dao;

import entity.CanHo;
import entity.LichSuXuLySuCo;
import entity.PhanAnhSuCo;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * DAO quan ly phan anh su co va lich su xu ly su co cho Cu Dan, Le Tan va Ban Quan Ly
 */
public class PhanAnhSuCoDAO {

    /**
     * Gui phan anh su co moi (Luu phanAnhSuCo + 1 dong lichSuXuLySuCo 'MoiTiepNhan' trong 1 Transaction)
     */
    public String savePhanAnhVoiLichSu(PhanAnhSuCo pa) {
        if (pa == null || pa.getMaCanHo() == null) {
            return "Thiếu thông tin căn hộ gửi phản ánh.";
        }
        if (pa.getTieuDe() == null || pa.getTieuDe().trim().isEmpty()) {
            return "Vui lòng nhập tiêu đề phản ánh.";
        }
        if (pa.getMoTa() == null || pa.getMoTa().trim().isEmpty()) {
            return "Vui lòng nhập nội dung mô tả sự cố.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            pa.setTrangThai("MoiTiepNhan");
            pa.setNguonGui("CuDan");
            pa.setNgayGui(new Date());
            pa.setMaNhanVien(null);
            pa.setNgayHoanThanh(null);

            em.persist(pa);
            em.flush(); // Lấy ID vừa tự sinh

            LichSuXuLySuCo ls = new LichSuXuLySuCo();
            ls.setMaPhanAnh(pa.getId());
            ls.setTrangThai("MoiTiepNhan");
            ls.setGhiChu("Cư dân gửi phản ánh");
            ls.setThoiGian(new Date());
            ls.setMaNhanVien(null);

            em.persist(ls);

            tx.commit();
            return null; // Thành công
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] savePhanAnhVoiLichSu FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Lễ tân tạo phản ánh hộ cư dân (NguonGui='LeTan', maCuDan=NULL, trangThai='DaTiepNhan')
     */
    public String taoPhanAnhHoCuDan(PhanAnhSuCo pa, int maNhanVienLeTan, String tenLeTan) {
        if (pa == null || pa.getMaCanHo() == null) {
            return "Vui lòng chọn căn hộ báo sự cố.";
        }
        if (pa.getTieuDe() == null || pa.getTieuDe().trim().isEmpty()) {
            return "Vui lòng nhập tiêu đề phản ánh.";
        }
        if (pa.getMoTa() == null || pa.getMoTa().trim().isEmpty()) {
            return "Vui lòng nhập nội dung mô tả sự cố.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            pa.setNguonGui("LeTan");
            pa.setMaCuDan(null);
            pa.setTrangThai("DaTiepNhan"); // Đã tiếp nhận ngay vì Lễ tân nhập trực tiếp
            pa.setNgayGui(new Date());
            pa.setMaNhanVien(null);
            pa.setNgayHoanThanh(null);

            em.persist(pa);
            em.flush();

            LichSuXuLySuCo ls = new LichSuXuLySuCo();
            ls.setMaPhanAnh(pa.getId());
            ls.setTrangThai("DaTiepNhan");
            ls.setGhiChu("Lễ tân " + (tenLeTan != null ? tenLeTan : "") + " ghi nhận sự cố hộ cư dân");
            ls.setThoiGian(new Date());
            ls.setMaNhanVien(maNhanVienLeTan);

            em.persist(ls);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] taoPhanAnhHoCuDan FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Lễ tân Tiếp nhận phản ánh (MoiTiepNhan -> DaTiepNhan)
     */
    public String tiepNhanPhanAnh(int maPhanAnh, int maNhanVienLeTan, String tenLeTan) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            PhanAnhSuCo pa = em.find(PhanAnhSuCo.class, maPhanAnh);
            if (pa == null) {
                return "Phản ánh không tồn tại.";
            }

            if (!"MoiTiepNhan".equalsIgnoreCase(pa.getTrangThai())) {
                return "Phản ánh này đã được tiếp nhận hoặc xử lý trước đó.";
            }

            pa.setTrangThai("DaTiepNhan");

            LichSuXuLySuCo ls = new LichSuXuLySuCo();
            ls.setMaPhanAnh(maPhanAnh);
            ls.setTrangThai("DaTiepNhan");
            ls.setGhiChu("Lễ tân " + (tenLeTan != null ? tenLeTan : "") + " tiếp nhận phản ánh");
            ls.setThoiGian(new Date());
            ls.setMaNhanVien(maNhanVienLeTan);

            em.persist(ls);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] tiepNhanPhanAnh FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Lễ tân Giao việc cho Nhân viên (Gọi Stored Procedure sp_GiaoViecSuCo)
     */
    public String giaoViecSuCo(int maPhanAnh, int maNhanVienGiao, String mucDoUuTien) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            PhanAnhSuCo pa = em.find(PhanAnhSuCo.class, maPhanAnh);
            if (pa == null) {
                return "Phản ánh không tồn tại.";
            }

            if ("HoanThanh".equalsIgnoreCase(pa.getTrangThai()) || "Huy".equalsIgnoreCase(pa.getTrangThai())) {
                return "Phản ánh đã hoàn thành hoặc đã hủy, không thể giao việc.";
            }

            StoredProcedureQuery query = em.createStoredProcedureQuery("sp_GiaoViecSuCo");
            query.registerStoredProcedureParameter("maPhanAnh", Integer.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("maNhanVien", Integer.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("mucDoUuTien", String.class, ParameterMode.IN);

            query.setParameter("maPhanAnh", maPhanAnh);
            query.setParameter("maNhanVien", maNhanVienGiao);
            query.setParameter("mucDoUuTien", (mucDoUuTien != null && !mucDoUuTien.isBlank()) ? mucDoUuTien : "TrungBinh");

            query.execute();

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] giaoViecSuCo FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Lễ tân Hủy phản ánh kèm lý do
     */
    public String huyPhanAnhBoiLeTan(int maPhanAnh, int maNhanVienLeTan, String lyDoHuy) {
        if (lyDoHuy == null || lyDoHuy.trim().isEmpty()) {
            return "Vui lòng nhập lý do hủy phản ánh.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            PhanAnhSuCo pa = em.find(PhanAnhSuCo.class, maPhanAnh);
            if (pa == null) {
                return "Phản ánh không tồn tại.";
            }

            if ("HoanThanh".equalsIgnoreCase(pa.getTrangThai())) {
                return "Phản ánh đã hoàn thành, không thể hủy.";
            }

            pa.setTrangThai("Huy");

            LichSuXuLySuCo ls = new LichSuXuLySuCo();
            ls.setMaPhanAnh(maPhanAnh);
            ls.setTrangThai("Huy");
            ls.setGhiChu("Lễ tân hủy phản ánh: " + lyDoHuy.trim());
            ls.setThoiGian(new Date());
            ls.setMaNhanVien(maNhanVienLeTan);

            em.persist(ls);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] huyPhanAnhBoiLeTan FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Helper build chuoi WHERE dong va Map tham so cho ca findAllForLeTan va countForLeTan (tranh sai lech)
     */
    private String buildWhereClauseForLeTan(String trangThai, String loaiSuCo, String mucDoUuTien, Date tuNgay, Date denNgay, Map<String, Object> params) {
        StringBuilder where = new StringBuilder(" WHERE 1=1 ");

        if (trangThai != null && !trangThai.isBlank() && !"ALL".equalsIgnoreCase(trangThai.trim())) {
            where.append("AND p.trangThai = :trangThai ");
            params.put("trangThai", trangThai.trim());
        }
        if (loaiSuCo != null && !loaiSuCo.isBlank() && !"ALL".equalsIgnoreCase(loaiSuCo.trim())) {
            where.append("AND p.loaiSuCo = :loaiSuCo ");
            params.put("loaiSuCo", loaiSuCo.trim());
        }
        if (mucDoUuTien != null && !mucDoUuTien.isBlank() && !"ALL".equalsIgnoreCase(mucDoUuTien.trim())) {
            where.append("AND p.mucDoUuTien = :mucDoUuTien ");
            params.put("mucDoUuTien", mucDoUuTien.trim());
        }
        if (tuNgay != null) {
            where.append("AND p.ngayGui >= :tuNgay ");
            params.put("tuNgay", tuNgay);
        }
        if (denNgay != null) {
            where.append("AND p.ngayGui <= :denNgay ");
            params.put("denNgay", denNgay);
        }
        return where.toString();
    }

    /**
     * Lấy danh sách phản ánh toàn tòa nhà dành cho Lễ tân (có bộ lọc, sắp xếp ưu tiên Cao trước, ngayGui cũ nhất trước)
     */
    public List<Map<String, Object>> findAllForLeTan(String trangThai, String loaiSuCo, String mucDoUuTien, Date tuNgay, Date denNgay, int page, int pageSize) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Map<String, Object> params = new HashMap<>();
            String whereClause = buildWhereClauseForLeTan(trangThai, loaiSuCo, mucDoUuTien, tuNgay, denNgay, params);

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT p.id, p.tieuDe, p.loaiSuCo, p.mucDoUuTien, p.trangThai, p.ngayGui, p.ngayHoanThanh, p.nguonGui, p.moTa, p.anhTruocXuLy, p.anhSauXuLy, ");
            sql.append("c.id AS maCanHoCode, c.soPhong, nv.hoTen AS tenNhanVien, cd.hoTen AS tenCuDan, cd.soDienThoai AS sdtCuDan, p.maNhanVien, p.maCanHo AS maCanHoId ");
            sql.append("FROM phanAnhSuCo p ");
            sql.append("LEFT JOIN canHo c ON p.maCanHo = c.id ");
            sql.append("LEFT JOIN nhanVien nv ON p.maNhanVien = nv.id ");
            sql.append("LEFT JOIN cuDan cd ON p.maCuDan = cd.id ");
            sql.append(whereClause);
            sql.append("ORDER BY CASE WHEN p.mucDoUuTien = 'Cao' THEN 1 WHEN p.mucDoUuTien = 'TrungBinh' THEN 2 ELSE 3 END ASC, p.ngayGui ASC, p.id DESC ");

            System.out.println("[PhanAnhSuCoDAO] findAllForLeTan SQL: " + sql + " | Params: " + params);

            var query = em.createNativeQuery(sql.toString());
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }

            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);

            List<Object[]> rawList = query.getResultList();
            List<Map<String, Object>> result = new ArrayList<>();
            Date now = new Date();

            for (Object[] r : rawList) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", r[0]);
                map.put("tieuDe", r[1]);
                map.put("loaiSuCo", r[2]);
                map.put("mucDoUuTien", r[3]);
                map.put("trangThai", r[4]);
                Date ngayGui = (Date) r[5];
                map.put("ngayGui", ngayGui);
                map.put("ngayHoanThanh", r[6]);
                map.put("nguonGui", r[7]);
                map.put("moTa", r[8]);
                map.put("anhTruocXuLy", r[9]);
                map.put("anhSauXuLy", r[10]);
                map.put("maCanHoCode", r[11]);
                map.put("soPhong", r[12]);
                map.put("tenNhanVien", r[13]);
                map.put("tenCuDan", r[14]);
                map.put("sdtCuDan", r[15]);
                map.put("maNhanVien", r[16]);
                map.put("maCanHoId", r[17]);

                long soNgayTroiQua = 0;
                if (ngayGui != null && !"HoanThanh".equalsIgnoreCase((String) r[4]) && !"Huy".equalsIgnoreCase((String) r[4])) {
                    long diffMs = now.getTime() - ngayGui.getTime();
                    soNgayTroiQua = diffMs / (24 * 3600 * 1000L);
                }
                map.put("soNgayTroiQua", soNgayTroiQua);

                result.add(map);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public long countForLeTan(String trangThai, String loaiSuCo, String mucDoUuTien, Date tuNgay, Date denNgay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Map<String, Object> params = new HashMap<>();
            String whereClause = buildWhereClauseForLeTan(trangThai, loaiSuCo, mucDoUuTien, tuNgay, denNgay, params);
            String sql = "SELECT COUNT(*) FROM phanAnhSuCo p " + whereClause;

            System.out.println("[PhanAnhSuCoDAO] countForLeTan SQL: " + sql + " | Params: " + params);

            var query = em.createNativeQuery(sql);
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }

            return ((Number) query.getSingleResult()).longValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách tất cả nhân viên vận hành (để đổ vào dropdown giao việc)
     */
    public List<Map<String, Object>> findAllNhanVienWithDepartment() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Object[]> list = em.createNativeQuery("SELECT id, hoTen, boPhan FROM nhanVien ORDER BY boPhan ASC, hoTen ASC").getResultList();
            List<Map<String, Object>> result = new ArrayList<>();
            for (Object[] r : list) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", r[0]);
                map.put("hoTen", r[1]);
                map.put("boPhan", r[2]);
                result.add(map);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách căn hộ đang ở (để Lễ tân chọn khi ghi nhận sự cố hộ cư dân)
     */
    public List<CanHo> findAllCanHoDangO() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM CanHo c WHERE c.trangThai = N'DangO' ORDER BY c.soPhong ASC", CanHo.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách phản ánh theo căn hộ có phân trang
     */
    public List<PhanAnhSuCo> findByCanHo(int maCanHo, int page, int pageSize) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            int firstResult = (page - 1) * pageSize;
            return em.createQuery("SELECT p FROM PhanAnhSuCo p WHERE p.maCanHo = :maCanHo ORDER BY p.id DESC", PhanAnhSuCo.class)
                    .setParameter("maCanHo", maCanHo)
                    .setFirstResult(firstResult)
                    .setMaxResults(pageSize)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    /**
     * Đếm tổng số phản ánh của 1 căn hộ
     */
    public long countByCanHo(int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM PhanAnhSuCo p WHERE p.maCanHo = :maCanHo", Long.class)
                    .setParameter("maCanHo", maCanHo)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy chi tiết phản ánh theo ID
     */
    public PhanAnhSuCo findById(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(PhanAnhSuCo.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy lịch sử xử lý của 1 phản ánh (sắp xếp theo thời gian tăng dần)
     */
    public List<LichSuXuLySuCo> findLichSuByPhanAnhId(int maPhanAnh) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT ls FROM LichSuXuLySuCo ls WHERE ls.maPhanAnh = :maPhanAnh ORDER BY ls.thoiGian ASC, ls.id ASC", LichSuXuLySuCo.class)
                    .setParameter("maPhanAnh", maPhanAnh)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy họ tên nhân viên phụ trách/xử lý
     */
    public String findTenNhanVien(Integer maNhanVien) {
        if (maNhanVien == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<String> list = em.createNativeQuery("SELECT hoTen FROM nhanVien WHERE id = ?")
                    .setParameter(1, maNhanVien)
                    .getResultList();
            if (!list.isEmpty()) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Cư dân hủy phản ánh sự cố (Chỉ cho phép khi ở trạng thái 'MoiTiepNhan')
     */
    public String huyPhanAnh(int maPhanAnh, int maCanHo, Integer maCuDan) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            PhanAnhSuCo pa = em.find(PhanAnhSuCo.class, maPhanAnh);
            if (pa == null) {
                return "Phản ánh không tồn tại.";
            }

            // Kiem tra quyen theo maCanHo (an toan voi null, ho tro maCuDan = null do Le Tan/Bao Ve tao)
            if (pa.getMaCanHo() == null || !Objects.equals(pa.getMaCanHo(), maCanHo)) {
                return "Bạn không có quyền hủy phản ánh của căn hộ khác.";
            }

            if (!"MoiTiepNhan".equalsIgnoreCase(pa.getTrangThai())) {
                return "Phản ánh đã được tiếp nhận hoặc đang xử lý, không thể hủy.";
            }

            pa.setTrangThai("Huy");

            LichSuXuLySuCo ls = new LichSuXuLySuCo();
            ls.setMaPhanAnh(maPhanAnh);
            ls.setTrangThai("Huy");
            ls.setGhiChu("Cư dân hủy phản ánh");
            ls.setThoiGian(new Date());
            ls.setMaNhanVien(null);

            em.persist(ls);

            tx.commit();
            return null; // Thành công
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[PhanAnhSuCoDAO] huyPhanAnh FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    private String extractRootMessage(Throwable e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        String msg = cause.getMessage();
        if (msg == null || msg.isBlank()) msg = e.getMessage();
        if (msg == null) msg = e.getClass().getSimpleName();
        return msg.length() > 500 ? msg.substring(0, 500) + "..." : msg;
    }
}
