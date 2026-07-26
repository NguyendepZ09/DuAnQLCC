package Entities;

import jakarta.persistence.*;
import java.util.Date;

/**
 * Entity PhanAnhSuCo map 1-1 voi bang [phanAnhSuCo]
 */
@Entity
@Table(name = "phanAnhSuCo")
public class PhanAnhSuCo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "maCuDan")
    private Integer maCuDan;

    @Column(name = "tieuDe", length = 255)
    private String tieuDe;

    @Column(name = "noiDung", length = 1000)
    private String noiDung;

    @Column(name = "trangThai", length = 50)
    private String trangThai; // 'Chờ tiếp nhận' | 'Đang xử lý' | 'Đã hoàn thành'

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngayTao")
    private Date ngayTao;

    public PhanAnhSuCo() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getMaCuDan() { return maCuDan; }
    public void setMaCuDan(Integer maCuDan) { this.maCuDan = maCuDan; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }
}
