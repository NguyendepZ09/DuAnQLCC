package dao;

import util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO truy van du lieu dong bao cao thong ke tai chinh va hieu suat cho Dashboard BQL
 */
public class ThongKeDAO {

    public Map<String, Double> getTongDoanhThuByTrangThai() {
        Map<String, Double> resultMap = new HashMap<>();
        resultMap.put("ChuaThanhToan", 0.0);
        resultMap.put("DaThanhToan", 0.0);
        resultMap.put("QuaHan", 0.0);

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT h.trangThaiThanhToan, SUM(h.tongTien) FROM HoaDon h GROUP BY h.trangThaiThanhToan";
            List<Object[]> list = em.createQuery(jpql, Object[].class).getResultList();
            for (Object[] row : list) {
                String status = (String) row[0];
                Number total = (Number) row[1];
                double amt = total != null ? total.doubleValue() : 0.0;
                if (status == null || status.trim().isEmpty()) {
                    status = "ChuaThanhToan";
                } else {
                    status = status.trim();
                }
                resultMap.put(status, resultMap.getOrDefault(status, 0.0) + amt);
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
            long cho = 0, dang = 0, xong = 0;
            for (Object[] row : list) {
                String status = (String) row[0];
                Number count = (Number) row[1];
                if (status != null && count != null) {
                    String st = status.trim();
                    long val = count.longValue();
                    if ("MoiTiepNhan".equalsIgnoreCase(st) || "DaTiepNhan".equalsIgnoreCase(st) || "ChuaXuLy".equalsIgnoreCase(st)) {
                        cho += val;
                    } else if ("DangXuLy".equalsIgnoreCase(st)) {
                        dang += val;
                    } else if ("HoanThanh".equalsIgnoreCase(st) || "HoanTat".equalsIgnoreCase(st)) {
                        xong += val;
                    }
                }
            }
            resultMap.put("Chờ tiếp nhận", cho);
            resultMap.put("Đang xử lý", dang);
            resultMap.put("Đã hoàn thành", xong);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return resultMap;
    }

    public Map<String, Object> thongKeThuPhiTheoKy(int thang, int nam) {
        EntityManager em = JPAUtil.getEntityManager();
        Map<String, Object> result = new HashMap<>();
        try {
            String sqlPhaiThu = "SELECT SUM(tongTien) FROM dbo.hoaDon WHERE thang = :thang AND nam = :nam";
            Number numPhaiThu = (Number) em.createNativeQuery(sqlPhaiThu)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .getSingleResult();

            String sqlDaThu = "SELECT SUM(g.soTien) FROM dbo.giaoDichThanhToan g " +
                    "JOIN dbo.hoaDon h ON h.id = g.maHoaDon " +
                    "WHERE h.thang = :thang AND h.nam = :nam AND g.trangThai = 'ThanhCong'";
            Number numDaThu = (Number) em.createNativeQuery(sqlDaThu)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .getSingleResult();

            double tongPhaiThu = numPhaiThu != null ? numPhaiThu.doubleValue() : 0.0;
            double tongDaThu = numDaThu != null ? numDaThu.doubleValue() : 0.0;
            double tongConNo = Math.max(0.0, tongPhaiThu - tongDaThu);
            double tyLeDaThu = tongPhaiThu > 0 ? (tongDaThu / tongPhaiThu) * 100.0 : 0.0;

            result.put("thang", thang);
            result.put("nam", nam);
            result.put("tongPhaiThu", tongPhaiThu);
            result.put("tongDaThu", tongDaThu);
            result.put("tongConNo", tongConNo);
            result.put("tyLeDaThu", tyLeDaThu);
            result.put("tyLeDaThuFormatted", String.format("%.1f", tyLeDaThu));
            result.put("hasData", tongPhaiThu > 0);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("tongPhaiThu", 0.0);
            result.put("tongDaThu", 0.0);
            result.put("tongConNo", 0.0);
            result.put("tyLeDaThu", 0.0);
            result.put("tyLeDaThuFormatted", "0.0");
            result.put("hasData", false);
        } finally {
            em.close();
        }
        return result;
    }

    public List<Map<String, Object>> getDoanhThu6ThangGanNhat() {
        List<Map<String, Object>> list = new ArrayList<>();
        java.time.LocalDate now = java.time.LocalDate.now();
        for (int i = 5; i >= 0; i--) {
            java.time.LocalDate m = now.minusMonths(i);
            int thang = m.getMonthValue();
            int nam = m.getYear();
            Map<String, Object> stats = thongKeThuPhiTheoKy(thang, nam);
            stats.put("label", "T" + thang + "/" + nam);
            list.add(stats);
        }
        return list;
    }

    public Map<String, Long> getThongKeSuCoDetailed() {
        Map<String, Long> resultMap = new LinkedHashMap<>();
        resultMap.put("MoiTiepNhan", 0L);
        resultMap.put("DangXuLy", 0L);
        resultMap.put("HoanThanh", 0L);
        resultMap.put("DaHuy", 0L);

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p.trangThai, COUNT(p.id) FROM PhanAnhSuCo p GROUP BY p.trangThai";
            List<Object[]> list = em.createQuery(jpql, Object[].class).getResultList();
            for (Object[] row : list) {
                String status = (String) row[0];
                Number count = (Number) row[1];
                if (status != null && count != null) {
                    String st = status.trim();
                    long val = count.longValue();
                    if ("MoiTiepNhan".equalsIgnoreCase(st) || "DaTiepNhan".equalsIgnoreCase(st) || "ChuaXuLy".equalsIgnoreCase(st)) {
                        resultMap.put("MoiTiepNhan", resultMap.get("MoiTiepNhan") + val);
                    } else if ("DangXuLy".equalsIgnoreCase(st)) {
                        resultMap.put("DangXuLy", resultMap.get("DangXuLy") + val);
                    } else if ("HoanThanh".equalsIgnoreCase(st) || "HoanTat".equalsIgnoreCase(st)) {
                        resultMap.put("HoanThanh", resultMap.get("HoanThanh") + val);
                    } else if ("DaHuy".equalsIgnoreCase(st) || "Huy".equalsIgnoreCase(st)) {
                        resultMap.put("DaHuy", resultMap.get("DaHuy") + val);
                    }
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
            String jpql = "SELECT n.hoTen, COUNT(l.id) FROM LichSuXuLySuCo l, NhanVien n WHERE l.maNhanVien = n.id GROUP BY n.id, n.hoTen ORDER BY COUNT(l.id) DESC";
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
