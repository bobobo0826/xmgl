package com.qgbest.xmgl.worklog.api.entity;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.io.Serializable;
@Data
@Entity
@Table(name = "log_month")
public class MonthLog implements Serializable {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", length = 64, nullable = false, unique = true)
  private Integer id;

  @Column(name = "work_date")
  private String work_date;

  @Column(name = "month_summary")
  private String month_summary;

  @Column(name = "next_plan")
  private String next_plan;

  @Column(name = "creator")
  private String creator;

  @Column(name = "create_date")
  private String create_date;

  @Column(name = "modifier")
  private String modifier;

  @Column(name = "modify_date")
  private String modify_date;

  @Column(name = "content")
  @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
  private String content;

  @Column(name = "create_type")
  private String create_type;

  @Column(name = "status_code")
  private String status_code;

  @Column(name = "creator_id")
  private Integer creator_id;

  @Column(name = "modifier_id")
  private Integer modifier_id;

  @Column(name = "work_explain")
  private String work_explain;
}
