-- ============================================================================
-- Patch 04: Gộp danh mục bộ phận trùng đôi & Chuẩn hóa mã bộ phận
-- SQL Server Database QLCCNew2
-- ============================================================================

USE QLCCNew2;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

-- 1. Thêm bộ mã mới 'LeTan' nếu chưa có trong danhMucBoPhan
IF NOT EXISTS (SELECT 1 FROM danhMucBoPhan WHERE maBoPhan = 'LeTan')
    INSERT INTO danhMucBoPhan (maBoPhan, tenBoPhan) VALUES ('LeTan', N'Lễ tân');

-- 2. Cập nhật tenBoPhan tiếng Việt có dấu cho 5 mã bộ phận mới
UPDATE danhMucBoPhan SET tenBoPhan = N'Ban quản lý' WHERE maBoPhan = 'BanQuanLy';
UPDATE danhMucBoPhan SET tenBoPhan = N'Lễ tân'      WHERE maBoPhan = 'LeTan';
UPDATE danhMucBoPhan SET tenBoPhan = N'Kế toán'     WHERE maBoPhan = 'KeToan';
UPDATE danhMucBoPhan SET tenBoPhan = N'Kỹ thuật'    WHERE maBoPhan = 'KyThuat';
UPDATE danhMucBoPhan SET tenBoPhan = N'Bảo vệ'      WHERE maBoPhan = 'BaoVe';

-- 3. Tạm thời DROP Foreign Key FK_taiKhoan_boPhan nếu đang tồn tại
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_taiKhoan_boPhan')
    ALTER TABLE taiKhoan DROP CONSTRAINT FK_taiKhoan_boPhan;

-- 4. Cập nhật taiKhoan.boPhanCode từ mã cũ sang mã mới
UPDATE taiKhoan SET boPhanCode = 'BanQuanLy' WHERE boPhanCode = 'MAIN';
UPDATE taiKhoan SET boPhanCode = 'LeTan'     WHERE boPhanCode = 'LT';
UPDATE taiKhoan SET boPhanCode = 'KeToan'    WHERE boPhanCode = 'KT';
UPDATE taiKhoan SET boPhanCode = 'KyThuat'   WHERE boPhanCode = 'NVKT';
UPDATE taiKhoan SET boPhanCode = 'BaoVe'     WHERE boPhanCode = 'BV';

-- 5. Chuẩn hóa nhanVien.boPhan về đúng 5 mã mới
UPDATE nhanVien SET boPhan = 'BanQuanLy' WHERE boPhan IN (N'Ban Quan Ly', N'Ban quản lý', N'MAIN');
UPDATE nhanVien SET boPhan = 'LeTan'     WHERE boPhan IN (N'Le Tan', N'Lễ tân', N'LT');
UPDATE nhanVien SET boPhan = 'KeToan'    WHERE boPhan IN (N'Ke Toan', N'Kế toán', N'KT');
UPDATE nhanVien SET boPhan = 'KyThuat'   WHERE boPhan IN (N'Nhan Vien Ky Thuat', N'Kỹ thuật', N'NVKT');
UPDATE nhanVien SET boPhan = 'BaoVe'     WHERE boPhan IN (N'Bao Ve', N'Bảo vệ', N'BV');

-- 6. Đổi kiểu dữ liệu nhanVien.boPhan sang VARCHAR(10) và thêm FK trỏ đến danhMucBoPhan
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_nhanVien_boPhan')
    ALTER TABLE nhanVien DROP CONSTRAINT FK_nhanVien_boPhan;

ALTER TABLE nhanVien ALTER COLUMN boPhan VARCHAR(10) NULL;
ALTER TABLE nhanVien ADD CONSTRAINT FK_nhanVien_boPhan FOREIGN KEY (boPhan) REFERENCES danhMucBoPhan(maBoPhan);

-- 7. Xóa các mã bộ phận cũ sau khi chuyển hết tham chiếu
DELETE FROM danhMucBoPhan WHERE maBoPhan IN ('MAIN', 'LT', 'KT', 'NVKT', 'BV');

-- 8. Tạo lại FK_taiKhoan_boPhan
ALTER TABLE taiKhoan ADD CONSTRAINT FK_taiKhoan_boPhan FOREIGN KEY (boPhanCode) REFERENCES danhMucBoPhan(maBoPhan);

-- 9. Kiểm tra không còn dòng mồ côi nào trước khi COMMIT
DECLARE @OrphanTaiKhoan INT = (SELECT COUNT(*) FROM taiKhoan WHERE boPhanCode IS NOT NULL AND boPhanCode NOT IN (SELECT maBoPhan FROM danhMucBoPhan));
DECLARE @OrphanNhanVien INT = (SELECT COUNT(*) FROM nhanVien WHERE boPhan IS NOT NULL AND boPhan NOT IN (SELECT maBoPhan FROM danhMucBoPhan));

IF @OrphanTaiKhoan = 0 AND @OrphanNhanVien = 0
BEGIN
    COMMIT TRANSACTION;
    PRINT N'Patch 04_gop-bo-phan-trung.sql executed successfully!';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR(N'Error: Found orphan records in taiKhoan or nhanVien. Rollback executed!', 16, 1);
END
GO
