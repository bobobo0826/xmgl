package com.qgbest.xmgl.plan.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wangchao on 2017/10/10.
 */
@Data
@Entity
@Table(name = "output_process")
public class OutputProcess {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 32, nullable = false, unique = true)
    private Integer id;

    @Column(name = "process_status")
    private String process_status;

    @Column(name = "process_opr")
    private String process_opr;

    @Column(name = "output_id")
    private Integer output_id;

    @Column(name = "plan_id")
    private Integer plan_id;

    @Column(name = "output_category")
    private String output_category;

    @Column(name = "order_num")
    private String order_num;

    @Column(name = "output_type")
    private String output_type;

    @Column(name = "doc_name")
    private String doc_name;

    @Column(name = "output_desc")
    private String output_desc;

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
