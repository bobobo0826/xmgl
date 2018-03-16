package com.qgbest.xmgl.plan.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

@Data
@Entity
@Table(name = "plan_alter")
public class PlanAlter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "plan_id")
    private  Integer plan_id;
    @Column(name = "alter_desc")
    private String alter_desc;
    @Column(name = "alter_content")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String alter_content;
    @Column(name = "alter_affect")
    private String alter_affect;
    @Column(name = "plan_name")
    private String plan_name;
    @Column(name = "alter_person")
    private String alter_person;
    @Column(name = "alter_time")
    private String alter_time;
    @Column(name = "alter_person_id")
    private Integer alter_person_id;

}
