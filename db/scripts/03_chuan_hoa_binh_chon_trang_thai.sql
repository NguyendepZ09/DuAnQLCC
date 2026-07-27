-- =========================================================
-- Script 03: Chuẩn hóa trạng thái bình chọn & Dọn dẹp dữ liệu rác
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Quy đổi toàn bộ trạng thái tiếng Việt / cũ về ASCII enum chuẩn
    UPDATE binhChon SET trangThai = 'DangMo' WHERE trangThai IN (N'Mở', 'Mo', N'Đang Mở');
    UPDATE binhChon SET trangThai = 'DaDong' WHERE trangThai IN (N'Đã đóng', N'Đã Đóng', 'Dong');
    UPDATE binhChon SET trangThai = 'KhongDuTucSo' WHERE trangThai IN (N'Không Đủ Túc Số', N'Không đủ túc số');

    -- 2. Thêm CHECK constraint chặn dữ liệu trạng thái sai quy tắc
    IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_binhChon_trangThai')
    BEGIN
        ALTER TABLE binhChon DROP CONSTRAINT CK_binhChon_trangThai;
    END

    ALTER TABLE binhChon ADD CONSTRAINT CK_binhChon_trangThai 
        CHECK (trangThai IN ('DangMo', 'DaDong', 'KhongDuTucSo'));

    -- 3. Dọn dẹp cuộc bình chọn rác "èdws" (xóa phieuBau -> phuongAnBinhChon -> binhChon)
    DELETE FROM phieuBau WHERE maBinhChon IN (SELECT id FROM binhChon WHERE cauHoi LIKE N'%èdws%');
    DELETE FROM phuongAnBinhChon WHERE maBinhChon IN (SELECT id FROM binhChon WHERE cauHoi LIKE N'%èdws%');
    DELETE FROM binhChon WHERE cauHoi LIKE N'%èdws%';

    -- 4. Dọn dẹp các thông báo rác "dfsfds", "ssadfasdfc"
    DELETE FROM thongBao_DaDoc WHERE maThongBao IN (SELECT id FROM thongBao WHERE tieuDe IN (N'dfsfds', N'ssadfasdfc'));
    DELETE FROM thongBao WHERE tieuDe IN (N'dfsfds', N'ssadfasdfc');

    COMMIT TRANSACTION;
    PRINT N'=== NÂNG CẤP & DỌN DẸP THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
