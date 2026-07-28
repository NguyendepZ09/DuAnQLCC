-- =========================================================
-- Script 05: Sửa maNhanVien rác (BQL id=10) cho phản ánh chưa giao việc (#7, #8, #10)
-- Và trả nguonGui của phản ánh #8 về 'CuDan'
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Set maNhanVien = NULL cho các phản ánh rác chưa thực sự giao việc (#7, #8, #10)
    UPDATE phanAnhSuCo 
    SET maNhanVien = NULL 
    WHERE id IN (7, 8, 10);

    -- 2. Trả nguonGui của phản ánh #8 về 'CuDan' (do căn 0102 gửi)
    UPDATE phanAnhSuCo 
    SET nguonGui = 'CuDan' 
    WHERE id = 8;

    COMMIT TRANSACTION;
    PRINT N'=== SCRIPT 05 HOÀN TẤT THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
