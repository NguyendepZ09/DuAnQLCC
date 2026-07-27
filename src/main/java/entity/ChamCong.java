package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "chamCong")
public class ChamCong {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Temporal(TemporalType.DATE)
    @Column(name = "ngayLam")
    private Date ngayLam;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "gioVao")
    private Date gioVao;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "gioRa")
    private Date gioRa;

    @Column(name = "caLam")
    private String caLam;

    public ChamCong() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public Date getNgayLam() { return ngayLam; }
    public void setNgayLam(Date ngayLam) { this.ngayLam = ngayLam; }

    public Date getGioVao() { return gioVao; }
    public void setGioVao(Date gioVao) { this.gioVao = gioVao; }

    public Date getGioRa() { return gioRa; }
    public void setGioRa(Date gioRa) { this.gioRa = gioRa; }

    public String getCaLam() { return caLam; }
    public void setCaLam(String caLam) { this.caLam = caLam; }
}
