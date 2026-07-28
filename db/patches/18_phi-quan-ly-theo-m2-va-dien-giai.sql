-- Patch 18: Phí quản lý theo m² sàn và tự động sinh diễn giải tách bậc hóa đơn
-- Encoding: UTF-8 WITH BOM

-- =======================================================================
-- PHẦN 1 — MỞ RỘNG BẢNG chiTietHoaDon VÀ RÀNG BUỘC
-- =======================================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.chiTietHoaDon') AND name = 'soLuong')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon ADD soLuong DECIMAL(10,2) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.chiTietHoaDon') AND name = 'donViTinh')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon ADD donViTinh VARCHAR(10) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.chiTietHoaDon') AND name = 'donGia')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon ADD donGia DECIMAL(15,2) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.chiTietHoaDon') AND name = 'dienGiai')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon ADD dienGiai NVARCHAR(1000) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_chiTietHoaDon_donViTinh')
BEGIN
    ALTER TABLE dbo.chiTietHoaDon WITH CHECK ADD CONSTRAINT CK_chiTietHoaDon_donViTinh CHECK (donViTinh IS NULL OR donViTinh IN ('kWh','m3','m2','xe','luot'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_canHo_dienTich')
BEGIN
    ALTER TABLE dbo.canHo WITH CHECK ADD CONSTRAINT CK_canHo_dienTich CHECK (dienTich > 0);
END
GO

-- =======================================================================
-- PHẦN 2 — ĐỔI BIỂU GIÁ PHÍ QUẢN LÝ THEO M² SÀN
-- =======================================================================
UPDATE dbo.bieuGiaDichVu
SET donGia = 8000,
    nguonGia = N'BQL quy định — đơn giá trên mỗi m² sàn/tháng'
WHERE loaiDichVu = 'PhiQuanLy';
GO

-- =======================================================================
-- PHẦN 3 — SỬA LẠI STORED PROCEDURE sp_XuatHoaDonHangLoat
-- =======================================================================
CREATE OR ALTER PROCEDURE dbo.sp_XuatHoaDonHangLoat
    @thang INT,
    @nam INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Tính tháng/năm kỳ trước và ngày cuối kỳ hiện tại
        DECLARE @thangTruoc INT = CASE WHEN @thang = 1 THEN 12 ELSE @thang - 1 END;
        DECLARE @namTruoc INT = CASE WHEN @thang = 1 THEN @nam - 1 ELSE @nam END;
        DECLARE @ngayCuoiKy DATE = EOMONTH(DATEFROMPARTS(@nam, @thang, 1));

        -- 2. Tạo hóa đơn mới cho các căn hộ DangO chưa có hóa đơn kỳ này
        DECLARE @hoaDonMoi TABLE (maHoaDon INT PRIMARY KEY, maCanHo INT);

        INSERT INTO dbo.hoaDon (maCanHo, thang, nam, tongTien, trangThaiThanhToan)
        OUTPUT inserted.id, inserted.maCanHo INTO @hoaDonMoi (maHoaDon, maCanHo)
        SELECT c.id, @thang, @nam, 0, N'ChuaThanhToan'
        FROM dbo.canHo c
        WHERE c.trangThai = N'DangO'
          AND NOT EXISTS (
              SELECT 1 FROM dbo.hoaDon h
              WHERE h.maCanHo = c.id AND h.thang = @thang AND h.nam = @nam
          );

        -- 3. Biểu giá hiệu lực chung cho tất cả dịch vụ tại mốc @ngayCuoiKy
        IF OBJECT_ID('tempdb..#giaHieuLuc') IS NOT NULL DROP TABLE #giaHieuLuc;

        SELECT g.*
        INTO #giaHieuLuc
        FROM dbo.bieuGiaDichVu g
        WHERE g.hieuLucTu = (
            SELECT MAX(b2.hieuLucTu)
            FROM dbo.bieuGiaDichVu b2
            WHERE b2.loaiDichVu = g.loaiDichVu
              AND b2.hieuLucTu <= @ngayCuoiKy
        );

        -- 4. Điện & Nước: Tách bậc và sinh diễn giải
        IF OBJECT_ID('tempdb..#bacChiTiet') IS NOT NULL DROP TABLE #bacChiTiet;

        SELECT 
            t.maHoaDon,
            t.loaiDichVu,
            t.chiSoCu,
            t.chiSoMoi,
            t.soTieuThu,
            t.donViTinh,
            g.bacTu,
            g.bacDen,
            g.donGia,
            ROW_NUMBER() OVER (PARTITION BY t.maHoaDon, t.loaiDichVu ORDER BY g.bacTu) AS thuTuBac,
            (CASE 
                WHEN g.bacDen IS NULL OR t.soTieuThu < g.bacDen THEN t.soTieuThu 
                ELSE g.bacDen 
             END - g.bacTu) AS soLuongBac,
            ((CASE 
                WHEN g.bacDen IS NULL OR t.soTieuThu < g.bacDen THEN t.soTieuThu 
                ELSE g.bacDen 
             END - g.bacTu) * g.donGia) AS tienBac
        INTO #bacChiTiet
        FROM (
            SELECT 
                m.maHoaDon,
                c_moi.loaiDichVu,
                ISNULL(c_cu.chiSo, c_moi.chiSo) AS chiSoCu,
                c_moi.chiSo AS chiSoMoi,
                (c_moi.chiSo - ISNULL(c_cu.chiSo, c_moi.chiSo)) AS soTieuThu,
                CASE WHEN c_moi.loaiDichVu = 'Dien' THEN 'kWh' ELSE 'm3' END AS donViTinh
            FROM @hoaDonMoi m
            JOIN dbo.chiSoTieuThu c_moi 
              ON c_moi.maCanHo = m.maCanHo 
             AND c_moi.thang = @thang 
             AND c_moi.nam = @nam 
             AND c_moi.loaiDichVu IN ('Dien', 'Nuoc')
            LEFT JOIN dbo.chiSoTieuThu c_cu 
              ON c_cu.maCanHo = m.maCanHo 
             AND c_cu.thang = @thangTruoc 
             AND c_cu.nam = @namTruoc 
             AND c_cu.loaiDichVu = c_moi.loaiDichVu
        ) t
        JOIN #giaHieuLuc g 
          ON g.loaiDichVu = t.loaiDichVu 
         AND g.bacTu < t.soTieuThu;

        -- 4a. Thêm các dòng tiêu thụ > 0 (tính tiền + diễn giải tách bậc)
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, chiSoCu, chiSoMoi, soLuong, donViTinh, donGia, thanhTien, dienGiai)
        SELECT 
            b.maHoaDon,
            b.loaiDichVu,
            b.chiSoCu,
            b.chiSoMoi,
            b.soTieuThu AS soLuong,
            b.donViTinh,
            NULL AS donGia,
            SUM(b.tienBac) AS thanhTien,
            STRING_AGG(
                N'Bậc ' + CAST(b.thuTuBac AS NVARCHAR) + N': ' 
                + FORMAT(b.soLuongBac, 'N0') + N' ' + b.donViTinh 
                + N' × ' + FORMAT(b.donGia, 'N0') + N'đ = ' 
                + FORMAT(b.tienBac, 'N0') + N'đ',
                N'; '
            ) WITHIN GROUP (ORDER BY b.bacTu) AS dienGiai
        FROM #bacChiTiet b
        GROUP BY b.maHoaDon, b.loaiDichVu, b.chiSoCu, b.chiSoMoi, b.soTieuThu, b.donViTinh;

        -- 4b. Thêm các dòng tiêu thụ <= 0 (kỳ đầu tiên hoặc không dùng)
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, chiSoCu, chiSoMoi, soLuong, donViTinh, donGia, thanhTien, dienGiai)
        SELECT 
            m.maHoaDon,
            c_moi.loaiDichVu,
            ISNULL(c_cu.chiSo, c_moi.chiSo) AS chiSoCu,
            c_moi.chiSo AS chiSoMoi,
            (c_moi.chiSo - ISNULL(c_cu.chiSo, c_moi.chiSo)) AS soLuong,
            CASE WHEN c_moi.loaiDichVu = 'Dien' THEN 'kWh' ELSE 'm3' END AS donViTinh,
            NULL AS donGia,
            0 AS thanhTien,
            N'Kỳ đầu tiên, chưa có chỉ số kỳ trước để đối chiếu' AS dienGiai
        FROM @hoaDonMoi m
        JOIN dbo.chiSoTieuThu c_moi 
          ON c_moi.maCanHo = m.maCanHo 
         AND c_moi.thang = @thang 
         AND c_moi.nam = @nam 
         AND c_moi.loaiDichVu IN ('Dien', 'Nuoc')
        LEFT JOIN dbo.chiSoTieuThu c_cu 
          ON c_cu.maCanHo = m.maCanHo 
         AND c_cu.thang = @thangTruoc 
         AND c_cu.nam = @namTruoc 
         AND c_cu.loaiDichVu = c_moi.loaiDichVu
        WHERE (c_moi.chiSo - ISNULL(c_cu.chiSo, c_moi.chiSo)) <= 0;

        -- 5. Phí quản lý: theo diện tích m² sàn (soLuong = dienTich, donViTinh = 'm2', donGia = g.donGia)
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, soLuong, donViTinh, donGia, thanhTien)
        SELECT m.maHoaDon, 'PhiQuanLy', c.dienTich, 'm2', g.donGia, c.dienTich * g.donGia
        FROM @hoaDonMoi m
        JOIN dbo.canHo c ON c.id = m.maCanHo
        JOIN #giaHieuLuc g ON g.loaiDichVu = 'PhiQuanLy';

        -- 6. Gửi xe: đếm số xe nhân đơn giá (soLuong = COUNT, donViTinh = 'xe', donGia = g.donGia)
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, soLuong, donViTinh, donGia, thanhTien)
        SELECT 
            m.maHoaDon,
            CASE WHEN x.loaiXe = 'OTo' THEN 'GuiXeOTo' ELSE 'GuiXeMay' END AS loaiDichVu,
            COUNT(x.id) AS soLuong,
            'xe' AS donViTinh,
            g.donGia AS donGia,
            COUNT(x.id) * g.donGia AS thanhTien
        FROM @hoaDonMoi m
        JOIN dbo.quanLyXe x ON x.maCanHo = m.maCanHo
        JOIN #giaHieuLuc g ON g.loaiDichVu = CASE WHEN x.loaiXe = 'OTo' THEN 'GuiXeOTo' ELSE 'GuiXeMay' END
        GROUP BY m.maHoaDon, x.loaiXe, g.donGia;

        -- 7. Đặt tiện ích: gộp theo lượt (soLuong = COUNT, donViTinh = 'luot', donGia = NULL)
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, soLuong, donViTinh, donGia, thanhTien)
        SELECT 
            m.maHoaDon,
            'DatTienIch' AS loaiDichVu,
            COUNT(d.id) AS soLuong,
            'luot' AS donViTinh,
            NULL AS donGia,
            SUM(d.giaTien) AS thanhTien
        FROM @hoaDonMoi m
        JOIN dbo.datLichTienIch d ON d.maCanHo = m.maCanHo
        WHERE MONTH(d.ngayDat) = @thang 
          AND YEAR(d.ngayDat) = @nam
          AND d.trangThai IN ('DaDuyet', 'HoanThanh')
        GROUP BY m.maHoaDon
        HAVING SUM(d.giaTien) > 0;

        -- 8. Chốt tổng tiền cho hóa đơn vừa tạo
        UPDATE h 
        SET h.tongTien = ISNULL(t.tong, 0)
        FROM dbo.hoaDon h
        JOIN @hoaDonMoi m ON m.maHoaDon = h.id
        OUTER APPLY (
            SELECT SUM(ct.thanhTien) AS tong 
            FROM dbo.chiTietHoaDon ct
            WHERE ct.maHoaDon = h.id
        ) t;

        COMMIT TRANSACTION;

        -- 9. Trả về 2 Result Sets
        -- Result Set 1: Danh sách hóa đơn vừa tạo
        SELECT h.id AS maHoaDon, h.maCanHo, c.soPhong, h.tongTien
        FROM dbo.hoaDon h
        JOIN @hoaDonMoi m ON m.maHoaDon = h.id
        JOIN dbo.canHo c ON c.id = h.maCanHo
        ORDER BY h.id ASC;

        -- Result Set 2: Cảnh báo căn hộ DangO thiếu chỉ số Điện/Nước, chỉ số âm, hoặc thiếu diện tích
        SELECT c.id AS maCanHo, c.soPhong, req.loaiDichVu, N'Thiếu chỉ số kỳ này' AS lyDo
        FROM dbo.canHo c
        CROSS JOIN (VALUES ('Dien'), ('Nuoc')) AS req(loaiDichVu)
        JOIN @hoaDonMoi m ON m.maCanHo = c.id
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.chiSoTieuThu s
            WHERE s.maCanHo = c.id AND s.loaiDichVu = req.loaiDichVu
              AND s.thang = @thang AND s.nam = @nam
        )
        UNION ALL
        SELECT c.id AS maCanHo, c.soPhong, ct.loaiDichVu, N'Chỉ số âm (số mới < số cũ)' AS lyDo
        FROM @hoaDonMoi m
        JOIN dbo.canHo c ON c.id = m.maCanHo
        JOIN dbo.chiTietHoaDon ct ON ct.maHoaDon = m.maHoaDon
        WHERE ct.loaiDichVu IN ('Dien', 'Nuoc') AND ct.chiSoMoi < ct.chiSoCu
        UNION ALL
        SELECT c.id AS maCanHo, c.soPhong, 'PhiQuanLy' AS loaiDichVu, N'Diện tích chưa nhập hoặc <= 0' AS lyDo
        FROM @hoaDonMoi m
        JOIN dbo.canHo c ON c.id = m.maCanHo
        WHERE c.dienTich IS NULL OR c.dienTich <= 0;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- =======================================================================
-- PHẦN 4 — LẬP LẠI HÓA ĐƠN DEMO
-- =======================================================================
DELETE FROM dbo.chiTietHoaDon;
DELETE FROM dbo.giaoDichThanhToan;
DELETE FROM dbo.hoaDon;
GO

EXEC dbo.sp_XuatHoaDonHangLoat 6, 2026;
EXEC dbo.sp_XuatHoaDonHangLoat 7, 2026;
GO

UPDATE dbo.hoaDon SET trangThaiThanhToan = N'DaThanhToan' WHERE thang = 6 AND nam = 2026;
GO
