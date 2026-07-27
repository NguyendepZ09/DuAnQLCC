package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "chiTietHoaDon")
public class ChiTietHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maHoaDon")
    private Integer maHoaDon;

    @Column(name = "loaiDichVu")
    private String loaiDichVu;

    @Column(name = "chiSoCu")
    private Double chiSoCu;

    @Column(name = "chiSoMoi")
    private Double chiSoMoi;

    @Column(name = "thanhTien")
    private BigDecimal thanhTien;

    public ChiTietHoaDon() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaHoaDon() { return maHoaDon; }
    public void setMaHoaDon(Integer maHoaDon) { this.maHoaDon = maHoaDon; }

    public String getLoaiDichVu() { return loaiDichVu; }
    public void setLoaiDichVu(String loaiDichVu) { this.loaiDichVu = loaiDichVu; }

    public Double getChiSoCu() { return chiSoCu; }
    public void setChiSoCu(Double chiSoCu) { this.chiSoCu = chiSoCu; }

    public Double getChiSoMoi() { return chiSoMoi; }
    public void setChiSoMoi(Double chiSoMoi) { this.chiSoMoi = chiSoMoi; }

    public BigDecimal getThanhTien() { return thanhTien; }
    public void setThanhTien(BigDecimal thanhTien) { this.thanhTien = thanhTien; }
}
