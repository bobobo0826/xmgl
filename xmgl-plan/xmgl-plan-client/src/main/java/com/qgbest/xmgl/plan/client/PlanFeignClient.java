package com.qgbest.xmgl.plan.client;
import com.qgbest.xmgl.plan.api.constants.PlanServiceHTTPConstants;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.api.entity.ReturnMsg;

import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.plan.api.constants.ServiceConstants;
import java.util.Map;
import java.util.List;
/**
 * Created by quangao on 2017/10/31.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface PlanFeignClient {
    /**
     * 选择计划列表
     *
     * @return
     */
    @RequestMapping(value = PlanServiceHTTPConstants.RequestMapping_getPlanQueryList, method = RequestMethod.POST)
    public Map getPlanQueryList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user,@RequestParam("taskType") String taskType);
    /**
     * 根据ID获取计划
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = PlanServiceHTTPConstants.RequestMapping_getPlanInfoById, method = RequestMethod.GET)
    public Plan getPlanInfoById(@RequestParam("id") Integer id);

    /**
     * 保存计划
     */
    @RequestMapping(value = PlanServiceHTTPConstants.RequestMapping_savePlan,method = RequestMethod.POST)
    public Map savePlan(@RequestBody Plan plan,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;

    /**
     * 计算计划完成情况
     */
    @RequestMapping(value = PlanServiceHTTPConstants.RequestMapping_getPlanPercent,method = RequestMethod.POST)
    public Map getPlanPercent(@RequestParam("taskId") Integer taskId);



}
