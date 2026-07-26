package Entities;

import jakarta.persistence.*;

/**
 * Entity CanHo map 1-1 voi bang [canHo] (soTang, soPhong, trangThai)
 */
@Entity
@Table(name = "canHo")
public class CanHo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "soTang")
    private Integer soTang;

    @Column(name = "soPhong", length = 255)
    private String soPhong;

    @Column(name = "trangThai", length = 255)
    private String trangThai; // 'TrongChoThue' | 'DangO' | 'BaoTri' | ...

    @Transient
    private Double dienTich = 75.0; // Gia tri mac dinh de hien thi UI

    public CanHo() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getSoTang() { return soTang; }
    public void setSoTang(Integer soTang) { this.soTang = soTang; }

    public String getSoPhong() { return soPhong; }
    public void setSoPhong(String soPhong) { this.soPhong = soPhong; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Double getDienTich() { return dienTich; }
    public void setDienTich(Double dienTich) { this.dienTich = dienTich; }

    // --- Alias Getter & Setter Compatibility ---
    public Integer getTang() { return soTang; }
    public void setTang(Integer tang) { this.soTang = tang; }

    public String getSoCanHo() { return soPhong; }
    public void setSoCanHo(String soCanHo) { this.soPhong = soCanHo; }
}
