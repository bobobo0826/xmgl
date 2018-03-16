package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.task.api.entity.*;
import com.qgbest.xmgl.task.service.dao.*;
import com.qgbest.xmgl.task.api.entity.*;
import com.qgbest.xmgl.task.service.service.LogService;
import com.qgbest.xmgl.task.service.service.TaskProcessService;
import com.qgbest.xmgl.task.service.service.TaskService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import io.swagger.annotations.Api;
import com.qgbest.xmgl.project.client.ProjectFeignClient;
import com.qgbest.xmgl.project.client.ProjModuleFeignClient;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by wjy on 2017/7/18.
 */
@RestController
@Transactional
public class TaskController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TaskController.class);
    @Autowired
    private TaskService taskService;
    @Autowired
    private LogService logService;
    @Autowired
    private TaskExtends taskExtends;
    @Autowired
    private TaskRepository taskRepository;
    @Autowired
    private TaskTempRepository taskTempRepository;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;
    @Autowired
    private ProjectFeignClient projectFeignClient;
    @Autowired
    private ProjModuleFeignClient projModuleFeignClient;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;
    @Autowired
    private TaskAlterRepository taskAlterRepository;
    @Autowired
    private TaskProcessService taskProcessService;
    @Autowired
    private TaskAlterExtends taskAlterExtends;


    private Boolean equals(String str1, String str2) {
        if (str1 == null)
            str1 = "";
        if (str2 == null)
            str2 = "";
        if (str1.equals(str2))
            return true;
        else
            return false;
    }

    @PostMapping(value = "/getTaskList")
    public PageControl getTaskList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        System.out.println("queryMap");
        System.out.println(queryMap);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))) {
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))) {
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))) {
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        Employee curEmp = employeeFeignClient.getEmployeeInfoByUserId(curUser.getId());
        String empStr = curEmp.getId()+"~"+curEmp.getDept_name()+"~"+curEmp.getEmployee_name();
        PageControl pc = taskExtends.findTaskList(queryOptions, cpage, len, curUser,empStr);
        System.out.println(JsonUtil.toJson(pc));
        return pc;
    }

    @PostMapping(value = "/deleteTask")
    public Map deleteTask(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            Integer id = (((Double) dataMap.get("id")).intValue());
            taskRepository.deleteTaskById(id);
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }
    @PostMapping(value = "/cancelTask")
    public Map cancelTask(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            Integer id = (((Double) dataMap.get("id")).intValue());
            Task task = taskRepository.getTaskInfoById(id);
            task.setTask_condition_code("YZX");
            taskRepository.save(task);
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }

    @RequestMapping(value = "/getTaskDic/{businessType}")
    @ResponseBody
    public List getTaskDic(@PathVariable String businessType) {
        return dicRepositoryExtends.getDicListByBusinessCode(businessType);
    }

    @RequestMapping(value = "/getProject")
    @ResponseBody
    public Map getProject() {
        Map project = projectFeignClient.queryProjectList((new HashMap()).toString(), 10000, 1);
        return project;
    }

    @RequestMapping(value = "/getModuleByProjectId/{projectId}")
    @ResponseBody
    public List getModuleByProjectId(@PathVariable Integer projectId) {
        List list = projModuleFeignClient.choseProjModule(projectId);
        return list;
    }

    @RequestMapping(value = "/getEmployeeIdListByPid/{projectId}")
    @ResponseBody
    public List getEmployeeIdListByPid(@PathVariable Integer projectId) {
        List list = projectFeignClient.getEmployeeIdListByPid(projectId);
        return list;
    }

    @RequestMapping(value = "/getDeptAndEmployee")
    @ResponseBody
    public Map getDeptAndEmployee() {
        Map employee = employeeFeignClient.getEmployeeList((new HashMap()).toString(), 10000, 1, new TcUser());
        return employee;
    }


    @ApiOperation(value = "任务管理操作日志分页查询", notes = "任务信息分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/getTaskOperateLog", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getTaskOperateLog(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.taskService.getTaskOperateLog(query, page, len, user);
        jsonData = getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value = "根据参与人员查任务列表", notes = "根据参与人员查任务列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "employee_id", value = "员工id", required = false, paramType = "query")
    })
    @PostMapping(value = "/selectTaskByEmployee", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map selectTaskByEmployee(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestParam Integer employee_id) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.taskService.selectTaskByEmployee(query, page, len, employee_id);
        jsonData = getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value = "获取任务信息model", notes = "根据任务信息ID获取任务信息model")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getTaskInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Task getTaskInfoById(@PathVariable Integer id, HttpServletRequest request) {
        Task task = new Task();
        if (id != null && id != -1)
            task = this.taskRepository.getTaskInfoById(id);
        else {
            TcUser user = userFeignClient.getCurUser(request.getHeader("token"));
            System.out.println(user);
            if (user != null) {
                task.setCreator(user.getDisplayName());
                task.setCreator_id(user.getId());
            }
            System.out.println(DateUtils.getCurDateTime2Minute());
            task.setCreate_time(DateUtils.getCurDateTime2Minute());
        }
        return task;
    }

    @RequestMapping(value = "/getTaskInfoOrTempByTaskId/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getTaskInfoOrTempByTaskId(@PathVariable Integer id, HttpServletRequest request) {
        Map map = new HashMap();
        TcUser user = userFeignClient.getCurUser(request.getHeader("token"));
        Task task = getTaskInfoById(id, request);
        TaskTemp taskTemp = this.taskTempRepository.getTaskTempInfoByTaskId(id);
        if (taskTemp != null && user.getId().equals(task.getCreator_id())) {
            map.put("data", taskTemp);
        } else {
            map.put("data", task);
        }
        map.put("success", true);
        return map;
    }

    @ApiOperation(value = "根据TaskId获取任务完成进度", notes = "根据TaskId获取任务完成进度")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "taskId", value = "taskId", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getTaskSchedulePercent", method = RequestMethod.POST)
    public Map getTaskSchedulePercent(@RequestParam("taskId") Integer taskId, @RequestParam Integer userId, @RequestParam String userName) {
        return taskService.getTaskSchedulePercent(taskId, userId, userName);
    }

    @RequestMapping(value = "/getAverageCompleteByProjectId", method = RequestMethod.POST)
    public String getAverageCompleteByProjectId(@RequestParam("project_id") Integer project_id) {
        return taskService.getAverageCompleteByProjectId(project_id);
    }

    @RequestMapping(value = "saveTaskInfo", method = RequestMethod.POST)
    @ResponseBody
    public Map saveTaskInfo(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Task task = JsonUtil.fromJson(JsonUtil.toJson(dataMap), Task.class);
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        if (task != null) {
            if (StringUtils.isNotBlankOrNull(task.getCreator())) {
                task.setModify_time(DateUtils.getCurDateTime2Minute());
                if (curUser != null) {
                    task.setModifier_id(curUser.getId());
                    task.setModifier(curUser.getDisplayName());
                }
            } else {
                task.setCreate_time(DateUtils.getCurDateTime2Minute());
                if (curUser != null) {
                    task.setCreator_id(curUser.getId());
                    task.setCreator(curUser.getDisplayName());
                }
            }
            task.setComplete("0");

            String oldTask = JsonUtil.toJson(taskRepository.getTaskInfoById(task.getId()));
            if (task.getId()==null || task.getId() <0 ){
                oldTask = null;
            }
            taskRepository.save(task);
            String newTask = JsonUtil.toJson(task);
            if (StringUtils.isNotBlankOrNull(task.getId())) {
                taskProcessService.saveTaskProcess(oldTask,newTask, curUser);
            }
        }
        Map map = new HashMap();
        map.put("success", true);
        map.put("data", task);
        return map;
    }

    @RequestMapping(value = "saveTaskTempInfo", method = RequestMethod.POST)
    @ResponseBody
    public Map saveTaskTempInfo(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        TaskTemp taskTemp = JsonUtil.fromJson(JsonUtil.toJson(dataMap), TaskTemp.class);
        taskTempRepository.save(taskTemp);
        Map map = new HashMap();
        map.put("success", true);
        map.put("data", taskTemp);
        return map;
    }

    @RequestMapping(value = "/getTaskTempInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public TaskTemp getTaskTempInfoById(@PathVariable Integer id) {
        return this.taskTempRepository.getTaskTempInfoById(id);
    }

    @PostMapping(value = "/deleteTaskTemp")
    public Map deleteTaskTemp(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            Integer id = (((Double) dataMap.get("id")).intValue());
            taskTempRepository.deleteTaskTempById(id);
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }
    @PostMapping(value = "/recordTaskAlter")
    public Map recordTaskAlter(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        Task newTask = JsonUtil.fromJson(JsonUtil.toJson(dataMap.get("taskData")), Task.class);
        Task oldTask = getTaskInfoById(newTask.getId(), request);
        TaskAlter taskAlter = generateTaskAlter(JsonUtil.toJson(newTask), JsonUtil.toJson(oldTask));
        TcUser user = userFeignClient.getCurUser(request.getHeader("token"));
        taskAlter.setAlter_person(user.getDisplayName());
        taskAlter.setAlter_person_id(user.getId());
        taskAlter.setAlter_time(DateUtils.getCurDateTime2Minute());
        taskAlter.setTask_id(newTask.getId());
        taskAlter.setTask_name(newTask.getTask_name());
        taskAlter.setAlter_desc(String.valueOf(dataMap.get("alterDesc")));
        taskAlterRepository.save(taskAlter);
        map.put("data", taskAlter);
        return map;
    }



    public TaskAlter generateTaskAlter(String newObject, String oldObject) {
        List<String> compareFieldList = new ArrayList<>
                (Arrays.asList(
                        "task_name", "task_type_code", "sup_project_name", "sup_module_name", "task_desc", "participants"
                        , "report_cycle", "importance", "urgency", "detail", "expected_end_time"
                ));
        String propertyName = "";
        List<Map> alterList = new ArrayList<>();
        for (int i = 0; i < compareFieldList.size(); i++) {
            propertyName = compareFieldList.get(i);
            String oldValue = String
                    .valueOf((JsonUtil.fromJsonToMap(oldObject)).get(propertyName));
            String newValue = String
                    .valueOf((JsonUtil.fromJsonToMap(newObject)).get(propertyName));
            if (!equals(oldValue, newValue)) {
                Map alterContent = new HashMap();
                alterContent.put("field_name", propertyName);
                alterContent.put("new_value", newValue);
                alterContent.put("old_value", oldValue);
                alterList.add(alterContent);
            }
        }
        TaskAlter taskAlter = new TaskAlter();
        taskAlter.setAlter_content(JsonUtil.toJson(alterList));
        return taskAlter;
    }

    @PostMapping(value = "/getTaskInfoById/{id}")
    public Task getEvaluationInfoById(@PathVariable Integer id) {
        Task task = taskRepository.getTaskInfoById(id);
        if (task==null){
            task = new Task();
        }
        return task;
    }
    @RequestMapping(value = "/getAlterMark/{task_id}")
    @ResponseBody
    public List getAlterMark(@PathVariable Integer task_id) {
        List lastAlterInfo = this.taskAlterExtends.getLastAlterInfo(task_id);
        return lastAlterInfo;
    }
    @RequestMapping(value = "/updateAttachment")
    public void updateAttachment(HttpServletRequest request){
        Map queryMap = getRequestPayload(request);
        if(queryMap!=null&& StringUtils.isNotBlankOrNull(queryMap.get("taskId"))){
            Integer taskId = ((Double)queryMap.get("taskId")).intValue();
            System.out.println(JsonUtil.toJson(queryMap.get("attachmentInfo")));
            taskExtends.updateAttachment(taskId,JsonUtil.toJson(queryMap.get("attachmentInfo")));
        }
    }
    @PostMapping(value = "/confirmAlter")
    public Task confirmAlter(HttpServletRequest request) {

        Map queryMap = getRequestPayload(request);
        Integer taskId = ((Double)queryMap.get("taskId")).intValue();
        String employeeId = String.valueOf(queryMap.get("employeeId"));
        Task task = taskRepository.getTaskInfoById(taskId);
        String confirm_employee = task.getConfirm_employee();
        confirm_employee += ","+employeeId;
        String participants = task.getParticipants();
        String[] parts = participants.split(",");
        String[] empls = confirm_employee.split(",");
        if (parts.length == empls.length){
            task.setTask_condition_code("JXZ");
        }
        task.setConfirm_employee(confirm_employee);
        taskRepository.save(task);
        return task;
    }
    @RequestMapping(value = "/getCurUser", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public TcUser getCurUser(HttpServletRequest request) {
        return userFeignClient.getCurUser(request.getHeader("token"));
    }

    @ApiOperation(value = "任务信息保存", notes = "任务信息保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Task", name = "task", value = "任务信息model", required = true, paramType = "body"),
    })
    @RequestMapping(value = "/saveTask", method = RequestMethod.POST)
    public Map saveTask(@RequestBody Task task, @RequestParam Integer userId, @RequestParam String userName) {
        logger.debug("保存任务信息信息：{}", task);
        Map map = new HashMap();
        ReturnMsg msg = taskService.saveTask(task, userId, userName);
        map.put("task", task);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }
}
