package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.worklog.service.service.LogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by xw on 2017/5/11 0011.
 * 日志新增
 */
@Api(value = "新增日志",description="提供新增日志API")
@RestController
@RequestMapping(value = "/manage/log")
public class LogController {
    public static final Logger logger = LoggerFactory.getLogger(LogController.class);
    @Autowired
    private LogService logService;

    @ApiOperation(value="新增日志")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "operateTypeName", value = "操作名称", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "bussinessId", value = "业务ID", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "oldObject", value = "旧model", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "newObject", value = "新model", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "formTypeName", value = "模块名称", required = true, paramType = "query"),
            //@ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = true, paramType = "body"),
            @ApiImplicitParam(dataType = "int", name = "userId", value = "用户信息Id", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "userName", value = "用户信息名称", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "operaterDescrip", value = "操作信息",  paramType = "query"),
            @ApiImplicitParam(dataType = "String", name = "operaterTitle", value = "日志标题", required = true, paramType = "query")
    })
    @RequestMapping(value = "/addLog",produces = MediaType.APPLICATION_JSON_VALUE)
    public void addLog(@RequestParam("operateTypeName") String operateTypeName,@RequestParam("bussinessId") String bussinessId,
                                @RequestParam("oldObject") String oldObject,@RequestParam("newObject") String newObject,@RequestParam("formTypeName") String formTypeName,
                                @RequestParam("userName") String userName,@RequestParam("userId") Integer userId,@RequestParam("operaterDescrip") String operaterDescrip,@RequestParam("operaterTitle") String operaterTitle) {
        logService.addLog(operateTypeName,bussinessId,oldObject, newObject, formTypeName, userName,userId, operaterDescrip,  operaterTitle);

    }

}
