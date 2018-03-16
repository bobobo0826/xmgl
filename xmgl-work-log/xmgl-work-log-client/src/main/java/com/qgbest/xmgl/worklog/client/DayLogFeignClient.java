package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.DayLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

/**
 * Created by wjy on 2017/7/4.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface DayLogFeignClient {
    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_listDayLog,method = RequestMethod.POST)
    public Map getDayLogList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;

    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_getWorkOperateLog,method = RequestMethod.POST)
    public Map getWorkOperateLog(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;


    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_getDayLogInfoById,method = RequestMethod.GET)
    public DayLog getDayLogInfoById(@RequestParam("id") Integer id);


    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_getDayLogContentListById,method = RequestMethod.GET)
    public Map getDayLogContentListById(@RequestParam("id") Integer id);


    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_saveDayLog,method = RequestMethod.POST)
    public Map saveDayLog(@RequestBody DayLog dayLog,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;


    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_delDayLog,method = RequestMethod.DELETE)
    public ReturnMsg delDayLog(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_getNewDayLogNumbers,method = RequestMethod.GET)
    public Integer getNewDayLogNumbers();

    @RequestMapping(value = DayLogServiceHTTPConstants.RequestMapping_checkWorkLogRepeat,method = RequestMethod.GET)
    public Integer checkWorkLogRepeat(@RequestParam("workDate") String workDate, @RequestParam("userId") Integer userId);
}
