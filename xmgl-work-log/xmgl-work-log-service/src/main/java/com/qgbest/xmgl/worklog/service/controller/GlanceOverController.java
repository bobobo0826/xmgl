package com.qgbest.xmgl.worklog.service.controller;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.GlanceOverService;
import com.qgbest.xmgl.worklog.service.service.ThumbsUpService;
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
 * Created by mjq on 2017/7/19.
 */
@Api(value = "浏览信息", description = "提供浏览信息增删改查API")
@RestController
@RequestMapping(value = "/manage/glanceOver")
public class GlanceOverController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(GlanceOverController.class);
    @Autowired
    private GlanceOverService glanceOverService;


    @ApiOperation(value = "保存浏览信息", notes = "保存浏览信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "GlanceOver", name = "glanceOver", value = "浏览信息", required = true, paramType = "body"),

    })
    @RequestMapping(value = "/saveGlanceOverInfo", method = RequestMethod.PUT)
    public Map saveGlanceOverInfo(@RequestBody GlanceOver glanceOver) {
        logger.debug("保存浏览信息：{}", glanceOver);
        Map map = new HashMap();
        ReturnMsg msg = glanceOverService.saveGlanceOverInfo(glanceOver);
        map.put("glanceOver",glanceOver);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }

    @ApiOperation(value="查询浏览信息", notes="根据日志id查询浏览信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "type", value = "type", required = true, paramType = "path"),

    })
    @RequestMapping(value = "/getGlanceOverListById",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public List getGlanceOverListById(@RequestParam Integer id,@RequestParam("type") String type){
        List taskList;
        taskList = glanceOverService.getGlanceOverListById(id,type);
        return taskList;
    }




    @ApiOperation(value = "更新并保存周浏览信息", notes = "更新并保存周浏览信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body"),
            @ApiImplicitParam(dataType = "String", name = "type", value = "type", required = true, paramType = "path"),

    })
    @RequestMapping(value = "/UpdateAndSaveGlanceOver", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg UpdateAndSaveGlanceOver(@RequestParam("id") Integer id, @RequestBody TcUser user,@RequestParam("type") String type) {
        ReturnMsg returnMsg = glanceOverService.UpdateAndSaveGlanceOver(id,user,type);
        return returnMsg;
    }





}
