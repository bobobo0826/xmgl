package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.MonthLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.worklog.service.service.LogService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */
@Api(value = "月日志管理", description = "提供月日志管理增删改查API")
@RestController
@RequestMapping(value = "/manage/monthLog")
public class MonthLogController extends BaseController {
  public static final Logger logger = LoggerFactory.getLogger(MonthLogController.class);
  @Autowired
  private MonthLogService monthLogService;
  @Autowired
  private LogService logService;
  @ApiOperation(value = "月日志分页查询", notes = "月日志分页查询")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
    @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
    @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
    @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
  })
  @PostMapping(value = "/getMonthLogList", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map getMonthLogList(
    @RequestParam String queryMap,
    @RequestParam Integer len,
    @RequestParam Integer page,
    @RequestBody TcUser user
  ) {
    Map jsonData = new HashMap();
    Map query = JsonUtil.fromJsonToMap(queryMap);
    PageControl pc = this.monthLogService.getMonthLogList(query, page, len, user);
    jsonData = getQueryMap(pc);
    return jsonData;
  }

  @ApiOperation(value = "获取月日志model", notes = "根据月日志ID获取月日志model")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
  })
  @RequestMapping(value = "/getMonthLogInfo/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public MonthLog getMonthLogInfo(@PathVariable Integer id) {
    MonthLog monthLog = null;
    try {
      monthLog = monthLogService.getMonthLogInfo(id);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return monthLog;
  }

  @ApiOperation(value = "保存月日志", notes = "保存月日志")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "MonthLog", name = "monthLog", value = "月日志model", required = true, paramType = "body"),
  })
  @RequestMapping(value = "/saveMonthLog", method = RequestMethod.PUT)
  public Map saveMonthLog(@RequestBody MonthLog monthLog,@RequestParam Integer userId,@RequestParam String userName) {
    logger.debug("保存状态信息：{}", monthLog);
    Map map = new HashMap();
    String operate= ServiceConstants.modify_operate;
    MonthLog oldMonthLog=null;
    if(monthLog.getId()==null||monthLog.getId()==-1){
      operate= ServiceConstants.add_operate;
    }else{
      oldMonthLog=monthLogService.getOldMonthLog(monthLog.getId());
    }
    ReturnMsg msg = monthLogService.saveMonthLog(monthLog);
    System.out.println("-------------"+monthLog);
    logService.addLog(operate, monthLog.getId() + "", JsonUtil.toJson(oldMonthLog), JsonUtil.toJson(monthLog), "log_month",userName,userId , "",
            monthLog.getCreator()+"_"+monthLog.getWork_date());
    map.put("monthLog", monthLog);
    map.put("msgCode", msg.getMsgCode());
    map.put("msgDesc", msg.getMsgDesc());
    return map;
  }

  @ApiOperation(value = "月日志删除", notes = "根据月日志ID获取月日志model")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "string", name = "id", value = "id", required = true, paramType = "path"),
  })
  @RequestMapping(value = "/delMonthLog/{id}/{userId}/{userName}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
  public ReturnMsg delMonthLog(@PathVariable("id") Integer id,@PathVariable("userId") Integer userId,@PathVariable("userName") String userName) {
    MonthLog monthLog=getMonthLogInfo(id);
    logService.addLog(ServiceConstants.delete_operate, monthLog.getId() + "", JsonUtil.toJson(monthLog), null, "log_month",userName,userId , "",
            monthLog.getCreator()+"_"+monthLog.getWork_date());
    return monthLogService.delMonthLog(id);
  }

  @ApiOperation(value = "获得新增月任务数量", notes = "根据月份获得月任务数量")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "string", name = "month", value = "month", required = true, paramType = "query"),
  })
  @RequestMapping(value = "/getMonthLogNumber", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public Integer getMonthLogNumber() {
    return monthLogService.getMonthLogNumber();
  }

  @ApiOperation(value = "查询某条任务的content", notes = "根据任务id查询某条任务的content")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path")
  })
  @RequestMapping(value = "/getMonthLogContentListById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
  public Map getMonthLogContentListById(@PathVariable Integer id) {
    return monthLogService.getMonthLogContentListById(id);
  }

  @ApiOperation(value = "查询month这个月的日志id", notes = "查询month这个月的日志id")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body"),
    @ApiImplicitParam(dataType = "String", name = "month", value = "月份", required = true, paramType = "query"),
  })
  @PostMapping(value = "/getMonthLogIdByMonth",produces = MediaType.APPLICATION_JSON_VALUE)
  public List getMonthLogIdByMonth(@RequestBody TcUser user, @RequestParam("month") String month) {
    List ids = this.monthLogService.getMonthLogIdByMonth(user, month);
    return ids;
  }

}