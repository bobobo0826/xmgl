package com.qgbest.xmgl.employee.api.entity;

import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by administror on 2017/5/11 0011.
 */
@Data
@Entity
@Table(name = "form_operate")
public class FormOperate extends IDEntity{
    @Column(name = "operatetypeid",length = 255)
    private Integer operatetypeid;
    @Column(name = "actiontype",length = 255)
    private String actiontype;
    @Column(name = "tablepk",length = 255)
    private String tablepk;
    @Column(name = "businesspk",length = 255)
    private String businesspk;
    @Column(name = "oldmodel",length = 255)
    private String oldmodel;
    @Column(name = "newmodel",length = 255)
    private String newmodel;
    @Column(name = "operator",length = 255)
    private String operator;
    @Column(name = "operatetime",length = 255)
    private String operatetime;
    @Column(name = "datapermission",length = 255)
    private String datapermission;
    @Column(name = "operaterdescrip",length = 255)
    private String operaterdescrip;
    @Column(name = "formtype",length = 255)
    private Integer formtype;
    @Column(name = "title",length = 255)
    private String title;
}
