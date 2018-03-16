package com.qgbest.xmgl.plan.service.controller;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.service.dao.PlanRepository;
import com.qgbest.xmgl.plan.service.dao.PlanRepositoryExtends;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.plan.api.entity.ReturnMsg;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by quangao on 2017/10/31.
 */
@Api(value = "选择计划", description = "提供任务计划增删改查API")
@RestController
@RequestMapping(value = "/manage/selectPlan")
public class SelectPlanController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(SelectPlanController.class);
    @Autowired
    private EmployeeFeignClient employeeFeignClient;
    @Autowired
    private PlanRepositoryExtends planRepositoryExtends;
    @Autowired
    private PlanRepository planRepository;

    /**
     * 选择计划列表
     *
     * @return
     */
    @ApiOperation(value = "分页查询获取我的任务管理列表", notes = "分页查询获取我的任务管理列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
    })
    @PostMapping(value = "/getPlanQueryList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getPlanQueryList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user,@RequestParam String taskType) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        Employee employee=employeeFeignClient.getEmployeeInfoByUserId(user.getId());
        String contractor=employee.getId()+"~"+employee.getDept_name()+"~"+employee.getEmployee_name();
        PageControl pc = planRepositoryExtends.getPlanQueryList(query, page,len,user,taskType,contractor);
        jsonData = getQueryMap(pc);
        return jsonData;
    }
    @ApiOperation(value = "获取计划信息ID", notes = "根据ID获取计划信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getPlanInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Plan getPlanInfoById(@PathVariable("id") Integer id) {
        Plan plan = planRepository.getPlanInfoById(id);
        return plan;
    }

    @ApiOperation(value = "计划信息保存", notes = "计划信息保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Plan", name = "plan", value = "计划信息model", required = true, paramType = "body"),
    })
    @RequestMapping(value = "/savePlan", method = RequestMethod.POST)
    public Map savePlan(@RequestBody Plan plan, @RequestParam Integer userId, @RequestParam String userName) {
        logger.debug("保存计划信息：{}", plan);
        Map map = new HashMap();
        planRepository.save(plan);
        map.put("plan", plan);
        return map;
    }

    @ApiOperation(value = "根据TaskId获取计划完成进度", notes = "根据TaskId获取计划完成进度")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "taskId", value = "taskId", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getPlanPercent", method = RequestMethod.POST)
    public Map getPlanPercent(@RequestParam("taskId") Integer taskId) {
        return planRepositoryExtends.getPlanPercent(taskId);
    }

}
