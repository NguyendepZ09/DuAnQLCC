package dao;

import entity.TheTu;
import entity.TheTuChucNang;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class TheTuDAO {

    private static final Set<String> CHUC_NANG_VALID = new HashSet<>(Arrays.asList(
            "CuaChinh", "ThangMay", "BaiXeOTo", "BaiXeMay", "HoBoi", "PhongGym"
    ));

    @SuppressWarnings("unchecked")
    public List<Object[]> findAllThe(String tuKhoa, String trangThai) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT t.id, t.soThe, c.soPhong, cd.hoTen AS tenCuDan, cd.loaiCuDan, t.ngayCap, t.ngayHetHan, t.trangThai, " +
                    "       (SELECT STRING_AGG(tc.chucNang, ',') FROM dbo.theTu_ChucNang tc WHERE tc.maThe = t.id) AS dsChucNang, " +
                    "       (SELECT COUNT(*) FROM dbo.quanLyXe x WHERE x.maThe = t.id) AS soXeGanThe, " +
                    "       t.maCanHo, t.maCuDan " +
                    "FROM dbo.theTu t " +
                    "JOIN dbo.canHo c ON c.id = t.maCanHo " +
                    "LEFT JOIN dbo.cuDan cd ON cd.id = t.maCuDan " +
                    "WHERE 1=1 "
            );

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                sql.append("AND (t.soThe LIKE :tk OR c.soPhong LIKE :tk OR cd.hoTen LIKE :tk) ");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                sql.append("AND t.trangThai = :trangThai ");
            }
            sql.append("ORDER BY t.id DESC");

            var query = em.createNativeQuery(sql.toString());
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                query.setParameter("tk", "%" + tuKhoa.trim() + "%");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", trangThai.trim());
            }

            List<Object[]> rawList = query.getResultList();
            List<Object[]> result = new ArrayList<>();
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate today = LocalDate.now();

            for (Object[] r : rawList) {
                Object[] row = new Object[15];
                row[0] = r[0]; // id
                row[1] = r[1]; // soThe
                row[2] = r[2]; // soPhong
                row[3] = r[3]; // tenCuDan
                row[4] = r[4]; // loaiCuDan
                row[5] = r[5]; // ngayCap
                row[6] = r[6]; // ngayHetHan
                row[7] = r[7]; // trangThai
                row[8] = r[8] != null ? r[8].toString() : ""; // dsChucNang
                row[9] = r[9] != null ? ((Number) r[9]).intValue() : 0; // soXe
                row[13] = r[10]; // maCanHo
                row[14] = r[11]; // maCuDan

                // Check expired in Java
                boolean daHetHan = false;
                LocalDate hetHanDate = null;
                if (r[6] instanceof java.sql.Date) {
                    hetHanDate = ((java.sql.Date) r[6]).toLocalDate();
                } else if (r[6] instanceof LocalDate) {
                    hetHanDate = (LocalDate) r[6];
                }

                if (hetHanDate != null && hetHanDate.isBefore(today)) {
                    daHetHan = true;
                }
                row[10] = daHetHan;

                // Formatted ngayCap & ngayHetHan
                String ngayCapStr = "";
                if (r[5] instanceof java.sql.Date) {
                    ngayCapStr = ((java.sql.Date) r[5]).toLocalDate().format(dtf);
                } else if (r[5] != null) {
                    ngayCapStr = r[5].toString();
                }
                row[11] = ngayCapStr;

                String ngayHetHanStr = "Vô hạn";
                if (hetHanDate != null) {
                    ngayHetHanStr = hetHanDate.format(dtf);
                }
                row[12] = ngayHetHanStr;

                result.add(row);
            }
            return result;
        } finally {
            em.close();
        }
    }

    public Map<String, Integer> thongKeTheTu() {
        EntityManager em = JPAUtil.getEntityManager();
        Map<String, Integer> map = new HashMap<>();
        try {
            String sql = "SELECT trangThai, COUNT(*) FROM dbo.theTu GROUP BY trangThai";
            @SuppressWarnings("unchecked")
            List<Object[]> rows = em.createNativeQuery(sql).getResultList();
            int tong = 0;
            int dangSuDung = 0;
            int tamKhoa = 0;
            int daThuHoi = 0;

            for (Object[] r : rows) {
                String st = (String) r[0];
                int count = ((Number) r[1]).intValue();
                tong += count;
                if ("DangSuDung".equalsIgnoreCase(st)) dangSuDung = count;
                else if ("TamKhoa".equalsIgnoreCase(st)) tamKhoa = count;
                else if ("DaThuHoi".equalsIgnoreCase(st)) daThuHoi = count;
            }

            map.put("tongSoThe", tong);
            map.put("dangSuDung", dangSuDung);
            map.put("tamKhoa", tamKhoa);
            map.put("daThuHoi", daThuHoi);
            return map;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findCanHoDangO() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, soPhong FROM dbo.canHo WHERE trangThai = 'DangO' ORDER BY soPhong";
            return em.createNativeQuery(sql).getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findCuDanTheoCanHo(int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, hoTen, loaiCuDan FROM dbo.cuDan WHERE maCanHo = :maCanHo AND trangThai = 'DangO' ORDER BY loaiCuDan, hoTen";
            return em.createNativeQuery(sql).setParameter("maCanHo", maCanHo).getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<String> findChucNangTheoThe(int maThe) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT chucNang FROM dbo.theTu_ChucNang WHERE maThe = :maThe";
            return em.createNativeQuery(sql).setParameter("maThe", maThe).getResultList();
        } finally {
            em.close();
        }
    }

    public String capTheMoi(int maCanHo, Integer maCuDan, String soThe, LocalDate ngayHetHan, List<String> dsChucNang) {
        if (soThe == null || soThe.trim().isEmpty()) {
            return "Vui lòng nhập số thẻ từ.";
        }
        soThe = soThe.trim().toUpperCase();

        LocalDate today = LocalDate.now();
        if (ngayHetHan != null && !ngayHetHan.isAfter(today)) {
            return "Ngày hết hạn thẻ phải sau ngày cấp (" + today.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ").";
        }

        if (dsChucNang != null) {
            for (String cn : dsChucNang) {
                if (!CHUC_NANG_VALID.contains(cn)) {
                    return "Chức năng thẻ '" + cn + "' không hợp lệ.";
                }
            }
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Check Duplicate soThe
            String sqlCheckSoThe = "SELECT COUNT(*) FROM dbo.theTu WHERE soThe = :soThe";
            Number countSoThe = (Number) em.createNativeQuery(sqlCheckSoThe).setParameter("soThe", soThe).getSingleResult();
            if (countSoThe != null && countSoThe.intValue() > 0) {
                return "Số thẻ '" + soThe + "' đã tồn tại trong hệ thống. Vui lòng nhập số thẻ khác.";
            }

            // Check maCanHo exists and DangO
            String sqlCheckCanHo = "SELECT COUNT(*) FROM dbo.canHo WHERE id = :id AND trangThai = 'DangO'";
            Number countCanHo = (Number) em.createNativeQuery(sqlCheckCanHo).setParameter("id", maCanHo).getSingleResult();
            if (countCanHo == null || countCanHo.intValue() == 0) {
                return "Căn hộ không tồn tại hoặc không ở trạng thái đang ở.";
            }

            // Check maCuDan belongs to THAT EXACT apartment AND is DangO
            if (maCuDan != null) {
                String sqlCheckCuDan = "SELECT COUNT(*) FROM dbo.cuDan WHERE id = :id AND maCanHo = :maCanHo AND trangThai = 'DangO'";
                Number countCuDan = (Number) em.createNativeQuery(sqlCheckCuDan)
                        .setParameter("id", maCuDan)
                        .setParameter("maCanHo", maCanHo)
                        .getSingleResult();
                if (countCuDan == null || countCuDan.intValue() == 0) {
                    return "Cư dân được chọn không thuộc căn hộ này hoặc không ở trạng thái đang ở.";
                }
            }

            tx.begin();
            TheTu t = new TheTu();
            t.setMaCanHo(maCanHo);
            t.setMaCuDan(maCuDan);
            t.setSoThe(soThe);
            t.setNgayCap(today);
            t.setNgayHetHan(ngayHetHan);
            t.setTrangThai("DangSuDung");
            em.persist(t);
            em.flush(); // Get generated ID

            if (dsChucNang != null) {
                for (String cn : dsChucNang) {
                    em.createNativeQuery("INSERT INTO dbo.theTu_ChucNang (maThe, chucNang) VALUES (:maThe, :cn)")
                            .setParameter("maThe", t.getId())
                            .setParameter("cn", cn)
                            .executeUpdate();
                }
            }

            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[TheTuDAO] capTheMoi FAILED: " + msg);
            if (msg.contains("UQ_theTu_soThe") || msg.contains("UNIQUE")) {
                return "Số thẻ '" + soThe + "' đã tồn tại trong hệ thống. Vui lòng chọn số thẻ khác.";
            }
            return "Lỗi khi cấp thẻ từ: " + msg;
        } finally {
            em.close();
        }
    }

    public String capNhatThe(int id, Integer maCuDan, LocalDate ngayHetHan, List<String> dsChucNang) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            TheTu t = em.find(TheTu.class, id);
            if (t == null) {
                return "Không tìm thấy thẻ từ.";
            }

            if ("DaThuHoi".equalsIgnoreCase(t.getTrangThai())) {
                return "Thẻ đã thu hồi không thể sửa thông tin.";
            }

            LocalDate ngayCap = t.getNgayCap() != null ? t.getNgayCap() : LocalDate.now();
            if (ngayHetHan != null && !ngayHetHan.isAfter(ngayCap)) {
                return "Ngày hết hạn phải sau ngày cấp (" + ngayCap.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + ").";
            }

            if (maCuDan != null) {
                String sqlCheckCuDan = "SELECT COUNT(*) FROM dbo.cuDan WHERE id = :id AND maCanHo = :maCanHo AND trangThai = 'DangO'";
                Number countCuDan = (Number) em.createNativeQuery(sqlCheckCuDan)
                        .setParameter("id", maCuDan)
                        .setParameter("maCanHo", t.getMaCanHo())
                        .getSingleResult();
                if (countCuDan == null || countCuDan.intValue() == 0) {
                    return "Cư dân được chọn không thuộc căn hộ của thẻ này hoặc không ở trạng thái đang ở.";
                }
            }

            if (dsChucNang != null) {
                for (String cn : dsChucNang) {
                    if (!CHUC_NANG_VALID.contains(cn)) {
                        return "Chức năng thẻ '" + cn + "' không hợp lệ.";
                    }
                }
            }

            tx.begin();
            t.setMaCuDan(maCuDan);
            t.setNgayHetHan(ngayHetHan);
            em.merge(t);

            // Replace functions
            em.createNativeQuery("DELETE FROM dbo.theTu_ChucNang WHERE maThe = :maThe")
                    .setParameter("maThe", id)
                    .executeUpdate();

            if (dsChucNang != null) {
                for (String cn : dsChucNang) {
                    em.createNativeQuery("INSERT INTO dbo.theTu_ChucNang (maThe, chucNang) VALUES (:maThe, :cn)")
                            .setParameter("maThe", id)
                            .setParameter("cn", cn)
                            .executeUpdate();
                }
            }

            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[TheTuDAO] capNhatThe FAILED: " + msg);
            return "Lỗi khi cập nhật thẻ từ: " + msg;
        } finally {
            em.close();
        }
    }

    public String doiTrangThaiThe(int id, String trangThaiMoi) {
        if (!"DangSuDung".equalsIgnoreCase(trangThaiMoi) &&
            !"TamKhoa".equalsIgnoreCase(trangThaiMoi) &&
            !"DaThuHoi".equalsIgnoreCase(trangThaiMoi)) {
            return "Trạng thái mới không hợp lệ.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            TheTu t = em.find(TheTu.class, id);
            if (t == null) {
                return "Không tìm thấy thẻ từ.";
            }

            // Rule: DaThuHoi is ONE-WAY
            if ("DaThuHoi".equalsIgnoreCase(t.getTrangThai())) {
                return "Thẻ đã thu hồi không thể kích hoạt lại. Vui lòng cấp thẻ mới.";
            }

            tx.begin();
            t.setTrangThai(trangThaiMoi);
            em.merge(t);

            // If revoking card ('DaThuHoi'): UNLINK ALL vehicles attached to this card
            if ("DaThuHoi".equalsIgnoreCase(trangThaiMoi)) {
                em.createNativeQuery("UPDATE dbo.quanLyXe SET maThe = NULL WHERE maThe = :maThe")
                        .setParameter("maThe", id)
                        .executeUpdate();
            }

            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[TheTuDAO] doiTrangThaiThe FAILED: " + msg);
            return "Lỗi khi đổi trạng thái thẻ: " + msg;
        } finally {
            em.close();
        }
    }
}
