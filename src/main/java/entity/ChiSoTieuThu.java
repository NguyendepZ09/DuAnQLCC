package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "chiSoTieuThu")
public class ChiSoTieuThu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "loaiDichVu")
    private String loaiDichVu;

    @Column(name = "thang")
    private Integer thang;

    @Column(name = "nam")
    private Integer nam;

    @Column(name = "chiSo")
    private Double chiSo;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayGhi")
    private Date ngayGhi;

    public ChiSoTieuThu() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }

    public String getLoaiDichVu() { return loaiDichVu; }
    public void setLoaiDichVu(String loaiDichVu) { this.loaiDichVu = loaiDichVu; }

    public Integer getThang() { return thang; }
    public void setThang(Integer thang) { this.thang = thang; }

    public Integer getNam() { return nam; }
    public void setNam(Integer nam) { this.nam = nam; }

    public Double getChiSo() { return chiSo; }
    public void setChiSo(Double chiSo) { this.chiSo = chiSo; }

    public Date getNgayGhi() { return ngayGhi; }
    public void setNgayGhi(Date ngayGhi) { this.ngayGhi = ngayGhi; }
}
