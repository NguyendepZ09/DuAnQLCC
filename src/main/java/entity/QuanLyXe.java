package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "quanLyXe")
public class QuanLyXe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "maThe")
    private Integer maThe;

    @Column(name = "bienSoXe")
    private String bienSoXe;

    @Column(name = "loaiXe")
    private String loaiXe;

    public QuanLyXe() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }

    public Integer getMaThe() { return maThe; }
    public void setMaThe(Integer maThe) { this.maThe = maThe; }

    public String getBienSoXe() { return bienSoXe; }
    public void setBienSoXe(String bienSoXe) { this.bienSoXe = bienSoXe; }

    public String getLoaiXe() { return loaiXe; }
    public void setLoaiXe(String loaiXe) { this.loaiXe = loaiXe; }
}
