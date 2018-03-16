package com.qgbest.xmgl.task.api.entity;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by qince on 2015/7/3.
 */

@Data
@MappedSuperclass
public class IDEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID",length = 64,nullable = false,unique = true)
    private Integer id;
}
