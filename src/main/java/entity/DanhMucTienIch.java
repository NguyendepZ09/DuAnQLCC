package entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "danhMucTienIch")
public class DanhMucTienIch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "tenTienIch")
    private String tenTienIch;

    @Column(name = "moTa")
    private String moTa;

    @Column(name = "sucChua")
    private Integer sucChua;

    @Column(name = "giaThueMacDinh")
    private BigDecimal giaThueMacDinh;

    @Column(name = "trangThaiHoatDong")
    private String trangThaiHoatDong;

    @Column(name = "hinhAnh")
    private String hinhAnh;

    public DanhMucTienIch() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenTienIch() { return tenTienIch; }
    public void setTenTienIch(String tenTienIch) { this.tenTienIch = tenTienIch; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public Integer getSucChua() { return sucChua; }
    public void setSucChua(Integer sucChua) { this.sucChua = sucChua; }

    public BigDecimal getGiaThueMacDinh() { return giaThueMacDinh; }
    public void setGiaThueMacDinh(BigDecimal giaThueMacDinh) { this.giaThueMacDinh = giaThueMacDinh; }

    public String getTrangThaiHoatDong() { return trangThaiHoatDong; }
    public void setTrangThaiHoatDong(String trangThaiHoatDong) { this.trangThaiHoatDong = trangThaiHoatDong; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
}
