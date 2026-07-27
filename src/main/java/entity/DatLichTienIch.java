package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "datLichTienIch")
public class DatLichTienIch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "maTienIch")
    private Integer maTienIch;

    @Temporal(TemporalType.DATE)
    @Column(name = "ngayDat")
    private Date ngayDat;

    @Column(name = "khungGio")
    private String khungGio;

    @Column(name = "giaTien")
    private BigDecimal giaTien;

    @Column(name = "trangThai")
    private String trangThai;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayTao")
    private Date ngayTao;

    public DatLichTienIch() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public Integer getMaTienIch() { return maTienIch; }
    public void setMaTienIch(Integer maTienIch) { this.maTienIch = maTienIch; }

    public Date getNgayDat() { return ngayDat; }
    public void setNgayDat(Date ngayDat) { this.ngayDat = ngayDat; }

    public String getKhungGio() { return khungGio; }
    public void setKhungGio(String khungGio) { this.khungGio = khungGio; }

    public BigDecimal getGiaTien() { return giaTien; }
    public void setGiaTien(BigDecimal giaTien) { this.giaTien = giaTien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }
}
