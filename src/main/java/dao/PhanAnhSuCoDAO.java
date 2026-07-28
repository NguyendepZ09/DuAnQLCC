package dao;

import entity.LichSuXuLySuCo;
import entity.PhanAnhSuCo;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.Date;
import java.util.List;

/**
 * DAO quan ly phan anh su co va lich su xu ly su co cho Cu Dan va Ban Quan Ly
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
            if (pa.getMaCanHo() == null || !java.util.Objects.equals(pa.getMaCanHo(), maCanHo)) {
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
