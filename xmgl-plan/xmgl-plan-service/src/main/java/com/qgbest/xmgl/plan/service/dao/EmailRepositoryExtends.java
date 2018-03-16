package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.MailUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017/9/30.
 */
@Repository
public class EmailRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

    public Map getTempletByCode(String templet_code) {
        String sql = "Select templet_title, templet_content from email_templet " +
                "where templet_code = '" + templet_code + "'";
        List list = commonDao.getSql(sql);
        Map templet = null;
        if (list != null && list.size() > 0) {
            templet = (Map) list.get(0);
        }
        return templet;

    }

    public String sendEmailByTemplet(Map queryMap,TcUser user)throws UnsupportedEncodingException {

        System.out.println("queryMap===="+queryMap);
        user.getDisplayName();
        System.out.println("queryMapuser===="+user.getDisplayName());
        String context = "";
        String title = "";
        String timeDiff = "";
        Map templet = null;
        if (StringUtils.isNotBlankOrNull(queryMap.get("templet_code"))) {
            templet = getTempletByCode(queryMap.get("templet_code") + "");
        }

        if (templet != null) {
            title =templet.get("templet_title") + "";
            switch (queryMap.get("templet_code") + "") {
                case "CJJHTZ":
                    //参数：计划名称，计划制定人，计划开始时间，计划结束时间
                    context = String.format(templet.get("templet_content") + "", queryMap.get("plan_name"), queryMap.get("creator"), queryMap.get("plan_start_time"), queryMap.get("plan_end_time"));
                    break;
                case "JHBGTZ":
                    System.out.println("pre_plan_name===="+ queryMap.get("pre_plan_name")+"==plan_name=="+queryMap.get("plan_name"));
                    context = String.format(templet.get("templet_content") + "", queryMap.get("pre_plan_name"), queryMap.get("plan_name"), user.getDisplayName(),queryMap.get("nowPctNames"),queryMap.get("plan_end_time"),queryMap.get("alterDesc"));
                    break;
                case "JHCSBJ_C":
                    //参数：计划名称，计划制定人，计划开始时间，计划结束时间
                    context = String.format(templet.get("templet_content") + "", queryMap.get("plan_name"),  queryMap.get("plan_end_time"), queryMap.get("timeDiff"));
                    break;
                case "JHCSBJ_R":
                    //参数：计划名称，计划制定人，计划开始时间，计划结束时间
                    context = String.format(templet.get("templet_content") + "", queryMap.get("plan_name"), queryMap.get("creator"), queryMap.get("plan_end_time"), queryMap.get("timeDiff"));
                    break;
                default:
                    break;
            }
        }
        title= URLEncoder.encode(title,"UTF-8");
        context=URLEncoder.encode(context,"UTF-8");
        System.out.println("====title===" + title);
        System.out.println("====context===" + context);
        Map sendMap = new HashMap();
        sendMap.put("to", queryMap.get("receivers"));
        sendMap.put("subject", title);
        sendMap.put("context", context);
        String result = MailUtil.sendMail(sendMap);
        return result;
    }

    public String getTimeDiff(String task_end_time) {
        String timeDiff = "";
        String taskEndTime = "";
        String curTime = DateUtils.getCurDateTime2Minute();
        SimpleDateFormat DateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try{
            Date end_time = DateFormat.parse(task_end_time);
            taskEndTime = DateFormat.format(end_time);
        }catch (Exception e){
            e.printStackTrace();
        }
        if (curTime.compareTo(taskEndTime) <= 0) {
            try {
                int betweenDays = DateUtils.getBetweenDays(curTime, taskEndTime, "yyyy-MM-dd HHmm");
                timeDiff = betweenDays+"天";
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            try {
                int betweenDays = DateUtils.getBetweenDays(taskEndTime, curTime, "yyyy-MM-dd HHmm");
                timeDiff = betweenDays+"天";
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return timeDiff;
    }

    /*public String getTempletByCode(Map queryMap) {
        String sql = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("templet_code"))) {
            sql += "Select templet_title, templet_content from email_templet " +
                    "where templet_code = '" + queryMap.get("templet_code") + "'";
        }
        List list = commonDao.getSql(sql);
        Map templet = null;
        if(list!=null&&list.size()>0) {
             templet = (Map) list.get(0);
        }
        return  sendEmailByTemplet(queryMap, templet);

    }
    public String sendEmailByTemplet(Map queryMap, Map templet){
        String context ="";
        String title = "";
        if(templet != null) {
            title = templet.get("templet_title") + "";
            switch(queryMap.get("templet_code")+""){
                case "CJJHTZ" :
                    //参数：计划名称，计划制定人，计划开始时间，计划结束时间
                    context = String.format(templet.get("templet_content") + "", queryMap.get("task_name"), queryMap.get("creator"), queryMap.get("task_start_time"), queryMap.get("task_end_time"));
                        break;
                case "JHCSBJ_C":
                    //参数：计划名称，计划结束时间，超期时长（天）
                    context = String.format(templet.get("templet_content") + "", queryMap.get("task_name"), queryMap.get("task_end_time"),queryMap.get("over_time"));
                    break;
                case "JHCSBJ_R" :
                    //参数：计划名称，计划制定人，计划结束时间，超期时长
                    context = String.format(templet.get("templet_content") + "", queryMap.get("task_name"), queryMap.get("creator"), queryMap.get("task_end_time"),queryMap.get("over_time"));
                    break;
                case "JHWCTZ" :
                    //参数：计划名称，计划诚承接人，计划完成类型
                    context = String.format(templet.get("templet_content") + "", queryMap.get("task_name"), queryMap.get("receiver"), queryMap.get("complete_type"));
                    break;
                default :
                    break;
            }
        }
        System.out.println("====title===" + title);
        System.out.println("====context===" + context);
        Map sendMap = new HashMap();
        sendMap.put("to", queryMap.get("receivers"));
        sendMap.put("subject", title);
        sendMap.put("context", context);
        String result = MailUtil.sendMail(sendMap);
        return result;
    }*/
}
