package DAOs;

import Entities.CuDan;
import Utils.JPAUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

/**
 * DAO quan ly truy van du lieu bang cuDan (Jakarta Persistence)
 */
public class CuDanDAO {

    /**
     * Tim thong tin CuDan theo maTaiKhoan (ID cua TaiKhoan)
     */
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
}
