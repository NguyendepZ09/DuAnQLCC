package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "nhatKyTuanTra")
public class NhatKyTuanTra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maBaoVe")
    private Integer maBaoVe;

    @Column(name = "soTang")
    private Integer soTang;

    @Column(name = "thoiGianQuet", insertable = false, updatable = false)
    private LocalDateTime thoiGianQuet;

    @Column(name = "anhMinhChung")
    private String anhMinhChung;

    public NhatKyTuanTra() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaBaoVe() { return maBaoVe; }
    public void setMaBaoVe(Integer maBaoVe) { this.maBaoVe = maBaoVe; }

    public Integer getSoTang() { return soTang; }
    public void setSoTang(Integer soTang) { this.soTang = soTang; }

    public LocalDateTime getThoiGianQuet() { return thoiGianQuet; }
    public void setThoiGianQuet(LocalDateTime thoiGianQuet) { this.thoiGianQuet = thoiGianQuet; }

    public String getAnhMinhChung() { return anhMinhChung; }
    public void setAnhMinhChung(String anhMinhChung) { this.anhMinhChung = anhMinhChung; }
}
