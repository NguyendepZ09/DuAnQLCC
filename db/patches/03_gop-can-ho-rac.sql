-- ============================================================================
-- Patch 03: Gộp căn hộ rác & Chuẩn hóa 200 căn hộ
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

-- 1. Cập nhật trạng thái N'DangO' cho căn id = 1 (vì đang có 2 cư dân sinh sống)
UPDATE canHo SET trangThai = N'DangO' WHERE id = 1;

-- 2. Xóa 2 dòng căn hộ rác id 201 và 202
DELETE FROM canHo WHERE id IN (201, 202);

-- 3. Kiểm tra tổng số căn hộ phải đúng 200 căn
DECLARE @TotalCanHo INT;
SELECT @TotalCanHo = COUNT(*) FROM canHo;

IF @TotalCanHo = 200
BEGIN
    COMMIT TRANSACTION;
    PRINT N'Patch 03_gop-can-ho-rac.sql executed successfully! Total apartments = 200';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR(N'Error: Total apartments is not 200 (Count: %d). Rollback executed!', 16, 1, @TotalCanHo);
END
GO
