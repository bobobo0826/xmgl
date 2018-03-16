package com.qgbest.xmgl.employee.service.controller;


import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.employee.service.service.RedisService;
import com.qgbest.xmgl.employee.service.service.SysdataGridPersonConfigService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 * 个人datagrid样式管理controller
 */
@Api(value = "运输地datagrid个人样式管理",description="提供运输地datagrid个人样式增删改查API")
@RestController
@RequestMapping(value = "/manage/personSysdata")
public class SysdataGridPersonConfigController {
    @Autowired
    private SysdataGridPersonConfigService sysdataGridPersonConfigService;
    @Autowired
    private RedisService redisService;

    @ApiOperation(value="获取个人datagrid样式", notes="根据ID获取个人datagrid样式")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "int", name = "id", value = "id", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getConfval/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public List getSysdataGridPersonConfigBase(@PathVariable("id") Integer id) {
        List sysdataGridPersonConfigBase = sysdataGridPersonConfigService.findConfValById(id);
        return sysdataGridPersonConfigBase;
    }

    @ApiOperation(value="获取个人datagrid样式", notes="根据用户ID和modelCode获取个人datagrid样式")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "int", name = "userId", value = "用户id", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "modelCode", value = "modelCode", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getConfvalByIdAndCode/{userId}/{modelCode}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public SysdataGridPersonConfig getSysdataGridPersonConfigBaseByIdAndCode(@PathVariable("userId") Integer userId,@PathVariable("modelCode") String modelCode) {
        SysdataGridPersonConfig sysdataGridPersonConfig =null;
        if (redisService.isExistCache("sysdata_grid_person_config_"+modelCode+userId)){
            sysdataGridPersonConfig = (SysdataGridPersonConfig) JsonUtil.fromJson(redisService.redisSysConfigGet("sysdata_grid_person_config_" + modelCode + userId),
                    SysdataGridPersonConfig.class);
        }else{
            sysdataGridPersonConfig = sysdataGridPersonConfigService.findConfValByIdAndCode(userId, modelCode);
            redisService.updateSysConfigRedis("sysdata_grid_person_config_"+modelCode+userId, JsonUtil.toJson(sysdataGridPersonConfig));
        }
        return sysdataGridPersonConfig;
    }

    @ApiOperation(value="保存个人datagrid样式", notes="保存个人datagrid样式")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "gridStyle", value = "样式明细", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "curModuleCode", value = "curModuleCode", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "int", name = "userId", value = "userId", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "userName", value = "用户名称", required = true, paramType = "path")
    })
    @RequestMapping(value = "/savePersonGridStyle",method = RequestMethod.PUT,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg savePersonGridStyle(@RequestParam("gridStyle") String gridStyle,@RequestParam("curModuleCode") String curModuleCode,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) {
        SysdataGridPersonConfig sysdataGridPersonConfig =null;
        if (redisService.isExistCache("sysdata_grid_person_config_"+curModuleCode+userId)){
            sysdataGridPersonConfig = (SysdataGridPersonConfig) JsonUtil.fromJson(redisService.redisSysConfigGet("sysdata_grid_person_config_" +curModuleCode+userId),
                    SysdataGridPersonConfig.class);
        }else{
            sysdataGridPersonConfig = sysdataGridPersonConfigService.findConfValByIdAndCode(userId, curModuleCode);
        }
        if (null != sysdataGridPersonConfig) {
            sysdataGridPersonConfig.setConf_val(gridStyle);
        } else {
            sysdataGridPersonConfig = new SysdataGridPersonConfig();
            sysdataGridPersonConfig.setUser_id(userId);
            sysdataGridPersonConfig.setUser_name(userName);
            sysdataGridPersonConfig.setModule_code(curModuleCode);
            sysdataGridPersonConfig.setConf_val(gridStyle);
            sysdataGridPersonConfig.setCreate_date(DateUtils.getCurDateTime2Minute());
        }
        ReturnMsg returnMsg=sysdataGridPersonConfigService.sysdataGridPersonConfigBase(sysdataGridPersonConfig);
        redisService.updateSysConfigRedis("sysdata_grid_person_config_"+curModuleCode+userId, JsonUtil.toJson(sysdataGridPersonConfig));
        return returnMsg ;
    }
}
