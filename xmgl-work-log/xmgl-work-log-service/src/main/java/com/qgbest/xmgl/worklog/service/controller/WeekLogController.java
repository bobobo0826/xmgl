package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.service.service.LogService;
import com.qgbest.xmgl.worklog.service.service.WeekLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by mjq on 2017/7/4.
 */
@Api(value = "每周计划", description = "提供每周计划增删改查API")
@RestController
@RequestMapping(value = "/manage/weekLog")
public class WeekLogController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(WeekLogController.class);
    @Autowired
    private WeekLogService weekLogService;
    @Autowired
    private LogService logService;



    @ApiOperation(value = "每周计划分页查询获取列表", notes = "每周计划分页查询获取列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
    })
    @PostMapping(value = "/getWeekLogList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getWeekLogList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.weekLogService.getWeekLogList(query, page,len,user);
        jsonData = getQueryMap(pc);
        return jsonData;
    }






    @ApiOperation(value = "获取每周计划信息ID", notes = "根据ID获取每周计划信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getWeekLogInfo/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public WeekLog getWeekLogInfo(@PathVariable("id") Integer id) {
        WeekLog weekLog = weekLogService.getWeekLogInfo(id);


        return weekLog;
    }




    @ApiOperation(value = "每周计划保存", notes = "每周计划保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "WeekLog", name = "weekLog", value = "每周计划", required = true, paramType = "body"),
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "日志ID", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "task_start_date", value = "任务开始日期", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "task_end_date", value = "任务结束日期", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "week_summary", value = "每周总结", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "next_plan", value = "下周计划", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "work_explain", value = "工作说明", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "create_type", value = "录入类别", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "creator", value = "录入人", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "create_date", value = "录入日期", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "modifier", value = "修改人", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "modify_date", value = "修改日期", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "content", value = "内容", required = true, paramType = "query")
    })
    @RequestMapping(value = "/saveWeekLogInfo", method = RequestMethod.POST)
    public Map saveWeekLogInfo(@RequestBody WeekLog weekLog,@RequestParam Integer userId,@RequestParam String userName) {
        logger.debug("保存状态信息：{}", weekLog);
        Map map = new HashMap();
        String operate= ServiceConstants.modify_operate;
        WeekLog oldWeekLog=null;
        if(weekLog.getId()==null||weekLog.getId()==-1){
            operate= ServiceConstants.add_operate;
        }else{
            oldWeekLog=weekLogService.getOldWeekLog(weekLog.getId());
        }
        ReturnMsg msg = weekLogService.saveWeekLogInfo(weekLog);
        logService.addLog(operate, weekLog.getId() + "", JsonUtil.toJson(oldWeekLog), JsonUtil.toJson(weekLog), "log_week",userName,userId , "",
                weekLog.getCreator()+"_"+weekLog.getTask_start_date()+"_"+weekLog.getTask_end_date());
        map.put("weekLog",weekLog);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }


    @ApiOperation(value = "每周计划删除", notes = "根据ID获取每周计划信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/delWeekLogInfo/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delWeekLogInfo(@PathVariable("id") Integer id,@RequestParam Integer userId,@RequestParam String userName) {
        WeekLog weekLog=getWeekLogInfo(id);
        logService.addLog(ServiceConstants.delete_operate, weekLog.getId() + "", JsonUtil.toJson(weekLog), null, "log_week",userName,userId , "",
                weekLog.getCreator()+"_"+weekLog.getTask_start_date()+"_"+weekLog.getTask_end_date());
        return weekLogService.delWeekLogInfo(id);
    }



    @ApiOperation(value="查询本周新增的任务记录", notes="查询数据库中的本周录入任务")
    @ApiImplicitParams({
    })
    @RequestMapping(value = "/getNewWeekLogNumbers",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer getNewWeekLogNumbers() {
        return weekLogService.getNewWeekLogNumbers();
    }



    @ApiOperation(value="查询某条任务的content", notes="根据任务id查询某条任务的content")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getWeekLogContentListById/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getWeekLogContentListById(@PathVariable Integer id){
        return weekLogService.getWeekLogContentListById(id);
    }

    @ApiOperation(value = "查询monday_date为起始日期的周日志id", notes = "查询monday_date为起始日期的周日志id")
    @ApiImplicitParams({
      @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body"),
      @ApiImplicitParam(dataType = "String", name = "monday_date", value = "任务开始时间", required = true, paramType = "query"),
    })
    @PostMapping(value = "/getWeekLogIdByTaskStartDate", produces = MediaType.APPLICATION_JSON_VALUE)
    public List getWeekLogIdByTaskStartDate(@RequestBody TcUser user, @RequestParam("monday_date") String monday_date) {
        List ids = this.weekLogService.getWeekLogIdByTaskStartDate(user, monday_date);
        return  ids;
    }


}
