-- =======================================================================
-- PATCH 21 — CHỐT MẪU SỐ TÚC SỐ BÌNH CHỌN DỰ ÁN POLYBUILDING (QLCCNew2)
-- UTF-8 CÓ BOM. Chuỗi Việt có tiền tố N''.
-- =======================================================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.binhChon') AND name = 'tongCanHoLucMo')
BEGIN
    ALTER TABLE dbo.binhChon ADD tongCanHoLucMo INT NULL;
    PRINT N'✅ PATCH 21: Bổ sung cột tongCanHoLucMo vào dbo.binhChon thành công!';
END

-- 1b. Điền giá trị cho các bản ghi CŨ (ước lượng bằng tổng số căn hộ DangO hiện tại)
UPDATE dbo.binhChon 
SET tongCanHoLucMo = (SELECT COUNT(*) FROM dbo.canHo WHERE trangThai = N'DangO')
WHERE tongCanHoLucMo IS NULL;

-- Mở rộng cột ketQua lên NVARCHAR(500) tránh rủi ro truncate chuỗi ghép
ALTER TABLE dbo.binhChon ALTER COLUMN ketQua NVARCHAR(500) NULL;
