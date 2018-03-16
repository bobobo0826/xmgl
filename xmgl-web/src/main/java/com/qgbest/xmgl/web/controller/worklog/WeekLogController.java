package com.qgbest.xmgl.web.controller.worklog;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.client.PlanFeignClient;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.task.client.MyTaskFeignClient;
import com.qgbest.xmgl.task.client.TaskFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Created by mjq on 2017/7/4.
 */

@Controller
@RequestMapping(value = "/manage/weekLog")
public class WeekLogController extends BaseController {
    @Autowired
    private WeekLogFeignClient weekLogFeignClient;
    @Autowired
    private ThumbsUpFeignClient thumbsUpFeignClient;
    @Autowired
    private WorkLogDictionaryFeignClient workLogDictionaryFeignClient;
    @Autowired
    private GlanceOverFeignClient glanceOverFeignClient;
    @Autowired
    private CommentsFeignClient commentsFeignClient;
    @Autowired
    private MonthLogFeignClient monthLogFeignClient;
    @Autowired
    private TaskFeignClient taskFeignClient;
    @Autowired
    private MyTaskFeignClient myTaskFeignClient;
    @Autowired
    private PlanFeignClient planFeignClient;

    /**
     * 初始化子系统列表
     */
    @RequestMapping(value = "/weekLogQueryIndex")
    public ModelAndView weekLogQueryIndex() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        Integer UserId = getCurUser().getId();
        model.put("UserId", UserId);
        if( StringUtils.isNotBlankOrNull(queryMap.get("isOrNotNew"))) {
            model.put("isOrNotNew", queryMap.get("isOrNotNew"));
        } else {
            model.put("isOrNotNew", null);
        }
        String monday = DateUtils.getCurWeekMonday();
        model.put("dateOfMonday", monday);
        return new ModelAndView("/weekLog/weekLogList", model);

    }

    /**
     * 初始化详情
     */
    @RequestMapping(value = "/weekLogInfoIndex/{id}/{addOrComments}/{curModuleCode}")
    public ModelAndView weekLogInfoIndex(@PathVariable Integer id, @PathVariable String addOrComments, @PathVariable String curModuleCode) {
        Map model =new HashMap();
        model.put("id", id);
        Integer UserId=getCurUser().getId();
        model.put("UserId", UserId);
        model.put("addOrComments", addOrComments);
        model.put("imageUrl",this.imageUrl);
        model.put("curModuleCode", curModuleCode);
        return new ModelAndView("/weekLog/weekLogInfo",model);
    }

    /**
     * 新增详情明细
     */
    @RequestMapping(value = "/initTaskPlanInfo")
    public ModelAndView initTaskPlanInfo(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("gridIndex",queryMap.get("_rowIndex"));
        model.put("isCopy", queryMap.get("isCopy"));
        return new ModelAndView("/weekLog/weekTaskPlanInfo",model);
    }

    /**
     * 根据Id获取详情信息
     */
    @RequestMapping(value = "/getWeekLogInfo/{id}/{business_type}/{parent_id}")
    @ResponseBody
    public Map getWeekLogInfo(@PathVariable Integer id, @PathVariable String business_type, @PathVariable Integer parent_id) {
        Map map = new HashMap();
        WeekLog weekLog = new WeekLog();
        weekLog = weekLogFeignClient.getWeekLogInfo(id);
        if(id==-1)
        {
            weekLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            weekLog.setCreator_id(getCurUser().getId());
            weekLog.setCreator(getCurUser().getDisplayName());
            weekLog.setStatus_code("CG");
            weekLog.setCreate_type("ZCLR");
        }
        String statusName="";
        if(weekLog.getStatus_code()!=null){
            statusName=workLogDictionaryFeignClient.getDataNameByDataCode("log_status",weekLog.getStatus_code());
        }
        List logCreateTypeList= workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        String type="MZJH";
        List ThumbsUpList;
        ThumbsUpList = thumbsUpFeignClient.getThumbsUpListById(id,type);
        if(id!=-1) {
            glanceOverFeignClient.UpdateAndSaveGlanceOver(id, getCurUser(), type);
        }
        List GlanceOverList;
        GlanceOverList = glanceOverFeignClient.getGlanceOverListById(id,type);
        map.put("logCreateTypeList", logCreateTypeList);
        map.put("weekLog", weekLog);
        map.put("statusName",statusName);
        map.put("ThumbsUpList",ThumbsUpList);
        map.put("GlanceOverList",GlanceOverList);

      /**
       * 获取评论
       */
      HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
      map.put("comments", commentsFeignClient.getCommentsList(JsonUtil.toJson(queryMap), id, parent_id, business_type, weekLog.getCreator_id(), getCurUser()));
      return map;
    }

    /**
     * 获取列表
     */
    @RequestMapping(value = "/weekLogQueryList")
    @ResponseBody
    public Map weekLogQueryList() {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        return weekLogFeignClient.getWeekLogList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }


    /**
     * 保存
     */
    @RequestMapping(value = "/saveWeekLogInfo")
    @ResponseBody
    public Map saveWeekLogInfo(@ModelAttribute WeekLog weekLog) {
        /**
         * 修改情况下，更新修改人等
         */
        if (weekLog.getId()!=null){
            weekLog.setModify_date(DateUtils.getCurDateTime2Minute());
            weekLog.setModifier(getCurUser().getDisplayName());
            weekLog.setModifier_id(getCurUser().getId());
        }
        Map map=weekLogFeignClient.saveWeekLogInfo(weekLog,getCurUser().getId(),getCurUser().getDisplayName());
        String statusName="";
        if(weekLog.getStatus_code()!=null){
            statusName=workLogDictionaryFeignClient.getDataNameByDataCode("log_status",weekLog.getStatus_code());
        }
        map.put("statusName",statusName);
        return map;
    }

    /**
     * 删除
     */
    @RequestMapping(value = "/delWeekLogInfo")
    @ResponseBody
    public ReturnMsg delWeekLogInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = weekLogFeignClient.delWeekLogInfo(id,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

    @RequestMapping(value = "/getWeekLogTaskTypeDic")
    @ResponseBody
    public Map getWeekLogTaskTypeDic() {
        Map model =new HashMap();
        List taskTypeList= workLogDictionaryFeignClient.getDicListByBusinessCode("task_type");
        model.put("taskTypeList", taskTypeList);
        return model;
    }

    @RequestMapping (value = "/getLogStatusDic")
    @ResponseBody
    public Map getLogStatusDic() {
        Map model =new HashMap();
        List logStatusList= workLogDictionaryFeignClient.getDicListByBusinessCode("log_status");
        model.put("logStatusList", logStatusList);
        return model;
    }

    @RequestMapping (value = "/getLogCreateTypeDic")
    @ResponseBody
    public Map getLogCreateTypeDic() {
        Map model =new HashMap();
        List logCreateTypeList= workLogDictionaryFeignClient.getDicListByBusinessCode("create_type");
        model.put("logCreateTypeList", logCreateTypeList);
        return model;
    }

    @RequestMapping(value = "/getNewWeekLogNumbers")
    @ResponseBody
    public Map getNewWeekLogNumbers(){
        Integer newWeekLogNumbers;
        newWeekLogNumbers= weekLogFeignClient.getNewWeekLogNumbers();
        Map map = new HashMap();
        map.put("count",String.valueOf(newWeekLogNumbers));
        return map;
    }

    @RequestMapping(value = "/getWeekLogContentListById/{id}")
    @ResponseBody
    public Map getWeekLogContentListById(@PathVariable Integer id){
        String type="MZJH";
        glanceOverFeignClient.UpdateAndSaveGlanceOver(id,getCurUser(),type);
        return weekLogFeignClient.getWeekLogContentListById(id);
    }

    /**
     * 保存周日志总结到月日志
     */
    @RequestMapping(value = "/saveWeekSummary2MonthLog")
    @ResponseBody
    public Map saveWeekSummary2MonthLog() {
        String task_start_date = httpServletRequest.getParameter("task_start_date");
        String task_end_date = httpServletRequest.getParameter("task_end_date");
        String weekSummary = "";
        try {
            weekSummary = URLDecoder.decode(httpServletRequest.getParameter("week_summary"),"utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        String month="";
        try {
            month = sdf.format(sdf.parse(task_end_date));
        } catch (ParseException exception) {
            exception.printStackTrace();
        }
        //查询month这个月的日志id并取其中最大的id
        List monthLogIdList = monthLogFeignClient.getMonthLogIdByMonth(getCurUser(), month);
        Map contentMap = new HashMap();
        MonthLog monthLog = new MonthLog();
        contentMap.put("record", weekSummary);
        contentMap.put("complete", "未完成");
        contentMap.put("task_end_time", task_end_date);
        contentMap.put("task_start_time", task_start_date);
        contentMap.put("task_type", "XMRW");
        contentMap.put("period_start", task_start_date);
        contentMap.put("period_end", task_end_date);
        contentMap.put("task_name","周总结");
        if (monthLogIdList.size() != 0) {
            Map weekLogIdMap = (Map) (monthLogIdList.get(0));
            Integer id = Integer.parseInt(weekLogIdMap.get("id").toString());
            monthLog = monthLogFeignClient.getMonthLogInfo(id);
            List content = JsonUtil.fromJsonToList(monthLog.getContent());
            content.add(contentMap);
            monthLog.setContent(JsonUtil.toJson(content));
        } else {
            monthLog.setWork_date(month);
            monthLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            monthLog.setCreator(getCurUser().getDisplayName());
            monthLog.setCreator_id(getCurUser().getId());
            monthLog.setStatus_code("CG");
            monthLog.setMonth_summary("暂无");
            monthLog.setNext_plan("暂无");
            if (DateUtils.getCurrDate("yyyy-MM").compareTo(month) > 0) {
                monthLog.setCreate_type("BL");
            } else {
                monthLog.setCreate_type("ZCLR");
            }
            String content = "[" + JsonUtil.toJson(contentMap) + "]";
            monthLog.setContent(content);
        }
        Map map = monthLogFeignClient.saveMonthLog(monthLog,getCurUser().getId(),getCurUser().getDisplayName());
        return map;
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
      String actual_end_time =httpServletRequest.getParameter("actual_end_time");
      Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
      Plan plan = planFeignClient.getPlanInfoById(plan_id);
      plan.setActual_plan_start_time(httpServletRequest.getParameter("actual_start_time"));
    try {
      if (URLDecoder.decode(httpServletRequest.getParameter("complete"), "utf-8").equals("已完成")) {
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

    ///**
    // * 新增临时任务回写到任务管理，计划管理
    // */
    //@RequestMapping(value = "/saveNewTemTask2TaskAndPlan")
    //@ResponseBody
    //public Map saveNewTemTask2TaskAndPlan(@ModelAttribute Task task, @ModelAttribute Plan plan) {
    //    //保存任务
    //    task.setCreator(getCurUser().getDisplayName());
    //    task.setCreator_id(getCurUser().getId());
    //    task.setCreate_time(DateUtils.getCurDateTime2Minute());
    //    task.setTask_condition_code("CG");
    //    Map mapTask = taskFeignClient.saveTask(task);
    //    Task newTask = (Task) JsonUtil.fromJson(JsonUtil.toJson(mapTask.get("task")), Task.class);
    //    //保存计划
    //    plan.setTask_id(newTask.getId());
    //    Map participantsMap = new HashMap();
    //    participantsMap.put("name", getCurUser().getDisplayName());
    //    participantsMap.put("photo", getCurUser().getHeadPhoto());
    //    participantsMap.put("employe_id", getCurUser().getId());
    //    participantsMap.put("mobilephone_number", "");
    //    String participants = "[" + JsonUtil.toJson(participantsMap) + "]";
    //    plan.setParticipants(participants);
    //    plan.setStart_date(plan.getStart_date());
    //    plan.setEnd_date(plan.getEnd_date());
    //    plan.setActual_start_time(plan.getActual_start_time());
    //    if (plan.getComplete().equals("已完成")) {
    //        plan.setActual_end_time(plan.getActual_end_time());
    //    } else {
    //        plan.setActual_end_time("");
    //    }
    //    Map mapPlan = taskFeignClient.savePlan(plan);
    //    return mapTask;
    //}


    @RequestMapping(value = "/saveUnComplete2Plan")
    @ResponseBody
    public Map saveUnComplete2Plan() {
        String work_date = httpServletRequest.getParameter("work_date");
        String actual_end_time = httpServletRequest.getParameter("actual_end_time");
        Integer plan_id = Integer.parseInt(httpServletRequest.getParameter("plan_id"));
        Plan plan = planFeignClient.getPlanInfoById(plan_id);
        plan.setPlan_condition_code("JXZ");
        /*if(StringUtils.isEmpty(plan.getEnd_date())){
            plan.setEnd_date(work_date + " " + actual_end_time);
        }
        if(plan.getComplete().equals("未完成")){
            if(StringUtils.isEmpty(plan.getActual_start_time())){
                plan.setComplete_type("WKS");
            }else if(StringUtils.isEmpty(plan.getActual_end_time())){
                plan.setComplete_type("ZZSS");
            }
        }*/
        Map map = planFeignClient.savePlan(plan, getCurUser().getId(), getCurUser().getDisplayName());
        return map;
    }
}
