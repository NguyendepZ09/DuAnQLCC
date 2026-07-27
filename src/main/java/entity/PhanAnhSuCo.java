package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "phanAnhSuCo")
public class PhanAnhSuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Column(name = "tieuDe")
    private String tieuDe;

    @Column(name = "moTa")
    private String moTa;

    @Column(name = "anhTruocXuLy")
    private String anhTruocXuLy;

    @Column(name = "anhSauXuLy")
    private String anhSauXuLy;

    @Column(name = "trangThai")
    private String trangThai;

    @Column(name = "nguonGui")
    private String nguonGui;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayGui")
    private Date ngayGui;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayHoanThanh")
    private Date ngayHoanThanh;

    @Column(name = "mucDoUuTien")
    private String mucDoUuTien;

    @Column(name = "loaiSuCo")
    private String loaiSuCo;

    public PhanAnhSuCo() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public String getAnhTruocXuLy() { return anhTruocXuLy; }
    public void setAnhTruocXuLy(String anhTruocXuLy) { this.anhTruocXuLy = anhTruocXuLy; }

    public String getAnhSauXuLy() { return anhSauXuLy; }
    public void setAnhSauXuLy(String anhSauXuLy) { this.anhSauXuLy = anhSauXuLy; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getNguonGui() { return nguonGui; }
    public void setNguonGui(String nguonGui) { this.nguonGui = nguonGui; }

    public Date getNgayGui() { return ngayGui; }
    public void setNgayGui(Date ngayGui) { this.ngayGui = ngayGui; }

    public Date getNgayHoanThanh() { return ngayHoanThanh; }
    public void setNgayHoanThanh(Date ngayHoanThanh) { this.ngayHoanThanh = ngayHoanThanh; }

    public String getMucDoUuTien() { return mucDoUuTien; }
    public void setMucDoUuTien(String mucDoUuTien) { this.mucDoUuTien = mucDoUuTien; }

    public String getLoaiSuCo() { return loaiSuCo; }
    public void setLoaiSuCo(String loaiSuCo) { this.loaiSuCo = loaiSuCo; }
}
