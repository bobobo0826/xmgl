package com.qgbest.xmgl.task.client;

import com.qgbest.xmgl.task.api.constants.MyTaskServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;

import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import java.util.Map;
import java.util.List;

/**
 * Created by mjq on 2017/7/26.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface MyTaskFeignClient {
    /**
     * 我的任务列表查询
     *
     * @param queryMap 查询条件
     * @param len      查询个数
     * @param page     查询页码
     * @return
     */
    @RequestMapping(value = MyTaskServiceHTTPConstants.RequestMapping_getMyTaskQueryList, method = RequestMethod.POST)
    public Map getMyTaskQueryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user,@RequestParam("taskType") String taskType);

    /**
     * 根据ID获取计划
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = MyTaskServiceHTTPConstants.RequestMapping_getMyTaskInfoById, method = RequestMethod.GET)
    public Plan getMyTaskInfoById(@RequestParam("id") Integer id);
    /**
     * 根据id获取参与人员信息
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = MyTaskServiceHTTPConstants.RequestMapping_getParticipantsListById,method = RequestMethod.GET)
    public Map getParticipantsListById(@RequestParam("id") Integer id);

    @RequestMapping(value = MyTaskServiceHTTPConstants.RequestMapping_getUnCompletePlan, method = RequestMethod.POST)
    public Map getUnCompletePlan(@RequestBody TcUser user);


}
