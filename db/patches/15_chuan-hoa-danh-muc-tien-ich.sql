-- Patch 15: Chuẩn hóa tiếng Việt có dấu cho danhMucTienIch
-- Encoding: UTF-8 WITH BOM

UPDATE dbo.danhMucTienIch
SET tenTienIch = N'Hồ bơi',
    moTa = N'Hồ bơi ngoài trời tầng 3'
WHERE id = 1;

UPDATE dbo.danhMucTienIch
SET tenTienIch = N'Phòng Gym',
    moTa = N'Phòng tập thể hình tầng 3'
WHERE id = 2;

UPDATE dbo.danhMucTienIch
SET tenTienIch = N'Phòng sinh hoạt cộng đồng',
    moTa = N'Phòng họp mặt, tổ chức sự kiện cho cư dân'
WHERE id = 3;

UPDATE dbo.danhMucTienIch
SET tenTienIch = N'Sân BBQ',
    moTa = N'Sân nướng ngoài trời tầng thượng'
WHERE id = 4;

UPDATE dbo.danhMucTienIch
SET tenTienIch = N'Phòng họp',
    moTa = N'Phòng họp nhỏ dành cho cư dân'
WHERE id = 5;

SELECT id, tenTienIch, moTa FROM dbo.danhMucTienIch ORDER BY id;
GO
