package Entities;

import jakarta.persistence.*;

/**
 * Entity CuDan map 1-1 voi bang [cuDan] trong SQL Server (Jakarta Persistence 3.x)
 */
@Entity
@Table(name = "cuDan")
public class CuDan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maCanHo")
    private Integer maCanHo;

    @Column(name = "maTaiKhoan")
    private Integer maTaiKhoan;

    @Column(name = "hoTen", length = 255)
    private String hoTen;

    @Column(name = "soDienThoai", length = 20)
    private String soDienThoai;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "loaiCuDan", length = 50)
    private String loaiCuDan;

    @Column(name = "trangThai", length = 50)
    private String trangThai;

    public CuDan() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMaCanHo() {
        return maCanHo;
    }

    public void setMaCanHo(Integer maCanHo) {
        this.maCanHo = maCanHo;
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

    public String getLoaiCuDan() {
        return loaiCuDan;
    }

    public void setLoaiCuDan(String loaiCuDan) {
        this.loaiCuDan = loaiCuDan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
