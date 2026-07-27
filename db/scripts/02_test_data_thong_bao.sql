-- ============================================================================
-- Script 02: Thêm dữ liệu test thông báo phân loại đối tượng (CuDan, NhanVien)
-- SQL Server Database QLCCNew2
-- File vị trí: db/scripts/02_test_data_thong_bao.sql
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

-- 1. Thông báo chỉ dành cho Cư dân
INSERT INTO thongBao (maNhanVien, tieuDe, noiDung, loaiThongBao, ngayTao, doiTuong)
VALUES (1, N'Thông báo sinh hoạt cư dân tháng 7', N'Kính mời cư dân tham gia buổi sinh hoạt định kỳ tháng 7 tại phòng sinh hoạt cộng đồng tầng 1.', 'ThongThuong', GETDATE(), 'CuDan');

-- 2. Thông báo chỉ dành cho Nhân viên
INSERT INTO thongBao (maNhanVien, tieuDe, noiDung, loaiThongBao, ngayTao, doiTuong)
VALUES (1, N'Lịch họp nội bộ Ban Quản Lý & Nhân Viên', N'Yêu cầu toàn thể nhân viên các bộ phận tham dự buổi giao ban tuần.', 'ThongThuong', GETDATE(), 'NhanVien');

COMMIT TRANSACTION;
PRINT N'Script 02_test_data_thong_bao.sql executed successfully!';
GO
