package dao;

import entity.BieuGiaDichVu;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

public class BieuGiaDichVuDAO {

    private static final Set<String> HOP_LE_LOAI_DICH_VU = Set.of(
            "Dien", "Nuoc", "PhiQuanLy", "GuiXeOTo", "GuiXeMay"
    );

    public List<BieuGiaDichVu> findAllSorted() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT b FROM BieuGiaDichVu b ORDER BY b.loaiDichVu ASC, b.hieuLucTu DESC, b.bacTu ASC", 
                BieuGiaDichVu.class
            ).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public BieuGiaDichVu findById(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(BieuGiaDichVu.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Xác định bộ ngày hiệu lực đang áp dụng hôm nay cho từng loại dịch vụ.
     * @return Map (loaiDichVu -> LocalDate max <= today)
     */
    public Map<String, LocalDate> findActiveHieuLucDates() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            List<Object[]> list = em.createQuery(
                "SELECT b.loaiDichVu, MAX(b.hieuLucTu) FROM BieuGiaDichVu b WHERE b.hieuLucTu <= :today GROUP BY b.loaiDichVu", 
                Object[].class
            ).setParameter("today", today).getResultList();

            Map<String, LocalDate> result = new HashMap<>();
            for (Object[] row : list) {
                result.put((String) row[0], (LocalDate) row[1]);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy danh sách các cảnh báo hở bậc (gap) cho JSP hiển thị banner vàng.
     */
    public List<String> checkTierGaps() {
        List<BieuGiaDichVu> all = findAllSorted();
        Map<String, Map<LocalDate, List<BieuGiaDichVu>>> grouped = new LinkedHashMap<>();

        for (BieuGiaDichVu b : all) {
            grouped.computeIfAbsent(b.getLoaiDichVu(), k -> new LinkedHashMap<>())
                   .computeIfAbsent(b.getHieuLucTu(), k -> new ArrayList<>())
                   .add(b);
        }

        List<String> warnings = new ArrayList<>();
        for (Map.Entry<String, Map<LocalDate, List<BieuGiaDichVu>>> entryLoai : grouped.entrySet()) {
            String loai = entryLoai.getKey();
            if ("PhiQuanLy".equals(loai) || "GuiXeOTo".equals(loai) || "GuiXeMay".equals(loai)) {
                continue;
            }

            for (Map.Entry<LocalDate, List<BieuGiaDichVu>> entryDate : entryLoai.getValue().entrySet()) {
                LocalDate date = entryDate.getKey();
                List<BieuGiaDichVu> tiers = entryDate.getValue();
                tiers.sort(Comparator.comparing(BieuGiaDichVu::getBacTu));

                if (!tiers.isEmpty()) {
                    if (tiers.get(0).getBacTu().compareTo(BigDecimal.ZERO) != 0) {
                        warnings.add("Cảnh báo hở bậc [" + loai + " - Hiệu lực " + date + "]: Bậc đầu tiên chưa bắt đầu từ 0 (đang là " + tiers.get(0).getBacTu() + ").");
                    }
                    for (int i = 0; i < tiers.size() - 1; i++) {
                        BigDecimal currDen = tiers.get(i).getBacDen();
                        BigDecimal nextTu = tiers.get(i + 1).getBacTu();
                        if (currDen == null) {
                            warnings.add("Cảnh báo hở bậc [" + loai + " - Hiệu lực " + date + "]: Bậc thứ " + (i + 1) + " đã để 'trở lên' (NULL) nhưng vẫn còn bậc phía sau.");
                        } else if (currDen.compareTo(nextTu) != 0) {
                            warnings.add("Cảnh báo hở bậc [" + loai + " - Hiệu lực " + date + "]: Khoảng giữa bậc " + currDen + " và " + nextTu + " bị hở.");
                        }
                    }
                }
            }
        }
        return warnings;
    }

    public String saveOrUpdate(BieuGiaDichVu bg) {
        if (bg == null) return "Dữ liệu biểu giá không hợp lệ.";

        // Validate 1: loaiDichVu
        if (bg.getLoaiDichVu() == null || !HOP_LE_LOAI_DICH_VU.contains(bg.getLoaiDichVu())) {
            return "Loại dịch vụ không hợp lệ. Phải thuộc: Điện, Nước, Phí quản lý, Gửi xe ô tô, Gửi xe máy.";
        }

        // Validate 2: donGia > 0, bacTu >= 0
        if (bg.getDonGia() == null || bg.getDonGia().compareTo(BigDecimal.ZERO) <= 0) {
            return "Đơn giá phải lớn hơn 0.";
        }
        if (bg.getBacTu() == null || bg.getBacTu().compareTo(BigDecimal.ZERO) < 0) {
            return "Bậc từ phải lớn hơn hoặc bằng 0.";
        }
        if (bg.getHieuLucTu() == null) {
            return "Ngày hiệu lực là bắt buộc.";
        }

        // Validate 3: bacDen > bacTu neu bacDen != null
        if (bg.getBacDen() != null && bg.getBacDen().compareTo(bg.getBacTu()) <= 0) {
            return "Bậc đến (" + bg.getBacDen() + ") phải lớn hơn Bậc từ (" + bg.getBacTu() + ").";
        }

        boolean isFlatService = Set.of("PhiQuanLy", "GuiXeOTo", "GuiXeMay").contains(bg.getLoaiDichVu());
        if (isFlatService) {
            if (bg.getBacTu().compareTo(BigDecimal.ZERO) != 0 || bg.getBacDen() != null) {
                return "Dịch vụ này chỉ cho phép 1 mức giá duy nhất (Bậc từ = 0, Bậc đến = NULL).";
            }
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Fetch existing records for same (loaiDichVu, hieuLucTu)
            List<BieuGiaDichVu> existingList = em.createQuery(
                "SELECT b FROM BieuGiaDichVu b WHERE b.loaiDichVu = :loai AND b.hieuLucTu = :date", 
                BieuGiaDichVu.class
            ).setParameter("loai", bg.getLoaiDichVu())
             .setParameter("date", bg.getHieuLucTu())
             .getResultList();

            for (BieuGiaDichVu ex : existingList) {
                if (bg.getId() != null && bg.getId().equals(ex.getId())) {
                    continue; // skip self when editing
                }

                if (isFlatService) {
                    tx.rollback();
                    return "Dịch vụ " + bg.getLoaiDichVu() + " ngày " + bg.getHieuLucTu() + " đã có biểu giá. Mỗi ngày hiệu lực chỉ được phép 1 dòng.";
                }

                // Check interval overlap: [bg.bacTu, bg.bacDen) vs [ex.bacTu, ex.bacDen)
                BigDecimal newTu = bg.getBacTu();
                BigDecimal newDen = bg.getBacDen();
                BigDecimal exTu = ex.getBacTu();
                BigDecimal exDen = ex.getBacDen();

                boolean overlap = (newDen == null || exTu.compareTo(newDen) < 0) &&
                                  (exDen == null || newTu.compareTo(exDen) < 0);

                if (overlap) {
                    tx.rollback();
                    String newRange = "[" + newTu + ", " + (newDen != null ? newDen : "trở lên") + ")";
                    String exRange = "[" + exTu + ", " + (exDen != null ? exDen : "trở lên") + ")";
                    return "Khoảng bậc " + newRange + " bị chồng lấn với bậc đã có " + exRange + ".";
                }
            }

            if (bg.getId() == null) {
                em.persist(bg);
            } else {
                em.merge(bg);
            }

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[BieuGiaDichVuDAO] saveOrUpdate FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String deleteBieuGia(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            BieuGiaDichVu bg = em.find(BieuGiaDichVu.class, id);
            if (bg == null) {
                tx.rollback();
                return "Không tìm thấy biểu giá mã #" + id;
            }

            // Kiểm tra xem có phải bộ giá đang áp dụng (hieuLucTu max <= today) không
            LocalDate today = LocalDate.now();
            List<LocalDate> maxActiveDateList = em.createQuery(
                "SELECT MAX(b.hieuLucTu) FROM BieuGiaDichVu b WHERE b.loaiDichVu = :loai AND b.hieuLucTu <= :today", 
                LocalDate.class
            ).setParameter("loai", bg.getLoaiDichVu())
             .setParameter("today", today)
             .getResultList();

            if (!maxActiveDateList.isEmpty() && bg.getHieuLucTu().equals(maxActiveDateList.get(0))) {
                tx.rollback();
                return "Không thể xóa bộ giá đang áp dụng. Hãy tạo bộ giá mới với ngày hiệu lực mới.";
            }

            em.remove(bg);
            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[BieuGiaDichVuDAO] deleteBieuGia FAILED: " + msg);
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
