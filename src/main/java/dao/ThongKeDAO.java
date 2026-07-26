package dao;

import util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO truy van du lieu dong bao cao thong ke tai chinh va hieu suat cho Dashboard BQL
 */
public class ThongKeDAO {

    public Map<String, Double> getTongDoanhThuByTrangThai() {
        Map<String, Double> resultMap = new HashMap<>();
        resultMap.put("Đã thanh toán", 0.0);
        resultMap.put("Chưa thanh toán", 0.0);

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT h.trangThaiThanhToan, SUM(h.tongTien) FROM HoaDon h GROUP BY h.trangThaiThanhToan";
            List<Object[]> list = em.createQuery(jpql, Object[].class).getResultList();
            for (Object[] row : list) {
                String status = (String) row[0];
                Number total = (Number) row[1];
                if (status != null && total != null) {
                    resultMap.put(status.trim(), total.doubleValue());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return resultMap;
    }

    public Map<String, Long> getThongKeSuCo() {
        Map<String, Long> resultMap = new HashMap<>();
        resultMap.put("Chờ tiếp nhận", 0L);
        resultMap.put("Đang xử lý", 0L);
        resultMap.put("Đã hoàn thành", 0L);

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p.trangThai, COUNT(p.id) FROM PhanAnhSuCo p GROUP BY p.trangThai";
            List<Object[]> list = em.createQuery(jpql, Object[].class).getResultList();
            for (Object[] row : list) {
                String status = (String) row[0];
                Number count = (Number) row[1];
                if (status != null && count != null) {
                    resultMap.put(status.trim(), count.longValue());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return resultMap;
    }

    public String getTopNhanVienXuatSac() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT n.hoTen, COUNT(l.id) FROM LichSuXuLySuCo l JOIN NhanVien n ON l.maNhanVien = n.id GROUP BY n.hoTen ORDER BY COUNT(l.id) DESC";
            List<Object[]> list = em.createQuery(jpql, Object[].class).setMaxResults(1).getResultList();
            if (!list.isEmpty()) {
                Object[] top = list.get(0);
                return top[0] + " (" + top[1] + " ca)";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return "Chưa có dữ liệu ca xử lý";
    }
}
