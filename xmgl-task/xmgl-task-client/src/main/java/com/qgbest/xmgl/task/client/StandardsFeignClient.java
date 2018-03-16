package com.qgbest.xmgl.task.client;

import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.constants.StandardsServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.WritingStandards;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by fcy on 2017/8/8.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface StandardsFeignClient {
    /**
     * 列表查询
     *

     * @return
     */
    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_getStandardsList, method = RequestMethod.POST)
    public List getStandardsList(@RequestParam("parentId") String parentId);


    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_getStandardsShowList, method = RequestMethod.POST)
    public List getStandardsShowList(@RequestParam("parentId") String parentId);

    /**
     * 规范详情
     * @param id
     * @return
     */
    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_getStandardsInfo,method= RequestMethod.GET)
    public WritingStandards getStandardsInfo(@RequestParam("id") Integer id);

    /**
     * 保存角色
     * @param writingStandards
     * @return
     */
    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_saveStandardsInfo,method= RequestMethod.PUT)
    public WritingStandards saveStandardsInfo(@RequestBody WritingStandards writingStandards);

    /**
     * 删除规范
     * @param
     * @return
     */
    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_delStandardsInfo,method= RequestMethod.DELETE)
    public Map delStandardsInfo(@RequestParam("id") String id);


    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_publishStandards, method = RequestMethod.POST)
    public ReturnMsg publishStandards(@RequestParam("id") Integer id);

    @RequestMapping(value = StandardsServiceHTTPConstants.RequestMapping_unPublishStandards, method = RequestMethod.POST)
    public ReturnMsg unPublishStandards(@RequestParam("id") Integer id);

    /**
     * 获取规范页面
     */
    @RequestMapping(value= StandardsServiceHTTPConstants.RequestMapping_getStandardsPage, method = RequestMethod.POST)
    public List getStandardsPage();
}
