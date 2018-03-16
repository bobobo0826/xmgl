package com.qgbest.xmgl.task.service.controller;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.service.service.MyTaskService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
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
 * Created by mjq on 2017/7/26.
 */
@Api(value = "任务计划", description = "提供任务计划增删改查API")
@RestController
@RequestMapping(value = "/manage/myTask")
public class MyTaskController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(MyTaskController.class);
    @Autowired
    private MyTaskService myTaskService;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;

    @ApiOperation(value = "分页查询获取我的任务管理列表", notes = "分页查询获取我的任务管理列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
    })
    @PostMapping(value = "/getMyTaskQueryList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getMyTaskQueryList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user,@RequestParam String taskType) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        Employee employee=employeeFeignClient.getEmployeeInfoByUserId(user.getId());
        System.out.println("!!!!!!!!!!!!!!!!!user.getId()="+user.getId());
        System.out.println("!!!!!!!!!!!!!!!!!"+employee);
        String contractor=employee.getId()+"~"+employee.getDept_name()+"~"+employee.getEmployee_name();
        PageControl pc = this.myTaskService.getMyTaskQueryList(query, page,len,user,taskType,contractor);
        jsonData = getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value = "获取计划信息ID", notes = "根据ID获取计划信息")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getMyTaskInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Plan getMyTaskInfoById(@PathVariable("id") Integer id) {
        Plan plan = myTaskService.getMyTaskInfoById(id);
        return plan;
    }



    @ApiOperation(value="查询某条计划的参与人员", notes="根据计划id查询某条计划的参与人员")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path")
    })
    @RequestMapping(value = "/getParticipantsListById/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getParticipantsListById(@PathVariable Integer id){
        return myTaskService.getParticipantsListById(id);
    }

    @ApiOperation(value = "获取我的待完成计划列表", notes = "获取我的待完成计划列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @RequestMapping(value = "/getUnCompletePlan", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getUnCompletePlan(@RequestBody TcUser user) {
        return myTaskService.getUnCompletePlan(user);

    }


}
