package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "lichSuXuLySuCo")
public class LichSuXuLySuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maPhanAnh")
    private Integer maPhanAnh;

    @Column(name = "trangThai")
    private String trangThai;

    @Column(name = "ghiChu")
    private String ghiChu;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "thoiGian")
    private Date thoiGian;

    public LichSuXuLySuCo() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaPhanAnh() { return maPhanAnh; }
    public void setMaPhanAnh(Integer maPhanAnh) { this.maPhanAnh = maPhanAnh; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public Date getThoiGian() { return thoiGian; }
    public void setThoiGian(Date thoiGian) { this.thoiGian = thoiGian; }
}
