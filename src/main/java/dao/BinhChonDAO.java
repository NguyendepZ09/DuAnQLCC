package dao;

import entity.BinhChon;
import entity.PhuongAnBinhChon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
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

    /**
     * Tao binh chon va cac phuong an.
     * Caller phai set day du: cauHoi, maThongBao, ngayBatDau, hanChot, trangThai, tyLeTucSo.
     * @return null neu thanh cong; message loi thuc tu SQL Server neu that bai.
     */
    public String saveBinhChonVoiPhuongAnGetError(BinhChon bc, List<String> phuongAnTexts) {
        if (bc == null || bc.getMaThongBao() == null) {
            return "maThongBao khong duoc de trong!";
        }
        if (bc.getHanChot() == null) {
            return "hanChot la bat buoc — khong duoc null.";
        }
        if (bc.getTrangThai() == null || bc.getTrangThai().isEmpty()) {
            return "trangThai la bat buoc.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            if (bc.getTongCanHoLucMo() == null) {
                Number activeAppts = (Number) em.createNativeQuery("SELECT COUNT(*) FROM dbo.canHo WHERE trangThai = N'DangO'").getSingleResult();
                bc.setTongCanHoLucMo(activeAppts != null ? activeAppts.intValue() : 0);
            }

            em.persist(bc);
            em.flush(); // flush ngay de bat loi CHECK constraint truoc khi insert phuong an

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
            return null; // thanh cong
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            // Dao sau de lay message thuc tu SQL Server (nam trong Caused by chain)
            String msg = extractRootMessage(e);
            System.err.println("[BinhChonDAO] saveBinhChonVoiPhuongAnGetError FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Goi Stored Procedure sp_DongBinhChon de dong cuoc binh chon va tong ket ket qua.
     * @return null neu thanh cong, hoac message loi tu SQL Server neu that bai.
     */
    public String dongBinhChon(int maBinhChon) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            jakarta.persistence.StoredProcedureQuery query = em.createStoredProcedureQuery("sp_DongBinhChon");
            query.registerStoredProcedureParameter("maBinhChon", Integer.class, jakarta.persistence.ParameterMode.IN);
            query.setParameter("maBinhChon", maBinhChon);
            query.execute();
            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[BinhChonDAO] dongBinhChon FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    /**
     * Lay thong ke tham gia cho 1 cuoc binh chon:
     * - canDaBau: COUNT(DISTINCT maCanHo) FROM phieuBau WHERE maBinhChon = ?
     * - tongCan: ISNULL(b.tongCanHoLucMo, (SELECT COUNT(*) FROM canHo WHERE trangThai = 'DangO'))
     * - tyLeThamGia: (canDaBau * 100.0 / tongCan)
     */
    public java.util.Map<String, Object> getParticipationStats(int maBinhChon) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            java.util.Map<String, Object> stats = new java.util.HashMap<>();
            String sql = "SELECT " +
                         "(SELECT COUNT(DISTINCT maCanHo) FROM dbo.phieuBau WHERE maBinhChon = :maBinhChon) AS canDaBau, " +
                         "ISNULL(b.tongCanHoLucMo, (SELECT COUNT(*) FROM dbo.canHo WHERE trangThai = N'DangO')) AS tongCan " +
                         "FROM dbo.binhChon b WHERE b.id = :maBinhChon";
            Object[] row = (Object[]) em.createNativeQuery(sql)
                    .setParameter("maBinhChon", maBinhChon)
                    .getSingleResult();

            int canDaBau = ((Number) row[0]).intValue();
            int tongCan = ((Number) row[1]).intValue();
            double tyLe = (tongCan > 0) ? (canDaBau * 100.0 / tongCan) : 0.0;

            stats.put("canDaBau", canDaBau);
            stats.put("tongCan", tongCan);
            stats.put("tyLeThamGia", tyLe);
            stats.put("tyLeThamGiaFormatted", String.format("%.1f", tyLe));
            return stats;
        } catch (Exception e) {
            e.printStackTrace();
            java.util.Map<String, Object> defaultMap = new java.util.HashMap<>();
            defaultMap.put("canDaBau", 0);
            defaultMap.put("tongCan", 0);
            defaultMap.put("tyLeThamGia", 0.0);
            defaultMap.put("tyLeThamGiaFormatted", "0.0");
            return defaultMap;
        } finally {
            em.close();
        }
    }

    /** Lay message root cause de hien thi loi SQL Server chinh xac cho nguoi dung. */
    private String extractRootMessage(Throwable e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        String msg = cause.getMessage();
        if (msg == null || msg.isBlank()) msg = e.getMessage();
        if (msg == null) msg = e.getClass().getSimpleName();
        // Giu toi da 500 ky tu de tranh tran man hinh
        return msg.length() > 500 ? msg.substring(0, 500) + "..." : msg;
    }

    /**
     * @deprecated Dung saveBinhChonVoiPhuongAnGetError thay the.
     */
    @Deprecated
    public boolean saveBinhChonVoiPhuongAn(BinhChon bc, List<String> phuongAnTexts) {
        return saveBinhChonVoiPhuongAnGetError(bc, phuongAnTexts) == null;
    }
}
