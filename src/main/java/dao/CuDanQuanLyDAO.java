package dao;

import entity.CuDan;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class CuDanQuanLyDAO {

    @SuppressWarnings("unchecked")
    public List<Object[]> timCuDan(String tuKhoa, String loaiCuDan, String trangThai) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                "SELECT cd.id, cd.hoTen, cd.soDienThoai, cd.cccd, c.soPhong, cd.maCanHo, cd.loaiCuDan, " +
                "       cd.trangThai, cd.ngayChuyenDen, " +
                "       CASE WHEN cd.maTaiKhoan IS NOT NULL THEN 1 ELSE 0 END AS coTaiKhoan, " +
                "       (SELECT COUNT(*) FROM dbo.theTu t WHERE t.maCuDan = cd.id AND t.trangThai = 'DangSuDung') AS soThe " +
                "FROM dbo.cuDan cd " +
                "JOIN dbo.canHo c ON c.id = cd.maCanHo " +
                "WHERE 1=1 "
            );

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                sql.append(" AND (cd.hoTen LIKE :tk OR cd.soDienThoai LIKE :tk OR cd.cccd LIKE :tk OR c.soPhong LIKE :tk)");
            }
            if (loaiCuDan != null && !loaiCuDan.trim().isEmpty()) {
                sql.append(" AND cd.loaiCuDan = :loaiCuDan");
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                sql.append(" AND cd.trangThai = :trangThai");
            }

            sql.append(" ORDER BY cd.id DESC");

            var query = em.createNativeQuery(sql.toString());

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                query.setParameter("tk", "%" + tuKhoa.trim() + "%");
            }
            if (loaiCuDan != null && !loaiCuDan.trim().isEmpty()) {
                query.setParameter("loaiCuDan", loaiCuDan.trim());
            }
            if (trangThai != null && !trangThai.trim().isEmpty()) {
                query.setParameter("trangThai", trangThai.trim());
            }

            List<Object[]> rawList = query.getResultList();
            List<Object[]> result = new ArrayList<>();
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            for (Object[] r : rawList) {
                Object[] row = new Object[11];
                row[0] = r[0]; // id
                row[1] = r[1]; // hoTen
                row[2] = r[2]; // soDienThoai
                row[3] = r[3]; // cccd
                row[4] = r[4]; // soPhong
                row[5] = r[5]; // maCanHo
                row[6] = r[6]; // loaiCuDan
                row[7] = r[7]; // trangThai

                // Format ngayChuyenDen
                LocalDate ncd = null;
                if (r[8] instanceof java.sql.Date) {
                    ncd = ((java.sql.Date) r[8]).toLocalDate();
                } else if (r[8] instanceof LocalDate) {
                    ncd = (LocalDate) r[8];
                }
                row[8] = ncd != null ? ncd.format(dtf) : "—";
                row[9] = r[9] != null && ((Number) r[9]).intValue() == 1; // coTaiKhoan
                row[10] = r[10] != null ? ((Number) r[10]).intValue() : 0; // soThe

                result.add(row);
            }

            return result;
        } finally {
            em.close();
        }
    }

    public Map<String, Integer> thongKeCuDan() {
        EntityManager em = JPAUtil.getEntityManager();
        Map<String, Integer> stats = new HashMap<>();
        try {
            Number totalDangO = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM dbo.cuDan WHERE trangThai = 'DangO'"
            ).getSingleResult();

            Number countChuHo = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM dbo.cuDan WHERE trangThai = 'DangO' AND loaiCuDan = 'ChuHo'"
            ).getSingleResult();

            Number countKhachThue = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM dbo.cuDan WHERE trangThai = 'DangO' AND loaiCuDan = 'KhachThue'"
            ).getSingleResult();

            Number countCanHoTrong = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM dbo.canHo WHERE trangThai = 'TrongChoThue'"
            ).getSingleResult();

            stats.put("tongCuDanDangO", totalDangO != null ? totalDangO.intValue() : 0);
            stats.put("soChuHo", countChuHo != null ? countChuHo.intValue() : 0);
            stats.put("soKhachThue", countKhachThue != null ? countKhachThue.intValue() : 0);
            stats.put("soCanHoTrong", countCanHoTrong != null ? countCanHoTrong.intValue() : 0);

            return stats;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findCanHoChoDropDown() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, soPhong, trangThai FROM dbo.canHo ORDER BY soPhong ASC";
            return em.createNativeQuery(sql).getResultList();
        } finally {
            em.close();
        }
    }

    public String themCuDan(int maCanHo, String hoTen, String soDienThoai, String cccd,
                           String loaiCuDan, LocalDate ngayChuyenDen) {
        if (hoTen == null || hoTen.trim().isEmpty()) {
            return "Họ và tên cư dân không được để trống.";
        }
        if (!"ChuHo".equals(loaiCuDan) && !"KhachThue".equals(loaiCuDan)) {
            return "Loại cư dân không hợp lệ (chỉ chấp nhận 'ChuHo' hoặc 'KhachThue').";
        }
        if (ngayChuyenDen != null && ngayChuyenDen.isAfter(LocalDate.now())) {
            return "Ngày chuyển đến không được vượt quá ngày hiện tại.";
        }

        String cleanCccd = cccd != null ? cccd.trim() : "";
        if (!cleanCccd.isEmpty()) {
            if (!cleanCccd.matches("\\d{12}")) {
                return "Số CCCD phải bao gồm đúng 12 chữ số.";
            }
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Check canHo exists
            String sqlCheckCanHo = "SELECT COUNT(*) FROM dbo.canHo WHERE id = :id";
            Number countCanHo = (Number) em.createNativeQuery(sqlCheckCanHo).setParameter("id", maCanHo).getSingleResult();
            if (countCanHo == null || countCanHo.intValue() == 0) {
                return "Căn hộ được chọn không tồn tại trong hệ thống.";
            }

            // Check duplicate CCCD among active residents
            if (!cleanCccd.isEmpty()) {
                String sqlCheckCccd = "SELECT COUNT(*) FROM dbo.cuDan WHERE cccd = :cccd AND trangThai = 'DangO'";
                Number countCccd = (Number) em.createNativeQuery(sqlCheckCccd).setParameter("cccd", cleanCccd).getSingleResult();
                if (countCccd != null && countCccd.intValue() > 0) {
                    return "Số CCCD '" + cleanCccd + "' đã được đăng ký bởi một cư dân đang ở khác.";
                }
            }

            // Check 1 ChuHo rule
            if ("ChuHo".equals(loaiCuDan)) {
                String sqlCheckChuHo = "SELECT cd.hoTen FROM dbo.cuDan cd WHERE cd.maCanHo = :maCanHo AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO'";
                List<String> chuHoList = em.createNativeQuery(sqlCheckChuHo).setParameter("maCanHo", maCanHo).getResultList();
                if (!chuHoList.isEmpty()) {
                    return "Căn hộ này đã có chủ hộ: " + chuHoList.get(0) + ". Mỗi căn chỉ có một chủ hộ.";
                }
            }

            tx.begin();
            CuDan cd = new CuDan();
            cd.setMaCanHo(maCanHo);
            cd.setHoTen(hoTen.trim());
            cd.setSoDienThoai(soDienThoai != null && !soDienThoai.trim().isEmpty() ? soDienThoai.trim() : null);
            cd.setCccd(!cleanCccd.isEmpty() ? cleanCccd : null);
            cd.setLoaiCuDan(loaiCuDan);
            cd.setTrangThai("DangO");
            cd.setNgayChuyenDen(ngayChuyenDen != null ? ngayChuyenDen : LocalDate.now());
            em.persist(cd);

            // Sync apartment status: If apartment was 'TrongChoThue', set it to 'DangO'
            em.createNativeQuery("UPDATE dbo.canHo SET trangThai = 'DangO' WHERE id = :maCanHo AND trangThai = 'TrongChoThue'")
                    .setParameter("maCanHo", maCanHo)
                    .executeUpdate();

            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[CuDanQuanLyDAO] themCuDan FAILED: " + msg);
            return "Lỗi khi thêm cư dân: " + msg;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public String capNhatCuDan(int id, String hoTen, String soDienThoai, String cccd,
                              String loaiCuDan, LocalDate ngayChuyenDen) {
        if (hoTen == null || hoTen.trim().isEmpty()) {
            return "Họ và tên cư dân không được để trống.";
        }
        if (!"ChuHo".equals(loaiCuDan) && !"KhachThue".equals(loaiCuDan)) {
            return "Loại cư dân không hợp lệ.";
        }
        if (ngayChuyenDen != null && ngayChuyenDen.isAfter(LocalDate.now())) {
            return "Ngày chuyển đến không được vượt quá ngày hiện tại.";
        }

        String cleanCccd = cccd != null ? cccd.trim() : "";
        if (!cleanCccd.isEmpty() && !cleanCccd.matches("\\d{12}")) {
            return "Số CCCD phải bao gồm đúng 12 chữ số.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            CuDan cd = em.find(CuDan.class, id);
            if (cd == null) {
                return "Không tìm thấy cư dân.";
            }

            if ("DaChuyenDi".equalsIgnoreCase(cd.getTrangThai())) {
                return "Cư dân đã chuyển đi không thể chỉnh sửa thông tin.";
            }

            // Check duplicate CCCD among active residents excluding this id
            if (!cleanCccd.isEmpty()) {
                String sqlCheckCccd = "SELECT COUNT(*) FROM dbo.cuDan WHERE cccd = :cccd AND trangThai = 'DangO' AND id <> :id";
                Number countCccd = (Number) em.createNativeQuery(sqlCheckCccd)
                        .setParameter("cccd", cleanCccd)
                        .setParameter("id", id)
                        .getSingleResult();
                if (countCccd != null && countCccd.intValue() > 0) {
                    return "Số CCCD '" + cleanCccd + "' đã được đăng ký bởi một cư dân đang ở khác.";
                }
            }

            // Check 1 ChuHo rule if changing to ChuHo
            if ("ChuHo".equals(loaiCuDan)) {
                String sqlCheckChuHo = "SELECT cd.hoTen FROM dbo.cuDan cd WHERE cd.maCanHo = :maCanHo AND cd.loaiCuDan = 'ChuHo' AND cd.trangThai = 'DangO' AND cd.id <> :id";
                List<String> chuHoList = em.createNativeQuery(sqlCheckChuHo)
                        .setParameter("maCanHo", cd.getMaCanHo())
                        .setParameter("id", id)
                        .getResultList();
                if (!chuHoList.isEmpty()) {
                    return "Căn hộ này đã có chủ hộ: " + chuHoList.get(0) + ". Mỗi căn chỉ có một chủ hộ.";
                }
            }

            tx.begin();
            cd.setHoTen(hoTen.trim());
            cd.setSoDienThoai(soDienThoai != null && !soDienThoai.trim().isEmpty() ? soDienThoai.trim() : null);
            cd.setCccd(!cleanCccd.isEmpty() ? cleanCccd : null);
            cd.setLoaiCuDan(loaiCuDan);
            if (ngayChuyenDen != null) {
                cd.setNgayChuyenDen(ngayChuyenDen);
            }
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[CuDanQuanLyDAO] capNhatCuDan FAILED: " + msg);
            return "Lỗi khi cập nhật thông tin cư dân: " + msg;
        } finally {
            em.close();
        }
    }

    public String chuyenDi(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            CuDan cd = em.find(CuDan.class, id);
            if (cd == null) {
                return "Không tìm thấy cư dân.";
            }

            if ("DaChuyenDi".equalsIgnoreCase(cd.getTrangThai())) {
                return "Cư dân này đã chuyển đi.";
            }

            int maCanHo = cd.getMaCanHo();

            tx.begin();

            // 1. Mark resident as DaChuyenDi
            cd.setTrangThai("DaChuyenDi");

            // 2. Unlink vehicles attached to this resident's cards
            em.createNativeQuery("UPDATE dbo.quanLyXe SET maThe = NULL WHERE maThe IN (SELECT id FROM dbo.theTu WHERE maCuDan = :id)")
                    .setParameter("id", id)
                    .executeUpdate();

            // 3. Revoke all RFID cards of this resident
            em.createNativeQuery("UPDATE dbo.theTu SET trangThai = 'DaThuHoi' WHERE maCuDan = :id AND trangThai <> 'DaThuHoi'")
                    .setParameter("id", id)
                    .executeUpdate();

            // 4. Check if apartment has NO OTHER active residents ('DangO')
            Number activeResidentsCount = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM dbo.cuDan WHERE maCanHo = :maCanHo AND trangThai = 'DangO' AND id <> :id"
            ).setParameter("maCanHo", maCanHo).setParameter("id", id).getSingleResult();

            if (activeResidentsCount == null || activeResidentsCount.intValue() == 0) {
                em.createNativeQuery("UPDATE dbo.canHo SET trangThai = 'TrongChoThue' WHERE id = :maCanHo")
                        .setParameter("maCanHo", maCanHo)
                        .executeUpdate();
            }

            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[CuDanQuanLyDAO] chuyenDi FAILED: " + msg);
            return "Lỗi khi xử lý chuyển đi cho cư dân: " + msg;
        } finally {
            em.close();
        }
    }
}
