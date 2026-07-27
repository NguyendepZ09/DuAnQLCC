package dao;

import entity.BinhChon;
import entity.PhuongAnBinhChon;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO xu ly nghiep vu bo phieu, kiem tra phieu bau can ho va lay ket qua binh chon
 */
public class CuDanBinhChonDAO {

    /**
     * Lay danh sach phuong an theo ma binh chon
     */
    public List<PhuongAnBinhChon> findPhuongAnByBinhChonId(Integer maBinhChon) {
        if (maBinhChon == null) return List.of();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT p FROM PhuongAnBinhChon p WHERE p.maBinhChon = :id ORDER BY p.thuTu ASC", PhuongAnBinhChon.class)
                .setParameter("id", maBinhChon)
                .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    /**
     * Kiem tra xem CAN HO (maCanHo) da bo phieu cho cuoc binh chon (maBinhChon) hay chưa.
     * Tra ve Map chua: maPhuongAn, thoiGianBau, nguoiBauHoTen (neu da bo phieu)
     */
    public Map<String, Object> findPhieuBauByCanHo(Integer maBinhChon, Integer maCanHo) {
        if (maBinhChon == null || maCanHo == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT pb.maPhuongAn, pb.thoiGianBau, cd.hoTen FROM PhieuBau pb, CuDan cd " +
                          "WHERE pb.maCuDan = cd.id AND pb.maBinhChon = :bc AND pb.maCanHo = :ch";
            List<Object[]> list = em.createQuery(jpql, Object[].class)
                .setParameter("bc", maBinhChon)
                .setParameter("ch", maCanHo)
                .getResultList();

            if (!list.isEmpty()) {
                Object[] row = list.get(0);
                Map<String, Object> res = new HashMap<>();
                res.put("maPhuongAn", row[0]);
                if (row[1] != null) {
                    if (row[1] instanceof Date) {
                        res.put("thoiGianBau", new SimpleDateFormat("dd/MM/yyyy HH:mm").format((Date) row[1]));
                    } else {
                        res.put("thoiGianBau", row[1].toString());
                    }
                } else {
                    res.put("thoiGianBau", "");
                }
                res.put("nguoiBauHoTen", row[2] != null ? row[2].toString() : "Cư dân căn hộ");
                return res;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return null;
    }

    /**
     * Thuc hien bo phieu qua Stored Procedure sp_BoPhieu
     * Tra ve VotingResult (success, message)
     */
    public VotingResult boPhieu(Integer maBinhChon, Integer maPhuongAn, Integer maCuDan, Integer maCanHo) {
        if (maBinhChon == null || maPhuongAn == null || maCuDan == null || maCanHo == null) {
            return new VotingResult(false, "Thông tin bỏ phiếu không đầy đủ.");
        }

        EntityManager em = JPAUtil.getEntityManager();
        try {
            StoredProcedureQuery query = em.createStoredProcedureQuery("sp_BoPhieu");
            query.registerStoredProcedureParameter("maBinhChon", Integer.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("maPhuongAn", Integer.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("maCuDan", Integer.class, ParameterMode.IN);

            query.setParameter("maBinhChon", maBinhChon);
            query.setParameter("maPhuongAn", maPhuongAn);
            query.setParameter("maCuDan", maCuDan);

            query.execute();

            // YEU CAU BAT BUOC: Query lai bang phieuBau de xac nhan phieu da ghi vao DB
            String checkJpql = "SELECT COUNT(p) FROM PhieuBau p WHERE p.maBinhChon = :bc AND p.maCanHo = :ch";
            Long count = em.createQuery(checkJpql, Long.class)
                .setParameter("bc", maBinhChon)
                .setParameter("ch", maCanHo)
                .getSingleResult();

            if (count != null && count > 0) {
                return new VotingResult(true, "Bỏ phiếu thành công!");
            } else {
                return new VotingResult(false, "Không thể xác nhận phiếu bầu trong hệ thống.");
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi gọi sp_BoPhieu: " + e.getMessage());
            e.printStackTrace();

            String errMsg = extractCleanErrorMessage(e);
            return new VotingResult(false, errMsg);
        } finally {
            em.close();
        }
    }

    /**
     * Lay ket qua binh chon chi tiet tu View v_KetQuaBinhChon
     */
    public List<Map<String, Object>> findKetQuaBinhChonFromView(Integer maBinhChon) {
        if (maBinhChon == null) return List.of();
        EntityManager em = JPAUtil.getEntityManager();
        List<Map<String, Object>> resultList = new ArrayList<>();
        try {
            String sql = "SELECT maBinhChon, cauHoi, trangThai, tyLeTucSo, ketQua, phuongAn, soPhieu, soCanDaBau, tongSoCan " +
                         "FROM v_KetQuaBinhChon WHERE maBinhChon = :id";
            List<Object[]> list = em.createNativeQuery(sql)
                .setParameter("id", maBinhChon)
                .getResultList();

            for (Object[] row : list) {
                Map<String, Object> map = new HashMap<>();
                map.put("maBinhChon", row[0]);
                map.put("cauHoi", row[1]);
                map.put("trangThai", row[2]);
                map.put("tyLeTucSo", row[3]);
                map.put("ketQua", row[4]);
                map.put("phuongAn", row[5]);
                map.put("soPhieu", row[6]);
                map.put("soCanDaBau", row[7]);
                map.put("tongSoCan", row[8]);
                resultList.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return resultList;
    }

    private String extractCleanErrorMessage(Throwable e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        String msg = cause.getMessage();
        if (msg != null) {
            if (msg.contains("Can ho cua ban da bo phieu")) {
                return "Căn hộ của bạn đã thực hiện bỏ phiếu cho cuộc bình chọn này.";
            }
            if (msg.contains("Cuoc binh chon da dong hoac het han")) {
                return "Cuộc bình chọn đã đóng hoặc quá hạn chót.";
            }
            if (msg.contains("Phuong an khong thuoc cuoc binh chon")) {
                return "Phương án lựa chọn không hợp lệ.";
            }
            return msg;
        }
        return "Lỗi thực thi bỏ phiếu.";
    }

    public static class VotingResult {
        private boolean success;
        private String message;

        public VotingResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
    }
}
