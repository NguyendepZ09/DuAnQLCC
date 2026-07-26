package DAOs;

import Entities.CanHo;
import Entities.CuDan;
import Entities.HoaDon;
import Utils.JPAUtil;
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

    /**
     * Lay danh sach 200 can ho va gom nhom theo So Tang (25 -> 1)
     */
    public Map<Integer, List<CanHo>> findAllMappedByTang() {
        Map<Integer, List<CanHo>> mapTang = new LinkedHashMap<>();
        
        // Khoi tao key 25 -> 1
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

    /**
     * Tim chi tiet can ho bang primary key id
     */
    public Map<String, Object> findDetailById(Integer canHoId) {
        Map<String, Object> result = new HashMap<>();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            CanHo ch = em.find(CanHo.class, canHoId);
            if (ch == null) return result;

            result.put("canHo", ch);

            // Tim cu dan (chu ho) cua can ho nay
            try {
                CuDan cd = em.createQuery("SELECT c FROM CuDan c WHERE c.maCanHo = :mch", CuDan.class)
                             .setParameter("mch", canHoId)
                             .setMaxResults(1)
                             .getSingleResult();
                result.put("cuDan", cd);
            } catch (NoResultException e) {
                result.put("cuDan", null);
            }

            // Tim hoa don moi nhat
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
}
