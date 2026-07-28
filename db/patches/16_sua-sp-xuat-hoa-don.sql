-- Patch 16: Viết lại Stored Procedure sp_XuatHoaDonHangLoat theo hướng Set-based
-- Encoding: UTF-8 WITH BOM

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

        -- 4. Điện & Nước: sinh dòng chi tiết cho các căn thực sự có chỉ số kỳ này
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, chiSoCu, chiSoMoi, thanhTien)
        SELECT 
            t.maHoaDon,
            t.loaiDichVu,
            t.chiSoCu,
            t.chiSoMoi,
            SUM((
                CASE 
                    WHEN g.bacDen IS NULL OR t.soTieuThu < g.bacDen THEN t.soTieuThu 
                    ELSE g.bacDen 
                END - g.bacTu) * g.donGia
            ) AS thanhTien
        FROM (
            SELECT 
                m.maHoaDon,
                c_moi.loaiDichVu, -- Mã ASCII: 'Dien' / 'Nuoc'
                ISNULL(c_cu.chiSo, c_moi.chiSo) AS chiSoCu,
                c_moi.chiSo AS chiSoMoi,
                (c_moi.chiSo - ISNULL(c_cu.chiSo, c_moi.chiSo)) AS soTieuThu
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
         AND g.bacTu < t.soTieuThu
        GROUP BY t.maHoaDon, t.loaiDichVu, t.chiSoCu, t.chiSoMoi;

        -- 5. Phí quản lý: mỗi hóa đơn đúng 1 dòng
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, thanhTien)
        SELECT m.maHoaDon, 'PhiQuanLy', g.donGia
        FROM @hoaDonMoi m
        JOIN #giaHieuLuc g ON g.loaiDichVu = 'PhiQuanLy';

        -- 6. Gửi xe: đếm xe của căn hộ nhân đơn giá, gộp theo loại
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, thanhTien)
        SELECT 
            m.maHoaDon,
            CASE WHEN x.loaiXe = 'OTo' THEN 'GuiXeOTo' ELSE 'GuiXeMay' END AS loaiDichVu,
            COUNT(x.id) * g.donGia AS thanhTien
        FROM @hoaDonMoi m
        JOIN dbo.quanLyXe x ON x.maCanHo = m.maCanHo
        JOIN #giaHieuLuc g ON g.loaiDichVu = CASE WHEN x.loaiXe = 'OTo' THEN 'GuiXeOTo' ELSE 'GuiXeMay' END
        GROUP BY m.maHoaDon, x.loaiXe, g.donGia;

        -- 7. Đặt tiện ích: gộp theo hóa đơn
        INSERT INTO dbo.chiTietHoaDon (maHoaDon, loaiDichVu, thanhTien)
        SELECT m.maHoaDon, 'DatTienIch', SUM(d.giaTien)
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

        -- Result Set 2: Cảnh báo căn hộ DangO thiếu chỉ số Điện/Nước hoặc chỉ số âm
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
        WHERE ct.loaiDichVu IN ('Dien', 'Nuoc') AND ct.chiSoMoi < ct.chiSoCu;

    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
