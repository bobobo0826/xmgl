package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wjy
 * Date:2017/10/18
 * Time:14:30
 * description:xmgl-serve
 */
@Data
@Entity
@Table(name = "task_alter")
public class TaskAlter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_id")
    private  Integer task_id;
    @Column(name = "alter_desc")
    private String alter_desc;
    @Column(name = "alter_content")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String alter_content;
    @Column(name = "alter_affect")
    private String alter_affect;
    @Column(name = "task_name")
    private String task_name;
    @Column(name = "alter_person")
    private String alter_person;
    @Column(name = "alter_time")
    private String alter_time;
    @Column(name = "alter_person_id")
    private Integer alter_person_id;

}
