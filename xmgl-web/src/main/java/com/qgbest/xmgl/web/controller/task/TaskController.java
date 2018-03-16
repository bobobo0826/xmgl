package com.qgbest.xmgl.web.controller.task;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.file.client.FileBaseClient;
import com.qgbest.xmgl.plan.client.PlanFeignClient;
import com.qgbest.xmgl.project.client.ProjectFeignClient;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.client.*;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Controller
@RequestMapping(value="/manage/task")
public class TaskController extends BaseController {
    @Autowired
    private TaskFeignClient taskClient;
    @Autowired
    private ProjectFeignClient projectClient;
    @Autowired
    private TaskSysdataGridPersonConfigFeginClient taskSysdataGridPersonConfigFeginClient;
    @Autowired
    private TaskSysdataGridDefaultConfigFeginClient taskSysdataGridDefaultConfigFeginClient;
    @Autowired
    private TaskSystemConfigFeignClient taskSystemConfigFeignClient;
    @Autowired
    private TaskDictionaryFeignClient taskDictionaryFeignClient;
    @Autowired
    private FileBaseClient fileClient;
    @Autowired
    private PlanFeignClient planFeignClient;

    @Autowired
    private EmployeeFeignClient employeeClient;
    /**
     * 初始化员工信息列表
     * @return
     */
    @RequestMapping(value = "/taskIndex")
    public ModelAndView initTaskList() {
        Map model= getRequestMapStr2Str(httpServletRequest);
        model.put("user_id",getCurUser().getId());
        return new ModelAndView( "/taskManager/task/taskList",model);
    }

    @RequestMapping(value = "/queryTaskList")
    @ResponseBody
    public Map queryTaskList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return taskClient.getTaskList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }



    @RequestMapping(value = "/selectTaskByEmployee")
    @ResponseBody

    public Map selectTaskByEmployee(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        Employee employee = employeeClient.getEmployeeInfoByUserId(getCurUser().getId());
        Integer employee_id;
        if (employee!=null){
            employee_id = employeeClient.getEmployeeInfoByUserId(getCurUser().getId()).getId();
        }else{
            employee_id = 0;
        }
        return taskClient.selectTaskByEmployee(JsonUtil.toJson(queryMap), len, cpage, employee_id);
    }

    @RequestMapping(value = "/queryPlanList")
    @ResponseBody
    public List queryPlanList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return taskClient.getPlanList(JsonUtil.toJson(queryMap));
    }



    @RequestMapping(value = "/initTaskInfo")
    public ModelAndView initTaskInfo() {
        Map model= getRequestMapStr2Str(httpServletRequest);
        Integer user_id = getCurUser().getId();
        model.put("user_id",user_id);
        model.put("imageUrl",this.imageUrl);
        return new ModelAndView("/taskManager/task/taskInfo",model);
    }

    @RequestMapping(value = "/getTaskInfoById/{id}")
    @ResponseBody
    public Task getTaskInfoById(@PathVariable Integer id) {
        Task task = new Task();
        task = taskClient.getTaskInfoById(id);
        if (id==-1){
            task.setCreate_time(DateUtils.getCurDateTime2Minute());
            task.setCreator(getCurUser().getDisplayName());
            task.setCreator_id(getCurUser().getId());
            task.setTask_condition_code("CG");
            task.setTask_type_code("XMRW");
        }
        return task;
    }

    @RequestMapping(value = "/getPlanInfoById/{id}")
    @ResponseBody
    public Plan getPlanInfoById(@PathVariable Integer id) {
        Plan plan = new Plan();
        plan = taskClient.getPlanInfoById(id);
        if (id==-1){
            plan.setCreate_time(DateUtils.getCurDateTime2Minute());
        }
        return plan;
    }

    @RequestMapping(value = "/delTask/{id}")
    @ResponseBody
    public ReturnMsg delTask(@PathVariable Integer id) {
        deletePlanByTaskId(id);//删除下属计划
        return taskClient.delTask(id,getCurUser().getId(),getCurUser().getDisplayName());
    }

    @RequestMapping(value = "/delPlan/{id}")
    @ResponseBody
    public ReturnMsg delPlan(@PathVariable Integer id) {
        return taskClient.delPlan(id,getCurUser().getId(),getCurUser().getDisplayName());
    }

    @RequestMapping(value = "/deletePlanByTaskId/{taskId}")
    @ResponseBody
    public ReturnMsg deletePlanByTaskId(@PathVariable Integer taskId) {
        return taskClient.deletePlanByTaskId(taskId);
    }

    @RequestMapping(value = "/saveTaskAndPlan")
    @ResponseBody
    public Map saveTaskAndPlan() {
        Task task = JsonUtil.fromJson(httpServletRequest.getParameter("task"), Task.class);
        String oprCode = String.valueOf(httpServletRequest.getParameter("oprCode"));
        Map map = new HashMap();
        if (task != null) {
            if (oprCode.equals("SAVE") || oprCode.equals("SUBMIT")) {
                if (task.getId() != null) {
                    task.setModify_time(DateUtils.getCurDateTime2Minute());
                    task.setModifier(getCurUser().getDisplayName());
                    task.setModifier_id(getCurUser().getId());
                }
            } else if (oprCode.equals("TG") || oprCode.equals("BTG")) {

            }
            map = taskClient.saveTask(task,getCurUser().getId(),getCurUser().getDisplayName());
            task = JsonUtil.fromJson(JsonUtil.toJson(map.get("task")),Task.class);
            if (task!=null) {
            Integer taskId = task.getId();
            if(oprCode.equals("XFRW") || oprCode.equals("ZJXF"))
            {
                if (!task.getTask_type_code().equals("LSRW")) {
                    Integer projectId = task.getSup_project_id();
                    if (projectId != null) {
                        String projectComplete = taskClient.getAverageCompleteByProjectId(projectId);
                        projectClient.updateCompleteStatus(projectId, projectComplete);
                    }
                }
            }
                if (httpServletRequest.getParameter("planList") != null) {
                    String planListStr = httpServletRequest.getParameter("planList");
                    List planList = JsonUtil.fromJsonToList(planListStr);
                    for (int i=0;i<planList.size();i++){
                        Plan plan=(Plan) JsonUtil.fromJson(JsonUtil.toJson(planList.get(i)),Plan.class);
                        plan.setTask_id(taskId);
                        plan.setComplete_type("WKS");
                        taskClient.savePlan(plan,getCurUser().getId(),getCurUser().getDisplayName());
                    }
                }
            }
        }
        return map;
    }

    @RequestMapping(value = "/savePlan")
    @ResponseBody
    public Map savePlan(){
        Plan plan=JsonUtil.fromJson(httpServletRequest.getParameter("plan"),Plan.class);
        return taskClient.savePlan(plan,getCurUser().getId(),getCurUser().getDisplayName());
    }

    @RequestMapping(value = "/getGridStyle")
    @ResponseBody
    public Map getGridStyle() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map map =new HashMap();
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        SysdataGridPersonConfig personConfig= taskSysdataGridPersonConfigFeginClient.getConfvalByIdAndCode(getCurUser().getId(), curModuleCode);
        List defaultConfig = taskSysdataGridDefaultConfigFeginClient.getConfVal(curModuleCode);
        if (null != personConfig) {
            map.put("gridStyle", personConfig.getConf_val());
        } else {

            map.put("gridStyle",defaultConfig.get(0));
        }
        return map;
    }

    /**
     * datagrid样式保存
     * @return
     */
    @RequestMapping(value = "/saveGridStyle")
    @ResponseBody
    public ReturnMsg saveGridStyle() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        String gridStyle=String.valueOf(queryMap.get("_gridStyle"));
        ReturnMsg returnMsg= taskSysdataGridPersonConfigFeginClient.savePersonGridStyle(gridStyle, curModuleCode,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

    @RequestMapping(value = "/showGridColumn")
    public ModelAndView showGridColumn()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String columnFiled=String.valueOf(queryMap.get("_columnFiled"));
        String columnTitle=String.valueOf(queryMap.get("_columnTitle"));
        String columnsHidden=String.valueOf(queryMap.get("_columnsHidden"));
        Map model =new HashMap();
        model.put("_columnFiled",columnFiled);
        model.put("_columnTitle",columnTitle);
        model.put("_columnsHidden",columnsHidden);
        return new ModelAndView("/sysdataGridDefaultConfig/showDataGridColumn",model);
    }


    @RequestMapping(value = "/getTaskDic")
    @ResponseBody
    public Map getTaskDic(){
        Map model =new HashMap();
        List taskTypeList= taskDictionaryFeignClient.getDicListByBusinessCode("task_type");
        model.put("taskTypeList", taskTypeList);
        List taskConditionList= taskDictionaryFeignClient.getDicListByBusinessCode("task_condition");
        model.put("taskConditionList", taskConditionList);
        List taskProjTypeList= taskDictionaryFeignClient.getDicListByBusinessCode("task_proj_type");
        model.put("taskProjTypeList", taskProjTypeList);
        List reportCycleList= taskDictionaryFeignClient.getDicListByBusinessCode("report_cycle");
        model.put("reportCycleList", reportCycleList);
        return model;
    }

    @RequestMapping(value = "/initPlanInfo")
    public ModelAndView initTaskPlanInfo(){
        Map model= getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/taskManager/task/planInfo",model);
    }

    /**
     * 跳转选择任务界面
     * @return
     */
    @RequestMapping(value = "/selectTask")
    public ModelAndView selectTask(){
        Map model= getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode","XZRW");
        return new ModelAndView("/taskManager/task/selectTask",model);
    }

    /**
     * 根据计划表计算任务进度并存入任务表
     * @return
     */
    @RequestMapping(value = "/getTaskSchedulePercent")
    @ResponseBody
    public Map getTaskSchedulePercent(){
        Integer taskId = Integer.valueOf(httpServletRequest.getParameter("taskId"));
        Map map=planFeignClient.getPlanPercent(taskId);
        String str = String.valueOf(map.get("percent"));
        Task task = taskClient.getTaskInfoById(taskId);
        task.setComplete(str);
        return taskClient.saveTask(task,getCurUser().getId(),getCurUser().getDisplayName());
    }

    /**
     * 领导审核保存
     */
    @RequestMapping(value="/saveAfterCheck")
    @ResponseBody
    public Map saveAfterCheck(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        return taskClient.saveAfterCheck(JsonUtil.toJson(queryMap),getCurUser());
    }

    @RequestMapping(value="/selectEmployee")
    public ModelAndView selectEmployee(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/taskManager/task/selectEmployee",queryMap );
    }

    @RequestMapping(value="/getParticipantsIdList")
    @ResponseBody
    public Map getParticipantsIdList(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map = new HashMap();
        Integer projectId;
        if (StringUtils.isNotBlankOrNull(queryMap.get("projectId"))) {
            projectId = Integer.valueOf(String.valueOf(queryMap.get("projectId")));
        }
        else{
            projectId = -1;
        }
        List idList = projectClient.getEmployeeIdListByPid(projectId);
        map.put("idList",idList);
        map.put("success",true);
        return map;
    }
    @RequestMapping(value="/getUncheckedTaskList")
    @ResponseBody
    public List getUncheckedTaskList(){
        List list = new ArrayList();
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        if(StringUtils.isNotBlankOrNull(queryMap.get("assigned_checker_id"))){
             Integer assigned_checker_id = Integer.valueOf(String.valueOf(queryMap.get("assigned_checker_id")));
             list = taskClient.getUncheckedTaskList(assigned_checker_id);
        }
        return list;
    }

    /**
     * 批量提交
     * @return
     */
    @RequestMapping(value="/multiSubmit")
    @ResponseBody
    public ReturnMsg multiSubmit(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        String query = JsonUtil.toJson(queryMap);
        return taskClient.multiSubmit(query,getCurUser().getId(),getCurUser().getDisplayName());
    }

    @RequestMapping(value="/multiCheck")
    public ModelAndView multiCheck(){
        Map model = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/taskManager/task/multiCheck",model);
    }
    /**
     *
     */

    @RequestMapping(value ="/saveMultiCheckDesc")
    @ResponseBody
    public ReturnMsg saveMultiCheckDesc(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        String query = JsonUtil.toJson(queryMap);
        return taskClient.saveMultiCheckDesc(query,getCurUser());
    }

    @RequestMapping(value ="/multiDistribute")
    @ResponseBody
    public ReturnMsg multiDistribute(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        String query = JsonUtil.toJson(queryMap);
        return taskClient.multiDistribute(query,getCurUser().getId(),getCurUser().getDisplayName());
    }
    @RequestMapping(value = "/uploadResultFile")
    public String uploadResultFile(@RequestParam("id") Integer id, @RequestParam("_module") String _module, ModelMap modelMap){
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("_module",_module);
        return "taskManager/task/uploadResultFile";
    }

    @RequestMapping(value ="/delResultFile/{id}")
    @ResponseBody
    public ReturnMsg delResultFile(@PathVariable Integer id){
        fileClient.delFileInfo(id);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, null);
    }
}
