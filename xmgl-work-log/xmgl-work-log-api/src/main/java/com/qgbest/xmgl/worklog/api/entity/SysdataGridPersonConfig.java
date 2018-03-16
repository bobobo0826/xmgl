package com.qgbest.xmgl.worklog.api.entity;
import lombok.Data;

import javax.persistence.*;

/**
 * Created by quangao on 2017/5/24.
 */
@Data
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
}
