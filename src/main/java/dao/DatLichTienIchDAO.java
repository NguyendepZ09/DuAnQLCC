package dao;

import entity.DanhMucTienIch;
import entity.DatLichTienIch;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DatLichTienIchDAO {

    public List<DanhMucTienIch> findAllAmenities() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT ti FROM DanhMucTienIch ti ORDER BY ti.id ASC", DanhMucTienIch.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public List<Object[]> findBookingHistoryByCanHo(int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT " +
                "  d.id, " +
                "  ti.tenTienIch, " +
                "  d.ngayDat, " +
                "  d.khungGio, " +
                "  d.giaTien, " +
                "  d.trangThai, " +
                "  d.ngayTao, " +
                "  ti.id AS maTienIch " +
                "FROM dbo.datLichTienIch d " +
                "JOIN dbo.danhMucTienIch ti ON ti.id = d.maTienIch " +
                "WHERE d.maCanHo = :maCanHo " +
                "ORDER BY d.ngayDat DESC, d.id DESC";

            List<Object[]> rawList = em.createNativeQuery(sql)
                    .setParameter("maCanHo", maCanHo)
                    .getResultList();

            List<Object[]> result = new ArrayList<>();
            LocalDate today = LocalDate.now();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            for (Object[] row : rawList) {
                Object[] newRow = new Object[10];
                System.arraycopy(row, 0, newRow, 0, Math.min(row.length, 8));

                Object rawNgayDat = row[2];
                LocalDate dt = null;
                if (rawNgayDat instanceof java.sql.Date) {
                    dt = ((java.sql.Date) rawNgayDat).toLocalDate();
                } else if (rawNgayDat instanceof java.util.Date) {
                    dt = new java.sql.Date(((java.util.Date) rawNgayDat).getTime()).toLocalDate();
                } else if (rawNgayDat != null) {
                    try {
                        dt = LocalDate.parse(rawNgayDat.toString().substring(0, 10));
                    } catch (Exception ignored) {}
                }

                String trangThai = row[5] != null ? row[5].toString() : "";
                boolean coTheHuy = ("ChoDuyet".equalsIgnoreCase(trangThai) || "DaDuyet".equalsIgnoreCase(trangThai))
                        && (dt != null && !dt.isBefore(today));

                String ngayDatFormatted = (dt != null) ? dt.format(fmt) : (rawNgayDat != null ? rawNgayDat.toString() : "");

                newRow[8] = coTheHuy;             // boolean flag
                newRow[9] = ngayDatFormatted;      // String dd/MM/yyyy

                result.add(newRow);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public String datLichTienIch(int maCanHo, Integer maCuDan, int maTienIch, LocalDate ngayDat, String khungGio) {
        if (ngayDat == null) {
            return "Ngày đặt là bắt buộc.";
        }
        if (khungGio == null || khungGio.isBlank()) {
            return "Khung giờ là bắt buộc.";
        }

        LocalDate today = LocalDate.now();
        // Validate 2: ngayDat < today
        if (ngayDat.isBefore(today)) {
            return "Ngày đặt không được là ngày trong quá khứ.";
        }
        // Validate 3: ngayDat > today + 30 days
        if (ngayDat.isAfter(today.plusDays(30))) {
            return "Ngày đặt không được quá 30 ngày kể từ hôm nay.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Validate 1: Amenity active check
            DanhMucTienIch ti = em.find(DanhMucTienIch.class, maTienIch);
            if (ti == null) {
                tx.rollback();
                return "Không tìm thấy tiện ích dịch vụ.";
            }
            if (!"HoatDong".equalsIgnoreCase(ti.getTrangThaiHoatDong())) {
                tx.rollback();
                return "Tiện ích này hiện đang tạm ngưng hoặc bảo trì, không thể đặt.";
            }

            // Validate 4: Time slot within open/close hours check
            if (ti.getGioMoCua() != null && ti.getGioDongCua() != null) {
                try {
                    String[] parts = khungGio.split("-");
                    LocalTime startSlot = LocalTime.parse(parts[0].trim());
                    LocalTime endSlot = LocalTime.parse(parts[1].trim());
                    LocalTime openTime = ti.getGioMoCua().toLocalTime();
                    LocalTime closeTime = ti.getGioDongCua().toLocalTime();

                    if (startSlot.isBefore(openTime) || endSlot.isAfter(closeTime)) {
                        tx.rollback();
                        return "Khung giờ đặt phải nằm trong giờ mở cửa (" + openTime + " - " + closeTime + ").";
                    }
                } catch (Exception ignored) {}
            }

            // Validate 6: Max 3 active bookings per apartment
            Long activeCount = em.createQuery(
                "SELECT COUNT(d) FROM DatLichTienIch d WHERE d.maCanHo = :maCanHo AND d.trangThai IN ('ChoDuyet', 'DaDuyet')", 
                Long.class
            ).setParameter("maCanHo", maCanHo).getSingleResult();

            if (activeCount != null && activeCount >= 3) {
                tx.rollback();
                return "Mỗi căn hộ chỉ được tối đa 3 lượt đặt tiện ích đang hiệu lực (Chờ duyệt/Đã duyệt).";
            }

            // Validate 5: Anti-overlap / Chống trùng
            java.sql.Date sqlDate = java.sql.Date.valueOf(ngayDat);
            Long dupCount = em.createQuery(
                "SELECT COUNT(d) FROM DatLichTienIch d WHERE d.maTienIch = :maTienIch AND d.ngayDat = :ngayDat AND d.khungGio = :khungGio AND d.trangThai IN ('ChoDuyet', 'DaDuyet')", 
                Long.class
            ).setParameter("maTienIch", maTienIch)
             .setParameter("ngayDat", sqlDate)
             .setParameter("khungGio", khungGio.trim())
             .getSingleResult();

            if (dupCount != null && dupCount > 0) {
                tx.rollback();
                return "Khung giờ này đã có người đặt.";
            }

            DatLichTienIch d = new DatLichTienIch();
            d.setMaCanHo(maCanHo);
            d.setMaCuDan(maCuDan);
            d.setMaTienIch(maTienIch);
            d.setNgayDat(sqlDate);
            d.setKhungGio(khungGio.trim());
            d.setGiaTien(ti.getGiaThueMacDinh());
            d.setTrangThai("ChoDuyet");
            d.setNgayTao(new Date());

            em.persist(d);
            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            if (msg.contains("UQ_datLich_khongTrung") || msg.contains("UNIQUE KEY")) {
                return "Khung giờ này đã có người đặt.";
            }
            System.err.println("[DatLichTienIchDAO] datLichTienIch FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String huyDatLich(int idDatLich, int maCanHo) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            DatLichTienIch d = em.find(DatLichTienIch.class, idDatLich);
            if (d == null || d.getMaCanHo() == null || d.getMaCanHo() != maCanHo) {
                tx.rollback();
                return "FORBIDDEN"; // IDOR Violation
            }

            if (!List.of("ChoDuyet", "DaDuyet").contains(d.getTrangThai())) {
                tx.rollback();
                return "Lượt đặt này không thể hủy.";
            }

            java.sql.Date today = java.sql.Date.valueOf(LocalDate.now());
            if (d.getNgayDat().before(today)) {
                tx.rollback();
                return "Không thể hủy lượt đặt trong quá khứ.";
            }

            d.setTrangThai("DaHuy");
            em.merge(d);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[DatLichTienIchDAO] huyDatLich FAILED: " + msg);
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

    @SuppressWarnings("unchecked")
    public List<Object[]> findTatCaLuotDat(String trangThai, LocalDate tuNgay, LocalDate denNgay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                "SELECT " +
                "  d.id, " +
                "  ti.tenTienIch, " +
                "  c.soPhong, " +
                "  ISNULL(cd.hoTen, N'Cư dân phòng ' + c.soPhong) AS tenCuDan, " +
                "  d.ngayDat, " +
                "  d.khungGio, " +
                "  d.giaTien, " +
                "  d.trangThai, " +
                "  ti.id AS maTienIch " +
                "FROM dbo.datLichTienIch d " +
                "JOIN dbo.danhMucTienIch ti ON ti.id = d.maTienIch " +
                "JOIN dbo.canHo c ON c.id = d.maCanHo " +
                "LEFT JOIN dbo.cuDan cd ON cd.id = d.maCuDan " +
                "WHERE 1=1 "
            );

            if (trangThai != null && !trangThai.isBlank() && !"ALL".equalsIgnoreCase(trangThai)) {
                sql.append(" AND d.trangThai = :trangThai ");
            }
            if (tuNgay != null) {
                sql.append(" AND d.ngayDat >= :tuNgay ");
            }
            if (denNgay != null) {
                sql.append(" AND d.ngayDat <= :denNgay ");
            }

            sql.append(" ORDER BY CASE WHEN d.trangThai = 'ChoDuyet' THEN 0 ELSE 1 END, d.ngayDat DESC, d.id DESC ");

            var query = em.createNativeQuery(sql.toString());

            if (trangThai != null && !trangThai.isBlank() && !"ALL".equalsIgnoreCase(trangThai)) {
                query.setParameter("trangThai", trangThai.trim());
            }
            if (tuNgay != null) {
                query.setParameter("tuNgay", java.sql.Date.valueOf(tuNgay));
            }
            if (denNgay != null) {
                query.setParameter("denNgay", java.sql.Date.valueOf(denNgay));
            }

            List<Object[]> rawList = query.getResultList();
            List<Object[]> result = new ArrayList<>();
            LocalDate today = LocalDate.now();
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            for (Object[] row : rawList) {
                Object[] newRow = new Object[12];
                System.arraycopy(row, 0, newRow, 0, Math.min(row.length, 8));

                Object rawNgayDat = row[4];
                LocalDate dt = null;
                if (rawNgayDat instanceof java.sql.Date) {
                    dt = ((java.sql.Date) rawNgayDat).toLocalDate();
                } else if (rawNgayDat instanceof java.util.Date) {
                    dt = new java.sql.Date(((java.util.Date) rawNgayDat).getTime()).toLocalDate();
                } else if (rawNgayDat != null) {
                    try { dt = LocalDate.parse(rawNgayDat.toString().substring(0, 10)); } catch (Exception ignored) {}
                }

                String st = row[7] != null ? row[7].toString() : "";
                String ngayDatFormatted = (dt != null) ? dt.format(fmt) : (rawNgayDat != null ? rawNgayDat.toString() : "");

                boolean coTheDuyet = "ChoDuyet".equalsIgnoreCase(st);
                boolean coTheTuChoi = "ChoDuyet".equalsIgnoreCase(st);
                boolean coTheHoanThanh = "DaDuyet".equalsIgnoreCase(st) && (dt != null && !dt.isAfter(today));

                newRow[4] = ngayDatFormatted;   // Formatted string
                newRow[8] = coTheDuyet;          // boolean flag
                newRow[9] = coTheTuChoi;         // boolean flag
                newRow[10] = coTheHoanThanh;     // boolean flag
                newRow[11] = dt;                 // LocalDate raw

                result.add(newRow);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }

    public String duyetLuotDat(int id, int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            DatLichTienIch d = em.find(DatLichTienIch.class, id);
            if (d == null) {
                tx.rollback();
                return "Không tìm thấy lượt đặt tiện ích.";
            }

            if (!"ChoDuyet".equalsIgnoreCase(d.getTrangThai())) {
                tx.rollback();
                return "Lượt đặt này đã được xử lý.";
            }

            // KIỂM TRA LẠI TRÙNG KHUNG GIỜ TRƯỚC KHI DUYỆT
            String checkSql = "SELECT c.soPhong FROM dbo.datLichTienIch d2 " +
                              "JOIN dbo.canHo c ON c.id = d2.maCanHo " +
                              "WHERE d2.maTienIch = :maTienIch AND d2.ngayDat = :ngayDat AND d2.khungGio = :khungGio " +
                              "AND d2.trangThai IN ('DaDuyet', 'HoanThanh') AND d2.id <> :id";

            List<String> conflictedRooms = em.createNativeQuery(checkSql, String.class)
                    .setParameter("maTienIch", d.getMaTienIch())
                    .setParameter("ngayDat", d.getNgayDat())
                    .setParameter("khungGio", d.getKhungGio())
                    .setParameter("id", id)
                    .getResultList();

            if (!conflictedRooms.isEmpty()) {
                tx.rollback();
                return "TỪ CHỐI DUYỆT: Khung giờ này đã được duyệt trước đó cho phòng " + conflictedRooms.get(0) + "!";
            }

            d.setTrangThai("DaDuyet");
            em.merge(d);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[DatLichTienIchDAO] duyetLuotDat FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String tuChoiLuotDat(int id, int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            DatLichTienIch d = em.find(DatLichTienIch.class, id);
            if (d == null) {
                tx.rollback();
                return "Không tìm thấy lượt đặt tiện ích.";
            }

            if (!"ChoDuyet".equalsIgnoreCase(d.getTrangThai())) {
                tx.rollback();
                return "Lượt đặt này đã được xử lý.";
            }

            d.setTrangThai("DaHuy");
            em.merge(d);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[DatLichTienIchDAO] tuChoiLuotDat FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }

    public String hoanThanhLuotDat(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            DatLichTienIch d = em.find(DatLichTienIch.class, id);
            if (d == null) {
                tx.rollback();
                return "Không tìm thấy lượt đặt tiện ích.";
            }

            if (!"DaDuyet".equalsIgnoreCase(d.getTrangThai())) {
                tx.rollback();
                return "Chỉ có thể xác nhận hoàn thành lượt đặt đã được duyệt.";
            }

            java.sql.Date today = java.sql.Date.valueOf(LocalDate.now());
            if (d.getNgayDat().after(today)) {
                tx.rollback();
                return "Chưa tới ngày sử dụng.";
            }

            d.setTrangThai("HoanThanh");
            em.merge(d);

            tx.commit();
            return null;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = extractRootMessage(e);
            System.err.println("[DatLichTienIchDAO] hoanThanhLuotDat FAILED: " + msg);
            e.printStackTrace();
            return msg;
        } finally {
            em.close();
        }
    }
}
