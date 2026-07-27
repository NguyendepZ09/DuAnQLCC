package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "danhMucBoPhan")
public class DanhMucBoPhan {

    @Id
    @Column(name = "maBoPhan")
    private String maBoPhan;

    @Column(name = "tenBoPhan")
    private String tenBoPhan;

    public DanhMucBoPhan() {}

    public String getMaBoPhan() { return maBoPhan; }
    public void setMaBoPhan(String maBoPhan) { this.maBoPhan = maBoPhan; }

    public String getTenBoPhan() { return tenBoPhan; }
    public void setTenBoPhan(String tenBoPhan) { this.tenBoPhan = tenBoPhan; }
}
