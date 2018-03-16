package com.qgbest.xmgl.web.controller.worklog;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.client.MessageFeignClient;
import com.qgbest.xmgl.worklog.client.ThumbsUpFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;
/**
 * Created by mjq on 2017/7/18.
 */
@Controller
@RequestMapping(value = "/manage/thumbsUp")
public class ThumbsUpController extends BaseController{
    @Autowired
    public ThumbsUpFeignClient thumbsUpFeignClient;
    @Autowired
    private MessageFeignClient messageFeignClient;


    /**
     * 保存点赞信息
     *
     * @return
     */
    @RequestMapping(value = "/saveThumbsUpInfo")
    @ResponseBody
    public Map saveThumbsUpInfo(@ModelAttribute ThumbsUp thumbsUp) {
        thumbsUp.setThumbs_up_time(DateUtils.getCurDateTime2Minute());
        thumbsUp.setThumbs_up_name(getCurUser().getDisplayName());
        thumbsUp.setThumbs_up_id(getCurUser().getId());
        thumbsUp.setThumbs_up_photo(getCurUser().getHeadPhoto());
        Map map=thumbsUpFeignClient.saveThumbsUpInfo(thumbsUp);
        return map;
    }
    /**
     * 删除周点赞信息
     *
     * @return
     */
    @RequestMapping(value = "/delThumbsUpInfo")
    @ResponseBody
    public ReturnMsg delThumbsUpInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        String type=String.valueOf(queryMap.get("type"));
        ReturnMsg returnMsg = thumbsUpFeignClient.delThumbsUpInfo(id,getCurUser(),type);
        return returnMsg;
    }

    @RequestMapping(value = "/saveMessage/{id}/{creator_id}/{type}/{task_start_date}/{creator}")
    @ResponseBody
    public ReturnMsg saveMessage(@PathVariable Integer id, @PathVariable Integer creator_id,@PathVariable String type,@PathVariable String task_start_date,@PathVariable String creator) {
        MessageBase messageBase = new MessageBase();
        try {
            creator = URLDecoder.decode(creator, "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        messageBase.setReceiver(creator);
        messageBase.setSenderHeadPhoto(getCurUser().getHeadPhoto());
        messageBase.setLogDate(task_start_date);
        messageBase.setSender(getCurUser().getDisplayName());
        messageBase.setBusinessType(type);//日志类型
        messageBase.setBusinessId(id);//日志id
        messageBase.setMessageType("DZ");//评论or点赞
        messageBase.setIsChecked("0");//字符串0表示未读
        messageBase.setReceiverId(creator_id);//被评论人，即消息接收者
        messageBase.setSenderId(getCurUser().getId());//评论人，即消息发送者
        messageBase.setRemindTime(DateUtils.getCurDateTime2Minute());
        //remind_title 和 remind_content自己拼接
        if(type.equals("MZJH")) {
            messageBase.setRemindTitle("来自： 【周日志】：" + getCurUser().getDisplayName());
            messageBase.setRemindContent("您的 【周日志】 " + "{ " + task_start_date + " }" + " 收到" + getCurUser().getDisplayName() + "的点赞");
        }
        if(type.equals("MRJH")){
            messageBase.setRemindTitle("来自： 【日日志】：" + getCurUser().getDisplayName());
            messageBase.setRemindContent("您的 【日日志】 " + "{ " + task_start_date + " }" + " 收到" + getCurUser().getDisplayName() + "的点赞");
        }
        if(type.equals("MYJH")){
            messageBase.setRemindTitle("来自： 【月日志】：" + getCurUser().getDisplayName());
            messageBase.setRemindContent("您的 【月日志】 " + "{ " + task_start_date + " }" + " 收到" + getCurUser().getDisplayName() + "的点赞");
        }

        ReturnMsg returnMsg = messageFeignClient.saveMessage(messageBase);

        return returnMsg;
    }





}
