package dao;

import entity.CanHo;
import entity.CuDan;
import entity.HoaDon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.*;

/**
 * DAO truy van sơ đồ 200 căn hộ va chi tiet can ho + cu dan + hoa don
 */
public class CanHoDAO {

    public List<CanHo> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM CanHo c ORDER BY c.soTang DESC, c.soPhong ASC", CanHo.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public Map<Integer, List<CanHo>> findAllMappedByTang() {
        Map<Integer, List<CanHo>> mapTang = new LinkedHashMap<>();
        
        for (int t = 25; t >= 1; t--) {
            mapTang.put(t, new ArrayList<>());
        }

        List<CanHo> list = findAll();
        for (CanHo ch : list) {
            int t = ch.getSoTang() != null ? ch.getSoTang() : 1;
            mapTang.computeIfAbsent(t, k -> new ArrayList<>()).add(ch);
        }

        return mapTang;
    }

    public Map<Integer, String> getTinhTrangMap() {
        EntityManager em = JPAUtil.getEntityManager();
        Map<Integer, String> map = new HashMap<>();
        try {
            String sql = "SELECT c.id, c.trangThai, " +
                    "       SUM(CASE WHEN cd.trangThai = 'DangO' AND cd.loaiCuDan = 'ChuHo' THEN 1 ELSE 0 END) AS countChuHo, " +
                    "       SUM(CASE WHEN cd.trangThai = 'DangO' AND cd.loaiCuDan = 'KhachThue' THEN 1 ELSE 0 END) AS countKhachThue " +
                    "FROM dbo.canHo c " +
                    "LEFT JOIN dbo.cuDan cd ON cd.maCanHo = c.id " +
                    "GROUP BY c.id, c.trangThai";

            @SuppressWarnings("unchecked")
            List<Object[]> list = em.createNativeQuery(sql).getResultList();
            for (Object[] r : list) {
                int id = ((Number) r[0]).intValue();
                String ttCanHo = (String) r[1];
                int countChuHo = r[2] != null ? ((Number) r[2]).intValue() : 0;
                int countKhachThue = r[3] != null ? ((Number) r[3]).intValue() : 0;

                String tinhTrang;
                if ("BaoTri".equalsIgnoreCase(ttCanHo)) {
                    tinhTrang = "BaoTri";
                } else if (countKhachThue > 0) {
                    tinhTrang = "KhachThueO";
                } else if (countChuHo > 0) {
                    tinhTrang = "ChuHoO";
                } else {
                    tinhTrang = "Trong";
                }
                map.put(id, tinhTrang);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return map;
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> findDetailById(Integer canHoId) {
        Map<String, Object> result = new HashMap<>();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            CanHo ch = em.find(CanHo.class, canHoId);
            if (ch == null) return result;

            result.put("canHo", ch);

            // Fetch ALL active residents ('DangO'), ordered so ChuHo comes first
            List<CuDan> dsCuDan = em.createQuery(
                "SELECT c FROM CuDan c WHERE c.maCanHo = :mch AND c.trangThai = 'DangO' " +
                "ORDER BY CASE WHEN c.loaiCuDan = 'ChuHo' THEN 0 ELSE 1 END, c.id ASC", 
                CuDan.class
            ).setParameter("mch", canHoId).getResultList();

            result.put("dsCuDan", dsCuDan);
            result.put("cuDan", !dsCuDan.isEmpty() ? dsCuDan.get(0) : null);

            try {
                HoaDon hd = em.createQuery("SELECT h FROM HoaDon h WHERE h.maCanHo = :mch ORDER BY h.id DESC", HoaDon.class)
                              .setParameter("mch", canHoId)
                              .setMaxResults(1)
                              .getSingleResult();
                result.put("hoaDon", hd);
            } catch (NoResultException e) {
                result.put("hoaDon", null);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return result;
    }

    public Map<String, Object> traCuuCanHoChoBaoVe(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return null;

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String kw = keyword.trim().toUpperCase();

            // Search by exact room number or LIKE
            String sqlCanHo = "SELECT c.id, c.soPhong, c.soTang, c.dienTich, c.trangThai " +
                    "FROM dbo.canHo c " +
                    "WHERE UPPER(c.soPhong) = :kw OR UPPER(c.soPhong) = :kwP OR UPPER(c.soPhong) LIKE :kwLike";

            @SuppressWarnings("unchecked")
            List<Object[]> list = em.createNativeQuery(sqlCanHo)
                    .setParameter("kw", kw)
                    .setParameter("kwP", "P" + kw)
                    .setParameter("kwLike", "%" + kw + "%")
                    .setMaxResults(1)
                    .getResultList();

            if (list.isEmpty()) return null;

            Object[] row = list.get(0);
            int canHoId = ((Number) row[0]).intValue();

            Map<String, Object> result = new HashMap<>();
            result.put("id", canHoId);
            result.put("soPhong", row[1]);
            result.put("tang", row[2]);
            result.put("dienTich", row[3]);
            result.put("trangThai", row[4]);

            // ONLY fetch resident names and types (NO CCCD, NO phone numbers for security privacy)
            String sqlCuDan = "SELECT cd.hoTen, cd.loaiCuDan " +
                    "FROM dbo.cuDan cd " +
                    "WHERE cd.maCanHo = :mch AND cd.trangThai = 'DangO' " +
                    "ORDER BY CASE WHEN cd.loaiCuDan = 'ChuHo' THEN 0 ELSE 1 END, cd.id ASC";

            @SuppressWarnings("unchecked")
            List<Object[]> dsCuDan = em.createNativeQuery(sqlCuDan)
                    .setParameter("mch", canHoId)
                    .getResultList();

            result.put("dsCuDan", dsCuDan);

            // Registered vehicles count
            Number countXe = (Number) em.createNativeQuery("SELECT COUNT(x.id) FROM dbo.quanLyXe x WHERE x.maCanHo = :mch")
                    .setParameter("mch", canHoId)
                    .getSingleResult();
            result.put("soXeDangKy", countXe != null ? countXe.intValue() : 0);

            // Active RFID cards count
            Number countThe = (Number) em.createNativeQuery("SELECT COUNT(t.id) FROM dbo.theTu t WHERE t.maCanHo = :mch AND t.trangThai = 'DangSuDung'")
                    .setParameter("mch", canHoId)
                    .getSingleResult();
            result.put("soTheDangHoatDong", countThe != null ? countThe.intValue() : 0);

            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}
