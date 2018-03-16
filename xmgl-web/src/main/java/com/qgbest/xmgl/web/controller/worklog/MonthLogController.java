package com.qgbest.xmgl.web.controller.worklog;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.client.PlanFeignClient;
import com.qgbest.xmgl.task.client.MyTaskFeignClient;
import com.qgbest.xmgl.task.client.TaskFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.client.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/monthLog")
public class MonthLogController extends BaseController {
    private static final Logger logger = LoggerFactory.getLogger(MonthLogController.class);
    @Autowired
    private MonthLogFeignClient monthFeignClient;
    @Autowired
    private WorkLogDictionaryFeignClient workLogDictionaryFeignClient;
    @Autowired
    private CommentsFeignClient commentsFeignClient;
    @Autowired
    private ThumbsUpFeignClient thumbsUpFeignClient;
    @Autowired
    private GlanceOverFeignClient glanceOverFeignClient;
    @Autowired
    private TaskFeignClient taskFeignClient;
    @Autowired
    private MyTaskFeignClient myTaskFeignClient;
    @Autowired
    private PlanFeignClient planFeignClient;

    /**
     * 初始化月日志列表界面
     */
    @RequestMapping(value = "/monthLogList")
    public ModelAndView monthLogList(HttpServletRequest request) {
        Map queryMap = getRequestMapStr2Str(request);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        Integer UserId = getCurUser().getId();
        model.put("UserId", UserId);
        //if (StringUtils.isNotBlankOrNull(queryMap.get("isOrNotNew"))) {
        //  model.put("isOrNotNew", queryMap.get("isOrNotNew"));
        //} else {
        //  model.put("isOrNotNew", null);
        //}
        model.put("isOrNotNew", queryMap.get("isOrNotNew"));
        String thisMonth = DateUtils.getCurrDateMonth();
        model.put("thisMonth", thisMonth);
        return new ModelAndView("/monthLog/monthLogList", model);
    }

    /**
     * 初始化月日志详情界面
     */
    @RequestMapping(value = "/monthLogInfo/{id}/{addOrComments}/{curModuleCode}")
    public ModelAndView monthLogInfo(@PathVariable Integer id, @PathVariable String addOrComments, @PathVariable String curModuleCode) {
        Map model = new HashMap();
        model.put("id", id);
        model.put("user", getCurUser().getDisplayName());
        Integer userId = getCurUser().getId();
        model.put("UserId", userId);
        model.put("curModuleCode", curModuleCode);
        model.put("addOrComments", addOrComments);
        model.put("imageUrl", this.imageUrl);
        return new ModelAndView("/monthLog/monthLogInfo", model);
    }

    /**
     * 初始化任务详情页面
     */
    @RequestMapping(value = "/initTaskPlanInfo")
    public ModelAndView initTaskPlanInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("gridIndex", queryMap.get("_rowIndex"));
        model.put("status_code", queryMap.get("status_code"));
        model.put("isCopy", queryMap.get("isCopy"));
        return new ModelAndView("/monthLog/monthTaskPlanInfo", model);
    }

    /**
     * 获取月日志列表
     */
    @RequestMapping(value = "/getMonthLogList", method = RequestMethod.POST)
    @ResponseBody
    public Map getMonthLogList() {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        return monthFeignClient.getMonthLogList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

    /**
     * 获取月日志详情
     */
    @RequestMapping(value = "/getMonthLogInfo/{id}/{business_type}/{parent_id}")
    @ResponseBody
    public Map getMonthLogInfo(@PathVariable Integer id, @PathVariable String business_type, @PathVariable Integer parent_id) {
        Map map = new HashMap();
        MonthLog monthLog = new MonthLog();
        monthLog = monthFeignClient.getMonthLogInfo(id);
        if (id == -1) {
            monthLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            monthLog.setCreator(getCurUser().getDisplayName());
            monthLog.setCreator_id(getCurUser().getId());
            monthLog.setStatus_code("CG");
            monthLog.setCreate_type("ZCLR");
        }
        String statusName = "";
        if (monthLog.getStatus_code() != null) {
            statusName = workLogDictionaryFeignClient.getDataNameByDataCode("log_status", monthLog.getStatus_code());
        }
        List logCreateTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        String type = "MYJH";
        List ThumbsUpList;
        ThumbsUpList = thumbsUpFeignClient.getThumbsUpListById(id, type);
        if (id != -1) {
            glanceOverFeignClient.UpdateAndSaveGlanceOver(id, getCurUser(), type);
        }
        List GlanceOverList;
        GlanceOverList = glanceOverFeignClient.getGlanceOverListById(id, type);
        map.put("logCreateTypeList", logCreateTypeList);
        map.put("monthLog", monthLog);
        map.put("statusName", statusName);
        map.put("ThumbsUpList", ThumbsUpList);
        map.put("GlanceOverList", GlanceOverList);

        /**
         * 获取评论
         */
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        map.put("comments", commentsFeignClient.getCommentsList(JsonUtil.toJson(queryMap), id, parent_id, business_type, monthLog.getCreator_id(), getCurUser()));
        return map;
    }

    /**
     * 删除
     */
    @RequestMapping(value = "/delMonthLog/{id}")
    @ResponseBody
    public ReturnMsg delMonthLog(@PathVariable Integer id) {
        return monthFeignClient.delMonthLog(id, getCurUser().getId(), getCurUser().getDisplayName());
    }

    /**
     * 保存
     */
    @RequestMapping(value = "/saveMonthLog")
    @ResponseBody
    public Map saveMonthLog(@ModelAttribute MonthLog monthLog) {
        /**
         * 修改情况下，更新修改人等
         */
        if (monthLog.getId() != null) {
            monthLog.setModify_date(DateUtils.getCurDateTime2Minute());
            monthLog.setModifier(getCurUser().getDisplayName());
            monthLog.setModifier_id(getCurUser().getId());
        }
        Map map = monthFeignClient.saveMonthLog(monthLog, getCurUser().getId(), getCurUser().getDisplayName());
        String statusName = "";
        if (monthLog.getStatus_code() != null) {
            statusName = workLogDictionaryFeignClient.getDataNameByDataCode("log_status", monthLog.getStatus_code());
        }
        map.put("statusName", statusName);
        return map;
    }

    /**
     * 获得每个任务的详情
     */
    @RequestMapping(value = "/getMonthLogTaskTypeDic")
    @ResponseBody
    public Map getMonthLogTaskTypeDic() {
        Map model = new HashMap();
        List taskTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("task_type");
        model.put("taskTypeList", taskTypeList);
        return model;
    }

    /**
     * 获得新增月任务数量
     */
    @RequestMapping(value = "/getMonthLogNumber")
    @ResponseBody
    public Map getMonthLogNumber() {
        Integer monthLogNumber;
        monthLogNumber = monthFeignClient.getMonthLogNumber();
        Map map = new HashMap();
        map.put("count", String.valueOf(monthLogNumber));
        return map;
    }

    @RequestMapping(value = "/getLogStatusDic")
    @ResponseBody
    public Map getLogStatusDic() {
        Map model = new HashMap();
        List logStatusList = workLogDictionaryFeignClient.getDicListByBusinessCode("log_status");
        model.put("logStatusList", logStatusList);
        return model;
    }

    @RequestMapping(value = "/getLogCreateTypeDic")
    @ResponseBody
    public Map getLogCreateTypeDic() {
        Map model = new HashMap();
        List create_type = workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        model.put("logCreateTypeList", create_type);
        return model;
    }

    @RequestMapping(value = "/getMonthLogContentListById/{id}")
    @ResponseBody
    public Map getMonthLogContentListById(@PathVariable Integer id) {
        String type = "MYJH";
        glanceOverFeignClient.UpdateAndSaveGlanceOver(id, getCurUser(), type);
        return monthFeignClient.getMonthLogContentListById(id);
    }

    /**
     * 更新计划的完成信息
     */
    @RequestMapping(value = "/saveComplete2Plan")
    @ResponseBody
    public Map saveComplete2Plan() {
        String actual_end_time = httpServletRequest.getParameter("actual_end_time");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        String delayReason = "";
        try {
            delayReason = URLDecoder.decode(httpServletRequest.getParameter("delay_reason"), "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setPlan_condition_code("YWC");
        plan.setActual_plan_end_time(actual_end_time);
        if (plan.getPlan_condition_code().equals("YWC")) {
            String end_time=plan.getPlan_end_time();
            if (actual_end_time.compareTo(end_time) < 0) {
                plan.setPlan_result_condition_code("TQWC");
            } else if(actual_end_time.compareTo(end_time) > 0){
                plan.setPlan_result_condition_code("YQWC");
            }else if(actual_end_time.compareTo(end_time) == 0){
                plan.setPlan_result_condition_code("ASWC");
            }
        }
        plan.setDelay_reason(delayReason);
        Map map = planFeignClient.savePlan(plan, getCurUser().getId(), getCurUser().getDisplayName());
        return map;
    }

    /**
     * 开始任务的时间和完成信息
     */
    @RequestMapping(value = "/saveActualStartTime2Plan")
    @ResponseBody
    public Map saveActualStartTime2Plan() {
        String delayReason = "";
        String actual_end_time=httpServletRequest.getParameter("actual_start_time");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setActual_plan_start_time(httpServletRequest.getParameter("actual_start_time"));
        try {
            if ("已完成".equals(URLDecoder.decode(httpServletRequest.getParameter("complete"), "utf-8"))) {
                plan.setPlan_condition_code("YWC");
                plan.setActual_plan_end_time(httpServletRequest.getParameter("actual_end_time"));
            }else{
                plan.setPlan_condition_code("JXZ");
            }
            delayReason = URLDecoder.decode(httpServletRequest.getParameter("delay_reason"), "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        if (plan.getPlan_condition_code().equals("YWC")) {
            String end_time=plan.getPlan_end_time();
            if (actual_end_time.compareTo(end_time) < 0) {
                plan.setPlan_result_condition_code("TQWC");
            } else if(actual_end_time.compareTo(end_time) > 0){
                plan.setPlan_result_condition_code("YQWC");
            }else if(actual_end_time.compareTo(end_time) == 0){
                plan.setPlan_result_condition_code("ASWC");
            }
        }
        plan.setDelay_reason(delayReason);
        Map map = planFeignClient.savePlan(plan, getCurUser().getId(), getCurUser().getDisplayName());
        return map;
    }

    @RequestMapping(value = "/saveUnComplete2Plan")
    @ResponseBody
    public Map saveUnComplete2Plan() {
        String work_date = httpServletRequest.getParameter("work_date");
        String actual_end_time = httpServletRequest.getParameter("actual_end_time");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setPlan_condition_code("JXZ");
       /* if (StringUtils.isEmpty(plan.getEnd_date())) {
            plan.setEnd_date(work_date + " " + actual_end_time);
        }
        if (plan.getComplete().equals("未完成")) {
            if (StringUtils.isEmpty(plan.getActual_start_time())) {
                plan.setComplete_type("WKS");
            } else if (StringUtils.isEmpty(plan.getActual_end_time())) {
                plan.setComplete_type("ZZSS");
            }
        }*/
        Map map = planFeignClient.savePlan(plan, getCurUser().getId(), getCurUser().getDisplayName());
        return map;
    }

}

