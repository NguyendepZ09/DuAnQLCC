-- ============================================================================
-- Patch 02: Dọn dẹp dữ liệu rác & Sửa bản ghi hỏng dấu tiếng Việt
-- SQL Server Database QLCCNew2
-- ============================================================================

USE QLCCNew2;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- ----------------------------------------------------------------------------
-- 1. SỬA CÁC BẢN GHI VĂN BẢN TIẾNG VIỆT
-- ----------------------------------------------------------------------------

-- A. Bảng cuDan
UPDATE cuDan SET hoTen = N'Trần Văn An' WHERE id = 2;
UPDATE cuDan SET hoTen = N'Trần Lê Nguyễn' WHERE id = 3;

-- B. Bảng nhanVien
UPDATE nhanVien SET hoTen = N'Nguyễn Admin', boPhan = N'Ban Quản Lý' WHERE id = 10;

-- C. Bảng thongBao
UPDATE thongBao SET tieuDe = N'Bảo trì máy lạnh', loaiThongBao = N'Bảo trì định kỳ' WHERE id = 2;
UPDATE thongBao SET tieuDe = N'Bảo trì thang máy', loaiThongBao = N'Bảo trì định kỳ' WHERE id = 3;
UPDATE thongBao SET tieuDe = N'Vỡ ống nước', loaiThongBao = N'Thông thường' WHERE id = 10;

-- D. Bảng phanAnhSuCo
UPDATE phanAnhSuCo SET tieuDe = N'Rò rỉ nước bồn rửa bếp', loaiSuCo = N'Đường nước' WHERE id = 4 OR id = 7;
UPDATE phanAnhSuCo SET tieuDe = N'Đèn hành hành lang chập chờn', loaiSuCo = N'Thiết bị điện' WHERE id = 5;
UPDATE phanAnhSuCo SET tieuDe = N'Cửa thang thoát hiểm kẹt', loaiSuCo = N'Cơ sở vật chất' WHERE id = 6;
UPDATE phanAnhSuCo SET tieuDe = N'Camera hầm B2 mất tín hiệu', loaiSuCo = N'Camera' WHERE id = 8;
UPDATE phanAnhSuCo SET tieuDe = N'Đèn hành lang tầng 1 chập chờn', loaiSuCo = N'Điện' WHERE id = 9;
UPDATE phanAnhSuCo SET tieuDe = N'Cửa thang thoát hiểm tầng 3 kẹt', loaiSuCo = N'Cơ khí' WHERE id = 10;


-- ----------------------------------------------------------------------------
-- 2. XOÁ DỮ LIỆU TEST RÁC
-- ----------------------------------------------------------------------------

-- A. Xóa binhChon & phuongAnBinhChon thuộc thông báo rác
DELETE FROM phuongAnBinhChon WHERE maBinhChon IN (SELECT id FROM binhChon WHERE maThongBao IN (1, 4, 5, 11, 12, 13, 14));
DELETE FROM phieuBau WHERE maBinhChon IN (SELECT id FROM binhChon WHERE maThongBao IN (1, 4, 5, 11, 12, 13, 14));
DELETE FROM binhChon WHERE maThongBao IN (1, 4, 5, 11, 12, 13, 14);

-- B. Bảng binhChon & phuongAnBinhChon liên quan trực tiếp id 3, 4
DELETE FROM phuongAnBinhChon WHERE maBinhChon IN (3, 4);
DELETE FROM phieuBau WHERE maBinhChon IN (3, 4);
DELETE FROM binhChon WHERE id IN (3, 4);

-- C. Bảng thongBao rác (Xóa các ID test rác 1, 4, 5, 11, 12, 13, 14)
DELETE FROM thongBao_DaDoc WHERE maThongBao IN (1, 4, 5, 11, 12, 13, 14);
DELETE FROM thongBao WHERE id IN (1, 4, 5, 11, 12, 13, 14);

-- D. Bảng cuDan rác
DELETE FROM cuDan WHERE id IN (5, 6, 7);

PRINT 'Patch 02_don-du-lieu-rac.sql executed successfully!';
GO
