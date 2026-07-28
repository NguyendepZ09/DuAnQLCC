-- =========================================================
-- Patch 11: Chuẩn hóa enum loaiSuCo & mucDoUuTien cho bảng phanAnhSuCo
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Quy đổi dữ liệu cũ trong bảng phanAnhSuCo sang bộ mã ASCII chuẩn
    UPDATE phanAnhSuCo SET loaiSuCo = 'Nuoc' WHERE loaiSuCo IN (N'Đường nước', N'Nước');
    UPDATE phanAnhSuCo SET loaiSuCo = 'Dien' WHERE loaiSuCo IN (N'Thiết bị điện', N'Điện');
    UPDATE phanAnhSuCo SET loaiSuCo = 'AnNinh' WHERE loaiSuCo IN (N'Camera', N'An ninh');
    -- Ghi chú: "Cửa thang thoát hiểm kẹt" (Cơ sở vật chất / Cơ khí) tạm quy đổi về 'Khac'. 
    -- Nếu luồng kỹ thuật sau này phát sinh nhiều sự cố cơ khí, có thể cân nhắc mở rộng enum 'CoKhi'.
    UPDATE phanAnhSuCo SET loaiSuCo = 'Khac' WHERE loaiSuCo IN (N'Cơ sở vật chất', N'Cơ khí');

    -- Chuẩn hóa mucDoUuTien nếu còn chuỗi có dấu
    UPDATE phanAnhSuCo SET mucDoUuTien = 'Cao' WHERE mucDoUuTien IN (N'Cao');
    UPDATE phanAnhSuCo SET mucDoUuTien = 'TrungBinh' WHERE mucDoUuTien IN (N'Trung bình', N'Trung Bình');
    UPDATE phanAnhSuCo SET mucDoUuTien = 'Thap' WHERE mucDoUuTien IN (N'Thấp');

    -- 2. Thêm CHECK constraint cho loaiSuCo (7 giá trị: Dien, Nuoc, ThangMay, PCCC, AnNinh, VeSinh, Khac)
    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_phanAnhSuCo_loaiSuCo')
    BEGIN
        ALTER TABLE phanAnhSuCo DROP CONSTRAINT CK_phanAnhSuCo_loaiSuCo;
    END

    ALTER TABLE phanAnhSuCo ADD CONSTRAINT CK_phanAnhSuCo_loaiSuCo 
        CHECK (loaiSuCo IN ('Dien', 'Nuoc', 'ThangMay', 'PCCC', 'AnNinh', 'VeSinh', 'Khac'));

    -- 3. Thêm CHECK constraint cho mucDoUuTien (3 giá trị: Cao, TrungBinh, Thap)
    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_phanAnhSuCo_mucDoUuTien')
    BEGIN
        ALTER TABLE phanAnhSuCo DROP CONSTRAINT CK_phanAnhSuCo_mucDoUuTien;
    END

    ALTER TABLE phanAnhSuCo ADD CONSTRAINT CK_phanAnhSuCo_mucDoUuTien 
        CHECK (mucDoUuTien IN ('Cao', 'TrungBinh', 'Thap'));

    COMMIT TRANSACTION;
    PRINT N'=== NÂNG CẤP PATCH 11 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
