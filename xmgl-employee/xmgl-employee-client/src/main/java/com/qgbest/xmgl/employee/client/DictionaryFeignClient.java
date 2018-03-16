package com.qgbest.xmgl.employee.client;
import com.qgbest.xmgl.employee.api.constants.DictionaryServiceHTTPConstants;
import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.Dictionary;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/7/31.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface DictionaryFeignClient {
  /**
 * 获取业务类型列表
 */
    @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_getBusinessTypeList,method = RequestMethod.GET)
  public List getBusinessTypeList();
  /**
   * 查询字典列表
   * @param queryMap 查询条件
   * @param len 查询条数
   * @param page 查询页码
   * @return
   */
  @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_queryDictionaryList,method = RequestMethod.POST)
  public Map queryDictionaryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page);
  /**
     * 根据项目Id删除项目信息
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_delDictionaryInfoById,method = RequestMethod.DELETE)
    public ReturnMsg delDictionaryInfoById(@RequestParam("id") Integer id) ;
  /**
   * 根据Id启用字典
   * @param id 项目Id
   * @return
   */
  @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_startDictionaryById,method = RequestMethod.POST)
  public ReturnMsg startDictionaryById(@RequestParam("id") Integer id) ;
  /**
   * 根据Id禁用字典
   * @param id 项目Id
   * @return
   */
  @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_forbiddenDictionaryById,method = RequestMethod.POST)
  public ReturnMsg forbiddenDictionaryById(@RequestParam("id") Integer id) ;

    /**
     * 根据项目Id 获取项目model
     * @param id 项目Id
     * @return
     */
    @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_getDictionaryInfoById,method = RequestMethod.POST)
    public Dictionary getDictionaryInfoById(@RequestParam("id") Integer id);

    /**
     * 保存项目信息
     * @param dictionary 项目model
     * @return
     */
    @RequestMapping(value = DictionaryServiceHTTPConstants.RequestMapping_saveDictionary,method = RequestMethod.PUT)
    public ReturnMsg saveDictionary(@RequestBody Dictionary dictionary) ;

}
