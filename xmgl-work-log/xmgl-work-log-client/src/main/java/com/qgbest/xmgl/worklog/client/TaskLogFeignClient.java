package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.constants.TaskLogServiceHTTPConstants;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by QG-YKM on 2017-07-13.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface TaskLogFeignClient {

    /**
     * 项目任务日志列表查询
     */
    @RequestMapping(value = TaskLogServiceHTTPConstants.RequestMapping_queryTaskLogList, method = RequestMethod.POST)
    public Map queryTaskLogList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page);
    /**
     * 获取周期列表
     */
    @RequestMapping(value = TaskLogServiceHTTPConstants.RequestMapping_getPeriodList,method = RequestMethod.GET)
    public List getPeriodList();

}