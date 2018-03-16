package com.qgbest.xmgl.worklog.service.controller;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
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
 * Created by mjq on 2017/7/18.
 */
@Api(value = "点赞信息", description = "提供点赞信息增删改查API")
@RestController
@RequestMapping(value = "/manage/thumbsUp")
public class ThumbsUpController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(ThumbsUpController.class);
    @Autowired
    private ThumbsUpService thumbsUpService;



    @ApiOperation(value = "保存点赞信息", notes = "保存点赞信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "ThumbsUp", name = "thumbsUp", value = "点赞信息", required = true, paramType = "body"),

    })
    @RequestMapping(value = "/saveThumbsUpInfo", method = RequestMethod.PUT)
    public Map saveThumbsUpInfo(@RequestBody ThumbsUp thumbsUp) {
        logger.debug("保存点赞信息：{}", thumbsUp);
        Map map = new HashMap();
        ReturnMsg msg = thumbsUpService.saveThumbsUpInfo(thumbsUp);
        map.put("thumbsUp",thumbsUp);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }

    @ApiOperation(value="查询点赞信息", notes="根据id查询点赞信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "type", value = "type", required = true, paramType = "path")

    })
    @RequestMapping(value = "/getThumbsUpListById",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public List getThumbsUpListById(@RequestParam Integer id,@RequestParam("type") String type){
        List taskList;
        taskList = thumbsUpService.getThumbsUpListById(id,type);
        return taskList;
    }



    @ApiOperation(value = "删除点赞信息", notes = "删除点赞信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body"),
            @ApiImplicitParam(dataType = "String", name = "type", value = "type", required = true, paramType = "path"),

    })
    @RequestMapping(value = "/delThumbsUpInfo", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delThumbsUpInfo(@RequestParam("id") Integer id, @RequestBody TcUser user,@RequestParam("type") String type) {
        ReturnMsg returnMsg = thumbsUpService.delThumbsUpInfo(id,user,type);
        return returnMsg;
    }



}
