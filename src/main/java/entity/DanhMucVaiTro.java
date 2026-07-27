package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "danhMucVaiTro")
public class DanhMucVaiTro {

    @Id
    @Column(name = "maVaiTro")
    private String maVaiTro;

    @Column(name = "tenVaiTro")
    private String tenVaiTro;

    public DanhMucVaiTro() {}

    public String getMaVaiTro() { return maVaiTro; }
    public void setMaVaiTro(String maVaiTro) { this.maVaiTro = maVaiTro; }

    public String getTenVaiTro() { return tenVaiTro; }
    public void setTenVaiTro(String tenVaiTro) { this.tenVaiTro = tenVaiTro; }
}
