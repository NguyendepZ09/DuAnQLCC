package dao;

import entity.QuanLyXe;
import entity.TheTu;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class QuanLyXeDAO {

    private static final Set<String> LOAI_XE_VALID = new HashSet<>(Arrays.asList("OTo", "XeMay", "XeDap"));

    @SuppressWarnings("unchecked")
    public List<Object[]> findAllXe(String tuKhoa, String loaiXe) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT x.id, x.bienSoXe, x.loaiXe, c.soPhong, t.soThe, " +
                    "       (SELECT TOP 1 cd.hoTen FROM dbo.cuDan cd WHERE cd.maCanHo = x.maCanHo AND cd.loaiCuDan = 'ChuHo') AS tenChuHo, " +
                    "       t.trangThai AS trangThaiThe, x.maCanHo, x.maThe " +
                    "FROM dbo.quanLyXe x " +
                    "JOIN dbo.canHo c ON c.id = x.maCanHo " +
                    "LEFT JOIN dbo.theTu t ON t.id = x.maThe " +
                    "WHERE 1=1 "
            );

            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                sql.append("AND (x.bienSoXe LIKE :tk OR c.soPhong LIKE :tk) ");
            }
            if (loaiXe != null && !loaiXe.trim().isEmpty()) {
                sql.append("AND x.loaiXe = :loaiXe ");
            }
            sql.append("ORDER BY x.id DESC");

            var query = em.createNativeQuery(sql.toString());
            if (tuKhoa != null && !tuKhoa.trim().isEmpty()) {
                query.setParameter("tk", "%" + tuKhoa.trim() + "%");
            }
            if (loaiXe != null && !loaiXe.trim().isEmpty()) {
                query.setParameter("loaiXe", loaiXe.trim());
            }

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> traCuuTheoBienSo(String bienSo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            if (bienSo == null || bienSo.trim().isEmpty()) {
                return new ArrayList<>();
            }

            // Normalize search input by removing spaces, dots, dashes for fuzzy plate matching
            String cleanSearch = bienSo.trim().replaceAll("[\\s\\.\\-]", "");
            String searchPattern = "%" + cleanSearch + "%";

            String sql = "SELECT x.id, x.bienSoXe, x.loaiXe, c.soPhong, " +
                         "       (SELECT TOP 1 cd.hoTen FROM dbo.cuDan cd WHERE cd.maCanHo = x.maCanHo AND cd.loaiCuDan = 'ChuHo') AS tenChuHo, " +
                         "       t.soThe, t.trangThai AS trangThaiThe, t.ngayHetHan " +
                         "FROM dbo.quanLyXe x " +
                         "JOIN dbo.canHo c ON c.id = x.maCanHo " +
                         "LEFT JOIN dbo.theTu t ON t.id = x.maThe " +
                         "WHERE REPLACE(REPLACE(REPLACE(x.bienSoXe, '.', ''), '-', ''), ' ', '') LIKE :search " +
                         "   OR t.soThe LIKE :rawSearch " +
                         "   OR c.soPhong LIKE :rawSearch " +
                         "ORDER BY x.id DESC";

            List<Object[]> rawList = em.createNativeQuery(sql)
                    .setParameter("search", searchPattern)
                    .setParameter("rawSearch", "%" + bienSo.trim() + "%")
                    .getResultList();

            List<Object[]> result = new ArrayList<>();
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate today = LocalDate.now();

            for (Object[] r : rawList) {
                Object[] row = new Object[10];
                row[0] = r[0]; // id
                row[1] = r[1]; // bienSoXe
                row[2] = r[2]; // loaiXe
                row[3] = r[3]; // soPhong
                row[4] = r[4]; // tenChuHo

                String soThe = r[5] != null ? r[5].toString() : null;
                String trangThaiThe = r[6] != null ? r[6].toString() : null;

                LocalDate hetHanDate = null;
                if (r[7] instanceof java.sql.Date) {
                    hetHanDate = ((java.sql.Date) r[7]).toLocalDate();
                } else if (r[7] instanceof LocalDate) {
                    hetHanDate = (LocalDate) r[7];
                }

                boolean daHetHan = (hetHanDate != null && hetHanDate.isBefore(today));

                String tinhTrangThe;
                String hetHanFmt;
                String lyDoKhongHieuLuc = "";

                if (soThe == null) {
                    // 1. CHƯA GẮN THẺ TỪ (maThe IS NULL)
                    tinhTrangThe = "ChuaGanThe";
                    hetHanFmt = "";
                } else if (!"DangSuDung".equalsIgnoreCase(trangThaiThe) || daHetHan) {
                    // 2. THẺ KHÔNG CÒN HIỆU LỰC (tạm khóa, thu hồi hoặc hết hạn)
                    tinhTrangThe = "TheKhongHieuLuc";
                    hetHanFmt = hetHanDate != null ? hetHanDate.format(dtf) : "Không thời hạn";

                    if ("TamKhoa".equalsIgnoreCase(trangThaiThe)) {
                        lyDoKhongHieuLuc = "Thẻ đang tạm khóa";
                    } else if ("DaThuHoi".equalsIgnoreCase(trangThaiThe)) {
                        lyDoKhongHieuLuc = "Thẻ đã thu hồi";
                    } else if (daHetHan) {
                        lyDoKhongHieuLuc = "Thẻ hết hạn từ " + (hetHanDate != null ? hetHanDate.format(dtf) : "");
                    } else {
                        lyDoKhongHieuLuc = "Thẻ không hợp lệ";
                    }
                } else {
                    // 3. THẺ HỢP LỆ (ĐangSuDung, ngayHetHan >= hôm nay hoặc NULL)
                    tinhTrangThe = "HopLe";
                    hetHanFmt = hetHanDate != null ? hetHanDate.format(dtf) : "Không thời hạn";
                }

                row[5] = soThe;
                row[6] = trangThaiThe;
                row[7] = tinhTrangThe;
                row[8] = hetHanFmt;
                row[9] = lyDoKhongHieuLuc;

                result.add(row);
            }
            return result;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findTheDangSuDungTheoCanHo(int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, soThe FROM dbo.theTu WHERE maCanHo = :maCanHo AND trangThai = 'DangSuDung' ORDER BY soThe";
            return em.createNativeQuery(sql).setParameter("maCanHo", maCanHo).getResultList();
        } finally {
            em.close();
        }
    }

    public String themXe(int maCanHo, Integer maThe, String bienSoXe, String loaiXe) {
        if (bienSoXe == null || bienSoXe.trim().isEmpty()) {
            return "Vui lòng nhập biển số xe.";
        }
        bienSoXe = bienSoXe.trim().toUpperCase();

        if (loaiXe == null || !LOAI_XE_VALID.contains(loaiXe.trim())) {
            return "Loại xe không hợp lệ (phải là Ô tô, Xe máy hoặc Xe đạp).";
        }
        loaiXe = loaiXe.trim();

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Check Duplicate bienSoXe
            String sqlCheckBienSo = "SELECT COUNT(*) FROM dbo.quanLyXe WHERE bienSoXe = :bienSoXe";
            Number countBienSo = (Number) em.createNativeQuery(sqlCheckBienSo).setParameter("bienSoXe", bienSoXe).getSingleResult();
            if (countBienSo != null && countBienSo.intValue() > 0) {
                return "Biển số xe '" + bienSoXe + "' đã tồn tại trong hệ thống. Vui lòng kiểm tra lại.";
            }

            // Check maCanHo exists and DangO
            String sqlCheckCanHo = "SELECT COUNT(*) FROM dbo.canHo WHERE id = :id AND trangThai = 'DangO'";
            Number countCanHo = (Number) em.createNativeQuery(sqlCheckCanHo).setParameter("id", maCanHo).getSingleResult();
            if (countCanHo == null || countCanHo.intValue() == 0) {
                return "Căn hộ không tồn tại hoặc không ở trạng thái đang ở.";
            }

            // Check maThe if provided belongs to THAT EXACT apartment and DangSuDung
            if (maThe != null) {
                TheTu card = em.find(TheTu.class, maThe);
                if (card == null || card.getMaCanHo() != maCanHo) {
                    return "Thẻ từ được chọn không thuộc căn hộ này.";
                }
                if (!"DangSuDung".equalsIgnoreCase(card.getTrangThai())) {
                    return "Thẻ từ được chọn không ở trạng thái 'Đang sử dụng'.";
                }
            }

            tx.begin();
            QuanLyXe x = new QuanLyXe();
            x.setMaCanHo(maCanHo);
            x.setMaThe(maThe);
            x.setBienSoXe(bienSoXe);
            x.setLoaiXe(loaiXe);
            em.persist(x);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[QuanLyXeDAO] themXe FAILED: " + msg);
            if (msg.contains("UQ_quanLyXe_bienSoXe") || msg.contains("UNIQUE")) {
                return "Biển số xe '" + bienSoXe + "' đã tồn tại trong hệ thống.";
            }
            return "Lỗi khi thêm xe: " + msg;
        } finally {
            em.close();
        }
    }

    public String suaXe(int id, Integer maThe, String bienSoXe, String loaiXe) {
        if (bienSoXe == null || bienSoXe.trim().isEmpty()) {
            return "Vui lòng nhập biển số xe.";
        }
        bienSoXe = bienSoXe.trim().toUpperCase();

        if (loaiXe == null || !LOAI_XE_VALID.contains(loaiXe.trim())) {
            return "Loại xe không hợp lệ.";
        }
        loaiXe = loaiXe.trim();

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            QuanLyXe x = em.find(QuanLyXe.class, id);
            if (x == null) {
                return "Không tìm thấy thông tin xe.";
            }

            // Check Duplicate bienSoXe if changed
            if (!bienSoXe.equalsIgnoreCase(x.getBienSoXe())) {
                String sqlCheckBienSo = "SELECT COUNT(*) FROM dbo.quanLyXe WHERE bienSoXe = :bienSoXe AND id <> :id";
                Number countBienSo = (Number) em.createNativeQuery(sqlCheckBienSo)
                        .setParameter("bienSoXe", bienSoXe)
                        .setParameter("id", id)
                        .getSingleResult();
                if (countBienSo != null && countBienSo.intValue() > 0) {
                    return "Biển số xe '" + bienSoXe + "' đã tồn tại ở phương tiện khác.";
                }
            }

            // Check maThe if provided belongs to THAT EXACT apartment and DangSuDung
            if (maThe != null) {
                TheTu card = em.find(TheTu.class, maThe);
                if (card == null || card.getMaCanHo() != x.getMaCanHo()) {
                    return "Thẻ từ được chọn không thuộc căn hộ này.";
                }
                if (!"DangSuDung".equalsIgnoreCase(card.getTrangThai())) {
                    return "Thẻ từ được chọn không ở trạng thái 'Đang sử dụng'.";
                }
            }

            tx.begin();
            x.setMaThe(maThe);
            x.setBienSoXe(bienSoXe);
            x.setLoaiXe(loaiXe);
            em.merge(x);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[QuanLyXeDAO] suaXe FAILED: " + msg);
            return "Lỗi khi sửa xe: " + msg;
        } finally {
            em.close();
        }
    }

    public String xoaXe(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            QuanLyXe x = em.find(QuanLyXe.class, id);
            if (x == null) {
                return "Không tìm thấy thông tin xe.";
            }

            tx.begin();
            em.remove(x);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[QuanLyXeDAO] xoaXe FAILED: " + msg);
            return "Lỗi khi xóa xe: " + msg;
        } finally {
            em.close();
        }
    }
}
