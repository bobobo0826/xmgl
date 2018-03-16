package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.DayLogService;
import com.qgbest.xmgl.worklog.service.service.LogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by quangao on 2017/7/4.
 */
@Api(value = "每天日志管理",description="提供每天日志管理增删改查API")
@RestController
@RequestMapping(value = "/manage/dayLog")
public class DayLogController extends BaseController{
    @Autowired
    private DayLogService dayLogService;
    @Autowired
    private LogService logService;
    @ApiOperation(value="每天日志分页查询", notes="每天日志分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/getDayLogList", produces= MediaType.APPLICATION_JSON_VALUE)
    public Map getDayLogList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query= JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.dayLogService.queryDayLogList(query, page, len,user);
        jsonData=getQueryMap(pc);
        return jsonData;
    }
    @ApiOperation(value="操作日志查询", notes="操作日志查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/getWorkOperateLog", produces= MediaType.APPLICATION_JSON_VALUE)
    public Map getWorkOperateLog(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query= JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.dayLogService.getWorkOperateLog(query, page, len,user);
        jsonData=getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value="获取每天日志model", notes="根据每天日志ID获取每天日志model")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "int", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getDayLogInfoById/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public DayLog getDayLogInfoById(@PathVariable Integer id) {
        DayLog dayLog;
        dayLog = dayLogService.getDayLogInfoById(id);
        return dayLog;
    }

    @ApiOperation(value="查询某条任务的content", notes="根据任务id查询某条任务的content")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getDayLogContentListById/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getDayLogContentListById(@PathVariable Integer id){
        return dayLogService.getDayLogContentListById(id);
    }

    @ApiOperation(value="每天日志保存", notes="每天日志保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "DayLog", name = "dayLog", value = "每天日志model", required = true, paramType = "body"),
    })
    @RequestMapping(value = "/saveDayLog",method = RequestMethod.POST)
    public Map saveDayLog(@RequestBody DayLog dayLog,@RequestParam Integer userId,@RequestParam String userName) {
        Map map =new HashMap();
        String operate=ServiceConstants.modify_operate;
        DayLog oldDayLog=null;
        if(dayLog.getId()==null||dayLog.getId()==-1){
            operate= ServiceConstants.add_operate;
        }else{
            oldDayLog=dayLogService.getOldDayLog(dayLog.getId());
        }
        ReturnMsg msg = dayLogService.saveDayLog(dayLog);
        logService.addLog(operate, dayLog.getId() + "", JsonUtil.toJson(oldDayLog), JsonUtil.toJson(dayLog), "log_day",userName,userId , "",
                dayLog.getCreator()+"_"+dayLog.getWork_date());
        map.put("dayLog",dayLog);
        map.put("msgCode",msg.getMsgCode());
        map.put("msgDesc",msg.getMsgDesc());
        return map;
    }

    @ApiOperation(value="每天日志删除", notes="根据每天日志ID获取每天日志model")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/delDayLog/{id}/{userId}/{userName}",method = RequestMethod.DELETE,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delDayLog(@PathVariable("id") Integer id,@PathVariable("userId") Integer userId,@PathVariable("userName") String userName) {
        DayLog dayLog=getDayLogInfoById(id);
        logService.addLog(ServiceConstants.delete_operate, dayLog.getId() + "", JsonUtil.toJson(dayLog), null, "log_day",userName,userId , "",
                dayLog.getCreator()+"_"+dayLog.getWork_date());
        return dayLogService.deleteById(id);
    }

    @ApiOperation(value="查询今天新增的任务记录", notes="查询数据库中的今天录入任务")
    @ApiImplicitParams({
    })
    @RequestMapping(value = "/getNewDayLogNumbers",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer getNewDayLogNumbers() {
        return dayLogService.getNewDayLogNumbers();
    }

    @ApiOperation(value="查询该日期的工作记录是否重复", notes="查询该日期的工作记录是否重复")
    @ApiImplicitParams({
      @ApiImplicitParam(dataType = "String", name = "workDate", value = "workDate", required = true, paramType = "query"),
      @ApiImplicitParam(dataType = "Integer", name = "userId", value = "userId", required = true, paramType = "query"),
    })
    @RequestMapping(value = "/checkWorkLogRepeat",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer checkWorkLogRepeat(@RequestParam String workDate, @RequestParam Integer userId) {
        return dayLogService.checkWorkLogRepeat(workDate,userId);
    }
}
