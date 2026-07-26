package entity;

import jakarta.persistence.*;

/**
 * Entity TaiKhoan map 1-1 voi bang [taiKhoan] trong SQL Server (Jakarta Persistence 3.x)
 */
@Entity
@Table(name = "taiKhoan")
public class TaiKhoan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maTaiKhoan", length = 255)
    private String maTaiKhoan;

    @Column(name = "tenDangNhap", length = 255)
    private String tenDangNhap;

    @Column(name = "matKhau", length = 255, nullable = false)
    private String matKhau;

    @Column(name = "vaiTro", length = 10, nullable = false)
    private String vaiTro;

    @Column(name = "boPhanCode", length = 10)
    private String boPhanCode;

    @Column(name = "trangThaiHoatDong", length = 255)
    private String trangThaiHoatDong;

    public TaiKhoan() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(String maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(String vaiTro) {
        this.vaiTro = vaiTro;
    }

    public String getBoPhanCode() {
        return boPhanCode;
    }

    public void setBoPhanCode(String boPhanCode) {
        this.boPhanCode = boPhanCode;
    }

    public String getTrangThaiHoatDong() {
        return trangThaiHoatDong;
    }

    public void setTrangThaiHoatDong(String trangThaiHoatDong) {
        this.trangThaiHoatDong = trangThaiHoatDong;
    }
}
