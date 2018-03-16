package com.qgbest.xmgl.worklog.client;
import com.qgbest.xmgl.worklog.api.constants.UpdateLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;

import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/7/24.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface UpdateLogFeignClient {

    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_getUpdateLogList,method = RequestMethod.GET)
    public List getUpdateLogList();
    /**
     * 列表查询
     *
     * @param queryMap 查询条件
     * @param len      查询个数
     * @param page     查询页码
     * @return
     */
    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_getUpdateLogList, method = RequestMethod.POST)
    public Map getUpdateLogList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page);


    /**
     * 获取
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_getUpdateLogInfo, method = RequestMethod.GET)
    public UpdateLog getUpdateLogInfo(@RequestParam("id") Integer id);


    /**
     * 保存
     *
     * @param updateLog model
     * @return
     */
    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_saveUpdateLogInfo, method = RequestMethod.PUT)
    public ReturnMsg saveUpdateLogInfo(@RequestBody UpdateLog updateLog);

    /**
     * 删除
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_delUpdateLogInfo, method = RequestMethod.DELETE)
    public ReturnMsg delUpdateLogInfo(@RequestParam("id") Integer id);




    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_publishUpdateLog, method = RequestMethod.POST)
    public ReturnMsg publishUpdateLog(@RequestParam("id") Integer id);

    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_unPublishUpdateLog, method = RequestMethod.POST)
    public ReturnMsg unPublishUpdateLog(@RequestParam("id") Integer id);


    @RequestMapping(value = UpdateLogServiceHTTPConstants.RequestMapping_getNewUpdateLogNumbers,method = RequestMethod.GET)
    public Integer getNewUpdateLogNumbers();
    /**
     * 获取更新日志
     */
    @RequestMapping(value= UpdateLogServiceHTTPConstants.RequestMapping_getLatestUpdateLog, method = RequestMethod.POST)
    public List getLatestUpdateLog();






}
