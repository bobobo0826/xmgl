package com.qgbest.xmgl.bugs;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by IntelliJ IDEA 2017.
 * User:lbb
 * Date:2017/8/29
 * Time:9:17
 * description:xmgl-new
 */
@Data
@Entity
@Table(name = "bug")
public class Bugs {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 64, nullable = false, unique = true)
    private Integer id;

    @Column(name = "status")
    private String status;

    @Column(name = "creator")
    private String creator;

    @Column(name = "create_date")
    private String createDate;

    @Column(name = "description")
    private String description;

    @Column(name = "module")
    private String module;

    @Column(name = "project")
    private String project;

    @Type(type = "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    @Column(name = "record")
    private String record;

    @Column(name = "responsible_person")
    private String responsible_person;

}
