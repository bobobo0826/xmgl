package com.qgbest.xmgl.web.controller.worklog;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.client.DayLogFeignClient;
import com.qgbest.xmgl.worklog.client.MessageFeignClient;
import com.qgbest.xmgl.worklog.client.MonthLogFeignClient;
import com.qgbest.xmgl.worklog.client.WeekLogFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017-07-18.
 */
@Controller
@RequestMapping(value = "/manage/message")
public class MessageController extends BaseController {
    @Autowired
    private MessageFeignClient messageFeignClient;
    @Autowired
    private DayLogFeignClient dayLogClient;
    @Autowired
    private WeekLogFeignClient weekLogFeignClient;
    @Autowired
    private MonthLogFeignClient monthFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;

    /**
     * 初始化评论消息展示页面
     *
     * @return
     */
    @RequestMapping(value = "/initShowCommentMsg")
    public ModelAndView initShowCommentMsg() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        Integer UserId = getCurUser().getId();
        String UserName = getCurUser().getDisplayName();
        model.put("UserId", UserId);
        model.put("UserName", UserName);
        model.put("imageUrl", imageUrl);
        return new ModelAndView("/message/showCommentMsg", model);

    }

    /**
     * 初始化点赞消息展示页面
     *
     * @return
     */
    @RequestMapping(value = "/initShowThumbUpMsg")
    public ModelAndView initShowThumbUpMsg() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        Integer UserId = getCurUser().getId();
        String UserName = getCurUser().getDisplayName();
        model.put("UserId", UserId);
        model.put("UserName", UserName);
        model.put("imageUrl", imageUrl);
        return new ModelAndView("/message/showThumbUpMsg", model);

    }

    /**
     * 查询消息
     *
     * @return
     */
    @RequestMapping(value = "/getMessageList")
    @ResponseBody
    public List getMessageList() throws ParseException {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        String timeDiff = "";
        long between = 0L;
        long day1 = 0L;
        long hour1 = 0L;
        long minute1 = 0L;
        List list = messageFeignClient.getMessageList(JsonUtil.toJson(queryMap));
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                Map map = (Map) list.get(i);
                SimpleDateFormat dfs = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Date begin = dfs.parse((String) map.get("remind_time"));
                Date end = dfs.parse(DateUtils.getCurDateTime2Minute());
                between = (end.getTime() - begin.getTime()) / 1000;//除以1000是为了转换成秒
                day1 = between / (24 * 3600);
                hour1 = between % (24 * 3600) / 3600;
                minute1 = between % 3600 / 60;
                if (day1 > 0) {
                    timeDiff = String.format("%s天前", day1);
                } else if (hour1 > 0) {
                    timeDiff = String.format("%s小时前", hour1);
                } else if (minute1 >= 0) {
                    timeDiff = String.format("%s分钟前", minute1);
                }
                map.put("timeDiff", timeDiff);//获得时间差
                //首页消息占用时间过多处理。和消息评论方法区分开
                    if (!"PL".equals(httpServletRequest.getParameter("messageType")) && !"DZ".equals(httpServletRequest.getParameter("messageType"))) {
                        continue;
                    }
                    if(StringUtils.isNotBlankOrNull(map.get("sender_id"))&&(0 == Integer.valueOf(map.get("sender_id")+""))){
                        map.put("sender_head_photo", null);
                    }
                  /*  TcUser sender = userFeignClient.getUserById((Integer) map.get("sender_id"));
                    if (sender != null) {
                        map.put("sender_name", sender.getDisplayName());
                        map.put("sender_head_photo", sender.getHeadPhoto());
                    } else {//若未查到消息发送者，则为匿名，使用默认头像
                        map.put("sender_name", "匿名");
                        map.put("sender_head_photo", "");
                }

                TcUser receiver = userFeignClient.getUserById((Integer) map.get("receiver_id"));
                if (StringUtils.isNotBlankOrNull(receiver)) {
                    map.put("receiver_name", receiver.getDisplayName());
                    map.put("receiver_head_photo", receiver.getHeadPhoto());
                }
                if (map.get("business_type").equals("MRJH")) {
                    map.put("business_name", "日日志");
                    DayLog daylog = dayLogClient.getDayLogInfoById((Integer) map.get("business_id"));
                    if (StringUtils.isNotBlankOrNull(daylog)) {
                        //若daylog为null，getWork_date()方法会报错
                        map.put("business_date", daylog.getWork_date());
                    }
                }
                if (map.get("business_type").equals("MZJH")) {
                    map.put("business_name", "周日志");
                    WeekLog weekLog = weekLogFeignClient.getWeekLogInfo((Integer) map.get("business_id"));
                    if (StringUtils.isNotBlankOrNull(weekLog)) {
                        map.put("business_date", weekLog.getTask_start_date());
                    }
                }
                if (map.get("business_type").equals("MYJH")) {
                    map.put("business_name", "月日志");
                    MonthLog monthLog = monthFeignClient.getMonthLogInfo((Integer) map.get("business_id"));
                    if (StringUtils.isNotBlankOrNull(monthLog)) {
                        map.put("business_date", monthLog.getWork_date());
                    }
                }
*/
            }

        }
        return list;
    }

    /**
     * 更改消息状态
     *
     * @return
     */
    @RequestMapping(value = "/checkMessage")
    @ResponseBody
    public Map checkMessage() {
        Map map = new HashMap();
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        queryMap.put("check_time", DateUtils.getCurDateTime2Minute());
        map = messageFeignClient.checkMessage(JsonUtil.toJson(queryMap));
        return map;
    }

}
