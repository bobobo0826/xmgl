package com.qgbest.xmgl.plan.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wangchao on 2017/10/10.
 */
@Data
@Entity
@Table(name = "plan_base")
public class Plan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32, nullable = false,unique = true)
    private Integer id;

    @Column(name = "task_id")
    private Integer task_id;

    @Column(name = "plan_name")
    private String plan_name;

    @Column(name = "plan_desc")
    private String plan_desc;

    @Column(name = "attachment")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String attachment;

    @Column(name = "plan_start_time")
    private String plan_start_time;

    @Column(name = "plan_end_time")
    private String plan_end_time;

    @Column(name = "plan_result_condition_code")
    private String plan_result_condition_code;

    @Column(name = "plan_result_summary")
    private String plan_result_summary;

    @Column(name = "creator")
    private String creator;

    @Column(name = "creator_id")
    private Integer creator_id;

    @Column(name = "contractor")
    private String contractor;

    @Column(name = "plan_condition_code")
    private String plan_condition_code;

    @Column(name = "modify_time")
    private String modify_time;

    @Column(name = "task_name")
    private String task_name;

    @Column(name = "actual_plan_start_time")
    private String actual_plan_start_time;

    @Column(name = "actual_plan_end_time")
    private String actual_plan_end_time;

    @Column(name = "create_time")
    private String create_time;

    @Column(name = "task_type_code")
    private String task_type_code;

    @Column(name = "sup_project_name")
    private String sup_project_name;

    @Column(name = "sup_module_name")
    private String sup_module_name;

    @Column(name = "delay_reason")
    private String delay_reason;

    @Column(name = "sup_project_id")
    private Integer sup_project_id;

    @Column(name = "sup_module_id")
    private Integer sup_module_id;


}
