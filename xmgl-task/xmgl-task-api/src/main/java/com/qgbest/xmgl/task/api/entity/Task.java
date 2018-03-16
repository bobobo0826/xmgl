package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wjy on 2017/7/26.
 */
@Data
@Entity
@Table(name = "task_base")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_name")
    private String task_name;
    @Column(name = "task_type_code")
    private String task_type_code;
    @Column(name = "expected_end_time")
    private String expected_end_time;
    @Column(name = "task_condition_code")
    private String task_condition_code;
    @Column(name = "complete")
    private String complete;
    @Column(name = "sup_project_id")
    private Integer sup_project_id;
    @Column(name = "sup_project_name")
    private String sup_project_name;
    @Column(name = "sup_module_id")
    private Integer sup_module_id;
    @Column(name = "sup_module_name")
    private String sup_module_name;
    @Column(name = "sup_task_id")
    private Integer sup_task_id;
    @Column(name = "sup_task_name")
    private String sup_task_name;
    @Column(name = "task_desc")
    private String task_desc;
    @Column(name = "report_cycle_code")
    private String report_cycle;
    @Column(name = "urgency")
    private String urgency;
    @Column(name = "importance")
    private String importance;
    @Column(name = "creator")
    private String creator;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "creator_id")
    private Integer creator_id;
    @Column(name = "create_time")
    private String create_time;
    @Column(name = "modifier")
    private String modifier;
    @Column(name = "modifier_id")
    private Integer modifier_id;
    @Column(name = "participants")
    private String participants;
    @Column(name = "result_files")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String result_files;
    @Column(name = "task_start_time")
    private String task_start_time;
    @Column(name = "task_end_time")
    private String task_end_time;
    @Column(name = "task_result_condition")
    private String task_result_condition;
    @Column(name = "task_result_summary")
    private String task_result_summary;
    @Column(name = "detail")
    private String detail;
    @Column(name = "confirm_employee")
    private String confirm_employee;
    @Column(name = "attachment")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String attachment;



}
