package dao;

import entity.CanHo;
import entity.CuDan;
import util.JPAUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.HashMap;
import java.util.Map;

/**
 * DAO quan ly truy van du lieu bang cuDan (Jakarta Persistence)
 */
public class CuDanDAO {

    public CuDan findByMaTaiKhoan(Integer maTaiKhoan) {
        if (maTaiKhoan == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<CuDan> query = em.createQuery(
                "SELECT c FROM CuDan c WHERE c.maTaiKhoan = :ma", CuDan.class);
            query.setParameter("ma", maTaiKhoan);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> findDetailWithCanHoByMaTaiKhoan(Integer maTaiKhoan) {
        if (maTaiKhoan == null) return Map.of();
        EntityManager em = JPAUtil.getEntityManager();
        Map<String, Object> map = new HashMap<>();
        try {
            CuDan cd = findByMaTaiKhoan(maTaiKhoan);
            if (cd != null) {
                map.put("cuDan", cd);
                if (cd.getMaCanHo() != null) {
                    CanHo ch = em.find(CanHo.class, cd.getMaCanHo());
                    map.put("canHo", ch);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return map;
    }
}
