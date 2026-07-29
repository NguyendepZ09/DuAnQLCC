package entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

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

    @Column(name = "ngayTruc")
    private LocalDate ngayTruc;

    @Column(name = "noiDung")
    private String noiDung;

    @Column(name = "luuYBanGiao")
    private String luuYBanGiao;

    @Column(name = "maNguoiNhanCa")
    private Integer maNguoiNhanCa;

    @Column(name = "thoiGianBanGiao")
    private LocalDateTime thoiGianBanGiao;

    public NhatKyCaTruc() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaBaoVe() { return maBaoVe; }
    public void setMaBaoVe(Integer maBaoVe) { this.maBaoVe = maBaoVe; }

    public String getCaTruc() { return caTruc; }
    public void setCaTruc(String caTruc) { this.caTruc = caTruc; }

    public LocalDate getNgayTruc() { return ngayTruc; }
    public void setNgayTruc(LocalDate ngayTruc) { this.ngayTruc = ngayTruc; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getLuuYBanGiao() { return luuYBanGiao; }
    public void setLuuYBanGiao(String luuYBanGiao) { this.luuYBanGiao = luuYBanGiao; }

    public Integer getMaNguoiNhanCa() { return maNguoiNhanCa; }
    public void setMaNguoiNhanCa(Integer maNguoiNhanCa) { this.maNguoiNhanCa = maNguoiNhanCa; }

    public LocalDateTime getThoiGianBanGiao() { return thoiGianBanGiao; }
    public void setThoiGianBanGiao(LocalDateTime thoiGianBanGiao) { this.thoiGianBanGiao = thoiGianBanGiao; }
}
