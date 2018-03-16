package com.qgbest.xmgl.employee.api.entity;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by administror on 2017/5/11 0011.
 */
@Data
@Entity
@Table(name = "form_operate_type")
public class FormOperateType implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "operatetypeid",length = 64,nullable = false,unique = true)
    private Integer operatetypeid;
    @Column(name = "operatetypename",length = 255)
    private String operatetypename;
    @Column(name = "tablerelationid",length = 255)
    private Integer tablerelationid;
    @Column(name = "maintableshowtype",length = 255)
    private String maintableshowtype;
    @Column(name = "relatetableshowtype",length = 255)
    private String relatetableshowtype;
    @Column(name = "formtype",length = 255)
    private Integer formtype;
}
