-- =======================================================================
-- PATCH 20 — DỌN DỮ LIỆU THẺ TEST TRONG DỰ ÁN POLYBUILDING (QLCCNew2)
-- UTF-8 CÓ BOM.
-- =======================================================================

BEGIN TRANSACTION;
BEGIN TRY

    -- 1. Gỡ liên kết maThe từ bảng quanLyXe với các thẻ test
    UPDATE dbo.quanLyXe
    SET maThe = NULL
    WHERE maThe IN (
        SELECT id FROM dbo.theTu
        WHERE soThe IN (N'THE-0106-99', N'THE-TEST-675', N'THE-IDOR-01')
           OR soThe LIKE N'THE-TEST-%'
    );

    -- 2. Xóa các chức năng thẻ của thẻ test trong bảng theTu_ChucNang
    DELETE FROM dbo.theTu_ChucNang
    WHERE maThe IN (
        SELECT id FROM dbo.theTu
        WHERE soThe IN (N'THE-0106-99', N'THE-TEST-675', N'THE-IDOR-01')
           OR soThe LIKE N'THE-TEST-%'
    );

    -- 3. Xóa các thẻ test khỏi bảng theTu
    DELETE FROM dbo.theTu
    WHERE soThe IN (N'THE-0106-99', N'THE-TEST-675', N'THE-IDOR-01')
       OR soThe LIKE N'THE-TEST-%';

    COMMIT TRANSACTION;
    PRINT N'✅ PATCH 20: Dọn dẹp dữ liệu thẻ test thành công!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrMsg, 16, 1);
END CATCH;
