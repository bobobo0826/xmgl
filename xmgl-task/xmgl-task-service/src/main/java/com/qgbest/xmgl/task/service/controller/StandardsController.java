package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.task.api.entity.WritingStandards;
import com.qgbest.xmgl.task.service.service.StandardsService;
import com.qgbest.xmgl.user.api.entity.ReturnMsg;

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
 * Created by fcy on 2017/8/8.
 */
@Api(value = "书写规范管理",description="提供书写规范管理增删改查")
@RestController
@RequestMapping(value = "/manage/writingStandards")
public class StandardsController {
    public static final Logger logger = LoggerFactory.getLogger(StandardsController.class);

    @Autowired
    private StandardsService standardsService;
    @ApiOperation(value="规范查询", notes="规范列表查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String",name = "parentId",value = "父节点",required = true, paramType = "query"),

    })
    @RequestMapping(value = "/getStandardsList",method = RequestMethod.POST)
    public List getStandardsList(@RequestParam("parentId") String parentId) {
        List list = this.standardsService.queryStandardsList(Integer.valueOf(parentId));
        return list;
    }

    @RequestMapping(value = "/getStandardsShowList",method = RequestMethod.POST)
    public List getStandardsShowList(@RequestParam("parentId") String parentId) {
        List list = this.standardsService.queryStandardsShowList(Integer.valueOf(parentId));
        return list;
    }

    @ApiOperation(value = "得到规范详情",notes = "获取规范详细信息")
    @ApiImplicitParam(dataType = "int",name = "id",value = "规范id",required = true, paramType = "path")
    @RequestMapping(value = "/getStandardsInfo/{id}",method = RequestMethod.GET)
    public WritingStandards getStandardsInfo(@PathVariable("id") Integer id){
        WritingStandards writingStandards =null;
        try{
            writingStandards = standardsService.getStandardsInfo(id);
        }catch(Exception e){
            e.printStackTrace();
        }
        return writingStandards;
    }

    @ApiOperation(value = "保存规范详情",notes = "保存规范详细信息")
    @ApiImplicitParam(dataType = "WritingStandards",name = "writingStandards",value = "规范model",required = true, paramType = "body")
    @RequestMapping(value = "/saveStandardsInfo",method = RequestMethod.PUT)
    public WritingStandards saveRoleInfo(@RequestBody  WritingStandards writingStandards) {
        logger.debug("保存信息：{}",writingStandards);
        WritingStandards writingStandards1=null;

        writingStandards1 = standardsService.save(writingStandards);
        return writingStandards1 ;
    }
    @ApiOperation(value = "删除规范详情",notes = "删除规范详细信息")
    @ApiImplicitParam(dataType = "int",name = "id",value = "规范id",required = true, paramType = "path")
    @RequestMapping(value = "/delStandardsInfo/{id}",method = RequestMethod.DELETE)
    public Map delStandardsInfo(@PathVariable Integer id){
        standardsService.delStandardsInfo(id);
        return ReturnMsg.getSuccess();
    }
    @ApiOperation(value = "发布规范信息",notes = "发布规范信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "规范id", required = true,paramType = "path")
    @RequestMapping(value = "/publishStandardsById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public com.qgbest.xmgl.task.api.entity.ReturnMsg publishStandardsById(@PathVariable("id") Integer id) {
        com.qgbest.xmgl.task.api.entity.ReturnMsg returnMsg= standardsService.publishById(id);
        return returnMsg ;
    }
    @ApiOperation(value = "撤销发布规范信息",notes = "撤销发布规范信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "规范id", required = true,paramType = "path")
    @RequestMapping(value = "/unPublishStandardsById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public com.qgbest.xmgl.task.api.entity.ReturnMsg unPublishStandardsById(@PathVariable("id") Integer id) {
        com.qgbest.xmgl.task.api.entity.ReturnMsg returnMsg= standardsService.unPublishById(id);

        return returnMsg ;
    }

    @RequestMapping(value="/getStandardsPage", method = RequestMethod.POST)
   public List getStandardsPage(){
        List list = this.standardsService.getStandardsPage();
        return list;
    }


}
