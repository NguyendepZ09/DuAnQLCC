-- =======================================================================
-- PATCH 22 — SỬA DẤU TIẾNG VIỆT CHO TÊN NHÂN VIÊN DỰ ÁN POLYBUILDING (QLCCNew2)
-- UTF-8 CÓ BOM. Chuỗi Việt có tiền tố N''.
-- =======================================================================

UPDATE dbo.nhanVien SET hoTen = N'Nguyễn Văn Quân' WHERE id = 1;
UPDATE dbo.nhanVien SET hoTen = N'Lê Thị Hoa'     WHERE id = 2;
UPDATE dbo.nhanVien SET hoTen = N'Trần Thị Mai'   WHERE id = 3;
UPDATE dbo.nhanVien SET hoTen = N'Phạm Thị Linh'  WHERE id = 4;
UPDATE dbo.nhanVien SET hoTen = N'Hoàng Văn Nam'  WHERE id = 5;
UPDATE dbo.nhanVien SET hoTen = N'Vũ Văn Đức'     WHERE id = 6;
UPDATE dbo.nhanVien SET hoTen = N'Nguyễn Văn Hùng' WHERE id = 7;
UPDATE dbo.nhanVien SET hoTen = N'Lê Văn Tuấn'    WHERE id = 8;
UPDATE dbo.nhanVien SET hoTen = N'Đinh Văn Sơn'   WHERE id = 9;

SELECT id, hoTen, boPhan FROM dbo.nhanVien ORDER BY id;
