-- =======================================================================
-- PATCH 26: BỔ SUNG CỘT VÀ INDEX PHỤC VỤ ĐỐI SOÁT SAO KÊ NGÂN HÀNG
-- Dự án: PolyBuilding (QLCC)
-- =======================================================================

BEGIN TRANSACTION;

BEGIN TRY
    -- 1a. Thêm cột soThamChieuSaoKe
    IF NOT EXISTS (
        SELECT 1 FROM sys.columns 
        WHERE object_id = OBJECT_ID(N'dbo.giaoDichThanhToan') 
          AND name = N'soThamChieuSaoKe'
    )
    BEGIN
        ALTER TABLE dbo.giaoDichThanhToan ADD soThamChieuSaoKe VARCHAR(100) NULL;
        PRINT N'Đã thêm cột soThamChieuSaoKe vào bảng giaoDichThanhToan';
    END

    -- 1c. Thêm cột ghiChuDoiSoat
    IF NOT EXISTS (
        SELECT 1 FROM sys.columns 
        WHERE object_id = OBJECT_ID(N'dbo.giaoDichThanhToan') 
          AND name = N'ghiChuDoiSoat'
    )
    BEGIN
        ALTER TABLE dbo.giaoDichThanhToan ADD ghiChuDoiSoat NVARCHAR(255) NULL;
        PRINT N'Đã thêm cột ghiChuDoiSoat vào bảng giaoDichThanhToan';
    END

    -- 1b. Thêm UNIQUE INDEX cho soThamChieuSaoKe (dùng dynamic SQL để tránh compile error)
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID(N'dbo.giaoDichThanhToan') 
          AND name = N'UQ_gdtt_soThamChieuSaoKe'
    )
    BEGIN
        EXEC(N'CREATE UNIQUE NONCLUSTERED INDEX UQ_gdtt_soThamChieuSaoKe ON dbo.giaoDichThanhToan(soThamChieuSaoKe) WHERE soThamChieuSaoKe IS NOT NULL;');
        PRINT N'Đã tạo UNIQUE INDEX UQ_gdtt_soThamChieuSaoKe chống đối soát trùng';
    END

    COMMIT TRANSACTION;
    PRINT N'=== PATCH 26 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH;
