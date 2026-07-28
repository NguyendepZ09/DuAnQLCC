-- =========================================================
-- Patch 13: Bổ sung hồ sơ nhân viên cho tài khoản ketoan.lan và kt.nam
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- Bổ sung hồ sơ nhân viên Kế toán cho tài khoản ketoan.lan (maTaiKhoan = 13)
    IF EXISTS (SELECT 1 FROM taiKhoan WHERE id = 13) AND NOT EXISTS (SELECT 1 FROM nhanVien WHERE maTaiKhoan = 13)
    BEGIN
        INSERT INTO nhanVien (hoTen, soDienThoai, email, boPhan, ngayVaoLam, maTaiKhoan)
        VALUES (N'Trần Thị Lan', '0988776655', 'lan.tran@polybuilding.vn', 'KeToan', '2023-01-15', 13);
        PRINT N'Đã tạo hồ sơ nhanVien cho ketoan.lan (maTaiKhoan=13)';
    END

    -- Bổ sung hồ sơ nhân viên Kỹ thuật cho tài khoản kt.nam (maTaiKhoan = 12)
    IF EXISTS (SELECT 1 FROM taiKhoan WHERE id = 12) AND NOT EXISTS (SELECT 1 FROM nhanVien WHERE maTaiKhoan = 12)
    BEGIN
        INSERT INTO nhanVien (hoTen, soDienThoai, email, boPhan, ngayVaoLam, maTaiKhoan)
        VALUES (N'Nguyễn Hoài Nam', '0977665544', 'nam.nguyen@polybuilding.vn', 'KyThuat', '2023-02-01', 12);
        PRINT N'Đã tạo hồ sơ nhanVien cho kt.nam (maTaiKhoan=12)';
    END

    COMMIT TRANSACTION;
    PRINT N'=== PATCH 13 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
