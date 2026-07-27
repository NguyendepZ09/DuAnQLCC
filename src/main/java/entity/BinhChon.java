package entity;

import jakarta.persistence.*;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Entity BinhChon map 1-1 voi bang [binhChon]
 */
@Entity
@Table(name = "binhChon")
public class BinhChon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maThongBao", nullable = false)
    private Integer maThongBao;

    @Column(name = "cauHoi", length = 500, nullable = false)
    private String cauHoi;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayBatDau", nullable = false)
    private Date ngayBatDau = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "hanChot", nullable = false)
    private Date hanChot; // REQUIRED — caller (BinhChonAdminServlet) phai set truoc khi persist

    @Column(name = "trangThai", length = 20, nullable = false)
    private String trangThai; // REQUIRED — luon set la 'DangMo' khi tao moi

    @Column(name = "tyLeTucSo", nullable = false)
    private Double tyLeTucSo; // REQUIRED — caller phai set

    @Column(name = "ketQua", length = 200)
    private String ketQua;

    public BinhChon() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaThongBao() { return maThongBao; }
    public void setMaThongBao(Integer maThongBao) { this.maThongBao = maThongBao; }

    public String getCauHoi() { return cauHoi; }
    public void setCauHoi(String cauHoi) { this.cauHoi = cauHoi; }

    public Date getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Date ngayBatDau) { this.ngayBatDau = ngayBatDau; }

    public String getNgayBatDauFormatted() {
        if (ngayBatDau == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(ngayBatDau);
    }

    public Date getHanChot() { return hanChot; }
    public void setHanChot(Date hanChot) { this.hanChot = hanChot; }

    public String getHanChotFormatted() {
        if (hanChot == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(hanChot);
    }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Double getTyLeTucSo() { return tyLeTucSo; }
    public void setTyLeTucSo(Double tyLeTucSo) { this.tyLeTucSo = tyLeTucSo; }

    public String getKetQua() { return ketQua; }
    public void setKetQua(String ketQua) { this.ketQua = ketQua; }
}
