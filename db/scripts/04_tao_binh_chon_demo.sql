-- =========================================================
-- Script 04: Dọn dẹp căn 0108, xóa dữ liệu rác & Khởi tạo 2 cuộc bình chọn demo
-- =========================================================

USE QLCCNew2;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Xóa tài khoản & cư dân căn 0108 (id=8)
    DELETE FROM phieuBau WHERE maCuDan IN (SELECT id FROM cuDan WHERE maCanHo = 8);
    DELETE FROM thongBao_DaDoc WHERE maCuDan IN (SELECT id FROM cuDan WHERE maCanHo = 8);
    
    DECLARE @idTaiKhoanCD08 INT;
    SELECT @idTaiKhoanCD08 = maTaiKhoan FROM cuDan WHERE maCanHo = 8;

    DELETE FROM cuDan WHERE maCanHo = 8;
    
    IF @idTaiKhoanCD08 IS NOT NULL
    BEGIN
        DELETE FROM taiKhoan WHERE id = @idTaiKhoanCD08;
    END
    DELETE FROM taiKhoan WHERE tenDangNhap = 'cudan.p108' OR maTaiKhoan = 'cd_08';

    -- Trả căn hộ 0108 về trạng thái TrongChoThue
    UPDATE canHo SET trangThai = N'TrongChoThue' WHERE id = 8;

    -- 2. Xóa toàn bộ phiếu bầu, phương án và cuộc bình chọn cũ
    DELETE FROM phieuBau;
    DELETE FROM phuongAnBinhChon;
    DELETE FROM binhChon;

    -- 3. Tạo Cuộc A
    INSERT INTO binhChon (maThongBao, cauHoi, ngayBatDau, hanChot, trangThai, tyLeTucSo)
    VALUES (2, N'Bạn có đồng ý mở rộng sân Pickleball tầng thượng không?', GETDATE(), DATEADD(day, 14, GETDATE()), 'DangMo', 50.0);

    DECLARE @idBinhChonA INT = SCOPE_IDENTITY();

    INSERT INTO phuongAnBinhChon (maBinhChon, noiDung, thuTu) VALUES
    (@idBinhChonA, N'Đồng ý', 1),
    (@idBinhChonA, N'Không đồng ý', 2);

    -- 4. Tạo Cuộc B
    INSERT INTO binhChon (maThongBao, cauHoi, ngayBatDau, hanChot, trangThai, tyLeTucSo)
    VALUES (2, N'Bạn có đồng ý tăng phí quản lý lên 8.000đ/m² từ tháng 9 không?', GETDATE(), DATEADD(day, 14, GETDATE()), 'DangMo', 50.0);

    DECLARE @idBinhChonB INT = SCOPE_IDENTITY();

    INSERT INTO phuongAnBinhChon (maBinhChon, noiDung, thuTu) VALUES
    (@idBinhChonB, N'Đồng ý', 1),
    (@idBinhChonB, N'Không đồng ý', 2),
    (@idBinhChonB, N'Cần họp thêm', 3);

    COMMIT TRANSACTION;
    PRINT N'=== THỰC THI SCRIPT 04 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO
