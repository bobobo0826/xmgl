package com.qgbest.xmgl.worklog.api.entity;
import lombok.Data;
import org.hibernate.annotations.Type;
import javax.persistence.*;
/**
 * Created by quangao on 2017/7/24.
 */
@Data
@Entity
@Table(name="update_log")
public class UpdateLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;

    @Column(name = "title")
    private String title;

    @Column(name = "content")
    private String content;

    @Column(name = "update_date")
    private String update_date;

    @Column(name = "create_date")
    private String create_date;

    @Column(name = "creator")
    private String creator;

    @Column(name = "creator_id")
    private Integer creator_id;

    @Column(name = "modifier")
    private String modifier;

    @Column(name = "modify_date")
    private String modify_date;

    @Column(name = "status")
    private String status;

}
