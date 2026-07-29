-- =======================================================================
-- PATCH 23 — THÔNG BÁO THEO CĂN HỘ VÀ NHẮC PHÍ DỰ ÁN POLYBUILDING (QLCCNew2)
-- UTF-8 CÓ BOM. Chuỗi Việt có tiền tố N''.
-- =======================================================================

-- a) Thêm cột maCanHo vào bảng dbo.thongBao
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.thongBao') AND name = 'maCanHo')
BEGIN
    ALTER TABLE dbo.thongBao ADD maCanHo INT NULL;
    ALTER TABLE dbo.thongBao ADD CONSTRAINT FK_thongBao_canHo FOREIGN KEY (maCanHo) REFERENCES dbo.canHo(id);
    PRINT N'✅ PATCH 23: Bổ sung cột maCanHo vào dbo.thongBao thành công!';
END

-- b) DROP và tạo lại CK_thongBao_doiTuong cho phép 'CanHo'
DECLARE @ckDoiTuong NVARCHAR(250);
SELECT @ckDoiTuong = name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.thongBao') AND name LIKE '%doiTuong%';
IF @ckDoiTuong IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.thongBao DROP CONSTRAINT [' + @ckDoiTuong + '];');
END
ALTER TABLE dbo.thongBao ADD CONSTRAINT CK_thongBao_doiTuong CHECK (doiTuong IN ('TatCa','NhanVien','CuDan','CanHo'));
PRINT N'✅ PATCH 23: Cập nhật CK_thongBao_doiTuong chấp nhận ''CanHo'' thành công!';

-- c) DROP và tạo lại CK_thongBao_loaiThongBao cho phép 'NhacPhi'
DECLARE @ckLoai NVARCHAR(250);
SELECT @ckLoai = name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('dbo.thongBao') AND name LIKE '%loaiThongBao%';
IF @ckLoai IS NOT NULL
BEGIN
    EXEC('ALTER TABLE dbo.thongBao DROP CONSTRAINT [' + @ckLoai + '];');
END
ALTER TABLE dbo.thongBao ADD CONSTRAINT CK_thongBao_loaiThongBao CHECK (loaiThongBao IN ('ThongThuong','BaoTri','KhanCap','NhacPhi'));
PRINT N'✅ PATCH 23: Cập nhật CK_thongBao_loaiThongBao chấp nhận ''NhacPhi'' thành công!';

-- d) Ràng buộc: doiTuong = 'CanHo' thì maCanHo BẮT BUỘC khác NULL; doiTuong khác thì maCanHo phải NULL
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_thongBao_maCanHo_doiTuong')
BEGIN
    ALTER TABLE dbo.thongBao ADD CONSTRAINT CK_thongBao_maCanHo_doiTuong CHECK ((doiTuong = 'CanHo' AND maCanHo IS NOT NULL) OR (doiTuong <> 'CanHo' AND maCanHo IS NULL));
    PRINT N'✅ PATCH 23: Bổ sung CK_thongBao_maCanHo_doiTuong thành công!';
END
