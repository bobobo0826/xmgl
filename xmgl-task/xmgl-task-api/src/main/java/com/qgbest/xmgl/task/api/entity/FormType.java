package com.qgbest.xmgl.task.api.entity;

import com.qgbest.xmgl.user.api.entity.IDEntity;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by administror on 2017/5/11 0011.
 */
@Data
@Entity
@Table(name = "form_type")
public class FormType extends IDEntity {
    // Fields
    @Column(name = "formtype",length = 255)
    private String formtype;
    @Column(name = "formtypedesc",length = 255)
    private String formtypedesc;
    @Column(name = "tableid",length = 255)
    private Integer tableid;
    @Column(name = "classname",length = 255)
    private String classname;
    @Column(name = "redirectname",length = 255)
    private String redirectname;
}
