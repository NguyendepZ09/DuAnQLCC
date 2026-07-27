-- ============================================================================
-- Patch 08: Chuẩn hóa Enum phanAnhSuCo.trangThai & Xóa 2 bình chọn rác id 7, 8
-- SQL Server Database QLCCNew2
-- ============================================================================

USE QLCCNew2;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

-- 1. Chuẩn hóa giá trị phanAnhSuCo.trangThai về 5 mã ASCII chuẩn:
--    ('MoiTiepNhan', 'DaTiepNhan', 'DangXuLy', 'HoanThanh', 'Huy')
UPDATE phanAnhSuCo SET trangThai = 'MoiTiepNhan' WHERE trangThai IN ('ChuaXuLy', N'Chưa xử lý', N'Mới tiếp nhận', N'Chờ tiếp nhận');
UPDATE phanAnhSuCo SET trangThai = 'HoanThanh'  WHERE trangThai IN ('HoanTat', N'Hoàn tất', N'Hoàn thành');
UPDATE phanAnhSuCo SET trangThai = 'DangXuLy'   WHERE trangThai IN (N'Đang xử lý');

-- Drop existing constraint if present
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_phanAnhSuCo_trangThai')
    ALTER TABLE phanAnhSuCo DROP CONSTRAINT CK_phanAnhSuCo_trangThai;

-- Thêm CHECK Constraint đảm bảo không bao giờ nhập giá trị ngoài Enum
ALTER TABLE phanAnhSuCo ADD CONSTRAINT CK_phanAnhSuCo_trangThai 
CHECK (trangThai IN ('MoiTiepNhan', 'DaTiepNhan', 'DangXuLy', 'HoanThanh', 'Huy'));

-- 2. Xóa 2 bản ghi bình chọn cũ rác id = 7, 8 (đang mang trangThai = 'Mở' sai chuẩn)
DELETE FROM phuongAnBinhChon WHERE maBinhChon IN (7, 8);
DELETE FROM phieuBau WHERE maBinhChon IN (7, 8);
DELETE FROM binhChon WHERE id IN (7, 8);

COMMIT TRANSACTION;
PRINT N'Patch 08_chuan-hoa-trang-thai-su-co.sql executed successfully!';
GO
