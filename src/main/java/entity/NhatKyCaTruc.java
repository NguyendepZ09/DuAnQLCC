package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "nhatKyCaTruc")
public class NhatKyCaTruc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maBaoVe")
    private Integer maBaoVe;

    @Column(name = "caTruc")
    private String caTruc;

    @Temporal(TemporalType.DATE)
    @Column(name = "ngayTruc")
    private Date ngayTruc;

    @Column(name = "noiDung")
    private String noiDung;

    @Column(name = "luuYBanGiao")
    private String luuYBanGiao;

    @Column(name = "maNguoiNhanCa")
    private Integer maNguoiNhanCa;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "thoiGianBanGiao")
    private Date thoiGianBanGiao;

    public NhatKyCaTruc() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaBaoVe() { return maBaoVe; }
    public void setMaBaoVe(Integer maBaoVe) { this.maBaoVe = maBaoVe; }

    public String getCaTruc() { return caTruc; }
    public void setCaTruc(String caTruc) { this.caTruc = caTruc; }

    public Date getNgayTruc() { return ngayTruc; }
    public void setNgayTruc(Date ngayTruc) { this.ngayTruc = ngayTruc; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getLuuYBanGiao() { return luuYBanGiao; }
    public void setLuuYBanGiao(String luuYBanGiao) { this.luuYBanGiao = luuYBanGiao; }

    public Integer getMaNguoiNhanCa() { return maNguoiNhanCa; }
    public void setMaNguoiNhanCa(Integer maNguoiNhanCa) { this.maNguoiNhanCa = maNguoiNhanCa; }

    public Date getThoiGianBanGiao() { return thoiGianBanGiao; }
    public void setThoiGianBanGiao(Date thoiGianBanGiao) { this.thoiGianBanGiao = thoiGianBanGiao; }
}
