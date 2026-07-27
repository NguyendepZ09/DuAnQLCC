-- =========================================================
-- Patch 10: Sua ket luan trong sp_DongBinhChon sang Tieng Viet co dau
-- =========================================================

USE QLCCNew2;
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_DongBinhChon]
    @maBinhChon INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.binhChon WHERE id = @maBinhChon AND trangThai = N'DangMo')
    BEGIN
        RAISERROR(N'Cuộc bình chọn không tồn tại hoặc đã đóng', 16, 1);
        RETURN;
    END

    DECLARE @tongCan INT, @canDaBau INT, @tyLeThamGia DECIMAL(5,2),
            @tucSo DECIMAL(5,2), @phuongAnThang NVARCHAR(300), @soPhieuThang INT;

    SELECT @tongCan = COUNT(*) FROM dbo.canHo WHERE trangThai = N'DangO';
    SELECT @canDaBau = COUNT(DISTINCT maCanHo) FROM dbo.phieuBau WHERE maBinhChon = @maBinhChon;
    SELECT @tucSo = tyLeTucSo FROM dbo.binhChon WHERE id = @maBinhChon;

    SET @tyLeThamGia = CASE WHEN @tongCan = 0 THEN 0
                            ELSE CAST(100.0 * @canDaBau / @tongCan AS DECIMAL(5,2)) END;

    -- Phuong an dan dau
    SELECT TOP 1 @phuongAnThang = pa.noiDung, @soPhieuThang = COUNT(pb.id)
    FROM dbo.phuongAnBinhChon pa
    LEFT JOIN dbo.phieuBau pb ON pb.maPhuongAn = pa.id
    WHERE pa.maBinhChon = @maBinhChon
    GROUP BY pa.noiDung
    ORDER BY COUNT(pb.id) DESC;

    IF @tyLeThamGia >= @tucSo
        UPDATE dbo.binhChon
        SET trangThai = N'DaDong',
            ketQua = N'Thông qua: "' + ISNULL(@phuongAnThang, N'') + N'" ('
                   + CAST(@soPhieuThang AS NVARCHAR) + N' phiếu, tỷ lệ tham gia '
                   + CAST(@tyLeThamGia AS NVARCHAR) + N'%)'
        WHERE id = @maBinhChon;
    ELSE
        UPDATE dbo.binhChon
        SET trangThai = N'KhongDuTucSo',
            ketQua = N'KHÔNG ĐỦ TÚC SỐ (' + CAST(@tyLeThamGia AS NVARCHAR)
                   + N'% < ' + CAST(@tucSo AS NVARCHAR)
                   + N'%). Kết quả chỉ mang tính tham khảo: "'
                   + ISNULL(@phuongAnThang, N'') + N'"'
        WHERE id = @maBinhChon;

    SELECT id, cauHoi, trangThai, ketQua FROM dbo.binhChon WHERE id = @maBinhChon;
END
GO
