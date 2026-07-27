-- ============================================================================
-- Patch 09: Chuẩn hóa bảng thongBao (loaiThongBao, doiTuong & Drop cột loai)
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

-- 1. Chuẩn hóa loaiThongBao về ('KhanCap', 'BaoTri', 'ThongThuong')
UPDATE thongBao SET loaiThongBao = 'BaoTri'      WHERE loaiThongBao IN (N'Bảo trì', N'Bảo trì định kỳ', 'BaoTri');
UPDATE thongBao SET loaiThongBao = 'KhanCap'     WHERE loaiThongBao IN (N'Khẩn cấp', 'KhanCap');
UPDATE thongBao SET loaiThongBao = 'ThongThuong' WHERE loaiThongBao IS NULL OR loaiThongBao IN (N'Thông thường', N'Sự kiện', N'Thông tin chung', 'ThongThuong');

-- 2. Chuẩn hóa doiTuong về ('CuDan', 'NhanVien', 'TatCa')
UPDATE thongBao SET doiTuong = 'TatCa' WHERE doiTuong IS NULL OR doiTuong NOT IN ('CuDan', 'NhanVien', 'TatCa');

-- 3. Thêm CHECK constraint cho loaiThongBao & doiTuong
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_thongBao_loaiThongBao')
    ALTER TABLE thongBao DROP CONSTRAINT CK_thongBao_loaiThongBao;

ALTER TABLE thongBao ADD CONSTRAINT CK_thongBao_loaiThongBao 
CHECK (loaiThongBao IN ('KhanCap', 'BaoTri', 'ThongThuong'));

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_thongBao_doiTuong')
    ALTER TABLE thongBao DROP CONSTRAINT CK_thongBao_doiTuong;

ALTER TABLE thongBao ADD CONSTRAINT CK_thongBao_doiTuong 
CHECK (doiTuong IN ('CuDan', 'NhanVien', 'TatCa'));

-- 4. Drop cột loai chồng chéo nếu tồn tại
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'thongBao' AND COLUMN_NAME = 'loai')
BEGIN
    ALTER TABLE thongBao DROP COLUMN loai;
END

COMMIT TRANSACTION;
PRINT N'Patch 09_chuan-hoa-thong-bao.sql executed successfully!';
GO
