package com.qgbest.xmgl.worklog.api.entity;

import lombok.Data;

import javax.persistence.*;

/**
 * Created by quangao on 2017/5/18.
 */
@Data
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
}
