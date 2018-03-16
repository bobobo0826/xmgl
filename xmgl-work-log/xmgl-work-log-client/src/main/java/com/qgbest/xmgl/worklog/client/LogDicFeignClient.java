package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.worklog.api.constants.LogDicServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/8/10.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface LogDicFeignClient {
    /**
     * 查询字典列表
     * @param queryMap 查询条件
     * @param len 查询条数
     * @param page 查询页码
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_queryLogDictionaryList,method = RequestMethod.POST)
    public Map queryLogDictionaryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page);
    /**
     * 根据项目Id 获取项目model
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_getLogDictionaryInfoById,method = RequestMethod.POST)
    public Dictionary getLogDictionaryInfoById(@RequestParam("id") Integer id);
    /**
     * 根据Id启用字典
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_startLogDictionaryById,method = RequestMethod.POST)
    public ReturnMsg startLogDictionaryById(@RequestParam("id") Integer id) ;
    /**
     * 根据Id禁用字典
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_forbiddenLogDictionaryById,method = RequestMethod.POST)
    public ReturnMsg forbiddenLogDictionaryById(@RequestParam("id") Integer id) ;
    /**
     * 保存项目信息
     * @param dictionary 项目model
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_saveLogDictionary,method = RequestMethod.PUT)
    public ReturnMsg saveLogDictionary(@RequestBody Dictionary dictionary) ;
    /**
     * 根据项目Id删除项目信息
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_delLogDictionaryInfoById,method = RequestMethod.DELETE)
    public ReturnMsg delLogDictionaryInfoById(@RequestParam("id") Integer id) ;
    /**
     * 获取业务类型列表
     */
    @RequestMapping(value = LogDicServiceHTTPConstants.RequestMapping_getBusinessTypeList,method = RequestMethod.GET)
    public List getBusinessTypeList();

}
