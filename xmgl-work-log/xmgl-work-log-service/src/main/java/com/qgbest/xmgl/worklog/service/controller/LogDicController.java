package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.LogDicService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/8/11.
 *
 */
    @RestController
    @RequestMapping(value = "/manage/dictionary")
    @Api(value = "字典管理", description = "提供字典的增删改查服务")
     public class LogDicController extends BaseController{
    @Autowired
    private LogDicService logDicService;
 /**
  * query
  */
  @RequestMapping(value = "/queryLogDictionaryList",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
  public Map queryLogDictionaryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page){
  Map query= JsonUtil.fromJsonToMap(queryMap);
  PageControl pc = this.logDicService.queryLogDictionaryList(query, page, len);
  Map jsonData = getQueryMap(pc);

  return jsonData;
  }
  @RequestMapping(value = "/getLogDictionaryInfoById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
  public Dictionary getFileInfoById(@PathVariable("id") Integer id) {
  Dictionary dictionary=logDicService.getLogDictionaryInfoById(id);
  return dictionary;
 }
 @ApiOperation(value = "保存字典信息",notes = "保存字典信息")
 @ApiImplicitParam(dataType = "Dictionary", name = "dictionary", value = "字典model", required = true, paramType = "body")
 @RequestMapping(value = "/saveLogDictionary",method = RequestMethod.PUT,produces = MediaType.APPLICATION_JSON_VALUE)
 public ReturnMsg saveLogDictionary(@RequestBody Dictionary dictionary) {
  ReturnMsg returnMsg=logDicService.saveLogDictionary(dictionary);
  return returnMsg ;
 }

 @ApiOperation(value = "删除字典信息",notes = "删除字典信息")
 @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
 @RequestMapping(value = "/delLogDictionaryInfoById/{id}",method = RequestMethod.DELETE,produces = MediaType.APPLICATION_JSON_VALUE)
 public ReturnMsg delLogDictionaryInfoById(@PathVariable("id") Integer id) {
  ReturnMsg returnMsg= logDicService.delLogDictionaryInfoById(id);
  return returnMsg ;
 }
 @ApiOperation(value = "启用字典",notes = "字典启用")
 @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
 @RequestMapping(value = "/startLogDictionaryById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
 public ReturnMsg startLogDictionaryById(@PathVariable("id") Integer id) {
  ReturnMsg returnMsg= logDicService.startLogDictionaryById(id);
  return returnMsg ;
 }

 @ApiOperation(value = "禁用字典",notes = "禁用")
 @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
 @RequestMapping(value = "/forbiddenLogDictionaryById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
 public ReturnMsg forbiddenLogDictionaryById(@PathVariable("id") Integer id) {
  ReturnMsg returnMsg= logDicService.forbiddenLogDictionaryById(id);
  return returnMsg ;
 }
 @ApiOperation(value = "字典类型列表列表查询",notes = "字典类型列表列表查询")
 @RequestMapping(value = "/getBusinessTypeList",method = RequestMethod.GET)
 public List getBusinessTypeList() {
  List list = logDicService.getBusinessTypeList();
  return list;
 }
}
