-- =========================================================
-- Patch 12: Chuẩn hóa nguonGui trong phanAnhSuCo & Thêm CHECK Constraint
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Quy đổi dữ liệu cũ trong bảng phanAnhSuCo sang bộ mã ASCII chuẩn
    UPDATE phanAnhSuCo SET nguonGui = 'BaoVe' WHERE id = 10 OR nguonGui LIKE N'%v%';
    UPDATE phanAnhSuCo SET nguonGui = 'LeTan' WHERE id = 8 OR nguonGui LIKE N'%ca%';
    UPDATE phanAnhSuCo SET nguonGui = 'CuDan' WHERE nguonGui NOT IN ('LeTan', 'BaoVe') OR nguonGui IS NULL;

    -- 2. Thêm CHECK constraint cho nguonGui (3 giá trị: CuDan, LeTan, BaoVe)
    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_phanAnhSuCo_nguonGui')
    BEGIN
        ALTER TABLE phanAnhSuCo DROP CONSTRAINT CK_phanAnhSuCo_nguonGui;
    END

    ALTER TABLE phanAnhSuCo ADD CONSTRAINT CK_phanAnhSuCo_nguonGui 
        CHECK (nguonGui IN ('CuDan', 'LeTan', 'BaoVe'));

    COMMIT TRANSACTION;
    PRINT N'=== NÂNG CẤP PATCH 12 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
