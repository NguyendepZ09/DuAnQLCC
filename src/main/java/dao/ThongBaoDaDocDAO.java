package dao;

import entity.ThongBaoDaDoc;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * DAO quan ly trang thai da doc thong bao phia Cu Dan
 */
public class ThongBaoDaDocDAO {

    public Set<Integer> getReadNoticeIds(Integer maCuDan) {
        if (maCuDan == null) return Set.of();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Integer> list = em.createQuery(
                "SELECT t.maThongBao FROM ThongBaoDaDoc t WHERE t.maCuDan = :ma", Integer.class)
                .setParameter("ma", maCuDan)
                .getResultList();
            return new HashSet<>(list);
        } catch (Exception e) {
            e.printStackTrace();
            return Set.of();
        } finally {
            em.close();
        }
    }

    public boolean markAsRead(Integer maThongBao, Integer maCuDan) {
        if (maThongBao == null || maCuDan == null) return false;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(t) FROM ThongBaoDaDoc t WHERE t.maThongBao = :tb AND t.maCuDan = :cd", Long.class)
                .setParameter("tb", maThongBao)
                .setParameter("cd", maCuDan)
                .getSingleResult();
            
            if (count == 0) {
                tx.begin();
                ThongBaoDaDoc doc = new ThongBaoDaDoc();
                doc.setMaThongBao(maThongBao);
                doc.setMaCuDan(maCuDan);
                doc.setThoiGianDoc(new Date());
                em.persist(doc);
                tx.commit();
            }
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public long countUnreadForCuDan(Integer maCuDan) {
        if (maCuDan == null) return 0L;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(t) FROM ThongBao t WHERE t.doiTuong IN ('CuDan', 'TatCa') " +
                          "AND t.id NOT IN (SELECT d.maThongBao FROM ThongBaoDaDoc d WHERE d.maCuDan = :cd)";
            return em.createQuery(jpql, Long.class)
                .setParameter("cd", maCuDan)
                .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            em.close();
        }
    }
}
