package com.qgbest.xmgl.task.service.controller;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.service.service.RedisService;
import com.qgbest.xmgl.task.service.service.SysdataGridDefaultConfigService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
@Api(value = "运输地datagrid默认样式管理",description="提供运输地datagrid默认样式增删改查API")
@RestController
@RequestMapping(value = "/manage/Sysdata")
public class SysdataGridDefaultConfigController {
    @Autowired
    private SysdataGridDefaultConfigService sysdataGridDefaultConfigService;
    @Autowired
    private RedisService redisService;



    @ApiOperation(value="获取datagrid样式", notes="根据modelCode获取datagrid样式")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "modelCode", value = "modelCode", required = true)
    })
    @RequestMapping(value = "getConfVal/{modelCode}",method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    public List getConfVal(@PathVariable("modelCode") String modelCode){
        List baseJson = null;
        if (redisService.isExistCache(modelCode)){
            baseJson = JsonUtil.fromJsonToList(redisService.redisSysConfigGet(modelCode));
        }else {
            baseJson = sysdataGridDefaultConfigService.getBaseJsonByCode(modelCode);
            redisService.updateSysConfigRedis(modelCode, JsonUtil.toJson(baseJson));
        }
        return baseJson;
    }

    /*@ApiOperation(value="datagrid样式保存", notes="datagrid样式保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "SysdataGridDefaultConfig", name = "sysdataGridDefaultConfig", value = "datagrid样式model", required = true)
    })
    @RequestMapping(value = "/saveSysdata",method = RequestMethod.PUT)
    public Map saveSysdata(@RequestBody SysdataGridDefaultConfig sysdataGridDefaultConfig) {
        Map map=sysdataGridDefaultConfigService.saveSysdata(sysdataGridDefaultConfig);
        return map;
    }*/

    /**
     * 删除datagrid样式
     * @return
     *//*
    @RequestMapping(value = "/delSysdataById",method = RequestMethod.POST)
    public Map delProjectById(@RequestParam("id")Integer id){
        Map map=sysdataGridDefaultConfigService.delSysdataById(id);
        return map ;
    }*/



}
