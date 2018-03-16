package com.qgbest.xmgl.worklog.api.entity;
import org.hibernate.annotations.Type;
import lombok.Data;
import javax.persistence.*;
/**
 * Created by mjq on 2017/7/19.
 */
@Data
@Entity
@Table(name="hd_glance_over")
public class GlanceOver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;

    @Column(name = "glance_over_type")
    private String glance_over_type;

    @Column(name = "glance_over_subject_id")
    private Integer glance_over_subject_id;

    @Column(name = "glance_over_id")
    private Integer glance_over_id;

    @Column(name = "glance_over_name")
    private String glance_over_name;

    @Column(name = "glance_over_photo")
    private String glance_over_photo;

    @Column(name = "glance_over_time")
    private String glance_over_time;

   /* public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getGlance_over_type() {
        return glance_over_type;
    }
    public void setGlance_over_type(String glance_over_type) {
        this.glance_over_type = glance_over_type;
    }

    public Integer getGlance_over_subject_id() {
        return glance_over_subject_id;
    }
    public void setGlance_over_subject_id(Integer glance_over_subject_id) {
        this.glance_over_subject_id = glance_over_subject_id;
    }

    public Integer getGlance_over_id() {
        return glance_over_id;
    }
    public void setGlance_over_id(Integer glance_over_id) {
        this.glance_over_id = glance_over_id;
    }

    public String getGlance_over_name() {
        return glance_over_name;
    }
    public void setGlance_over_name(String glance_over_name) {
        this.glance_over_name = glance_over_name;
    }

    public String getGlance_over_photo() {
        return glance_over_photo;
    }
    public void setGlance_over_photo(String glance_over_photo) {
        this.glance_over_photo = glance_over_photo;
    }

    public String getGlance_over_time() {
        return glance_over_time;
    }

    public void setGlance_over_time(String glance_over_time) {
        this.glance_over_time = glance_over_time;
    }*/




}
