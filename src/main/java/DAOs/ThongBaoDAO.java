package DAOs;

import Entities.ThongBao;
import Utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.Date;
import java.util.List;

/**
 * DAO quan ly thong bao toan toa nha
 */
public class ThongBaoDAO {

    public List<ThongBao> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT t FROM ThongBao t ORDER BY t.id DESC", ThongBao.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public boolean save(ThongBao tb) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (tb.getMaNhanVien() == null) tb.setMaNhanVien(1);
            if (tb.getNgayTao() == null) tb.setNgayTao(new Date());
            if (tb.getDoiTuong() == null) tb.setDoiTuong("TatCa");
            if (tb.getLoai() == null) tb.setLoai("Chung");

            em.persist(tb);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Loi save ThongBao trong ThongBaoDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
