package DAOs;

import Entities.NhanVien;
import Utils.JPAUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

/**
 * DAO quan ly truy van du lieu bang nhanVien (Jakarta Persistence)
 */
public class NhanVienDAO {

    /**
     * Tim thong tin NhanVien theo maTaiKhoan (ID cua TaiKhoan)
     */
    public NhanVien findByMaTaiKhoan(Integer maTaiKhoan) {
        if (maTaiKhoan == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<NhanVien> query = em.createQuery(
                "SELECT n FROM NhanVien n WHERE n.maTaiKhoan = :ma", NhanVien.class);
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
