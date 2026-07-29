package dao;

import entity.NhatKyCaTruc;
import entity.NhatKyTuanTra;
import util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class BaoVeDAO {

    // =========================================================================
    // 1. TUẦN TRA
    // =========================================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> findTuanTraTheoNgay(int maBaoVe, LocalDate ngay) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, soTang, thoiGianQuet, anhMinhChung " +
                         "FROM dbo.nhatKyTuanTra " +
                         "WHERE maBaoVe = :maBaoVe AND CAST(thoiGianQuet AS DATE) = :ngay " +
                         "ORDER BY thoiGianQuet DESC";
            return em.createNativeQuery(sql)
                    .setParameter("maBaoVe", maBaoVe)
                    .setParameter("ngay", java.sql.Date.valueOf(ngay))
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Integer> findTangChuaTuanTra24h() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT n.soTang FROM (SELECT TOP 25 ROW_NUMBER() OVER (ORDER BY object_id) AS soTang FROM sys.objects) n " +
                         "WHERE NOT EXISTS (" +
                         "    SELECT 1 FROM dbo.nhatKyTuanTra t " +
                         "    WHERE t.soTang = n.soTang AND t.thoiGianQuet >= DATEADD(HOUR, -24, GETDATE())" +
                         ") ORDER BY n.soTang DESC";
            List<Number> list = em.createNativeQuery(sql).getResultList();
            List<Integer> result = new ArrayList<>();
            for (Number num : list) {
                result.add(num.intValue());
            }
            return result;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public String ghiNhanTuanTra(int maBaoVe, int soTang, String anhMinhChung) {
        if (soTang < 1 || soTang > 25) {
            return "Số tầng phải từ 1 đến 25.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Anti-spam check: check if THIS guard scanned THIS floor within last 15 mins
            String sqlCheck = "SELECT TOP 1 thoiGianQuet FROM dbo.nhatKyTuanTra " +
                              "WHERE maBaoVe = :maBaoVe AND soTang = :soTang AND thoiGianQuet >= DATEADD(MINUTE, -15, GETDATE()) " +
                              "ORDER BY thoiGianQuet DESC";
            List<Object> recentList = em.createNativeQuery(sqlCheck)
                    .setParameter("maBaoVe", maBaoVe)
                    .setParameter("soTang", soTang)
                    .getResultList();

            if (!recentList.isEmpty()) {
                Object lastTime = recentList.get(0);
                String formattedTime = "";
                if (lastTime instanceof java.sql.Timestamp) {
                    formattedTime = new java.text.SimpleDateFormat("HH:mm").format((java.sql.Timestamp) lastTime);
                } else {
                    formattedTime = lastTime.toString();
                }
                return "Tầng " + soTang + " vừa được bạn quét lúc " + formattedTime + ".";
            }

            tx.begin();
            NhatKyTuanTra t = new NhatKyTuanTra();
            t.setMaBaoVe(maBaoVe);
            t.setSoTang(soTang);
            t.setThoiGianQuet(LocalDateTime.now());
            if (anhMinhChung != null && !anhMinhChung.trim().isEmpty()) {
                t.setAnhMinhChung(anhMinhChung.trim());
            }
            em.persist(t);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[BaoVeDAO] ghiNhanTuanTra FAILED: " + msg);
            return "Lỗi khi ghi nhận tuần tra: " + msg;
        } finally {
            em.close();
        }
    }

    // =========================================================================
    // 2. CA TRỰC & BÀN GIAO
    // =========================================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> findCaTrucCuaToi(int maBaoVe) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT c.id, c.caTruc, c.ngayTruc, c.noiDung, c.luuYBanGiao, c.maNguoiNhanCa, nv.hoTen AS tenNguoiNhan, c.thoiGianBanGiao " +
                         "FROM dbo.nhatKyCaTruc c " +
                         "LEFT JOIN dbo.nhanVien nv ON nv.id = c.maNguoiNhanCa " +
                         "WHERE c.maBaoVe = :maBaoVe AND c.ngayTruc >= DATEADD(DAY, -30, GETDATE()) " +
                         "ORDER BY c.ngayTruc DESC, c.id DESC";
            List<Object[]> rawList = em.createNativeQuery(sql)
                    .setParameter("maBaoVe", maBaoVe)
                    .getResultList();

            List<Object[]> result = new ArrayList<>();
            DateTimeFormatter dtfDate = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dtfTime = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

            for (Object[] r : rawList) {
                Object[] row = new Object[10];
                row[0] = r[0]; // id
                row[1] = r[1]; // caTruc
                row[2] = r[2]; // ngayTruc raw
                row[3] = r[3]; // noiDung
                row[4] = r[4]; // luuYBanGiao
                row[5] = r[5]; // maNguoiNhanCa
                row[6] = r[6]; // tenNguoiNhan
                row[7] = r[7]; // thoiGianBanGiao raw

                // Pre-compute boolean coTheBanGiao (chua ban giao)
                boolean coTheBanGiao = (r[7] == null);
                row[8] = coTheBanGiao;

                // Formatted ngayTruc string
                String ngayFmt = "";
                if (r[2] instanceof java.sql.Date) {
                    ngayFmt = ((java.sql.Date) r[2]).toLocalDate().format(dtfDate);
                } else if (r[2] != null) {
                    ngayFmt = r[2].toString();
                }
                row[9] = ngayFmt;

                result.add(row);
            }
            return result;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findCaTrucChoNhanBanGiao(int maBaoVe) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT c.id, c.maBaoVe, nvGiao.hoTen AS tenBaoVeGiao, c.caTruc, c.ngayTruc, c.noiDung, c.luuYBanGiao, c.thoiGianBanGiao " +
                         "FROM dbo.nhatKyCaTruc c " +
                         "JOIN dbo.nhanVien nvGiao ON nvGiao.id = c.maBaoVe " +
                         "WHERE c.maNguoiNhanCa = :maBaoVe AND c.thoiGianBanGiao IS NOT NULL " +
                         "ORDER BY c.thoiGianBanGiao DESC";
            List<Object[]> rawList = em.createNativeQuery(sql)
                    .setParameter("maBaoVe", maBaoVe)
                    .getResultList();

            List<Object[]> result = new ArrayList<>();
            DateTimeFormatter dtfDate = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dtfTime = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");

            for (Object[] r : rawList) {
                Object[] row = new Object[10];
                row[0] = r[0]; // id
                row[1] = r[1]; // maBaoVe
                row[2] = r[2]; // tenBaoVeGiao
                row[3] = r[3]; // caTruc
                row[4] = r[4]; // ngayTruc raw
                row[5] = r[5]; // noiDung
                row[6] = r[6]; // luuYBanGiao
                row[7] = r[7]; // thoiGianBanGiao raw

                String ngayFmt = "";
                if (r[4] instanceof java.sql.Date) {
                    ngayFmt = ((java.sql.Date) r[4]).toLocalDate().format(dtfDate);
                } else if (r[4] != null) {
                    ngayFmt = r[4].toString();
                }
                row[8] = ngayFmt;

                String banGiaoFmt = "";
                if (r[7] instanceof java.sql.Timestamp) {
                    banGiaoFmt = new java.text.SimpleDateFormat("HH:mm dd/MM/yyyy").format((java.sql.Timestamp) r[7]);
                } else if (r[7] != null) {
                    banGiaoFmt = r[7].toString();
                }
                row[9] = banGiaoFmt;

                result.add(row);
            }
            return result;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public String ghiNhatKyCaTruc(int maBaoVe, String caTruc, LocalDate ngayTruc, String noiDung) {
        if (caTruc == null || (!caTruc.equals("Sang") && !caTruc.equals("Chieu") && !caTruc.equals("Dem"))) {
            return "Ca trực phải là 'Sang', 'Chieu' hoặc 'Dem'.";
        }
        if (ngayTruc == null || ngayTruc.isAfter(LocalDate.now().plusDays(1))) {
            return "Ngày trực không hợp lệ hoặc quá tương lai.";
        }
        if (noiDung == null || noiDung.trim().isEmpty()) {
            return "Vui lòng nhập nội dung nhật ký ca trực.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // Check UQ_caTruc (maBaoVe, caTruc, ngayTruc)
            String sqlCheck = "SELECT COUNT(*) FROM dbo.nhatKyCaTruc WHERE maBaoVe = :maBaoVe AND caTruc = :caTruc AND ngayTruc = :ngayTruc";
            Number count = (Number) em.createNativeQuery(sqlCheck)
                    .setParameter("maBaoVe", maBaoVe)
                    .setParameter("caTruc", caTruc)
                    .setParameter("ngayTruc", java.sql.Date.valueOf(ngayTruc))
                    .getSingleResult();

            if (count != null && count.intValue() > 0) {
                return "Bạn đã ghi nhật ký ca này trong ngày rồi.";
            }

            tx.begin();
            NhatKyCaTruc ca = new NhatKyCaTruc();
            ca.setMaBaoVe(maBaoVe);
            ca.setCaTruc(caTruc);
            ca.setNgayTruc(ngayTruc);
            ca.setNoiDung(noiDung.trim());
            em.persist(ca);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[BaoVeDAO] ghiNhatKyCaTruc FAILED: " + msg);
            if (msg.contains("UQ_caTruc") || msg.contains("UNIQUE")) {
                return "Bạn đã ghi nhật ký ca này trong ngày rồi.";
            }
            return "Lỗi khi ghi nhật ký ca trực: " + msg;
        } finally {
            em.close();
        }
    }

    public String banGiaoCa(int maCaTruc, int maBaoVeHienTai, int maNguoiNhanCa, String luuYBanGiao) {
        if (maNguoiNhanCa == maBaoVeHienTai) {
            return "Người nhận ca phải khác bảo vệ giao ca.";
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            NhatKyCaTruc ca = em.find(NhatKyCaTruc.class, maCaTruc);
            if (ca == null) {
                return "Không tìm thấy nhật ký ca trực.";
            }

            // IDOR Protection: Check if this shift belongs to current guard
            if (ca.getMaBaoVe() == null || ca.getMaBaoVe() != maBaoVeHienTai) {
                return "Bạn không có quyền bàn giao ca trực của người khác.";
            }

            // Anti-double handover check
            if (ca.getThoiGianBanGiao() != null) {
                String formatted = ca.getThoiGianBanGiao().format(DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));
                return "Ca này đã được bàn giao lúc " + formatted + ".";
            }

            // Validate maNguoiNhanCa is in department 'BaoVe'
            String sqlCheckNV = "SELECT COUNT(*) FROM dbo.nhanVien WHERE id = :id AND boPhan = 'BaoVe'";
            Number countNV = (Number) em.createNativeQuery(sqlCheckNV)
                    .setParameter("id", maNguoiNhanCa)
                    .getSingleResult();
            if (countNV == null || countNV.intValue() == 0) {
                return "Nhân viên nhận ca không phải là Bảo vệ hợp lệ.";
            }

            tx.begin();
            ca.setMaNguoiNhanCa(maNguoiNhanCa);
            ca.setLuuYBanGiao(luuYBanGiao != null ? luuYBanGiao.trim() : null);
            ca.setThoiGianBanGiao(LocalDateTime.now());
            em.merge(ca);
            tx.commit();
            return null; // Success
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            String msg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[BaoVeDAO] banGiaoCa FAILED: " + msg);
            return "Lỗi khi bàn giao ca: " + msg;
        } finally {
            em.close();
        }
    }

    @SuppressWarnings("unchecked")
    public List<Object[]> findDanhSachBaoVeKhac(int maBaoVeHienTai) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, hoTen, soDienThoai FROM dbo.nhanVien " +
                         "WHERE boPhan = 'BaoVe' AND id <> :id " +
                         "ORDER BY hoTen";
            return em.createNativeQuery(sql)
                    .setParameter("id", maBaoVeHienTai)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    // =========================================================================
    // 3. CHẤM CÔNG & DASHBOARD
    // =========================================================================

    @SuppressWarnings("unchecked")
    public List<Object[]> findChamCongCuaToi(int maNhanVien) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String sql = "SELECT id, ngayLam, gioVao, gioRa, caLam " +
                         "FROM dbo.chamCong " +
                         "WHERE maNhanVien = :maNhanVien AND ngayLam >= DATEADD(DAY, -30, GETDATE()) " +
                         "ORDER BY ngayLam DESC, id DESC";
            return em.createNativeQuery(sql)
                    .setParameter("maNhanVien", maNhanVien)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Map<String, Object> thongKeDashboardBaoVe(int maBaoVe) {
        EntityManager em = JPAUtil.getEntityManager();
        Map<String, Object> map = new HashMap<>();
        try {
            // 1. Số lượt tuần tra hôm nay của tôi
            String sql1 = "SELECT COUNT(*) FROM dbo.nhatKyTuanTra WHERE maBaoVe = :maBaoVe AND CAST(thoiGianQuet AS DATE) = CAST(GETDATE() AS DATE)";
            Number count1 = (Number) em.createNativeQuery(sql1).setParameter("maBaoVe", maBaoVe).getSingleResult();
            map.put("luotTuanTraHomNay", count1 != null ? count1.intValue() : 0);

            // 2. Số tầng chưa tuần tra trong 24h qua
            List<Integer> tangChuaTuanTra = findTangChuaTuanTra24h();
            map.put("tangChuaTuanTraCount", tangChuaTuanTra.size());
            map.put("tangChuaTuanTraList", tangChuaTuanTra);

            // 3. Ca trực đang mở (gioRa NULL trong chamCong hôm nay)
            String sql3 = "SELECT COUNT(*) FROM dbo.chamCong WHERE maNhanVien = :maBaoVe AND gioRa IS NULL";
            Number count3 = (Number) em.createNativeQuery(sql3).setParameter("maBaoVe", maBaoVe).getSingleResult();
            map.put("caTrucDangMo", count3 != null ? count3.intValue() : 0);

            // 4. Số ca chờ tôi nhận bàn giao
            String sql4 = "SELECT COUNT(*) FROM dbo.nhatKyCaTruc WHERE maNguoiNhanCa = :maBaoVe AND thoiGianBanGiao IS NOT NULL";
            Number count4 = (Number) em.createNativeQuery(sql4).setParameter("maBaoVe", maBaoVe).getSingleResult();
            map.put("caChoNhanBanGiaoCount", count4 != null ? count4.intValue() : 0);

            // 5. Bảng 5 lượt tuần tra gần nhất của tôi
            String sql5 = "SELECT TOP 5 id, soTang, thoiGianQuet, anhMinhChung FROM dbo.nhatKyTuanTra WHERE maBaoVe = :maBaoVe ORDER BY thoiGianQuet DESC";
            @SuppressWarnings("unchecked")
            List<Object[]> top5 = em.createNativeQuery(sql5).setParameter("maBaoVe", maBaoVe).getResultList();
            
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
            List<Object[]> top5Fmt = new ArrayList<>();
            for (Object[] r : top5) {
                Object[] row = new Object[4];
                row[0] = r[0]; // id
                row[1] = r[1]; // soTang
                String timeStr = "";
                if (r[2] instanceof java.sql.Timestamp) {
                    timeStr = new java.text.SimpleDateFormat("HH:mm:ss dd/MM/yyyy").format((java.sql.Timestamp) r[2]);
                } else if (r[2] != null) {
                    timeStr = r[2].toString();
                }
                row[2] = timeStr; // thoiGianQuet string
                row[3] = r[3]; // anhMinhChung
                top5Fmt.add(row);
            }
            map.put("top5TuanTra", top5Fmt);

            return map;
        } finally {
            em.close();
        }
    }
}
