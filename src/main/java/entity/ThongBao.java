package entity;

import jakarta.persistence.*;
import java.util.Date;

/**
 * Entity ThongBao map 1-1 voi bang [thongBao]
 */
@Entity
@Table(name = "thongBao")
public class ThongBao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maNhanVien", nullable = false)
    private Integer maNhanVien = 1;

    @Column(name = "tieuDe", length = 255)
    private String tieuDe;

    @Column(name = "noiDung", length = 2000)
    private String noiDung;

    @Column(name = "loaiThongBao", length = 255)
    private String loaiThongBao;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayTao")
    private Date ngayTao;

    @Column(name = "doiTuong", length = 255)
    private String doiTuong = "TatCa";

    @Column(name = "loai", length = 255)
    private String loai = "Chung";

    public ThongBao() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(Integer maNhanVien) { this.maNhanVien = maNhanVien; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getLoaiThongBao() { return loaiThongBao; }
    public void setLoaiThongBao(String loaiThongBao) { this.loaiThongBao = loaiThongBao; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    public String getDoiTuong() { return doiTuong; }
    public void setDoiTuong(String doiTuong) { this.doiTuong = doiTuong; }

    public String getLoai() { return loai; }
    public void setLoai(String loai) { this.loai = loai; }
}
