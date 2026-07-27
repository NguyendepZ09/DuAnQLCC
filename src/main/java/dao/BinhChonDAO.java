package dao;

import entity.BinhChon;
import entity.PhuongAnBinhChon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.Date;
import java.util.List;

/**
 * DAO quan ly binh chon va cac phuong an binh chon (su dung Transaction)
 */
public class BinhChonDAO {

    public List<BinhChon> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT b FROM BinhChon b ORDER BY b.id DESC", BinhChon.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public boolean saveBinhChonVoiPhuongAn(BinhChon bc, List<String> phuongAnTexts) {
        if (bc == null || bc.getMaThongBao() == null) {
            System.err.println("Loi saveBinhChonVoiPhuongAn: maThongBao khong duoc de trong!");
            return false;
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            if (bc.getNgayBatDau() == null) bc.setNgayBatDau(new Date());
            if (bc.getHanChot() == null) bc.setHanChot(new Date(System.currentTimeMillis() + 7L * 24L * 3600L * 1000L));
            if (bc.getTrangThai() == null) bc.setTrangThai("DangMo");
            if (bc.getTyLeTucSo() == null) bc.setTyLeTucSo(50.0);

            em.persist(bc);
            em.flush();

            if (phuongAnTexts != null) {
                int thuTuIndex = 1;
                for (String text : phuongAnTexts) {
                    if (text != null && !text.trim().isEmpty()) {
                        PhuongAnBinhChon pa = new PhuongAnBinhChon();
                        pa.setMaBinhChon(bc.getId());
                        pa.setNoiDung(text.trim());
                        pa.setThuTu(thuTuIndex++);
                        pa.setSoLuotChon(0);
                        em.persist(pa);
                    }
                }
            }

            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            System.err.println("Loi saveBinhChonVoiPhuongAn trong BinhChonDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
