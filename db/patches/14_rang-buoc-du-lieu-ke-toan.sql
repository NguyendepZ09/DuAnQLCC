-- Patch 14: Bổ sung các ràng buộc UNIQUE và CHECK cho dữ liệu Kế toán
-- Encoding: UTF-8 WITH BOM

-- 1. UNIQUE CONSTRAINTS
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_hoaDon_maCanHo_thang_nam')
BEGIN
    ALTER TABLE dbo.hoaDon ADD CONSTRAINT UQ_hoaDon_maCanHo_thang_nam UNIQUE (maCanHo, thang, nam);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_chiSoTieuThu_maCanHo_loaiDichVu_thang_nam')
BEGIN
    ALTER TABLE dbo.chiSoTieuThu ADD CONSTRAINT UQ_chiSoTieuThu_maCanHo_loaiDichVu_thang_nam UNIQUE (maCanHo, loaiDichVu, thang, nam);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_theTu_soThe')
BEGIN
    ALTER TABLE dbo.theTu ADD CONSTRAINT UQ_theTu_soThe UNIQUE (soThe);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_quanLyXe_bienSoXe')
BEGIN
    ALTER TABLE dbo.quanLyXe ADD CONSTRAINT UQ_quanLyXe_bienSoXe UNIQUE (bienSoXe);
END
GO

-- 2. CHECK CONSTRAINTS (dùng WITH CHECK)
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_bieuGiaDichVu_loaiDichVu')
BEGIN
    ALTER TABLE dbo.bieuGiaDichVu WITH CHECK ADD CONSTRAINT CK_bieuGiaDichVu_loaiDichVu CHECK (loaiDichVu IN ('Dien','Nuoc','PhiQuanLy','GuiXeOTo','GuiXeMay'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chiSoTieuThu_loaiDichVu')
BEGIN
    ALTER TABLE dbo.chiSoTieuThu WITH CHECK ADD CONSTRAINT CK_chiSoTieuThu_loaiDichVu CHECK (loaiDichVu IN ('Dien','Nuoc'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chiTietHoaDon_loaiDichVu')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon WITH CHECK ADD CONSTRAINT CK_chiTietHoaDon_loaiDichVu CHECK (loaiDichVu IN ('Dien','Nuoc','PhiQuanLy','GuiXeOTo','GuiXeMay','DatTienIch'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_hoaDon_trangThaiThanhToan')
BEGIN
    ALTER TABLE dbo.hoaDon WITH CHECK ADD CONSTRAINT CK_hoaDon_trangThaiThanhToan CHECK (trangThaiThanhToan IN ('ChuaThanhToan','DaThanhToan','QuaHan'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_canHo_trangThai')
BEGIN
    ALTER TABLE dbo.canHo WITH CHECK ADD CONSTRAINT CK_canHo_trangThai CHECK (trangThai IN ('DangO','TrongChoThue','BaoTri'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_cuDan_loaiCuDan')
BEGIN
    ALTER TABLE dbo.cuDan WITH CHECK ADD CONSTRAINT CK_cuDan_loaiCuDan CHECK (loaiCuDan IN ('ChuHo','KhachThue'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_cuDan_trangThai')
BEGIN
    ALTER TABLE dbo.cuDan WITH CHECK ADD CONSTRAINT CK_cuDan_trangThai CHECK (trangThai IN ('DangO','DaChuyenDi'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_datLichTienIch_trangThai')
BEGIN
    ALTER TABLE dbo.datLichTienIch WITH CHECK ADD CONSTRAINT CK_datLichTienIch_trangThai CHECK (trangThai IN ('ChoDuyet','DaDuyet','HoanThanh','DaHuy'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_giaoDichThanhToan_trangThai')
BEGIN
    ALTER TABLE dbo.giaoDichThanhToan WITH CHECK ADD CONSTRAINT CK_giaoDichThanhToan_trangThai CHECK (trangThai IN ('ChoXacNhan','ThanhCong','ThatBai'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_giaoDichThanhToan_phuongThuc')
BEGIN
    ALTER TABLE dbo.giaoDichThanhToan WITH CHECK ADD CONSTRAINT CK_giaoDichThanhToan_phuongThuc CHECK (phuongThuc IN ('TienMat','ChuyenKhoan','QR'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_danhMucTienIch_trangThaiHoatDong')
BEGIN
    ALTER TABLE dbo.danhMucTienIch WITH CHECK ADD CONSTRAINT CK_danhMucTienIch_trangThaiHoatDong CHECK (trangThaiHoatDong IN ('HoatDong','TamNgung','BaoTri'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_theTu_trangThai')
BEGIN
    ALTER TABLE dbo.theTu WITH CHECK ADD CONSTRAINT CK_theTu_trangThai CHECK (trangThai IN ('DangSuDung','TamKhoa','DaThuHoi'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_quanLyXe_loaiXe')
BEGIN
    ALTER TABLE dbo.quanLyXe WITH CHECK ADD CONSTRAINT CK_quanLyXe_loaiXe CHECK (loaiXe IN ('OTo','XeMay','XeDap'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_hoaDon_thang')
BEGIN
    ALTER TABLE dbo.hoaDon WITH CHECK ADD CONSTRAINT CK_hoaDon_thang CHECK (thang BETWEEN 1 AND 12);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chiSoTieuThu_thang')
BEGIN
    ALTER TABLE dbo.chiSoTieuThu WITH CHECK ADD CONSTRAINT CK_chiSoTieuThu_thang CHECK (thang BETWEEN 1 AND 12);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chiSoTieuThu_chiSo')
BEGIN
    ALTER TABLE dbo.chiSoTieuThu WITH CHECK ADD CONSTRAINT CK_chiSoTieuThu_chiSo CHECK (chiSo >= 0);
END
GO
