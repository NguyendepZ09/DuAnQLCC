package dao;

import entity.ChamCong;
import entity.NhatKyCaTruc;
import util.JPAUtil;
import jakarta.persistence.EntityManager;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class NhanSuDAO {

    @SuppressWarnings("unchecked")
    public List<Object[]> findChamCong(String boPhan, LocalDate tuNgay, LocalDate denNgay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                "SELECT nv.id, nv.hoTen, nv.boPhan, cc.ngayLam, cc.caLam, cc.gioVao, cc.gioRa " +
                "FROM dbo.chamCong cc " +
                "JOIN dbo.nhanVien nv ON nv.id = cc.maNhanVien " +
                "WHERE 1=1 "
            );

            if (boPhan != null && !boPhan.trim().isEmpty()) {
                sql.append(" AND nv.boPhan = :boPhan ");
            }
            if (tuNgay != null) {
                sql.append(" AND cc.ngayLam >= :tuNgay ");
            }
            if (denNgay != null) {
                sql.append(" AND cc.ngayLam <= :denNgay ");
            }

            sql.append(" ORDER BY cc.ngayLam DESC, cc.gioVao DESC ");

            var query = em.createNativeQuery(sql.toString());

            if (boPhan != null && !boPhan.trim().isEmpty()) {
                query.setParameter("boPhan", boPhan.trim());
            }
            if (tuNgay != null) {
                query.setParameter("tuNgay", tuNgay);
            }
            if (denNgay != null) {
                query.setParameter("denNgay", denNgay);
            }

            List<Object[]> list = query.getResultList();
            List<Object[]> result = new ArrayList<>();

            DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");

            for (Object[] r : list) {
                Object[] row = new Object[10];
                row[0] = r[0]; // nv.id
                row[1] = r[1]; // hoTen
                row[2] = r[2]; // boPhan

                // ngayLam
                LocalDate ngayLam = null;
                if (r[3] instanceof java.sql.Date) ngayLam = ((java.sql.Date) r[3]).toLocalDate();
                else if (r[3] instanceof LocalDate) ngayLam = (LocalDate) r[3];
                row[3] = ngayLam != null ? ngayLam.format(dateFormat) : "—";

                row[4] = r[4]; // caLam

                // gioVao
                LocalDateTime gioVao = null;
                if (r[5] instanceof java.sql.Timestamp) gioVao = ((java.sql.Timestamp) r[5]).toLocalDateTime();
                else if (r[5] instanceof LocalDateTime) gioVao = (LocalDateTime) r[5];
                String gioVaoText = gioVao != null ? gioVao.format(timeFormat) : "";
                row[5] = gioVaoText;

                // gioRa
                LocalDateTime gioRa = null;
                if (r[6] instanceof java.sql.Timestamp) gioRa = ((java.sql.Timestamp) r[6]).toLocalDateTime();
                else if (r[6] instanceof LocalDateTime) gioRa = (LocalDateTime) r[6];
                String gioRaText = gioRa != null ? gioRa.format(timeFormat) : "";
                row[6] = gioRaText;

                // ChronoUnit Calculation for shift duration across midnight
                String soGioLamText = null;
                Double soGioLamDouble = null;
                String trangThaiCa = "DangTruc";

                if (gioVao != null && gioRa != null) {
                    long phut = java.time.temporal.ChronoUnit.MINUTES.between(gioVao, gioRa);
                    if (phut < 0) {
                        phut += 24 * 60; // night shift across midnight (22:00 -> 06:00)
                    }
                    soGioLamDouble = Math.round((phut / 60.0) * 10.0) / 10.0;
                    soGioLamText = String.format(java.util.Locale.US, "%.1f", soGioLamDouble);
                    trangThaiCa = "HoanThanh";
                } else {
                    soGioLamText = null;
                    trangThaiCa = "DangTruc";
                }

                row[7] = soGioLamText;
                row[8] = trangThaiCa;
                row[9] = soGioLamDouble;

                result.add(row);
            }

            return result;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> thongKeNhanSu(LocalDate tuNgay, LocalDate denNgay) {
        List<Object[]> listCC = findChamCong(null, tuNgay, denNgay);
        Map<String, Object> stats = new HashMap<>();

        int tongSoCa = listCC.size();
        int soCaDangTruc = 0;
        Map<String, Double> tongGioBoPhan = new LinkedHashMap<>();

        for (Object[] r : listCC) {
            String boPhan = (String) r[2];
            String trangThaiCa = (String) r[8];
            Double hours = (Double) r[9];

            if ("DangTruc".equals(trangThaiCa)) {
                soCaDangTruc++;
            }

            if (hours != null) {
                tongGioBoPhan.put(boPhan, tongGioBoPhan.getOrDefault(boPhan, 0.0) + hours);
            }
        }

        stats.put("tongSoCa", tongSoCa);
        stats.put("soCaDangTruc", soCaDangTruc);
        stats.put("tongGioBoPhan", tongGioBoPhan);
        return stats;
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findCaTruc(LocalDate tuNgay, LocalDate denNgay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                "SELECT nk.id, nk.ngayTruc, nk.caTruc, nv1.hoTen AS nguoiTruc, nk.noiDung, nk.luuYBanGiao, " +
                "       nv2.hoTen AS nguoiNhan, nk.thoiGianBanGiao " +
                "FROM dbo.nhatKyCaTruc nk " +
                "JOIN dbo.nhanVien nv1 ON nv1.id = nk.maBaoVe " +
                "LEFT JOIN dbo.nhanVien nv2 ON nv2.id = nk.maNguoiNhanCa " +
                "WHERE 1=1 "
            );

            if (tuNgay != null) {
                sql.append(" AND nk.ngayTruc >= :tuNgay ");
            }
            if (denNgay != null) {
                sql.append(" AND nk.ngayTruc <= :denNgay ");
            }

            sql.append(" ORDER BY nk.ngayTruc DESC, nk.id DESC ");

            var query = em.createNativeQuery(sql.toString());
            if (tuNgay != null) query.setParameter("tuNgay", tuNgay);
            if (denNgay != null) query.setParameter("denNgay", denNgay);

            List<Object[]> list = query.getResultList();
            List<Object[]> result = new ArrayList<>();

            DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dateTimeFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            for (Object[] r : list) {
                Object[] row = new Object[9];
                row[0] = r[0]; // id

                LocalDate ngayTruc = null;
                if (r[1] instanceof java.sql.Date) ngayTruc = ((java.sql.Date) r[1]).toLocalDate();
                else if (r[1] instanceof LocalDate) ngayTruc = (LocalDate) r[1];
                row[1] = ngayTruc != null ? ngayTruc.format(dateFormat) : "—";

                row[2] = r[2]; // caTruc
                row[3] = r[3]; // nguoiTruc
                row[4] = r[4]; // noiDung
                row[5] = r[5]; // luuYBanGiao
                row[6] = r[6] != null ? r[6] : "Chưa nhận ca";

                LocalDateTime tgBanGiao = null;
                if (r[7] instanceof java.sql.Timestamp) tgBanGiao = ((java.sql.Timestamp) r[7]).toLocalDateTime();
                else if (r[7] instanceof LocalDateTime) tgBanGiao = (LocalDateTime) r[7];

                row[7] = tgBanGiao != null ? tgBanGiao.format(dateTimeFormat) : "Chưa bàn giao";
                row[8] = tgBanGiao != null; // daBanGiao

                result.add(row);
            }

            return result;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findChamCongCuaToi(int maNhanVien, LocalDate tuNgay, LocalDate denNgay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder sql = new StringBuilder(
                "SELECT cc.ngayLam, cc.caLam, cc.gioVao, cc.gioRa " +
                "FROM dbo.chamCong cc " +
                "WHERE cc.maNhanVien = :mnv "
            );

            if (tuNgay != null) sql.append(" AND cc.ngayLam >= :tuNgay ");
            if (denNgay != null) sql.append(" AND cc.ngayLam <= :denNgay ");
            sql.append(" ORDER BY cc.ngayLam DESC, cc.gioVao DESC ");

            var query = em.createNativeQuery(sql.toString()).setParameter("mnv", maNhanVien);
            if (tuNgay != null) query.setParameter("tuNgay", tuNgay);
            if (denNgay != null) query.setParameter("denNgay", denNgay);

            List<Object[]> list = query.getResultList();
            List<Object[]> result = new ArrayList<>();

            DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");

            for (Object[] r : list) {
                Object[] row = new Object[7];

                // 0: ngayLamText
                LocalDate ngayLam = null;
                if (r[0] instanceof java.sql.Date) ngayLam = ((java.sql.Date) r[0]).toLocalDate();
                else if (r[0] instanceof LocalDate) ngayLam = (LocalDate) r[0];
                row[0] = ngayLam != null ? ngayLam.format(dateFormat) : "—";

                // 1: caLam
                row[1] = r[1];

                // 2: gioVaoText
                LocalDateTime gioVao = null;
                if (r[2] instanceof java.sql.Timestamp) gioVao = ((java.sql.Timestamp) r[2]).toLocalDateTime();
                else if (r[2] instanceof LocalDateTime) gioVao = (LocalDateTime) r[2];
                row[2] = gioVao != null ? gioVao.format(timeFormat) : "";

                // 3: gioRaText
                LocalDateTime gioRa = null;
                if (r[3] instanceof java.sql.Timestamp) gioRa = ((java.sql.Timestamp) r[3]).toLocalDateTime();
                else if (r[3] instanceof LocalDateTime) gioRa = (LocalDateTime) r[3];
                row[3] = gioRa != null ? gioRa.format(timeFormat) : "";

                // 4 & 5 & 6: soGioLamText, trangThaiCa, soGioLamDouble
                String soGioLamText = null;
                Double soGioLamDouble = null;
                String trangThaiCa = "DangTruc";

                if (gioVao != null && gioRa != null) {
                    long phut = java.time.temporal.ChronoUnit.MINUTES.between(gioVao, gioRa);
                    if (phut < 0) {
                        phut += 24 * 60; // ca đêm 22:00-06:00 vắt qua ngày
                    }
                    soGioLamDouble = Math.round((phut / 60.0) * 10.0) / 10.0;
                    soGioLamText = String.format(java.util.Locale.US, "%.1f", soGioLamDouble);
                    trangThaiCa = "HoanThanh";
                } else {
                    soGioLamText = null;
                    trangThaiCa = "DangTruc";
                }

                row[4] = soGioLamText;
                row[5] = trangThaiCa;
                row[6] = soGioLamDouble;

                result.add(row);
            }

            return result;
        } finally {
            em.close();
        }
    }

    public Map<String, Object> thongKeCuaToi(int maNhanVien, LocalDate tuNgay, LocalDate denNgay) {
        List<Object[]> list = findChamCongCuaToi(maNhanVien, tuNgay, denNgay);
        Map<String, Object> stats = new HashMap<>();

        int soNgayCong = list.size();
        double tongGioLam = 0.0;
        int soCaSang = 0;
        int soCaChieu = 0;
        int soCaDem = 0;

        for (Object[] r : list) {
            String caLam = (String) r[1];
            Double hours = (Double) r[6];

            if (hours != null) {
                tongGioLam += hours;
            }

            if ("Sang".equalsIgnoreCase(caLam)) soCaSang++;
            else if ("Chieu".equalsIgnoreCase(caLam)) soCaChieu++;
            else if ("Dem".equalsIgnoreCase(caLam)) soCaDem++;
        }

        stats.put("soNgayCong", soNgayCong);
        stats.put("tongGioLam", Math.round(tongGioLam * 10.0) / 10.0);
        stats.put("soCaSang", soCaSang);
        stats.put("soCaChieu", soCaChieu);
        stats.put("soCaDem", soCaDem);

        return stats;
    }
}
