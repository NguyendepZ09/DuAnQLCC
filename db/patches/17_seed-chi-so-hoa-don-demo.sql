-- Patch 17: Dọn dữ liệu cũ và seed dữ liệu chỉ số / hóa đơn demo sạch
-- Encoding: UTF-8 WITH BOM

-- 1. Dọn sạch dữ liệu cũ đúng thứ tự khóa ngoại
DELETE FROM dbo.chiTietHoaDon;
DELETE FROM dbo.giaoDichThanhToan;
DELETE FROM dbo.hoaDon;
DELETE FROM dbo.chiSoTieuThu;
GO

-- 2. Seed chiSoTieuThu cho đủ 6 căn DangO (id: 1, 2, 6, 9, 18, 35) qua 3 kỳ 5/2026, 6/2026, 7/2026
-- Kỳ 5/2026 (Kỳ gốc)
INSERT INTO dbo.chiSoTieuThu (maCanHo, loaiDichVu, thang, nam, chiSo, ngayGhi) VALUES
(1, 'Dien', 5, 2026, 1000.0, '2026-05-31 23:59:59'),
(1, 'Nuoc', 5, 2026, 100.0,  '2026-05-31 23:59:59'),
(2, 'Dien', 5, 2026, 1200.0, '2026-05-31 23:59:59'),
(2, 'Nuoc', 5, 2026, 150.0,  '2026-05-31 23:59:59'),
(6, 'Dien', 5, 2026, 800.0,  '2026-05-31 23:59:59'),
(6, 'Nuoc', 5, 2026, 80.0,   '2026-05-31 23:59:59'),
(9, 'Dien', 5, 2026, 1500.0, '2026-05-31 23:59:59'),
(9, 'Nuoc', 5, 2026, 200.0,  '2026-05-31 23:59:59'),
(18, 'Dien', 5, 2026, 950.0, '2026-05-31 23:59:59'),
(18, 'Nuoc', 5, 2026, 90.0,  '2026-05-31 23:59:59'),
(35, 'Dien', 5, 2026, 1100.0,'2026-05-31 23:59:59'),
(35, 'Nuoc', 5, 2026, 110.0, '2026-05-31 23:59:59');

-- Kỳ 6/2026 (Chỉ số tăng, Căn 1 tiêu thụ 250 kWh, Căn 9 tiêu thụ 320 kWh chạm Bậc 4)
INSERT INTO dbo.chiSoTieuThu (maCanHo, loaiDichVu, thang, nam, chiSo, ngayGhi) VALUES
(1, 'Dien', 6, 2026, 1250.0, '2026-06-30 23:59:59'),
(1, 'Nuoc', 6, 2026, 118.0,  '2026-06-30 23:59:59'),
(2, 'Dien', 6, 2026, 1380.0, '2026-06-30 23:59:59'),
(2, 'Nuoc', 6, 2026, 165.0,  '2026-06-30 23:59:59'),
(6, 'Dien', 6, 2026, 920.0,  '2026-06-30 23:59:59'),
(6, 'Nuoc', 6, 2026, 90.0,   '2026-06-30 23:59:59'),
(9, 'Dien', 6, 2026, 1820.0, '2026-06-30 23:59:59'),
(9, 'Nuoc', 6, 2026, 224.0,  '2026-06-30 23:59:59'),
(18, 'Dien', 6, 2026, 1100.0,'2026-06-30 23:59:59'),
(18, 'Nuoc', 6, 2026, 102.0, '2026-06-30 23:59:59'),
(35, 'Dien', 6, 2026, 1210.0,'2026-06-30 23:59:59'),
(35, 'Nuoc', 6, 2026, 119.0, '2026-06-30 23:59:59');

-- Kỳ 7/2026 (Chỉ số tiếp tục tăng)
INSERT INTO dbo.chiSoTieuThu (maCanHo, loaiDichVu, thang, nam, chiSo, ngayGhi) VALUES
(1, 'Dien', 7, 2026, 1520.0, '2026-07-31 23:59:59'),
(1, 'Nuoc', 7, 2026, 139.0,  '2026-07-31 23:59:59'),
(2, 'Dien', 7, 2026, 1590.0, '2026-07-31 23:59:59'),
(2, 'Nuoc', 7, 2026, 182.0,  '2026-07-31 23:59:59'),
(6, 'Dien', 7, 2026, 1060.0, '2026-07-31 23:59:59'),
(6, 'Nuoc', 7, 2026, 101.0,  '2026-07-31 23:59:59'),
(9, 'Dien', 7, 2026, 2170.0, '2026-07-31 23:59:59'),
(9, 'Nuoc', 7, 2026, 249.0,  '2026-07-31 23:59:59'),
(18, 'Dien', 7, 2026, 1260.0,'2026-07-31 23:59:59'),
(18, 'Nuoc', 7, 2026, 115.0, '2026-07-31 23:59:59'),
(35, 'Dien', 7, 2026, 1340.0,'2026-07-31 23:59:59'),
(35, 'Nuoc', 7, 2026, 129.0, '2026-07-31 23:59:59');
GO

-- 3. Thực thi xuất hóa đơn cho Tháng 6 và Tháng 7 năm 2026
EXEC dbo.sp_XuatHoaDonHangLoat 6, 2026;
EXEC dbo.sp_XuatHoaDonHangLoat 7, 2026;
GO

-- 4. Đánh dấu hóa đơn Tháng 6/2026 là DaThanhToan
UPDATE dbo.hoaDon SET trangThaiThanhToan = N'DaThanhToan' WHERE thang = 6 AND nam = 2026;
GO
