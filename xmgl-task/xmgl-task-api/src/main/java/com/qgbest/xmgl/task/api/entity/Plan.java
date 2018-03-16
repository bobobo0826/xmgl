package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by mjq on 2017/7/26.
 */
@Data
@Entity
@Table(name = "plan_base")
public class Plan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_id")
    private Integer task_id;
    @Column(name = "plan_name")
    private String plan_name;
    @Column(name = "plan_desc")
    private String plan_desc;
    @Column(name = "start_date")
    private String start_date;
    @Column(name = "end_date")
    private String end_date;
    @Column(name = "complete")
    private String complete;
    @Column(name = "participants")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String participants;
    @Column(name = "actual_start_time")
    private String actual_start_time;
    @Column(name = "actual_end_time")
    private String actual_end_time;
    @Column(name = "is_cancel")
    private String is_cancel;
    @Column(name = "create_time")
    private String create_time;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "modified_flag")
    private String modified_flag;
    @Column(name = "complete_type")
    private String complete_type;
    @Column(name = "delay_reason")
    private String delay_reason;

}
