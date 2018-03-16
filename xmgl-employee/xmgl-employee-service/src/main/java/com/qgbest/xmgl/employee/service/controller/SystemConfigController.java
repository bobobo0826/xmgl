package com.qgbest.xmgl.employee.service.controller;


import com.qgbest.xmgl.employee.service.service.SystemConfigService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by xw on 2017/6/19.
 * 系统配置controller
 */
@Api(value = "运输地系统参数配置管理",description="提供运运输地系统参数配置增删改查API")
@RestController
@RequestMapping(value = "/manage/systemConf")
public class SystemConfigController {
    @Autowired
    private SystemConfigService systemConfigService;

    @ApiOperation(value="获取系统参数配置", notes="获取系统参数配置")
    @RequestMapping(value = "getDataValueByCode/{dataCode}",method = RequestMethod.GET)
    public String getDataValueByCode(@PathVariable("dataCode") String dataCode){

        String dataValue = systemConfigService.getDataValueByCode(dataCode);
        return dataValue;
    }

   /* @RequestMapping(value = "/getSystemConf",method = RequestMethod.POST)
    public Map getSystemConf(HttpServletRequest httpServletRequest) {
        Map condition=httpServletRequest.getParameterMap();
        Map jsonData = new HashMap();
        try {
            Map conditionMap= JsonUtil.fromJsonToMap(JsonUtil.getJsonStrByObject(condition));
            Integer page=Integer.valueOf(String.valueOf(conditionMap.get("page")));
            Integer size=Integer.valueOf(String.valueOf(conditionMap.get("rows")));
            Map queryMap= JsonUtil.fromJsonToMap(conditionMap.get("queryMap").toString());
            Pageable pageable = new PageRequest(page-1,size);
            PageControl pc = this.systemConfigService.getSystemConf(queryMap,page, size);
            jsonData.put("total", pc.getTotalitem());
            jsonData.put("rows", pc.getList());
            Map pagination = new HashMap();
            pagination.put("pageSize", pc.getPagesize());
            pagination.put("pageNumber", pc.getNextpage());
            jsonData.put("pagination", pagination);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonData;
    }

    @RequestMapping(value = "/getSystem/{id}",produces = MediaType.APPLICATION_JSON_VALUE)
    public SystemConfig getWy(@PathVariable Integer id) {
        SystemConfig SystemConfig = systemConfigService.findSystemById(id);
        return SystemConfig;
    }

    //删除
    @RequestMapping(value = "/delSystemById",method = RequestMethod.POST)
    public Map delProjectById(@RequestParam("id")Integer id){
        Map<String,Object> map = new HashMap<String,Object>();
        systemConfigService.delSystemById(id);
        map.put("msgCode","success");
        map.put("msgDesc","操作成功");
        return map ;
    }

    @RequestMapping(value = "/saveSystem",method = RequestMethod.POST)
    public SystemConfig saveSystem(@RequestBody SystemConfig SystemConfig) {
        systemConfigService.saveSystem(SystemConfig);
        return SystemConfig;
    }

   */
}
