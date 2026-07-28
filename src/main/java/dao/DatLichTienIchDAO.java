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
}
