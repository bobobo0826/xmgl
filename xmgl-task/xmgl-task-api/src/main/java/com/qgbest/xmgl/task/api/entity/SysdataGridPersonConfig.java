package com.qgbest.xmgl.task.api.entity;
import javax.persistence.*;

/**
 * Created by quangao on 2017/5/24.
 */
@Entity
@Table(name="sysdata_grid_person_config")
public class SysdataGridPersonConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 32, nullable = false, unique = true)
    private Integer id;

    @Column(name = "user_id", length = 32)
    private Integer user_id;

    @Column(name = "user_name", length = 64)
    private String user_name;

    @Column(name = "module_code", length = 128)
    private String module_code;
    @Column(name = "conf_val", length = 128)
    private String conf_val;

    @Column(name = "create_date", length = 128)
    private String create_date;

    public Integer getId() {
        return id;
    }

    public String getModule_code() {
        return module_code;
    }

    public void setModule_code(String module_code) {
        this.module_code = module_code;
    }

    public String getConf_val() {
        return conf_val;
    }

    public void setConf_val(String conf_val) {
        this.conf_val = conf_val;
    }

    public String getCreate_date() {
        return create_date;
    }

    public void setCreate_date(String create_date) {
        this.create_date = create_date;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }


}
