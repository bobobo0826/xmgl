package com.qgbest.xmgl.worklog.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by quangao on 2017/7/4.
 */
@Data
@Entity
@Table(name = "log_day")
public class DayLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "work_date")
    private String work_date;
    @Column(name = "day_summary")
    private String day_summary;
    @Column(name = "next_plan")
    private String next_plan;
    @Column(name = "work_explain")
    private String work_explain;
    @Column(name = "create_type")
    private String create_type;
    @Column(name = "creator")
    private String creator;
    @Column(name = "create_date")
    private String create_date;
    @Column(name = "modifier")
    private String modifier;
    @Column(name = "modify_date")
    private String modify_date;
    @Column(name = "status_code")
    private String status_code;
    @Column(name = "content")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String content;
    @Column(name = "creator_id")
    private Integer creator_id;
    @Column(name = "modifier_id")
    private Integer modifier_id;
}
