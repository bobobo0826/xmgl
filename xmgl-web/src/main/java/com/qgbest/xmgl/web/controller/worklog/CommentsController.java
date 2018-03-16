package com.qgbest.xmgl.web.controller.worklog;

/**
 * Created by quangao-Lu Tianle on 2017/7/19.
 */

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.worklog.api.entity.Comments;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.client.MessageFeignClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.worklog.client.CommentsFeignClient;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/comments")
public class CommentsController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(CommentsController.class);
    @Autowired
    private CommentsFeignClient commentsFeignClient;
    @Autowired
    private MessageFeignClient messageFeignClient;

    /**
     * 获得评论
     * id是评论的日志的id
     * parent_id是父节点的id
     */
    @RequestMapping(value = "/getComments/{id}/{parent_id}/{business_type}/{creator_id}")
    @ResponseBody
    public Map getComments(
            @PathVariable Integer id,
            @PathVariable Integer parent_id,
            @PathVariable String business_type,
            @PathVariable Integer creator_id
    ) {
        Map map = new HashMap();
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        map.put("reply", commentsFeignClient.getCommentsList(JsonUtil.toJson(queryMap), id, parent_id, business_type, creator_id, getCurUser()));
        return map;
    }

    /**
     * 获得评论的回复
     * id是评论的日志的id
     * parent_id是父节点的id
     */
    @RequestMapping(value = "/getReply/{id}/{parent_id}/{business_type}/{creator_id}")
    @ResponseBody
    public Map getReply(
            @PathVariable Integer id,
            @PathVariable Integer parent_id,
            @PathVariable String business_type,
            @PathVariable Integer creator_id
    ) {
        Map map = new HashMap();
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        map.put("reply", commentsFeignClient.getCommentsList(JsonUtil.toJson(queryMap), id, parent_id, business_type, creator_id, getCurUser()));
        return map;
    }

    /**
     * 保存评论
     * log_type 是日志类型
     */
    @RequestMapping(value = "/saveComments/{log_type}/{log_id}/{creator_id}/{work_date}/{commentType}/{creator}")
    @ResponseBody
    public Map saveComments(@ModelAttribute Comments comments, @PathVariable String log_type, @PathVariable Integer log_id, @PathVariable Integer creator_id, @PathVariable String work_date, @PathVariable String commentType, @PathVariable String creator) {
        comments.setComment_time(DateUtils.getCurDateTime());
        comments.setCommentator_id(getCurUser().getId());
        comments.setCommentator_name(getCurUser().getDisplayName());
        comments.setCommentator_photo(getCurUser().getHeadPhoto());
        Map map = commentsFeignClient.saveComments(comments);
        Comments comments1 = (Comments) JsonUtil.fromJson(JsonUtil.toJson(map.get("comments")), Comments.class);
        String BusinessType = "";
        String Sender = "";

        if (log_type.equals("MRJH")) {
            BusinessType = " 【日日志】 ";
        } else if (log_type.equals("MZJH")) {
            BusinessType = " 【周日志】 ";
        } else {
            BusinessType = " 【月日志】 ";
        }

        MessageBase messageBase = new MessageBase();
        if (commentType.equals("NM")) {
            messageBase.setSenderId(0);
            Sender = "匿名";
        } else {
            messageBase.setSenderId(getCurUser().getId());
            Sender = getCurUser().getDisplayName();
        }
        try {
            creator = URLDecoder.decode(creator, "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        messageBase.setReceiver(creator);
        messageBase.setSender(getCurUser().getDisplayName());
        messageBase.setLogDate(work_date);
        messageBase.setSenderHeadPhoto(getCurUser().getHeadPhoto());
        messageBase.setBusinessType(log_type);
        messageBase.setBusinessId(log_id);
        messageBase.setMessageType("PL");
        messageBase.setIsChecked("0");
        messageBase.setReceiverId(creator_id);
        messageBase.setRemindTime(DateUtils.getCurDateTime2Minute());
        messageBase.setCommentId(comments1.getId());
        messageBase.setRemindTitle("来自：" + BusinessType + "：" + Sender);
        messageBase.setRemindContent("您的" + BusinessType + "{ " + work_date + " }" + "收到" + Sender + "的评论");
        messageFeignClient.saveMessage(messageBase);
        return map;
    }

    /**
     * 保存回复
     */
    @RequestMapping(value = "/saveReply/{log_type}/{log_id}/{commentator_id}/{work_date}/{commentType}/{commentator_name}")
    @ResponseBody
    public Map saveReply(@ModelAttribute Comments comments, @PathVariable String log_type, @PathVariable Integer log_id, @PathVariable Integer commentator_id, @PathVariable String work_date, @PathVariable String commentType, @PathVariable String commentator_name) {
        comments.setComment_time(DateUtils.getCurDateTime());
        comments.setReplier_id(getCurUser().getId());
        comments.setReplier_name(getCurUser().getDisplayName());
        comments.setReplier_photo(getCurUser().getHeadPhoto());
        Map map = commentsFeignClient.saveComments(comments);
        Comments comments1 = (Comments) JsonUtil.fromJson(JsonUtil.toJson(map.get("comments")), Comments.class);
        String BusinessType = "";
        String Sender = "";
        if (log_type.equals("MRJH")) {
            BusinessType = " 【日日志】 ";
        } else if (log_type.equals("MZJH")) {
            BusinessType = " 【周日志】 ";
        } else {
            BusinessType = " 【月日志】 ";
        }
        MessageBase messageBase = new MessageBase();

        if (commentType.equals("NM")) {
            messageBase.setSenderId(0);
            Sender = "匿名";
        } else {
            messageBase.setSenderId(getCurUser().getId());
            Sender = getCurUser().getDisplayName();
        }
        try {
            commentator_name = URLDecoder.decode(commentator_name, "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        messageBase.setReceiver(commentator_name);
        messageBase.setSender(getCurUser().getDisplayName());
        messageBase.setSenderHeadPhoto(getCurUser().getHeadPhoto());
        messageBase.setLogDate(work_date);
        messageBase.setBusinessType(log_type);
        messageBase.setBusinessId(log_id);
        messageBase.setMessageType("PL");
        messageBase.setIsChecked("0");
        messageBase.setReceiverId(commentator_id);
        messageBase.setRemindTime(DateUtils.getCurDateTime2Minute());
        messageBase.setCommentId(comments1.getId());
        messageBase.setRemindTitle("来自：" + BusinessType + "：" + Sender);
        messageBase.setRemindContent("您评论的" + BusinessType + "{ " + work_date + " }" + "收到" + Sender + "的回复");
        messageFeignClient.saveMessage(messageBase);
        return map;
    }

    /**
     * 删除评论
     */
    @RequestMapping(value = "/delComments")
    @ResponseBody
    public ReturnMsg delComments() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = commentsFeignClient.delComments(id);
        return returnMsg;
    }

    /**
     * 获得评论数
     * id是评论的日志的id
     * parent_id是父节点的id
     */
    @RequestMapping(value = "/getCommentsCount/{id}/{business_type}/{creator_id}")
    @ResponseBody
    public Map getCommentsCount(@PathVariable Integer id, @PathVariable String business_type, @PathVariable Integer creator_id) {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Integer CommentsCount;
        CommentsCount = commentsFeignClient.getCommentsCount(JsonUtil.toJson(queryMap), id, business_type, creator_id, getCurUser());
        Map map = new HashMap();
        map.put("comments_count", String.valueOf(CommentsCount));

        return map;
    }

}
