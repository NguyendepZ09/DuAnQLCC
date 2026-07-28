package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "bieuGiaDichVu")
public class BieuGiaDichVu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "loaiDichVu")
    private String loaiDichVu;

    @Column(name = "bacTu")
    private BigDecimal bacTu;

    @Column(name = "bacDen")
    private BigDecimal bacDen;

    @Column(name = "donGia")
    private BigDecimal donGia;

    @Column(name = "hieuLucTu")
    private LocalDate hieuLucTu;

    @Column(name = "nguonGia")
    private String nguonGia;

    public BieuGiaDichVu() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getLoaiDichVu() { return loaiDichVu; }
    public void setLoaiDichVu(String loaiDichVu) { this.loaiDichVu = loaiDichVu; }

    public BigDecimal getBacTu() { return bacTu; }
    public void setBacTu(BigDecimal bacTu) { this.bacTu = bacTu; }

    public BigDecimal getBacDen() { return bacDen; }
    public void setBacDen(BigDecimal bacDen) { this.bacDen = bacDen; }

    public BigDecimal getDonGia() { return donGia; }
    public void setDonGia(BigDecimal donGia) { this.donGia = donGia; }

    public LocalDate getHieuLucTu() { return hieuLucTu; }
    public void setHieuLucTu(LocalDate hieuLucTu) { this.hieuLucTu = hieuLucTu; }

    public String getNguonGia() { return nguonGia; }
    public void setNguonGia(String nguonGia) { this.nguonGia = nguonGia; }
}
