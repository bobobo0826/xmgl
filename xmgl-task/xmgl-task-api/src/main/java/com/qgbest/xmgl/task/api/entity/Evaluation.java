package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
/**
 * Created by quangao on 2017/9/28.
 */
@Data
@Entity
@Table(name = "evaluation")
public class Evaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_id")
    private Integer task_id;
    @Column(name = "evaluate_object_code")
    private String evaluate_object_code;
    @Column(name = "single_contractor")
    private String single_contractor;
    @Column(name = "evaluate_type_code")
    private String evaluate_type_code;
    @Column(name = "evaluate_sup_type_code")
    private String evaluate_sup_type_code;
    @Column(name = "evaluate_level_code")
    private String evaluate_level_code;
    @Column(name = "evaluate_description")
    private String evaluate_description;
    @Column(name = "evaluate_people")
    private String evaluate_people;
    @Column(name = "evaluate_time")
    private String evaluate_time;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "task_name")
    private String task_name;

}
