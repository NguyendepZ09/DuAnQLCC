package Entities;

import jakarta.persistence.*;
import java.util.Date;

/**
 * Entity LichSuXuLySuCo map 1-1 voi bang [lichSuXuLySuCo]
 */
@Entity
@Table(name = "lichSuXuLySuCo")
public class LichSuXuLySuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maPhanAnh")
    private Integer maPhanAnh;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Column(name = "ketQua", length = 500)
    private String ketQua;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayXuLy")
    private Date ngayXuLy;

    public LichSuXuLySuCo() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaPhanAnh() { return maPhanAnh; }
    public void setMaPhanAnh(Integer maPhanAnh) { this.maPhanAnh = maPhanAnh; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public String getKetQua() { return ketQua; }
    public void setKetQua(String ketQua) { this.ketQua = ketQua; }

    public Date getNgayXuLy() { return ngayXuLy; }
    public void setNgayXuLy(Date ngayXuLy) { this.ngayXuLy = ngayXuLy; }
}
