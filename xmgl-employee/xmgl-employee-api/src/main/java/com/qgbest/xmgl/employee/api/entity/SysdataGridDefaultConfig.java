package com.qgbest.xmgl.employee.api.entity;

import javax.persistence.*;

/**
 * Created by quangao on 2017/5/18.
 */
@Entity
@Table(name="sysdata_grid_default_config")
public class SysdataGridDefaultConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 32, nullable = false, unique = true)
    private Integer id;

    @Column(name = "module_code", length = 128)
    private String module_code;

    @Column(name = "conf_val")
    private String conf_val;

    @Column(name = "create_date", length = 23)
    private String create_date;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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
}
