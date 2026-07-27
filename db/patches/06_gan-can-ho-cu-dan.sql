-- ============================================================================
-- Patch 06: Gán căn hộ cho các tài khoản cư dân mồ côi & Chuẩn hóa Cư Dân
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

-- 1. Sửa dữ liệu trùng Chủ hộ căn 0101 (id = 1): Trần Lê Nguyễn (id = 3) -> KhachThue
UPDATE cuDan SET loaiCuDan = N'KhachThue' WHERE id = 3;

-- 2. Thêm bản ghi cuDan mới cho 5 tài khoản Cư dân mồ côi (15, 19, 20, 21, 22)
-- A. cudan.p102 (id=15) -> căn 0102 (id=2)
IF NOT EXISTS (SELECT 1 FROM cuDan WHERE maTaiKhoan = 15)
    INSERT INTO cuDan (maCanHo, maTaiKhoan, hoTen, soDienThoai, email, loaiCuDan, trangThai)
    VALUES (2, 15, N'Chủ hộ căn 0102', '0901000102', 'p102@polybuilding.vn', N'ChuHo', N'DangO');

-- B. cudan.p201 (id=19) -> căn 0201 (id=9)
IF NOT EXISTS (SELECT 1 FROM cuDan WHERE maTaiKhoan = 19)
    INSERT INTO cuDan (maCanHo, maTaiKhoan, hoTen, soDienThoai, email, loaiCuDan, trangThai)
    VALUES (9, 19, N'Chủ hộ căn 0201', '0901000201', 'p201@polybuilding.vn', N'ChuHo', N'DangO');

-- C. cudan.p302 (id=20) -> căn 0302 (id=18)
IF NOT EXISTS (SELECT 1 FROM cuDan WHERE maTaiKhoan = 20)
    INSERT INTO cuDan (maCanHo, maTaiKhoan, hoTen, soDienThoai, email, loaiCuDan, trangThai)
    VALUES (18, 20, N'Chủ hộ căn 0302', '0901000302', 'p302@polybuilding.vn', N'ChuHo', N'DangO');

-- D. cudan.p503 (id=21) -> căn 0503 (id=35)
IF NOT EXISTS (SELECT 1 FROM cuDan WHERE maTaiKhoan = 21)
    INSERT INTO cuDan (maCanHo, maTaiKhoan, hoTen, soDienThoai, email, loaiCuDan, trangThai)
    VALUES (35, 21, N'Chủ hộ căn 0503', '0901000503', 'p503@polybuilding.vn', N'ChuHo', N'DangO');

-- E. cudan.p106 (id=22) -> căn 0106 (id=6)
IF NOT EXISTS (SELECT 1 FROM cuDan WHERE maTaiKhoan = 22)
    INSERT INTO cuDan (maCanHo, maTaiKhoan, hoTen, soDienThoai, email, loaiCuDan, trangThai)
    VALUES (6, 22, N'Chủ hộ căn 0106', '0901000106', 'p106@polybuilding.vn', N'ChuHo', N'DangO');

-- 3. Cập nhật trangThai = N'DangO' cho 5 căn hộ vừa được gán cư dân (2, 9, 18, 35, 6)
UPDATE canHo SET trangThai = N'DangO' WHERE id IN (2, 9, 18, 35, 6);

COMMIT TRANSACTION;
PRINT N'Patch 06_gan-can-ho-cu-dan.sql executed successfully!';
GO
