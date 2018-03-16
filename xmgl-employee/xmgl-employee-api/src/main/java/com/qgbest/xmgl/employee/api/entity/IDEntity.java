package com.qgbest.xmgl.employee.api.entity;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by qince on 2015/7/3.
 */
@MappedSuperclass
public class IDEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID",length = 64,nullable = false,unique = true)
    private Integer id;

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

}
