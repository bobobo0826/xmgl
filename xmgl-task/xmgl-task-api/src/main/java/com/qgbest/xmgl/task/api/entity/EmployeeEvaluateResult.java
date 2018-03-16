package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
/**
 * Created by quangao on 2017/9/28.
 */
@Data
@Entity
@Table(name = "employee_evaluate_result")
public class EmployeeEvaluateResult {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_id")
    private Integer task_id;
    @Column(name = "employee_id")
    private Integer employee_id;
    @Column(name = "evaluate_type_code")
    private String evaluate_type_code;
    @Column(name = "average_type")
    private Integer average_type;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "task_name")
    private String task_name;
    @Column(name = "employee_name")
    private String employee_name;

}
