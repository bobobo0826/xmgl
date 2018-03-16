package com.qgbest.xmgl.worklog.service.controller;
import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.service.service.UpdateLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/7/26.
 */
@Api(value = "更新日志管理",description="提供更新日志管理增删改查")
@RestController
@RequestMapping(value = "/manage/updateLogManage")
public class UpdateLogController extends BaseController{
   // public static final Logger logger = LoggerFactory.getLogger(DayLogController.class);

    @Autowired
    private UpdateLogService updateLogService;
    @ApiOperation(value="更新日志查询", notes="更新日志分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "java.lang.String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "java.lang.Integer", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "java.lang.Integer", name = "page", value = "查询页码", required = true, paramType = "query")
    })
    @RequestMapping(value = "/getUpdateLogList",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getDayLogList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page) {
       // System.out.println("dddddd+++++++++++++++++++++++");
        Map jsonData = new HashMap();
        Map query= JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.updateLogService.queryUpdateLogList(query, page, len);
        jsonData=getQueryMap(pc);
        return jsonData;
    }


    @ApiOperation(value = "删除更新日志信息",notes = "删除更新日志信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "更新日志id", required = true,paramType = "path")
    @RequestMapping(value = "/delUpdateLogInfoById/{id}",method = RequestMethod.DELETE,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delUpdateLogInfoById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= updateLogService.deleteById(id);
        return returnMsg ;
    }
    @ApiOperation(value = "获取更新日志model",notes = "根据ID获取更新日志详情")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "更新日志ID", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getUpdateLogInfoById/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public UpdateLog getUpdateLogInfoById(@PathVariable("id") Integer id) {
        //System.out.println("dddddd+++++++++++++++++++++++");
        UpdateLog updateLog=updateLogService.getUpdateLogInfoById(id);
       // System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+updateLog);
        return updateLog;
    }

    @ApiOperation(value = "保存更新日志信息",notes = "保存更新日志信息")
    @ApiImplicitParam(dataType = "UpdateLog", name = "updateLog", value = "更新日志model", required = true, paramType = "body")
    @RequestMapping(value = "/saveUpdateLogInfo",method = RequestMethod.PUT,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg saveUpdateLog(@RequestBody UpdateLog updateLog) {
        ReturnMsg returnMsg=updateLogService.saveUpdateLog(updateLog);
        return returnMsg ;
    }

    @RequestMapping(value="/getLatestUpdateLog", method = RequestMethod.POST)
    private List getLatestUpdateLog(){
        List list = this.updateLogService.getLatestUpdateLog();
        return list;
    }

    @ApiOperation(value = "发布更新日志信息",notes = "发布更新日志信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "更新日志id", required = true,paramType = "path")
    @RequestMapping(value = "/publishUpdateLogById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg publishUpdateLogById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= updateLogService.publishById(id);
        return returnMsg ;
    }

    @ApiOperation(value = "撤销发布更新日志信息",notes = "撤销发布更新日志信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "更新日志id", required = true,paramType = "path")
    @RequestMapping(value = "/unPublishUpdateLogById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg unPublishUpdateLogById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= updateLogService.unPublishById(id);
        return returnMsg ;
    }




}
