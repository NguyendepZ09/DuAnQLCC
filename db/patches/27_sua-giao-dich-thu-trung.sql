-- =======================================================================
-- PATCH 27: SỬA DỮ LIỆU CÁC HÓA ĐƠN BỊ THU TRÙNG / THU VƯỢT TỔNG TIỀN
-- Dự án: PolyBuilding (QLCC)
-- =======================================================================

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Sửa dữ liệu: Với các hóa đơn có tổng tiền đã thu (ThanhCong) > tongTien
    -- Giữ lại giao dịch ThanhCong có thoiGianXacNhan sớm nhất (hoặc id nhỏ nhất).
    -- Đổi các giao dịch ThanhCong thừa thành 'ThatBai' kèm ghi chú đối soát.

    WITH RankedTransactions AS (
        SELECT g.id, g.maHoaDon, g.trangThai, g.thoiGianXacNhan,
               ROW_NUMBER() OVER (
                   PARTITION BY g.maHoaDon 
                   ORDER BY ISNULL(g.thoiGianXacNhan, '2099-12-31') ASC, g.id ASC
               ) AS rn
        FROM dbo.giaoDichThanhToan g
        JOIN dbo.hoaDon h ON h.id = g.maHoaDon
        WHERE g.trangThai = 'ThanhCong'
          AND h.id IN (
              SELECT h2.id
              FROM dbo.hoaDon h2
              JOIN dbo.giaoDichThanhToan g2 ON g2.maHoaDon = h2.id
              WHERE g2.trangThai = 'ThanhCong'
              GROUP BY h2.id, h2.tongTien
              HAVING SUM(g2.soTien) > h2.tongTien
          )
    )
    UPDATE dbo.giaoDichThanhToan
    SET trangThai = 'ThatBai',
        ghiChuDoiSoat = N'Hủy do trùng lặp — hóa đơn đã được thanh toán bởi giao dịch trước'
    WHERE id IN (
        SELECT id FROM RankedTransactions WHERE rn > 1
    );

    PRINT N'Đã cập nhật các giao dịch thu trùng về trạng thái ThatBai.';

    -- 2. Kiểm tra lại: ra 0 dòng là thành công
    SELECT h.id AS maHoaDon, h.tongTien,
           SUM(CASE WHEN g.trangThai='ThanhCong' THEN g.soTien ELSE 0 END) AS daThu
    FROM dbo.hoaDon h 
    JOIN dbo.giaoDichThanhToan g ON g.maHoaDon = h.id
    GROUP BY h.id, h.tongTien
    HAVING SUM(CASE WHEN g.trangThai='ThanhCong' THEN g.soTien ELSE 0 END) > h.tongTien;

    COMMIT TRANSACTION;
    PRINT N'=== PATCH 27 THÀNH CÔNG ===';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH;
