-- ============================================================================
-- Patch 01: Fix Encoding VARCHAR -> NVARCHAR for SQL Server Database QLCCNew2
-- Multi-run safe (idempotent), drops default/check/index constraints dynamically.
-- ABSOLUTELY NO UPDATE STATEMENTS ON ENUM VALUES.
-- ============================================================================

USE QLCCNew2;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('tempdb..#AlterColumnToNVarChar') IS NOT NULL
    DROP PROCEDURE #AlterColumnToNVarChar;
GO

CREATE PROCEDURE #AlterColumnToNVarChar
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128),
    @NewType NVARCHAR(128),
    @IsNullable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ConstraintName NVARCHAR(256);
    DECLARE @Sql NVARCHAR(MAX);

    -- 1. Drop any DEFAULT constraint on this column
    SELECT @ConstraintName = name
    FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID(@TableName)
      AND parent_column_id = COLUMNPROPERTY(OBJECT_ID(@TableName), @ColumnName, 'ColumnId');

    IF @ConstraintName IS NOT NULL
    BEGIN
        SET @Sql = 'ALTER TABLE ' + QUOTENAME(@TableName) + ' DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
        EXEC sp_executesql @Sql;
    END

    -- 2. Drop any CHECK constraint on this column
    SELECT @ConstraintName = name
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID(@TableName)
      AND parent_column_id = COLUMNPROPERTY(OBJECT_ID(@TableName), @ColumnName, 'ColumnId');

    IF @ConstraintName IS NOT NULL
    BEGIN
        SET @Sql = 'ALTER TABLE ' + QUOTENAME(@TableName) + ' DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
        EXEC sp_executesql @Sql;
    END

    -- 3. Drop known non-PK unique constraints/indexes if present
    IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_chiSo_ky' AND parent_object_id = OBJECT_ID('chiSoTieuThu'))
        ALTER TABLE chiSoTieuThu DROP CONSTRAINT UQ_chiSo_ky;

    IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_datLich_khongTrung' AND object_id = OBJECT_ID('datLichTienIch'))
        DROP INDEX UQ_datLich_khongTrung ON datLichTienIch;

    IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_caTruc' AND parent_object_id = OBJECT_ID('nhatKyCaTruc'))
        ALTER TABLE nhatKyCaTruc DROP CONSTRAINT UQ_caTruc;

    IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_theTu_ChucNang' AND parent_object_id = OBJECT_ID('theTu_ChucNang'))
        ALTER TABLE theTu_ChucNang DROP CONSTRAINT PK_theTu_ChucNang;

    -- 4. Execute ALTER TABLE ALTER COLUMN
    DECLARE @Nullability NVARCHAR(20) = CASE WHEN @IsNullable = 1 THEN 'NULL' ELSE 'NOT NULL' END;
    SET @Sql = 'ALTER TABLE ' + QUOTENAME(@TableName) + ' ALTER COLUMN ' + QUOTENAME(@ColumnName) + ' ' + @NewType + ' ' + @Nullability;
    EXEC sp_executesql @Sql;
END;
GO

-- ============================================================================
-- Execute Column Alterations
-- ============================================================================

-- 1. cuDan
EXEC #AlterColumnToNVarChar 'cuDan', 'hoTen', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'cuDan', 'loaiCuDan', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'cuDan', 'trangThai', 'NVARCHAR(255)', 1;

-- 2. canHo
EXEC #AlterColumnToNVarChar 'canHo', 'trangThai', 'NVARCHAR(255)', 1;

-- 3. thongBao
EXEC #AlterColumnToNVarChar 'thongBao', 'tieuDe', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'thongBao', 'noiDung', 'NVARCHAR(MAX)', 1;
EXEC #AlterColumnToNVarChar 'thongBao', 'loaiThongBao', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'thongBao', 'doiTuong', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'thongBao', 'loai', 'NVARCHAR(255)', 1;

-- 4. binhChon
EXEC #AlterColumnToNVarChar 'binhChon', 'trangThai', 'NVARCHAR(20)', 0;

-- 5. hoaDon
EXEC #AlterColumnToNVarChar 'hoaDon', 'trangThaiThanhToan', 'NVARCHAR(255)', 1;

-- 6. phanAnhSuCo
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'tieuDe', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'moTa', 'NVARCHAR(MAX)', 1;
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'loaiSuCo', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'trangThai', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'mucDoUuTien', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'phanAnhSuCo', 'nguonGui', 'NVARCHAR(255)', 1;

-- 7. lichSuXuLySuCo
EXEC #AlterColumnToNVarChar 'lichSuXuLySuCo', 'trangThai', 'NVARCHAR(20)', 1;

-- 8. datLichTienIch
EXEC #AlterColumnToNVarChar 'datLichTienIch', 'trangThai', 'NVARCHAR(20)', 1;
EXEC #AlterColumnToNVarChar 'datLichTienIch', 'khungGio', 'NVARCHAR(20)', 1;

-- 9. giaoDichThanhToan
EXEC #AlterColumnToNVarChar 'giaoDichThanhToan', 'phuongThuc', 'NVARCHAR(20)', 1;
EXEC #AlterColumnToNVarChar 'giaoDichThanhToan', 'trangThai', 'NVARCHAR(20)', 1;

-- 10. theTu & theTu_ChucNang
EXEC #AlterColumnToNVarChar 'theTu', 'trangThai', 'NVARCHAR(20)', 1;
EXEC #AlterColumnToNVarChar 'theTu_ChucNang', 'chucNang', 'NVARCHAR(20)', 0;

-- 11. quanLyXe
EXEC #AlterColumnToNVarChar 'quanLyXe', 'loaiXe', 'NVARCHAR(20)', 1;

-- 12. chamCong & nhatKyCaTruc
EXEC #AlterColumnToNVarChar 'chamCong', 'caLam', 'NVARCHAR(20)', 1;
EXEC #AlterColumnToNVarChar 'nhatKyCaTruc', 'caTruc', 'NVARCHAR(20)', 1;

-- 13. bieuGiaDichVu, chiSoTieuThu, chiTietHoaDon
EXEC #AlterColumnToNVarChar 'bieuGiaDichVu', 'loaiDichVu', 'NVARCHAR(20)', 1;
EXEC #AlterColumnToNVarChar 'chiSoTieuThu', 'loaiDichVu', 'NVARCHAR(255)', 1;
EXEC #AlterColumnToNVarChar 'chiTietHoaDon', 'loaiDichVu', 'NVARCHAR(255)', 1;

-- 14. taiKhoan
EXEC #AlterColumnToNVarChar 'taiKhoan', 'trangThaiHoatDong', 'NVARCHAR(255)', 1;

-- ============================================================================
-- Re-create Constraints / Indexes if needed
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_theTu_ChucNang' AND parent_object_id = OBJECT_ID('theTu_ChucNang'))
    ALTER TABLE theTu_ChucNang ADD CONSTRAINT PK_theTu_ChucNang PRIMARY KEY (maThe, chucNang);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_datLich_khongTrung' AND object_id = OBJECT_ID('datLichTienIch'))
    CREATE UNIQUE INDEX UQ_datLich_khongTrung ON datLichTienIch (maTienIch, ngayDat, khungGio);

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_caTruc' AND parent_object_id = OBJECT_ID('nhatKyCaTruc'))
    ALTER TABLE nhatKyCaTruc ADD CONSTRAINT UQ_caTruc UNIQUE (maBaoVe, caTruc, ngayTruc);

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_chiSo_ky' AND parent_object_id = OBJECT_ID('chiSoTieuThu'))
    ALTER TABLE chiSoTieuThu ADD CONSTRAINT UQ_chiSo_ky UNIQUE (maCanHo, loaiDichVu, thang, nam);

PRINT 'Patch 01_fix-encoding-nvarchar.sql executed successfully!';
GO
