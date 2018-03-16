package com.qgbest.xmgl.worklog.api.entity;

import lombok.Data;

import javax.persistence.*;

/**
 * Created by wangchao on 2017-07-18.
 */
@Data
@Entity
@Table(name = "hd_message_base")
public class MessageBase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "business_type")
    private String businessType;
    @Column(name = "message_type")
    private String messageType;
    @Column(name = "business_id")
    private Integer businessId;
    @Column(name = "is_checked")
    private String isChecked;
    @Column(name = "remind_time")
    private String remindTime;
    @Column(name = "check_time")
    private String checkTime;
    @Column(name = "remind_title")
    private String remindTitle;
    @Column(name = "remind_content")
    private String remindContent;
    @Column(name = "sender_id")
    private Integer senderId;
    @Column(name = "receiver_id")
    private Integer receiverId;
    @Column(name = "comment_id")
    private Integer commentId;
    @Column(name = "sender")
    private String sender;
    @Column(name = "receiver")
    private String receiver;
    @Column(name = "sender_head_photo")
    private String senderHeadPhoto;
    @Column(name = "log_date")
    private String logDate;

}
