package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.service.service.TaskLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Created by wch on 2017-07-13.
 */
@Api(value = "项目任务日志查询",description="提供项目任务日志查询API")
@RestController
@RequestMapping(value = "/manage/taskLog")
public class TaskLogController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TaskLogController.class);
    @Autowired
    private TaskLogService taskLogService;

    @ApiOperation(value = "项目任务日志分页查询", notes = "项目任务日志分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query")
    })
    @PostMapping(value = "/queryTaskLogList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map queryTaskLogList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page) {
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.taskLogService.queryTaskLogList(query, page, len);
        Map jsonData = getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value = "周期列表查询",notes = "周期列表查询")
    @RequestMapping(value = "/getPeriodList",method = RequestMethod.GET)
    public List getPeriodList() {
        List list = taskLogService.getPeriodList();
        return list;
    }

}