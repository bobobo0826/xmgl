package com.qgbest.xmgl.employee.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wjy on 2017/7/18.
 */
@Data
@Entity
@Table(name = "employees")
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "employee_name")
    private String employee_name;
    @Column(name = "employment_code")
    private String employment_code;
    @Column(name = "basic_info")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String basic_info;
    @Column(name = "photo")
    private String photo;
    @Column(name = "dept_id")
    private Integer dept_id;
    @Column(name = "dept_name")
    private String dept_name;
    @Column(name = "user_id")
    private Integer user_id;
    @Column(name = "creator")
    private String creator;
    @Column(name = "create_date")
    private String create_date;
    @Column(name = "modifier")
    private String modifier;
    @Column(name = "modify_date")
    private String modify_date;
    @Column(name = "creator_id")
    private Integer creator_id;
    @Column(name = "modifier_id")
    private Integer modifier_id;
    @Column(name = "position_code")
    private String position_code;
    @Column(name = "position_name")
    private String position_name;


}
