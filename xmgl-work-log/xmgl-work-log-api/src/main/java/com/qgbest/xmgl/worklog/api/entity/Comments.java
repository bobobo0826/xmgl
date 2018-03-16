package com.qgbest.xmgl.worklog.api.entity;

import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by quangao-Lu Tianle on 2017/7/18.
 */
@Entity
@Table(name = "hd_comments")
public class Comments implements Serializable{

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", length = 64, nullable = false, unique = true)
  private Integer id;

  @Column(name = "comment_type")
  private String comment_type;

  @Column(name = "commentator_id")
  private Integer commentator_id;

  @Column(name = "commentator_name")
  private String commentator_name;

  @Column(name = "commentator_photo")
  private String commentator_photo;

  @Column(name = "replier_id")
  private Integer replier_id;

  @Column(name = "replier_name")
  private String replier_name;

  @Column(name = "replier_photo")
  private String replier_photo;

  @Column(name = "business_type")
  private String business_type;

  @Column(name = "business_id")
  private Integer business_id;

  @Column(name = "content")
  private String content;

  @Column(name = "comment_time")
  private String comment_time;

  @Column(name = "parent_id")
  private Integer parent_id;

  @Column(name = "reply_type")
  private String reply_type;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getComment_type() {
    return comment_type;
  }

  public void setComment_type(String comment_type) {
    this.comment_type = comment_type;
  }

  public Integer getCommentator_id() {
    return commentator_id;
  }

  public void setCommentator_id(Integer commentator_id) {
    this.commentator_id = commentator_id;
  }

  public String getCommentator_name() {
    return commentator_name;
  }

  public void setCommentator_name(String commentator_name) {
    this.commentator_name = commentator_name;
  }

  public String getCommentator_photo() {
    return commentator_photo;
  }

  public void setCommentator_photo(String commentator_photo) {
    this.commentator_photo = commentator_photo;
  }

  public Integer getReplier_id() {
    return replier_id;
  }

  public void setReplier_id(Integer replier_id) {
    this.replier_id = replier_id;
  }

  public String getReplier_name() {
    return replier_name;
  }

  public void setReplier_name(String replier_name) {
    this.replier_name = replier_name;
  }

  public String getReplier_photo() {
    return replier_photo;
  }

  public void setReplier_photo(String replier_photo) {
    this.replier_photo = replier_photo;
  }

  public String getBusiness_type() {
    return business_type;
  }

  public void setBusiness_type(String business_type) {
    this.business_type = business_type;
  }

  public Integer getBusiness_id() {
    return business_id;
  }

  public void setBusiness_id(Integer business_id) {
    this.business_id = business_id;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getComment_time() {
    return comment_time;
  }

  public void setComment_time(String comment_time) {
    this.comment_time = comment_time;
  }

  public Integer getParent_id() {
    return parent_id;
  }

  public void setParent_id(Integer parent_id) {
    this.parent_id = parent_id;
  }

  public String getReply_type() {
    return reply_type;
  }

  public void setReply_type(String reply_type) {
    this.reply_type = reply_type;
  }
}
