package entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "theTu")
public class TheTu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "soThe")
    private String soThe;

    @Column(name = "ngayCap")
    private LocalDate ngayCap;

    @Column(name = "ngayHetHan")
    private LocalDate ngayHetHan;

    @Column(name = "trangThai")
    private String trangThai;

    public TheTu() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public String getSoThe() { return soThe; }
    public void setSoThe(String soThe) { this.soThe = soThe; }

    public LocalDate getNgayCap() { return ngayCap; }
    public void setNgayCap(LocalDate ngayCap) { this.ngayCap = ngayCap; }

    public LocalDate getNgayHetHan() { return ngayHetHan; }
    public void setNgayHetHan(LocalDate ngayHetHan) { this.ngayHetHan = ngayHetHan; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
}
