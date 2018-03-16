package com.qgbest.xmgl.task.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by fcy on 2017/8/8.
 */
@Data
@Entity
@Table(name = "writing_standards")
public class  WritingStandards{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;

    @Column(name = "status")
    private String status;

    @Column(name = "standards_name")
    private String standards_name;

    @Column(name = "standards_content")
    private String standards_content;

    @Column(name = "creator")
    private String creator;

    @Column(name = "create_date")
    private String create_date;

    @Column(name = "modifier")
    private String modifier;


    @Column(name = "modify_date")
    private String modify_date;


    @Column(name = "order_no")
    private Integer order_no;

    @Column(name = "parent_id")
    private Integer parent_id;

}
