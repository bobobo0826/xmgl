package com.qgbest.xmgl.task.client;

import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.constants.TaskServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface TaskFeignClient {
    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_listTask,method = RequestMethod.POST)
    public Map getTaskList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getTaskOperateLog,method = RequestMethod.POST)
    public Map getTaskOperateLog(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;


    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_selectTaskByEmployee,method = RequestMethod.POST)
    public Map selectTaskByEmployee(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestParam("employee_id") Integer employee_id) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_listPlan,method = RequestMethod.POST)
    public List getPlanList(@RequestParam("queryMap") String queryMap) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getTaskInfoById,method = RequestMethod.GET)
    public Task getTaskInfoById(@RequestParam("id") Integer id);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getPlanInfoById,method = RequestMethod.GET)
    public Plan getPlanInfoById(@RequestParam("id") Integer id);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_saveTask,method = RequestMethod.POST)
    public Map saveTask(@RequestBody Task task,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_savePlanList,method = RequestMethod.POST)
    public ReturnMsg savePlanList(@RequestParam("planListStr") String planListStr, @RequestParam("taskId") Integer taskId,
                                  @RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_resetModifiedFlag,method = RequestMethod.PUT)
    public Map resetModifiedFlag(@RequestParam("taskId") Integer taskId) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_savePlan,method = RequestMethod.POST)
    public Map savePlan(@RequestBody Plan plan,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_delTask,method = RequestMethod.DELETE)
    public ReturnMsg delTask(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_delPlan,method = RequestMethod.DELETE)
    public ReturnMsg delPlan(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_deletePlanByTaskId,method = RequestMethod.DELETE)
    public ReturnMsg deletePlanByTaskId(@RequestParam("taskId") Integer taskId);


    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getTaskSchedulePercent,method = RequestMethod.POST)
    public Map getTaskSchedulePercent(@RequestParam("taskId") Integer taskId,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_saveAfterCheck,method = RequestMethod.PUT)
    public Map saveAfterCheck(@RequestParam("queryMap") String queryMap,@RequestBody TcUser user);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_multiSubmit,method = RequestMethod.POST)
    public ReturnMsg multiSubmit(@RequestParam("queryMap") String queryMap,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_saveMultiCheckDesc,method = RequestMethod.PUT)
    public ReturnMsg saveMultiCheckDesc(@RequestParam("queryMap") String queryMap, @RequestBody TcUser user);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_multiDistribute,method = RequestMethod.POST)
    public ReturnMsg multiDistribute(@RequestParam("queryMap") String queryMap,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);


    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_resetTaskAndPlanCondition,method = RequestMethod.POST)
    public ReturnMsg resetTaskAndPlanCondition(@RequestParam("moduleId") Integer moduleId);


    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_updateTaskModuleName,method = RequestMethod.POST)
    public ReturnMsg updateTaskModuleName(@RequestParam("moduleId") Integer moduleId, @RequestParam("moduleName") String moduleName);


    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_resetPlanCondition,method = RequestMethod.POST)
    public ReturnMsg resetPlanCondition(@RequestParam("taskId") Integer taskId);



/*    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_setTaskUserId,method = RequestMethod.DELETE)
    public Map setTaskUserId(@RequestParam("id") Integer id);*/

    /**
     *查询monday_date为起始日期的周日志id
     */
    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getPlanIncompleteCountByTaskId, method = RequestMethod.GET)
    Integer getPlanIncompleteCountByTaskId(@RequestParam("task_id" ) Integer task_id);
    /**
     * 根据指定审核人id获取待审核的任务列表
     */
    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getUncheckedTaskList,method = RequestMethod.GET)
    List getUncheckedTaskList(@RequestParam("assigned_checker_id") Integer assigned_checker_id);

    @RequestMapping(value = TaskServiceHTTPConstants.RequestMapping_getAverageCompleteByProjectId,method = RequestMethod.POST)
    public String getAverageCompleteByProjectId(@RequestParam("project_id") Integer project_id);


}
