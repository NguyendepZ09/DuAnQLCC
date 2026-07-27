-- ============================================================================
-- Patch 05: BCrypt Hash Mật Khẩu Mặc Định cho Toàn Bộ Tài Khoản
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

-- BCrypt hash cost 12 cho mật khẩu "123456":
-- $2a$12$LcqtFz54EtiZEBYeSb490.ujyA9zy7OxBc40OaO1Vp7l1.6miAh1m

UPDATE taiKhoan 
SET matKhau = '$2a$12$LcqtFz54EtiZEBYeSb490.ujyA9zy7OxBc40OaO1Vp7l1.6miAh1m';

COMMIT TRANSACTION;
PRINT N'Patch 05_hash-mat-khau.sql executed successfully!';
GO
