package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "phieuBau")
public class PhieuBau {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maBinhChon")
    private Integer maBinhChon;

    @Column(name = "maPhuongAn")
    private Integer maPhuongAn;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "thoiGianBau")
    private Date thoiGianBau;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    public PhieuBau() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaBinhChon() { return maBinhChon; }
    public void setMaBinhChon(Integer maBinhChon) { this.maBinhChon = maBinhChon; }

    public Integer getMaPhuongAn() { return maPhuongAn; }
    public void setMaPhuongAn(Integer maPhuongAn) { this.maPhuongAn = maPhuongAn; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public Date getThoiGianBau() { return thoiGianBau; }
    public void setThoiGianBau(Date thoiGianBau) { this.thoiGianBau = thoiGianBau; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }
}
