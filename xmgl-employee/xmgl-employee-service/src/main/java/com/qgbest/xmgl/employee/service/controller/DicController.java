package com.qgbest.xmgl.employee.service.controller;


import com.qgbest.xmgl.employee.service.service.DicService;
import com.qgbest.xmgl.employee.service.service.RedisService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 * 字典controller
 */
@Api(value = "运输地字典表管理",description="提供运输地字典表增删改查API")
@RestController
@RequestMapping(value = "/manage/dic")
public class DicController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(DicController.class);
    @Autowired
    private DicService dicService;//字典管理service
    @Autowired
    private RedisService redisService;//缓存service

    @ApiOperation(value="获取字典表", notes="根据业务类型code获取字典表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "businessCode", value = "业务code", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getDicListByBusinessCode/{businessCode}",method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    public List getDicListByBusinessCode(@PathVariable String businessCode){
        List list = null;
        //有缓存先从缓存里取
        if (redisService.isExistCache(businessCode)){
            list = redisService.redisDicGet(businessCode);
        }else{
            list = dicService.getDicListByBusinessCode(businessCode);
            redisService.updateDicRedis(businessCode,list);
        }
        return list;
    }
    @ApiOperation(value="获取字典表字典名称", notes="根据业务类型code和字典code获取字典表字典名称")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "businessCode", value = "业务code", required = true, paramType = "path"),
            @ApiImplicitParam(dataType = "String", name = "dataCode", value = "字典code", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getDataNameByDataCode/{businessCode}/{dataCode}",method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    public String getDataNameByDataCode(@PathVariable String businessCode,@PathVariable String dataCode){
        String dataName=dicService.getDataNameByDataCode(businessCode,dataCode);
        return dataName;
    }

  /*  *//**
     * 获取业务类型列表
     * @return
     *//*
    @RequestMapping(value = "/getBusinessTypeList",method = RequestMethod.POST)
    public List getBusinessTypeList(){
        List list = dicService.getBusinessTypeList();
        return list;
    }

    *//**
     * 获取字典列表
     * @param httpServletRequest
     * @return
     *//*
    @RequestMapping(value = "/getDicList",method = RequestMethod.POST)
    public Map getDicList(HttpServletRequest httpServletRequest) {
        Map condition=httpServletRequest.getParameterMap();
        Map jsonData = new HashMap();
        try {
            Map conditionMap= JsonUtil.fromJsonToMap(JsonUtil.getJsonStrByObject(condition));
            Integer page=Integer.valueOf(String.valueOf(conditionMap.get("page")));
            Integer size=Integer.valueOf(String.valueOf(conditionMap.get("rows")));
            Map queryMap=JsonUtil.fromJsonToMap(conditionMap.get("queryMap").toString());
            Pageable pageable = new PageRequest(page-1,size);
            PageControl pc = this.dicService.findDicList(queryMap,page, size);
            jsonData=getQueryMap(pc);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonData;
    }

    *//**
     * 根据id获取字典信息
     * @param id
     * @return
     *//*
    @RequestMapping(value = "/getDicById/{id}",produces = MediaType.APPLICATION_JSON_VALUE)
    public Dictionary getSupplierInfo(@PathVariable Integer id) {
        Dictionary dictionary;
        if(id==0){
            dictionary=new Dictionary();
        }else{
            dictionary = dicService.findById(id);
        }

        return dictionary;
    }

    *//**
     * 根据id删除字典信息
     * @param id
     * @return
     *//*
    @RequestMapping(value = "/delDic",produces = MediaType.APPLICATION_JSON_VALUE)
    public Map delDic(@RequestParam("id")Integer id) {
        Map<String,Object> map = new HashMap<String,Object>();
        if(id==null){
            map.put("msgCode","failure");
            map.put("msgDesc","删除失败");
        }else{
            dicService.deleteById(id);
            map.put("msgCode","success");
            map.put("msgDesc","删除成功");
        }
        return map ;
    }

    *//**
     * 保存字典信息
     * @param dictionary
     * @return
     *//*
    @RequestMapping(value = "/save",method = RequestMethod.POST)
    public Dictionary save(@RequestBody Dictionary dictionary) {
        dicService.save(dictionary);
        return dictionary;
    }*/



}
