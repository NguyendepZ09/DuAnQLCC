package entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "chamCong")
public class ChamCong {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maNhanVien")
    private Integer maNhanVien;

    @Column(name = "ngayLam")
    private LocalDate ngayLam;

    @Column(name = "gioVao")
    private LocalDateTime gioVao;

    @Column(name = "gioRa")
    private LocalDateTime gioRa;

    @Column(name = "caLam")
    private String caLam;

    public ChamCong() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public LocalDate getNgayLam() { return ngayLam; }
    public void setNgayLam(LocalDate ngayLam) { this.ngayLam = ngayLam; }

    public LocalDateTime getGioVao() { return gioVao; }
    public void setGioVao(LocalDateTime gioVao) { this.gioVao = gioVao; }

    public LocalDateTime getGioRa() { return gioRa; }
    public void setGioRa(LocalDateTime gioRa) { this.gioRa = gioRa; }

    public String getCaLam() { return caLam; }
    public void setCaLam(String caLam) { this.caLam = caLam; }
}
