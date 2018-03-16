package com.qgbest.xmgl.task.api.entity;
import javax.persistence.*;

/**
 * Created by quangao on 2017/5/8.
 */
@Entity
@Table(name="system_conf")
public class SystemConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 32, nullable = false, unique = true)
    private Integer id;

    @Column(name = "data_code", length = 32)
    private String data_code;

    @Column(name = "data_value", length = 512)
    private String data_value;

    @Column(name = "data_desc", length = 512)
    private String data_desc;

    @Column(name = "is_used", length = 32)
    private Integer is_used;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getData_code() {
        return data_code;
    }

    public void setData_code(String data_code) {
        this.data_code = data_code;
    }

    public String getData_value() {
        return data_value;
    }

    public void setData_value(String data_value) {
        this.data_value = data_value;
    }

    public String getData_desc() {
        return data_desc;
    }

    public void setData_desc(String data_desc) {
        this.data_desc = data_desc;
    }

    public Integer getIs_used() {
        return is_used;
    }

    public void setIs_used(Integer is_used) {
        this.is_used = is_used;
    }

}
