package com.qgbest.xmgl.worklog.api.entity;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
/**
 * Created by mjq on 2017/7/17.
 */
@Data
@Entity
@Table(name="hd_thumbs_up")
public class ThumbsUp {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;

    @Column(name = "thumbs_up_type")
    private String thumbs_up_type;

    @Column(name = "thumbs_up_subject_id")
    private Integer thumbs_up_subject_id;

    @Column(name = "thumbs_up_id")
    private Integer thumbs_up_id;

    @Column(name = "thumbs_up_name")
    private String thumbs_up_name;

    @Column(name = "thumbs_up_photo")
    private String thumbs_up_photo;

    @Column(name = "thumbs_up_time")
    private String thumbs_up_time;
}
