-- =======================================================================
-- PATCH 19: RÀNG BUỘC VÀ SEED DỮ LIỆU BẢO VỆ
-- DỰ ÁN: PolyBuilding (QLCC) — SQL Server
-- ENCODING: UTF-8 WITH BOM
-- =======================================================================

USE QLCCNew2;
GO

-- Xóa dữ liệu cũ của các bảng Bảo vệ trước khi gắn CHECK constraint mới
DELETE FROM dbo.theTu_ChucNang;
DELETE FROM dbo.quanLyXe;
DELETE FROM dbo.theTu;
DELETE FROM dbo.nhatKyTuanTra;
DELETE FROM dbo.nhatKyCaTruc;
DELETE FROM dbo.chamCong;
GO

-- =======================================================================
-- PHẦN 1 — DROP DUPLICATE CONSTRAINTS & ADD CHECK CONSTRAINTS
-- =======================================================================

-- 1. Xóa 2 UNIQUE constraint trùng lặp lỡ tạo ở Patch 14
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'UQ_chiSoTieuThu_maCanHo_loaiDichVu_thang_nam' AND type = 'UQ')
BEGIN
    ALTER TABLE dbo.chiSoTieuThu DROP CONSTRAINT UQ_chiSoTieuThu_maCanHo_loaiDichVu_thang_nam;
END
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'UQ_hoaDon_maCanHo_thang_nam' AND type = 'UQ')
BEGIN
    ALTER TABLE dbo.hoaDon DROP CONSTRAINT UQ_hoaDon_maCanHo_thang_nam;
END
GO

-- 2. Thêm CHECK constraints cho các bảng Bảo vệ (Bọc IF NOT EXISTS)
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_nhatKyCaTruc_caTruc')
BEGIN
    ALTER TABLE dbo.nhatKyCaTruc WITH CHECK ADD CONSTRAINT CK_nhatKyCaTruc_caTruc CHECK (caTruc IN ('Sang','Chieu','Dem'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chamCong_caLam')
BEGIN
    ALTER TABLE dbo.chamCong WITH CHECK ADD CONSTRAINT CK_chamCong_caLam CHECK (caLam IN ('Sang','Chieu','Dem'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_theTuChucNang_chucNang')
BEGIN
    ALTER TABLE dbo.theTu_ChucNang WITH CHECK ADD CONSTRAINT CK_theTuChucNang_chucNang CHECK (chucNang IN ('CuaChinh','ThangMay','BaiXeOTo','BaiXeMay','HoBoi','PhongGym'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_nhatKyTuanTra_soTang')
BEGIN
    ALTER TABLE dbo.nhatKyTuanTra WITH CHECK ADD CONSTRAINT CK_nhatKyTuanTra_soTang CHECK (soTang BETWEEN 1 AND 25);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_theTu_ngayHetHan')
BEGIN
    ALTER TABLE dbo.theTu WITH CHECK ADD CONSTRAINT CK_theTu_ngayHetHan CHECK (ngayHetHan IS NULL OR ngayHetHan > ngayCap);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chamCong_gioRa')
BEGIN
    ALTER TABLE dbo.chamCong WITH CHECK ADD CONSTRAINT CK_chamCong_gioRa CHECK (gioRa IS NULL OR gioRa > gioVao);
END
GO

-- =======================================================================
-- PHẦN 2 — SEED DỮ LIỆU DEMO BẢO VỆ & THẺ TỪ / QUẢN LÝ XE
-- =======================================================================

-- 2a. Seed 8 Thẻ Từ (theTu)
INSERT INTO dbo.theTu (maCanHo, maCuDan, soThe, ngayCap, ngayHetHan, trangThai)
VALUES 
(1,  2,  'THE-0101-01', '2025-01-15', '2027-01-15', 'DangSuDung'),
(1,  3,  'THE-0101-02', '2025-08-01', '2027-08-01', 'TamKhoa'),
(2,  8,  'THE-0102-01', '2025-02-01', '2027-02-01', 'DangSuDung'),
(2,  8,  'THE-0102-02', '2024-01-01', '2026-01-01', 'DaThuHoi'),
(6,  12, 'THE-0106-01', '2025-03-10', '2027-03-10', 'DangSuDung'),
(9,  9,  'THE-0201-01', '2025-04-15', '2027-04-15', 'DangSuDung'),
(18, 10, 'THE-0302-01', '2025-05-20', '2027-05-20', 'DangSuDung'),
(35, 11, 'THE-0503-01', '2025-06-01', '2027-06-01', 'DangSuDung');
GO

-- 2b. Seed Chức năng thẻ từ (theTu_ChucNang)
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'CuaChinh' FROM dbo.theTu WHERE trangThai = 'DangSuDung';
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'ThangMay' FROM dbo.theTu WHERE trangThai = 'DangSuDung';
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'BaiXeOTo' FROM dbo.theTu WHERE soThe IN ('THE-0101-01', 'THE-0106-01', 'THE-0302-01');
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'BaiXeMay' FROM dbo.theTu WHERE soThe IN ('THE-0101-02', 'THE-0102-01', 'THE-0201-01', 'THE-0503-01');
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'HoBoi' FROM dbo.theTu WHERE soThe IN ('THE-0101-01', 'THE-0302-01');
INSERT INTO dbo.theTu_ChucNang (maThe, chucNang)
SELECT id, N'PhongGym' FROM dbo.theTu WHERE soThe IN ('THE-0101-01', 'THE-0503-01');
GO

-- 2c. Seed 9 Xe (quanLyXe)
DECLARE @the0101_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0101-01');
DECLARE @the0101_02 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0101-02');
DECLARE @the0102_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0102-01');
DECLARE @the0106_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0106-01');
DECLARE @the0201_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0201-01');
DECLARE @the0302_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0302-01');
DECLARE @the0503_01 INT = (SELECT id FROM dbo.theTu WHERE soThe = 'THE-0503-01');

INSERT INTO dbo.quanLyXe (maCanHo, maThe, bienSoXe, loaiXe)
VALUES 
(1,  @the0101_01, '30A-123.45', 'OTo'),
(1,  @the0101_02, '29H1-678.90', 'XeMay'),
(2,  @the0102_01, '30F-456.78', 'OTo'),
(2,  NULL,        '29K1-112.23', 'XeMay'),
(6,  @the0106_01, '30E-888.99', 'OTo'),
(9,  @the0201_01, '29P1-334.45', 'XeMay'),
(18, @the0302_01, '30G-999.11', 'OTo'),
(35, NULL,        'XD-0503-01', 'XeDap'),
(35, @the0503_01, '29M1-556.67', 'XeMay');
GO

-- 2d. Seed Chấm Công (chamCong) — 3 bảo vệ x 7 ngày (2026-07-22 -> 2026-07-28)
INSERT INTO dbo.chamCong (maNhanVien, ngayLam, gioVao, gioRa, caLam)
VALUES
-- Bảo vệ 7 (Hung)
(7, '2026-07-22', '2026-07-22 06:00:00', '2026-07-22 14:00:00', 'Sang'),
(7, '2026-07-23', '2026-07-23 14:00:00', '2026-07-23 22:00:00', 'Chieu'),
(7, '2026-07-24', '2026-07-24 22:00:00', '2026-07-25 06:00:00', 'Dem'),
(7, '2026-07-25', '2026-07-25 06:00:00', '2026-07-25 14:00:00', 'Sang'),
(7, '2026-07-26', '2026-07-26 14:00:00', '2026-07-26 22:00:00', 'Chieu'),
(7, '2026-07-27', '2026-07-27 22:00:00', '2026-07-28 06:00:00', 'Dem'),
(7, '2026-07-28', '2026-07-28 06:00:00', '2026-07-28 14:00:00', 'Sang'),

-- Bảo vệ 8 (Tuan)
(8, '2026-07-22', '2026-07-22 14:00:00', '2026-07-22 22:00:00', 'Chieu'),
(8, '2026-07-23', '2026-07-23 22:00:00', '2026-07-24 06:00:00', 'Dem'),
(8, '2026-07-24', '2026-07-24 06:00:00', '2026-07-24 14:00:00', 'Sang'),
(8, '2026-07-25', '2026-07-25 14:00:00', '2026-07-25 22:00:00', 'Chieu'),
(8, '2026-07-26', '2026-07-26 22:00:00', '2026-07-27 06:00:00', 'Dem'),
(8, '2026-07-27', '2026-07-27 06:00:00', '2026-07-27 14:00:00', 'Sang'),
(8, '2026-07-28', '2026-07-28 14:00:00', NULL,                  'Chieu'), -- Trực dở 1

-- Bảo vệ 9 (Son)
(9, '2026-07-22', '2026-07-22 22:00:00', '2026-07-23 06:00:00', 'Dem'),
(9, '2026-07-23', '2026-07-23 06:00:00', '2026-07-23 14:00:00', 'Sang'),
(9, '2026-07-24', '2026-07-24 14:00:00', '2026-07-24 22:00:00', 'Chieu'),
(9, '2026-07-25', '2026-07-25 22:00:00', '2026-07-26 06:00:00', 'Dem'),
(9, '2026-07-26', '2026-07-26 06:00:00', '2026-07-26 14:00:00', 'Sang'),
(9, '2026-07-27', '2026-07-27 14:00:00', '2026-07-27 22:00:00', 'Chieu'),
(9, '2026-07-28', '2026-07-28 22:00:00', NULL,                  'Dem');  -- Trực dở 2
GO

-- 2e. Seed Nhật Ký Ca Trực (nhatKyCaTruc) — 6 bản ghi
INSERT INTO dbo.nhatKyCaTruc (maBaoVe, caTruc, ngayTruc, noiDung, luuYBanGiao, maNguoiNhanCa, thoiGianBanGiao)
VALUES
(7, 'Sang',  '2026-07-22', N'Tuần tra định kỳ sảnh chính và tầng hầm, không phát hiện bất thường.', N'Bàn giao bộ đàm và chìa khóa phòng kỹ thuật', 8, '2026-07-22 14:05:00'),
(8, 'Chieu', '2026-07-23', N'Tình hình an ninh ca chiều ổn định, hỗ trợ cư dân nhận bưu kiện.', N'Bàn giao sổ trực ca chiều', 9, '2026-07-23 22:10:00'),
(9, 'Dem',   '2026-07-24', N'Ca đêm êm sảnh, hệ thống camera hoạt động tốt.', N'Cửa sảnh chính đã khóa an toàn', 7, '2026-07-25 06:00:00'),
(7, 'Sang',  '2026-07-26', N'Kiểm tra công tác PCCC tầng 1-10, tình hình bình thường.', NULL, NULL, NULL),
(8, 'Chieu', '2026-07-27', N'Điều phối bãi xe ca chiều giờ cao điểm thông thoáng.', NULL, NULL, NULL),
(9, 'Dem',   '2026-07-28', N'Trực ca đêm an ninh tòa nhà, tuần tra tầng trệt và bãi xe.', NULL, NULL, NULL);
GO

-- 2f. Seed Nhật Ký Tuần Tra (nhatKyTuanTra) — 42 bản ghi
-- Rải qua 3 bảo vệ, tầng 1..19 có quét trong 24h qua, tầng 20..25 KHÔNG quét trong 24h qua để màn hình cảnh báo có dữ liệu
INSERT INTO dbo.nhatKyTuanTra (maBaoVe, soTang, thoiGianQuet, anhMinhChung)
VALUES
-- Tuần tra ngày 2026-07-22 -> 2026-07-27 (các ca cũ)
(7, 1,  '2026-07-22 08:30:00', 'assets/tuan-tra/tang01.jpg'),
(7, 2,  '2026-07-22 08:45:00', 'assets/tuan-tra/tang02.jpg'),
(7, 3,  '2026-07-22 09:00:00', 'assets/tuan-tra/tang03.jpg'),
(7, 4,  '2026-07-22 09:15:00', 'assets/tuan-tra/tang04.jpg'),
(7, 5,  '2026-07-22 09:30:00', 'assets/tuan-tra/tang05.jpg'),
(8, 6,  '2026-07-23 15:00:00', 'assets/tuan-tra/tang06.jpg'),
(8, 7,  '2026-07-23 15:20:00', 'assets/tuan-tra/tang07.jpg'),
(8, 8,  '2026-07-23 15:40:00', 'assets/tuan-tra/tang08.jpg'),
(8, 9,  '2026-07-23 16:00:00', 'assets/tuan-tra/tang09.jpg'),
(8, 10, '2026-07-23 16:20:00', 'assets/tuan-tra/tang10.jpg'),
(9, 11, '2026-07-24 23:00:00', 'assets/tuan-tra/tang11.jpg'),
(9, 12, '2026-07-24 23:20:00', 'assets/tuan-tra/tang12.jpg'),
(9, 13, '2026-07-24 23:40:00', 'assets/tuan-tra/tang13.jpg'),
(9, 14, '2026-07-25 00:00:00', 'assets/tuan-tra/tang14.jpg'),
(9, 15, '2026-07-25 00:20:00', 'assets/tuan-tra/tang15.jpg'),
(7, 16, '2026-07-26 10:00:00', 'assets/tuan-tra/tang16.jpg'),
(7, 17, '2026-07-26 10:20:00', 'assets/tuan-tra/tang17.jpg'),
(7, 18, '2026-07-26 10:40:00', 'assets/tuan-tra/tang18.jpg'),
(7, 19, '2026-07-26 11:00:00', 'assets/tuan-tra/tang19.jpg'),
(7, 20, '2026-07-26 11:20:00', 'assets/tuan-tra/tang20.jpg'),
(8, 21, '2026-07-27 17:00:00', 'assets/tuan-tra/tang21.jpg'),
(8, 22, '2026-07-27 17:20:00', 'assets/tuan-tra/tang22.jpg'),
(8, 23, '2026-07-27 17:40:00', 'assets/tuan-tra/tang23.jpg'),
(8, 24, '2026-07-27 18:00:00', 'assets/tuan-tra/tang24.jpg'),
(8, 25, '2026-07-27 18:20:00', 'assets/tuan-tra/tang25.jpg'),

-- Tuần tra TRONG 24H GẦN NHẤT (Tầng 1 -> 19)
(7, 1,  GETDATE(), 'assets/tuan-tra/tang01_now.jpg'),
(7, 2,  GETDATE(), 'assets/tuan-tra/tang02_now.jpg'),
(7, 3,  GETDATE(), 'assets/tuan-tra/tang03_now.jpg'),
(7, 4,  GETDATE(), 'assets/tuan-tra/tang04_now.jpg'),
(7, 5,  GETDATE(), 'assets/tuan-tra/tang05_now.jpg'),
(8, 6,  GETDATE(), 'assets/tuan-tra/tang06_now.jpg'),
(8, 7,  GETDATE(), 'assets/tuan-tra/tang07_now.jpg'),
(8, 8,  GETDATE(), 'assets/tuan-tra/tang08_now.jpg'),
(8, 9,  GETDATE(), 'assets/tuan-tra/tang09_now.jpg'),
(8, 10, GETDATE(), 'assets/tuan-tra/tang10_now.jpg'),
(9, 11, GETDATE(), 'assets/tuan-tra/tang11_now.jpg'),
(9, 12, GETDATE(), 'assets/tuan-tra/tang12_now.jpg'),
(9, 13, GETDATE(), 'assets/tuan-tra/tang13_now.jpg'),
(9, 14, GETDATE(), 'assets/tuan-tra/tang14_now.jpg'),
(9, 15, GETDATE(), 'assets/tuan-tra/tang15_now.jpg'),
(7, 16, GETDATE(), 'assets/tuan-tra/tang16_now.jpg'),
(7, 19, GETDATE(), 'assets/tuan-tra/tang19_now.jpg');
GO
