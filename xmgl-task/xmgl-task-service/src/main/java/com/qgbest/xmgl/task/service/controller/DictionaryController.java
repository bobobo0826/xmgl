package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.entity.Dictionary;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.service.service.DictionaryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/7/31.
 */

@RestController
@RequestMapping(value = "/manage/dictionaryTask")
@Api(value = "字典管理",description = "提供RESTful风格API的字典的增删改查服务")
public class DictionaryController extends BaseController{
   // public static final Logger logger = LoggerFactory.getLogger(DictionaryController.class);
    @Autowired
    private DictionaryService dictionaryService;

    @ApiOperation(value="字典查询", notes="字典分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "java.lang.String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "java.lang.Integer", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "java.lang.Integer", name = "page", value = "查询页码", required = true, paramType = "query")
    })
    /**
     * query
     */
    @RequestMapping(value = "/queryDictionaryList",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public Map queryDictionaryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page){
        Map query= JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.dictionaryService.queryDictionaryList(query, page, len);
        Map jsonData = getQueryMap(pc);

        return jsonData;
    }

    @ApiOperation(value = "删除字典信息",notes = "删除字典信息")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
    @RequestMapping(value = "/delDictionaryInfoById/{id}",method = RequestMethod.DELETE,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delDictionaryInfoById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= dictionaryService.delDictionaryInfoById(id);
        return returnMsg ;
    }
    @ApiOperation(value = "启用字典",notes = "字典启用")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
    @RequestMapping(value = "/startDictionaryById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg startDictionaryById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= dictionaryService.startDictionaryById(id);
        return returnMsg ;
    }

    @ApiOperation(value = "禁用字典",notes = "禁用")
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典id", required = true,paramType = "path")
    @RequestMapping(value = "/forbiddenDictionaryById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg forbiddenDictionaryById(@PathVariable("id") Integer id) {
        ReturnMsg returnMsg= dictionaryService.forbiddenDictionaryById(id);
        return returnMsg ;
    }
    @ApiOperation(value = "字典类型列表列表查询",notes = "字典类型列表列表查询")
    @RequestMapping(value = "/getBusinessTypeList",method = RequestMethod.GET)
    public List getBusinessTypeList() {
        List list = dictionaryService.getBusinessTypeList();
        return list;
    }

    @ApiOperation(value = "获取字典model",notes = "根据字典ID获取字典详情")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Integer", name = "id", value = "字典ID", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getDictionaryInfoById/{id}",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public Dictionary getFileInfoById(@PathVariable("id") Integer id) {
        Dictionary dictionary=dictionaryService.getDictionaryInfoById(id);
        return dictionary;
    }
    @ApiOperation(value = "保存字典信息",notes = "保存字典信息")
    @ApiImplicitParam(dataType = "Dictionary", name = "dictionary", value = "字典model", required = true, paramType = "body")
    @RequestMapping(value = "/saveDictionary",method = RequestMethod.PUT,produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg saveDictionary(@RequestBody Dictionary dictionary) {
        ReturnMsg returnMsg=dictionaryService.saveDictionary(dictionary);
        return returnMsg ;
    }
}
