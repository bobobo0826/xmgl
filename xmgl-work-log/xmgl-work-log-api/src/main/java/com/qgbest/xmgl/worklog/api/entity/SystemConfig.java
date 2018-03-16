package com.qgbest.xmgl.worklog.api.entity;
import lombok.Data;

import javax.persistence.*;

/**
 * Created by quangao on 2017/5/8.
 */
@Data
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
}
