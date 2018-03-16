package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wangchao on 2017/10/12.
 */
@Data
@Entity
@Table(name = "task_process")
public class TaskProcess {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32, nullable = false,unique = true)
    private Integer id;

    @Column(name = "process_opr")
    private String process_opr;

    @Column(name ="task_id")
    private Integer task_id;

    @Column(name = "task_name")
    private String task_name;

    @Column(name = "task_type_code")
    private String task_type_code;

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

    @Column(name = "task_desc")
    private String task_desc;

    @Column(name = "creator")
    private String creator;

    @Column(name = "create_time")
    private String create_time;

    @Column(name = "modifier")
    private String modifier;

    @Column(name = "modify_time")
    private String modify_time;

    @Column(name = "creator_id")
    private Integer creator_id;

    @Column(name = "modifier_id")
    private Integer modifier_id;

    @Column(name = "plan_list")
    private String plan_list;

    @Column(name = "participants")
    private String participants;

    @Column(name = "report_cycle")
    private String report_cycle;

    @Column(name = "importance")
    private String importance;

    @Column(name = "urgency")
    private String urgency;

    @Column(name = "checker_id")
    private Integer checker_id;

    @Column(name = "check_time")
    private String checker_time;

    @Column(name = "check_desc")
    private String checker_desc;

    @Column(name = "task_proj_type_code")
    private String task_proj_type_code;

    @Column(name = "assigned_checker")
    private String assigned_checker;

    @Column(name = "assigned_checker_id")
    private Integer assigned_checker_id;

    @Column(name = "checker")
    private String checker;

    @Column(name = "sup_task_id")
    private Integer sup_task_id;

    @Column(name = "sup_task_name")
    private String sup_task_name;

    @Column(name = "result_files")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String result_files;

    @Column(name = "detail")
    private String detail;

    @Column(name = "sup_subproject_id")
    private Integer sup_subproject_id;

    @Column(name = "sup_subproject_name")
    private String sup_subproject_name;

    @Column(name = "task_type")
    private String task_type;

    @Column(name = "attachment")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String attachment;

    @Column(name = "task_start_time")
    private String task_start_time;

    @Column(name = "task_end_time")
    private String task_end_time;

    @Column(name = "task_result_condition")
    private String task_result_condition;

    @Column(name = "task_result_summary")
    private String task_result_summary;

    @Column(name = "excepted_end_time")
    private String excepted_end_time;

    @Column(name = "change_info")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String change_info;

    @Column(name = "operator_id")
    private Integer operator_id;

    @Column(name = "operator")
    private String operator;

    @Column(name = "record_time")
    private String record_time;

}
