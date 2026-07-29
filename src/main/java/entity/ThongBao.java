package entity;

import jakarta.persistence.*;
import java.text.SimpleDateFormat;
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
    private String loaiThongBao = "ThongThuong";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayTao")
    private Date ngayTao = new Date();

    @Column(name = "doiTuong", length = 255)
    private String doiTuong = "TatCa";

    @Column(name = "maCanHo")
    private Integer maCanHo;

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

    public String getNgayTaoFormatted() {
        if (ngayTao == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(ngayTao);
    }

    public String getDoiTuong() { return doiTuong; }
    public void setDoiTuong(String doiTuong) { this.doiTuong = doiTuong; }

    public Integer getMaCanHo() { return maCanHo; }
    public void setMaCanHo(Integer maCanHo) { this.maCanHo = maCanHo; }
}
