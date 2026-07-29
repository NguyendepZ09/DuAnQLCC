package entity;

import java.io.Serializable;
import java.util.Objects;

public class TheTuChucNangId implements Serializable {

    private Integer maThe;
    private String chucNang;

    public TheTuChucNangId() {}

    public TheTuChucNangId(Integer maThe, String chucNang) {
        this.maThe = maThe;
        this.chucNang = chucNang;
    }

    public Integer getMaThe() { return maThe; }
    public void setMaThe(Integer maThe) { this.maThe = maThe; }

    public String getChucNang() { return chucNang; }
    public void setChucNang(String chucNang) { this.chucNang = chucNang; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TheTuChucNangId that = (TheTuChucNangId) o;
        return Objects.equals(maThe, that.maThe) && Objects.equals(chucNang, that.chucNang);
    }

    @Override
    public int hashCode() {
        return Objects.hash(maThe, chucNang);
    }
}
