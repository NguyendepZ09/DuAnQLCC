package dao;

import entity.ChiSoTieuThu;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import java.util.Date;
import java.util.List;

public class ChiSoTieuThuDAO {

    public static class ChiSoInput {
        private int maCanHo;
        private Double chiSoDien;
        private Double chiSoNuoc;
        private Double chiSoDienKyTruoc;
        private Double chiSoNuocKyTruoc;

        public ChiSoInput(int maCanHo, Double chiSoDien, Double chiSoNuoc, Double chiSoDienKyTruoc, Double chiSoNuocKyTruoc) {
            this.maCanHo = maCanHo;
            this.chiSoDien = chiSoDien;
            this.chiSoNuoc = chiSoNuoc;
            this.chiSoDienKyTruoc = chiSoDienKyTruoc;
            this.chiSoNuocKyTruoc = chiSoNuocKyTruoc;
        }

        public int getMaCanHo() { return maCanHo; }
        public Double getChiSoDien() { return chiSoDien; }
        public Double getChiSoNuoc() { return chiSoNuoc; }
        public Double getChiSoDienKyTruoc() { return chiSoDienKyTruoc; }
        public Double getChiSoNuocKyTruoc() { return chiSoNuocKyTruoc; }
    }

    public List<Object[]> findChiSoTheoKy(int thang, int nam) {
        int thangTruoc = (thang == 1) ? 12 : thang - 1;
        int namTruoc = (thang == 1) ? nam - 1 : nam;

        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  c.id AS canHoId, " +
                "  c.soPhong, " +
                "  c.dienTich, " +
                "  cur_dien.chiSo AS chiSoDien, " +
                "  cur_nuoc.chiSo AS chiSoNuoc, " +
                "  prev_dien.chiSo AS chiSoDienKyTruoc, " +
                "  prev_nuoc.chiSo AS chiSoNuocKyTruoc " +
                "FROM canHo c " +
                "LEFT JOIN chiSoTieuThu cur_dien ON cur_dien.maCanHo = c.id AND cur_dien.thang = :thang AND cur_dien.nam = :nam AND cur_dien.loaiDichVu = 'Dien' " +
                "LEFT JOIN chiSoTieuThu cur_nuoc ON cur_nuoc.maCanHo = c.id AND cur_nuoc.thang = :thang AND cur_nuoc.nam = :nam AND cur_nuoc.loaiDichVu = 'Nuoc' " +
                "LEFT JOIN chiSoTieuThu prev_dien ON prev_dien.maCanHo = c.id AND prev_dien.thang = :thangTruoc AND prev_dien.nam = :namTruoc AND prev_dien.loaiDichVu = 'Dien' " +
                "LEFT JOIN chiSoTieuThu prev_nuoc ON prev_nuoc.maCanHo = c.id AND prev_nuoc.thang = :thangTruoc AND prev_nuoc.nam = :namTruoc AND prev_nuoc.loaiDichVu = 'Nuoc' " +
                "WHERE c.trangThai = N'DangO' " +
                "ORDER BY c.soPhong ASC";

            return em.createNativeQuery(sql)
                    .setParameter("thang", thang)
                    .setParameter("nam", nam)
                    .setParameter("thangTruoc", thangTruoc)
                    .setParameter("namTruoc", namTruoc)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public String luuSingleChiSo(EntityManager em, int maCanHo, String loaiDichVu, int thang, int nam, double chiSo, Double chiSoKyTruoc) {
        if (thang < 1 || thang > 12) {
            return "Tháng phải nằm trong khoảng từ 1 đến 12.";
        }
        if (chiSo < 0) {
            return "Chỉ số mới không được nhỏ hơn 0.";
        }
        if (chiSoKyTruoc != null && chiSo < chiSoKyTruoc) {
            return "Chỉ số mới (" + chiSo + ") nhỏ hơn chỉ số kỳ trước (" + chiSoKyTruoc + ")";
        }

        try {
            ChiSoTieuThu existing = null;
            try {
                existing = em.createQuery("SELECT cs FROM ChiSoTieuThu cs WHERE cs.maCanHo = :maCanHo AND cs.loaiDichVu = :loaiDichVu AND cs.thang = :thang AND cs.nam = :nam", ChiSoTieuThu.class)
                        .setParameter("maCanHo", maCanHo)
                        .setParameter("loaiDichVu", loaiDichVu)
                        .setParameter("thang", thang)
                        .setParameter("nam", nam)
                        .getSingleResult();
            } catch (NoResultException ignored) {}

            if (existing != null) {
                existing.setChiSo(chiSo);
                existing.setNgayGhi(new Date());
                em.merge(existing);
            } else {
                ChiSoTieuThu cs = new ChiSoTieuThu();
                cs.setMaCanHo(maCanHo);
                cs.setLoaiDichVu(loaiDichVu);
                cs.setThang(thang);
                cs.setNam(nam);
                cs.setChiSo(chiSo);
                cs.setNgayGhi(new Date());
                em.persist(cs);
            }
            return null;
        } catch (Exception e) {
            return extractRootMessage(e);
        }
    }

    public String luuChiSoHangLoat(List<ChiSoInput> inputList, int thang, int nam) {
        if (inputList == null || inputList.isEmpty()) {
            return "Không có dữ liệu chỉ số để ghi nhận.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            for (ChiSoInput item : inputList) {
                if (item.getChiSoDien() != null) {
                    String errDien = luuSingleChiSo(em, item.getMaCanHo(), "Dien", thang, nam, item.getChiSoDien(), item.getChiSoDienKyTruoc());
                    if (errDien != null) {
                        tx.rollback();
                        return "Căn hộ #" + item.getMaCanHo() + " (Điện): " + errDien;
                    }
                }
                if (item.getChiSoNuoc() != null) {
                    String errNuoc = luuSingleChiSo(em, item.getMaCanHo(), "Nuoc", thang, nam, item.getChiSoNuoc(), item.getChiSoNuocKyTruoc());
                    if (errNuoc != null) {
                        tx.rollback();
                        return "Căn hộ #" + item.getMaCanHo() + " (Nước): " + errNuoc;
                    }
                }
            }
            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[ChiSoTieuThuDAO] luuChiSoHangLoat FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    private String extractRootMessage(Throwable e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        String msg = cause.getMessage();
        if (msg == null || msg.isBlank()) msg = e.getMessage();
        if (msg == null) msg = e.getClass().getSimpleName();
        return msg.length() > 500 ? msg.substring(0, 500) + "..." : msg;
    }
}
