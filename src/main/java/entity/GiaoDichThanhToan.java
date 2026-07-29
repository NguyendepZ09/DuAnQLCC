package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "giaoDichThanhToan")
public class GiaoDichThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maHoaDon")
    private Integer maHoaDon;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "soTien")
    private BigDecimal soTien;

    @Column(name = "phuongThuc")
    private String phuongThuc;

    @Column(name = "maGiaoDichNganHang")
    private String maGiaoDichNganHang;

    @Column(name = "trangThai")
    private String trangThai;

    @Column(name = "thoiGianTao")
    private LocalDateTime thoiGianTao;

    @Column(name = "thoiGianXacNhan")
    private LocalDateTime thoiGianXacNhan;

    @Column(name = "soThamChieuSaoKe")
    private String soThamChieuSaoKe;

    @Column(name = "ghiChuDoiSoat")
    private String ghiChuDoiSoat;

    public GiaoDichThanhToan() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaHoaDon() { return maHoaDon; }
    public void setMaHoaDon(Integer maHoaDon) { this.maHoaDon = maHoaDon; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public BigDecimal getSoTien() { return soTien; }
    public void setSoTien(BigDecimal soTien) { this.soTien = soTien; }

    public String getPhuongThuc() { return phuongThuc; }
    public void setPhuongThuc(String phuongThuc) { this.phuongThuc = phuongThuc; }

    public String getMaGiaoDichNganHang() { return maGiaoDichNganHang; }
    public void setMaGiaoDichNganHang(String maGiaoDichNganHang) { this.maGiaoDichNganHang = maGiaoDichNganHang; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public LocalDateTime getThoiGianTao() { return thoiGianTao; }
    public void setThoiGianTao(LocalDateTime thoiGianTao) { this.thoiGianTao = thoiGianTao; }

    public LocalDateTime getThoiGianXacNhan() { return thoiGianXacNhan; }
    public void setThoiGianXacNhan(LocalDateTime thoiGianXacNhan) { this.thoiGianXacNhan = thoiGianXacNhan; }

    public String getSoThamChieuSaoKe() { return soThamChieuSaoKe; }
    public void setSoThamChieuSaoKe(String soThamChieuSaoKe) { this.soThamChieuSaoKe = soThamChieuSaoKe; }

    public String getGhiChuDoiSoat() { return ghiChuDoiSoat; }
    public void setGhiChuDoiSoat(String ghiChuDoiSoat) { this.ghiChuDoiSoat = ghiChuDoiSoat; }
}
