package Entities;

import jakarta.persistence.*;

/**
 * Entity NhanVien map 1-1 voi bang [nhanVien] trong SQL Server (Jakarta Persistence 3.x)
 */
@Entity
@Table(name = "nhanVien")
public class NhanVien {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maTaiKhoan")
    private Integer maTaiKhoan;

    @Column(name = "hoTen", length = 255)
    private String hoTen;

    @Column(name = "soDienThoai", length = 20)
    private String soDienThoai;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "boPhan", length = 50)
    private String boPhan;

    public NhanVien() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMaTaiKhoan() {
        return maTaiKhoan;
    }

    public void setMaTaiKhoan(Integer maTaiKhoan) {
        this.maTaiKhoan = maTaiKhoan;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBoPhan() {
        return boPhan;
    }

    public void setBoPhan(String boPhan) {
        this.boPhan = boPhan;
    }
}
