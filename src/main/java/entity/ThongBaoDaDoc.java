package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "thongBao_DaDoc")
public class ThongBaoDaDoc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maThongBao")
    private Integer maThongBao;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "thoiGianDoc")
    private Date thoiGianDoc;

    public ThongBaoDaDoc() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaThongBao() { return maThongBao; }
    public void setMaThongBao(Integer maThongBao) { this.maThongBao = maThongBao; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public Date getThoiGianDoc() { return thoiGianDoc; }
    public void setThoiGianDoc(Date thoiGianDoc) { this.thoiGianDoc = thoiGianDoc; }
}
