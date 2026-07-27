-- ============================================================================
-- Patch 07: Thêm cột dienTich cho bảng canHo & Cập nhật diện tích thực tế
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

-- 1. Thêm cột dienTich DECIMAL(6,2) nếu chưa có
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'canHo' AND COLUMN_NAME = 'dienTich')
BEGIN
    ALTER TABLE canHo ADD dienTich DECIMAL(6,2) NULL;
END
GO

BEGIN TRANSACTION;

-- 2. Cập nhật diện tích theo vị trí căn hộ:
-- A. Các căn x01, x02 (Căn góc 3 Phòng Ngủ): 95.00 m²
UPDATE canHo 
SET dienTich = 95.00 
WHERE RIGHT(soPhong, 2) IN ('01', '02');

-- B. Các căn x03, x04, x05, x06 (Căn tiêu chuẩn 2 Phòng Ngủ): 75.00 m²
UPDATE canHo 
SET dienTich = 75.00 
WHERE RIGHT(soPhong, 2) IN ('03', '04', '05', '06');

-- C. Các căn x07, x08 (Căn nhỏ 1 Phòng Ngủ + 1): 60.00 m²
UPDATE canHo 
SET dienTich = 60.00 
WHERE RIGHT(soPhong, 2) IN ('07', '08');

COMMIT TRANSACTION;
PRINT N'Patch 07_them-dien-tich-can-ho.sql executed successfully!';
GO
