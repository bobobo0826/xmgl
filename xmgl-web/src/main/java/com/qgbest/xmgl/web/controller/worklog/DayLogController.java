package com.qgbest.xmgl.web.controller.worklog;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.client.PlanFeignClient;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.client.MyTaskFeignClient;
import com.qgbest.xmgl.task.client.TaskFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.client.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/4.
 * 日计划Controller
 */
@Controller
@RequestMapping(value = "/manage/dayLog")
public class DayLogController extends BaseController {

    @Autowired
    private DayLogFeignClient dayLogClient;
    @Autowired
    private WorkLogDictionaryFeignClient workLogDictionaryFeignClient;
    @Autowired
    private WorkLogSystemConfigFeignClient workLogSystemConfigFeignClient;
    @Autowired
    private ThumbsUpFeignClient thumbsUpFeignClient;
    @Autowired
    private CommentsFeignClient commentsFeignClient;
    @Autowired
    private GlanceOverFeignClient glanceOverFeignClient;
    @Autowired
    private WeekLogFeignClient weekLogFeignClient;
    @Autowired
    private TaskFeignClient taskFeignClient;
    @Autowired
    private MyTaskFeignClient myTaskFeignClient;
    @Autowired
    private PlanFeignClient planFeignClient;


    /**
     * 初始化日志列表
     */
    @RequestMapping(value = "/dayLogManage")
    public ModelAndView initDayLogList() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        Integer UserId = getCurUser().getId();
        model.put("UserId", UserId);
        if (StringUtils.isNotBlankOrNull(queryMap.get("isOrNotNew"))) {
            model.put("isOrNotNew", queryMap.get("isOrNotNew"));
        } else {
            model.put("isOrNotNew", null);
        }
        String today = DateUtils.getCurDateTimeDay();
        model.put("dateOfToday", today);
        return new ModelAndView("/dayLog/dayLogList", model);
    }

    @RequestMapping(value = "/queryDayLogList")
    @ResponseBody
    public Map queryDayLogList() {

        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        return dayLogClient.getDayLogList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

    @RequestMapping(value = "/initDayLogInfo/{id}/{addOrComments}/{curModuleCode}")
    public ModelAndView initDayLogInfo(@PathVariable Integer id, @PathVariable String addOrComments, @PathVariable String curModuleCode) {
        Map model = new HashMap();
        model.put("id", id);
        Integer UserId = getCurUser().getId();
        model.put("UserId", UserId);
        model.put("curModuleCode", curModuleCode);
        model.put("addOrComments", addOrComments);
        model.put("imageUrl", this.imageUrl);
        return new ModelAndView("/dayLog/dayLogInfo", model);
    }

    @RequestMapping(value = "/getDayLogInfoById/{id}/{business_type}/{parent_id}")
    @ResponseBody
    public Map getDayLogInfoById(@PathVariable Integer id, @PathVariable String business_type, @PathVariable Integer parent_id) {
        Map map = new HashMap();
        DayLog dayLog = new DayLog();

        dayLog = dayLogClient.getDayLogInfoById(id);

        if (id == -1) {
            dayLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            dayLog.setCreator(getCurUser().getDisplayName());
            dayLog.setCreator_id(getCurUser().getId());
            dayLog.setStatus_code("CG");
            dayLog.setCreate_type("ZCLR");
        }
        String statusName = "";
        if (dayLog.getStatus_code() != null) {
            statusName = workLogDictionaryFeignClient.getDataNameByDataCode("log_status", dayLog.getStatus_code());
        }
        String value = workLogSystemConfigFeignClient.getDataValue("WXSJ");//午休时间
        String[] order_date = value.split(",");
        List logCreateTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        String type = "MRJH";
        List ThumbsUpList;
        ThumbsUpList = thumbsUpFeignClient.getThumbsUpListById(id, type);
        if (id != -1) {
            glanceOverFeignClient.UpdateAndSaveGlanceOver(id, getCurUser(), type);
        }
        List GlanceOverList;
        GlanceOverList = glanceOverFeignClient.getGlanceOverListById(id, type);
        map.put("logCreateTypeList", logCreateTypeList);
        map.put("dayLog", dayLog);
        map.put("statusName", statusName);
        map.put("lunch_break_from", order_date[0]);
        map.put("lunch_break_to", order_date[1]);
        map.put("ThumbsUpList", ThumbsUpList);
        map.put("GlanceOverList", GlanceOverList);

        /**
         * 获取评论
         */
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        map.put("comments", commentsFeignClient.getCommentsList(JsonUtil.toJson(queryMap), id, parent_id, business_type, dayLog.getCreator_id(), getCurUser()));
        return map;
    }

    @RequestMapping(value = "/getDayLogContentListById/{id}")
    @ResponseBody
    public Map getDayLogContentListById(@PathVariable Integer id) {
        String type = "MRJH";
        glanceOverFeignClient.UpdateAndSaveGlanceOver(id, getCurUser(), type);
        return dayLogClient.getDayLogContentListById(id);
    }

    @RequestMapping(value = "/delDayLog/{id}")
    @ResponseBody
    public ReturnMsg delDayLog(@PathVariable Integer id) {
        return dayLogClient.delDayLog(id, getCurUser().getId(), getCurUser().getDisplayName());
    }

    /**
     * 保存日志
     *
     * @param dayLog 日志
     * @return 存储操作日志的map
     */
    @RequestMapping(value = "/saveDayLog")
    @ResponseBody
    public Map saveDayLog(@ModelAttribute DayLog dayLog) {
        /**
         * 修改情况下，更新修改人等
         */
        if (dayLog.getId() != null) {
            dayLog.setModify_date(DateUtils.getCurDateTime2Minute());
            dayLog.setModifier(getCurUser().getDisplayName());
            dayLog.setModifier_id(getCurUser().getId());
        }
        Map map = dayLogClient.saveDayLog(dayLog, getCurUser().getId(), getCurUser().getDisplayName());
        String statusName = "";
        if (dayLog.getStatus_code() != null) {
            statusName = workLogDictionaryFeignClient.getDataNameByDataCode("log_status", dayLog.getStatus_code());
        }
        map.put("statusName", statusName);
        return map;
    }

    @RequestMapping(value = "/getDayLogTaskTypeDic")
    @ResponseBody
    public Map getDayLogTaskTypeDic() {
        Map model = new HashMap();
        List taskTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("task_type");
        model.put("taskTypeList", taskTypeList);
        return model;
    }

    @RequestMapping(value = "/initTaskPlanInfo")
    public ModelAndView initTaskPlanInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("gridIndex", queryMap.get("_rowIndex"));
        model.put("isCopy", queryMap.get("isCopy"));
        model.put("work_date", queryMap.get("work_date"));
        return new ModelAndView("/dayLog/dayTaskPlanInfo", model);

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
        List logCreateTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        model.put("logCreateTypeList", logCreateTypeList);
        return model;
    }

    @RequestMapping(value = "/getNewDayLogNumbers")
    @ResponseBody
    public Map getTodayLogNumbers() {
        Integer newDayLogNumbers;
        newDayLogNumbers = dayLogClient.getNewDayLogNumbers();
        Map map = new HashMap();
        map.put("count", String.valueOf(newDayLogNumbers));
        return map;
    }

    @RequestMapping(value = "/getAbleTime")
    @ResponseBody
    public Map getAbleTime() {
        String lunchBreak = workLogSystemConfigFeignClient.getDataValue("WXSJ");
        String workTime = workLogSystemConfigFeignClient.getDataValue("SXBSJ");
        String[] lunchBreaks = lunchBreak.split(",");
        String[] workTimes = workTime.split(",");
        Map map = new HashMap();
        map.put("lunchBreakStart", lunchBreaks[0]);
        map.put("lunchBreakEnd", lunchBreaks[1]);
        map.put("workTimeStart", workTimes[0]);
        map.put("workTimeEnd", workTimes[1]);
        map.put("success", true);
        return map;
    }

    @RequestMapping(value = "/getDaySysConfByStart")
    @ResponseBody
    public Map getDaySysConfByStart() throws ParseException {
        String value = workLogSystemConfigFeignClient.getDataValue("WXSJ");
        String[] values = value.split(",");
        String start_time = httpServletRequest.getParameter("start_time");
        String end_time = httpServletRequest.getParameter("end_time");
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        Date startTime = sdf.parse(start_time);
        Date endTime = sdf.parse(end_time);
        Map map = new HashMap();
        if (endTime.getTime() < startTime.getTime()) {
            map.put("msg", "开始时间不可大于结束时间！");
            return map;
        }
        if (startTime.getTime() <= sdf.parse(values[0]).getTime() && endTime.getTime() >= sdf.parse(values[1]).getTime()) {
            map.put("msg", "开始时间和结束时间跨越了午休时间！");
            return map;
        }
        map.put("msgCode", 1);
        return map;
    }

    /**
     * 保存日日志总结到周日志
     */
    @RequestMapping(value = "/saveDaySummary2WeekLog")
    @ResponseBody
    public Map saveDaySummary2WeekLog() {
        String workDate = httpServletRequest.getParameter("work_date");
        String daySummary = "";
        try {
            daySummary = URLDecoder.decode(httpServletRequest.getParameter("day_summary"), "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String MondayDate = "";
        String fridayDate = "";
        try {
            Date date = sdf.parse(workDate);
            Integer weekDay = DateUtils.getWeekDay(date);
            MondayDate = sdf.format(DateUtils.dateAdd(date, 1 - weekDay));
            fridayDate = sdf.format(DateUtils.dateAdd(date, 5 - weekDay));
        } catch (ParseException exception) {
            exception.printStackTrace();
        }
        //查询monday_date为起始日期的周日志id并取其中最大的id
        List weekLogIdList = weekLogFeignClient.getWeekLogIdByTaskStartDate(getCurUser(), MondayDate);
        Map contentMap = new HashMap();
        WeekLog weekLog = new WeekLog();
        contentMap.put("record", daySummary);
        contentMap.put("complete", "未完成");
        contentMap.put("task_end_time", workDate);
        contentMap.put("task_start_time", workDate);
        contentMap.put("task_type", "XMRW");
        contentMap.put("period_start", workDate);
        contentMap.put("period_end", workDate);
        contentMap.put("task_name", "日总结");
        if (weekLogIdList != null && weekLogIdList.size() != 0) {
            Map weekLogIdMap = (Map) (weekLogIdList.get(0));
            Integer id = Integer.parseInt(weekLogIdMap.get("id") + "");
            weekLog = weekLogFeignClient.getWeekLogInfo(id);
            List content = JsonUtil.fromJsonToList(weekLog.getContent());
            content.add(contentMap);
            weekLog.setContent(JsonUtil.toJson(content));
        } else {
            weekLog.setTask_start_date(MondayDate);
            weekLog.setTask_end_date(fridayDate);
            weekLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            weekLog.setCreator(getCurUser().getDisplayName());
            weekLog.setCreator_id(getCurUser().getId());
            weekLog.setStatus_code("CG");
            weekLog.setWeek_summary("暂无");
            weekLog.setNext_plan("暂无");
            if (DateUtils.getCurrDate("yyyy-MM-dd").compareTo(fridayDate) > 0) {
                weekLog.setCreate_type("BL");
            } else {
                weekLog.setCreate_type("ZCLR");
            }
            String content = "[" + JsonUtil.toJson(contentMap) + "]";
            weekLog.setContent(content);
        }
        Map map = weekLogFeignClient.saveWeekLogInfo(weekLog, getCurUser().getId(), getCurUser().getDisplayName());
        return map;
    }

    /**
     * 新增临时任务回写到任务管理，计划管理
     */
    @RequestMapping(value = "/saveNewTemTask2TaskAndPlan")
    @ResponseBody
    public Map saveNewTemTask2TaskAndPlan(@ModelAttribute Task task, @ModelAttribute Plan plan) {
        String work_date = httpServletRequest.getParameter("work_date");
        //保存任务
        task.setCreator(getCurUser().getDisplayName());
        task.setCreator_id(getCurUser().getId());
        task.setCreate_time(DateUtils.getCurDateTime2Minute());
        task.setTask_condition_code("YXF");
        if (task.getComplete().equals("已完成")) {
            task.setComplete("100%");
        } else {
            task.setComplete("0%");
        }
        task.setReport_cycle("DAY");
        Map mapTask = taskFeignClient.saveTask(task, getCurUser().getId(), getCurUser().getDisplayName());
        Task newTask = (Task) JsonUtil.fromJson(JsonUtil.toJson(mapTask.get("task")), Task.class);
        //保存计划
        plan.setTask_id(newTask.getId());
        plan.setCreate_time(DateUtils.getCurDateTime2Minute());
       // plan.setModified_flag("0");
        Map participantsMap = new HashMap();
        participantsMap.put("name", getCurUser().getDisplayName());
        participantsMap.put("photo", getCurUser().getHeadPhoto());
        participantsMap.put("employe_id", getCurUser().getId());
        participantsMap.put("mobilephone_number", "");
        String participants = "[" + JsonUtil.toJson(participantsMap) + "]";
      /*  plan.setParticipants(participants);
        plan.setStart_date(work_date + " " + plan.getStart_date());
        plan.setActual_start_time(work_date + " " + plan.getActual_start_time());
        plan.setIs_cancel("未注销");
        if (plan.getComplete().equals("已完成")) {
            plan.setActual_end_time(work_date + " " + plan.getActual_end_time());
            plan.setEnd_date(work_date + " " + plan.getEnd_date());
        } else {
            plan.setActual_end_time("");
            plan.setEnd_date("");
        }
        Map mapPlan = taskFeignClient.savePlan(plan, getCurUser().getId(), getCurUser().getDisplayName());*/
        Map mapPlan=null;

        return mapPlan;
    }

    /**
     * 更新计划的完成信息
     */
    @RequestMapping(value = "/saveComplete2Plan")
    @ResponseBody
    public Map saveComplete2Plan() {
        String work_date = httpServletRequest.getParameter("work_date");
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
        plan.setActual_plan_end_time(work_date + " " + actual_end_time);
        if (StringUtils.isEmpty(plan.getPlan_end_time())) {
            plan.setPlan_end_time(work_date + " " + actual_end_time);
        }

        if (plan.getPlan_condition_code().equals("YWC")) {
            String actual_end_time2 =work_date;
            String end_time=plan.getPlan_end_time();
            if (actual_end_time2.compareTo(end_time) < 0) {
                plan.setPlan_result_condition_code("TQWC");
            } else if(actual_end_time2.compareTo(end_time) > 0){
                plan.setPlan_result_condition_code("YQWC");
            }else if(actual_end_time2.compareTo(end_time) == 0){
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
        String work_date = httpServletRequest.getParameter("work_date");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setActual_plan_start_time(work_date + " " + httpServletRequest.getParameter("actual_start_time"));
        try {
            if (URLDecoder.decode(httpServletRequest.getParameter("complete"), "utf-8").equals("已完成")) {
                plan.setPlan_condition_code("YWC");
                plan.setActual_plan_end_time(work_date + " " + httpServletRequest.getParameter("actual_end_time"));
            }else{
                plan.setPlan_condition_code("JXZ");
            }
            delayReason = URLDecoder.decode(httpServletRequest.getParameter("delay_reason"), "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }

        if (plan.getPlan_condition_code().equals("YWC")) {
            String actual_end_time =work_date;
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

    @RequestMapping(value = "/getNotPlanTaskTypeDic")
    @ResponseBody
    public Map getNotPlanTaskTypeDic() {
        Map model = new HashMap();
        List taskTypeList = workLogDictionaryFeignClient.getDicListByBusinessCode("not_plan_task_type");
        model.put("taskTypeList", taskTypeList);
        return model;
    }

    @RequestMapping(value = "/checkWorkLogRepeat")
    @ResponseBody
    public Integer checkWorkLogRepeat() {
        String workDate = httpServletRequest.getParameter("datas");
        Integer userId = getCurUser().getId();
        return dayLogClient.checkWorkLogRepeat(workDate, userId);
    }

    @RequestMapping(value = "/saveUnComplete2Plan")
    @ResponseBody
    public Map saveUnComplete2Plan() {
        String work_date = httpServletRequest.getParameter("work_date");
        String actual_end_time = httpServletRequest.getParameter("actual_end_time");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setPlan_condition_code("JXZ");
        /*if (StringUtils.isEmpty(plan.getEnd_date())) {
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
