-- =======================================================================
-- PATCH 24: DỌN DỮ LIỆU TRƯỚC DEMO
-- PolyBuilding QLCC — SQL Server Patch 24 (UTF-8 WITH BOM)
-- =======================================================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Xóa 2 thẻ test còn sót (id 19, 20) theo đúng thứ tự khóa ngoại
    UPDATE dbo.quanLyXe SET maThe = NULL WHERE maThe IN (19, 20);
    DELETE FROM dbo.theTu_ChucNang WHERE maThe IN (19, 20);
    DELETE FROM dbo.theTu WHERE id IN (19, 20);

    -- 2. Điền nguonGia cho dòng biểu giá id 12 (đang rỗng)
    UPDATE dbo.bieuGiaDichVu
    SET nguonGia = N'BQL quy định — điều chỉnh phí quản lý từ 01/12/2026'
    WHERE id = 12;

    COMMIT TRANSACTION;
    PRINT N'✅ APPLIED PATCH 24 THÀNH CÔNG!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrMsg, 16, 1);
END CATCH;

-- Kiểm tra lại số lượng thẻ từ còn lại
SELECT COUNT(*) AS tongSoTheTuConLai FROM dbo.theTu;
