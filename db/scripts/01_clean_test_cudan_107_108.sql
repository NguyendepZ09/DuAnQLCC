-- ============================================================================
-- Script 01: Dọn dẹp 2 tài khoản cư dân test (cudan.p107 & cudan.p108)
-- SQL Server Database QLCCNew2
-- File vị trí: db/scripts/01_clean_test_cudan_107_108.sql
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

-- 1. Xóa bản ghi trong cuDan của 2 tài khoản cudan.p107 và cudan.p108
DELETE FROM cuDan 
WHERE maTaiKhoan IN (SELECT id FROM taiKhoan WHERE tenDangNhap IN ('cudan.p107', 'cudan.p108'));

-- 2. Xóa bản ghi trong taiKhoan
DELETE FROM taiKhoan 
WHERE tenDangNhap IN ('cudan.p107', 'cudan.p108');

-- 3. Trả canHo.trangThai của 2 căn hộ (0107, 0108) về N'TrongChoThue'
UPDATE canHo 
SET trangThai = N'TrongChoThue' 
WHERE soPhong IN ('0107', '0108');

-- 4. Kiểm tra số căn hộ DangO phải đúng bằng 6 (Căn 0101, 0102, 0106, 0201, 0302, 0503)
DECLARE @CountDangO INT;
SELECT @CountDangO = COUNT(*) FROM canHo WHERE trangThai = N'DangO';

IF @CountDangO = 6
BEGIN
    COMMIT TRANSACTION;
    PRINT N'Script 01_clean_test_cudan_107_108.sql executed successfully! DangO count = 6';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR(N'Error: Total DangO apartments is not 6 (Current count: %d). Rollback executed!', 16, 1, @CountDangO);
END
GO
