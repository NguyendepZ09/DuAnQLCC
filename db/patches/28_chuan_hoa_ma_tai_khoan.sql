-- ============================================================================
-- PATCH 28: Chuẩn hóa mã tài khoản (maTaiKhoan) đệm 4 chữ số (cd_0001, nv_bv0001...)
-- Dự án: PolyBuilding - Quản lý chung cư
-- Ngày tạo: 2026-08-04
-- Ghi chú: Chỉ thay đổi cột maTaiKhoan, giữ nguyên tenDangNhap và khóa ngoại id
-- ============================================================================

USE QLCCNew2;
GO

-- 1. BÁO CÁO DỮ LIỆU TRƯỚC KHI CHUẨN HÓA
PRINT N'=== TRƯỚC KHI CHUẨN HÓA MÃ TÀI KHOẢN ===';
SELECT id, maTaiKhoan, tenDangNhap, vaiTro, boPhanCode
FROM dbo.taiKhoan
ORDER BY vaiTro, boPhanCode, id;
GO

-- 2. CHUẨN HÓA MÃ TÀI KHOẢN THEO ĐỊNH DẠNG PADDED 4 CHỮ SỐ
BEGIN TRANSACTION;

-- Role Cư dân (CD): cd_0001, cd_0002...
WITH CTE_CD AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'CD'
)
UPDATE t
SET t.maTaiKhoan = 'cd_' + RIGHT('0000' + CAST(c.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_CD c ON t.id = c.id;

-- Role Ban Quản Lý (BQL): bql_0001, bql_0002...
WITH CTE_BQL AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'BQL'
)
UPDATE t
SET t.maTaiKhoan = 'bql_' + RIGHT('0000' + CAST(b.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_BQL b ON t.id = b.id;

-- Role Nhân viên - Lễ tân (NV LeTan): nv_lt0001, nv_lt0002...
WITH CTE_LT AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'NV' AND (boPhanCode = 'LeTan' OR boPhanCode LIKE '%lt%')
)
UPDATE t
SET t.maTaiKhoan = 'nv_lt' + RIGHT('0000' + CAST(l.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_LT l ON t.id = l.id;

-- Role Nhân viên - Kế toán (NV KeToan): nv_kt0001, nv_kt0002...
WITH CTE_KT AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'NV' AND (boPhanCode = 'KeToan' OR (boPhanCode LIKE '%kt%' AND boPhanCode NOT LIKE '%kythuat%'))
)
UPDATE t
SET t.maTaiKhoan = 'nv_kt' + RIGHT('0000' + CAST(k.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_KT k ON t.id = k.id;

-- Role Nhân viên - Kỹ thuật (NV KyThuat): nv_ktht0001, nv_ktht0002...
WITH CTE_NVKT AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'NV' AND (boPhanCode = 'KyThuat' OR boPhanCode LIKE '%kythuat%' OR boPhanCode LIKE '%nvkt%')
)
UPDATE t
SET t.maTaiKhoan = 'nv_ktht' + RIGHT('0000' + CAST(k.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_NVKT k ON t.id = k.id;

-- Role Nhân viên - Bảo vệ (NV BaoVe): nv_bv0001, nv_bv0002...
WITH CTE_BV AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM dbo.taiKhoan
    WHERE vaiTro = 'NV' AND (boPhanCode = 'BaoVe' OR boPhanCode LIKE '%bv%')
)
UPDATE t
SET t.maTaiKhoan = 'nv_bv' + RIGHT('0000' + CAST(b.rn AS VARCHAR(10)), 4)
FROM dbo.taiKhoan t
JOIN CTE_BV b ON t.id = b.id;

COMMIT TRANSACTION;
GO

-- 3. BÁO CÁO KẾT QUẢ SAU KHI CHUẨN HÓA
PRINT N'=== SAU KHI CHUẨN HÓA MÃ TÀI KHOẢN ===';
SELECT id, maTaiKhoan, tenDangNhap, vaiTro, boPhanCode
FROM dbo.taiKhoan
ORDER BY vaiTro, boPhanCode, id;
GO
