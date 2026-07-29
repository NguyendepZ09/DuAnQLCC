package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "theTu_ChucNang")
@IdClass(TheTuChucNangId.class)
public class TheTuChucNang {

    @Id
    @Column(name = "maThe")
    private Integer maThe;

    @Id
    @Column(name = "chucNang")
    private String chucNang;

    public TheTuChucNang() {}

    public TheTuChucNang(Integer maThe, String chucNang) {
        this.maThe = maThe;
        this.chucNang = chucNang;
    }

    public Integer getMaThe() { return maThe; }
    public void setMaThe(Integer maThe) { this.maThe = maThe; }

    public String getChucNang() { return chucNang; }
    public void setChucNang(String chucNang) { this.chucNang = chucNang; }
}
