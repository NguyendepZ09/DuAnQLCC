-- =======================================================================
-- PATCH 21 — BỔ SUNG CỘT CCCD VÀ SỬA NẠP UNIQUE maTaiKhoan CHO BẢNG cuDan
-- UTF-8 CÓ BOM.
-- =======================================================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.cuDan') AND name = 'cccd')
BEGIN
    ALTER TABLE dbo.cuDan ADD cccd NVARCHAR(20) NULL;
    PRINT N'✅ PATCH 21: Bổ sung cột cccd vào bảng dbo.cuDan thành công!';
END

-- Sửa UQ maTaiKhoan cho phép nhiều NULL (Cư dân chưa tạo tài khoản app)
DECLARE @ConstraintName NVARCHAR(250);
SELECT @ConstraintName = name FROM sys.objects WHERE type = 'UQ' AND parent_object_id = OBJECT_ID('dbo.cuDan');
IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.cuDan DROP CONSTRAINT [' + @ConstraintName + '];');
    CREATE UNIQUE NONCLUSTERED INDEX UQ_cuDan_maTaiKhoan ON dbo.cuDan(maTaiKhoan) WHERE maTaiKhoan IS NOT NULL;
    PRINT N'✅ PATCH 21: Đã chuyển UQ_cuDan_maTaiKhoan sang Filtered Index cho phép nhiều NULL!';
END
