package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.constants.WeekLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by mjq on 2017/7/4.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface WeekLogFeignClient {
    /**
     * 列表查询
     *
     * @param queryMap 查询条件
     * @param len      查询个数
     * @param page     查询页码
     * @return
     */
    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_getWeekLogList, method = RequestMethod.POST)
    public Map getWeekLogList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user);


    /**
     * 获取员工管理系统
     * @param id ID
     * @return
     */
    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_getWeekLogInfo, method = RequestMethod.GET)
    public WeekLog getWeekLogInfo(@RequestParam("id") Integer id);


    /**
     * 保存
     * @param weekLog model
     * @return
     */
    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_saveWeekLogInfo, method = RequestMethod.POST)
    public Map saveWeekLogInfo(@RequestBody WeekLog weekLog,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    /**
     * 删除
     * @param id ID
     * @return
     */
    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_delWeekLogInfo, method = RequestMethod.DELETE)
    public ReturnMsg delWeekLogInfo(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);


    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_getNewWeekLogNumbers,method = RequestMethod.GET)
    public Integer getNewWeekLogNumbers();


    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_getWeekLogContentListById,method = RequestMethod.GET)
    public Map getWeekLogContentListById(@RequestParam("id") Integer id);

    /**
     *查询monday_date为起始日期的周日志id
     */
    @RequestMapping(value = WeekLogServiceHTTPConstants.RequestMapping_getWeekLogIdByTaskStartDate,method = RequestMethod.GET)
    List getWeekLogIdByTaskStartDate(@RequestBody TcUser user, @RequestParam("monday_date") String monday_date);

}
