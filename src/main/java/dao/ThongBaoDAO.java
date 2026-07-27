package dao;

import entity.ThongBao;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
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

    public List<ThongBao> findForCuDan(int page, int pageSize) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<ThongBao> query = em.createQuery(
                "SELECT t FROM ThongBao t WHERE t.doiTuong IN ('CuDan', 'TatCa') ORDER BY t.ngayTao DESC", ThongBao.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public long countForCuDan() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT COUNT(t) FROM ThongBao t WHERE t.doiTuong IN ('CuDan', 'TatCa')", Long.class).getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
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
            if (tb.getLoaiThongBao() == null || tb.getLoaiThongBao().isEmpty()) tb.setLoaiThongBao("ThongThuong");
            if (tb.getDoiTuong() == null || tb.getDoiTuong().isEmpty()) tb.setDoiTuong("TatCa");

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
