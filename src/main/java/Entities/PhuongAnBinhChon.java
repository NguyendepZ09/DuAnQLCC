package Entities;

import jakarta.persistence.*;

/**
 * Entity PhuongAnBinhChon map 1-1 voi bang [phuongAnBinhChon]
 */
@Entity
@Table(name = "phuongAnBinhChon")
public class PhuongAnBinhChon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maBinhChon", nullable = false)
    private Integer maBinhChon;

    @Column(name = "noiDung", length = 255, nullable = false)
    private String noiDung;

    @Column(name = "thuTu", nullable = false)
    private Integer thuTu = 1;

    @Transient
    private Integer soLuotChon = 0;

    public PhuongAnBinhChon() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaBinhChon() { return maBinhChon; }
    public void setMaBinhChon(Integer maBinhChon) { this.maBinhChon = maBinhChon; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public Integer getThuTu() { return thuTu; }
    public void setThuTu(Integer thuTu) { this.thuTu = thuTu; }

    public Integer getSoLuotChon() { return soLuotChon; }
    public void setSoLuotChon(Integer soLuotChon) { this.soLuotChon = soLuotChon; }
}
