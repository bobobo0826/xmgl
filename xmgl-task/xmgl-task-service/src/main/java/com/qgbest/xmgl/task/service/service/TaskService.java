package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.service.dao.MyTaskExtends;
import com.qgbest.xmgl.task.service.dao.PlanRepository;
import com.qgbest.xmgl.task.service.dao.TaskExtends;
import com.qgbest.xmgl.task.service.dao.TaskRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Service
@Transactional
public class TaskService {
    @Autowired
    private TaskExtends taskExtends;
    @Autowired
    private TaskRepository taskRepository;
    @Autowired
    private PlanRepository planRepository;
    @Autowired
    private MyTaskExtends myTaskExtends;

    @Autowired
    private LogService logService;

    /**
     * 查询任务信息列表
     *
     * @param queryMap 查询条件
     * @param cpage    页码
     * @param len      长度
     * @return pc
     */
    public PageControl getTaskOperateLog(Map queryMap, int cpage, int len, TcUser user) {
        return this.taskExtends.getTaskOperateLog(queryMap, cpage, len, user);
    }
    /*
     * 查询任务信息列表
     *
     * @param queryMap 查询条件
     * @param cpage    页码
     * @param len      长度
     * @return pc
     */

    public PageControl selectTaskByEmployee(Map queryMap, int cpage, int len, Integer employee_id) {
        return this.taskExtends.selectTaskByEmployee(queryMap, cpage, len, employee_id);
    }

    /**
     * 任务信息删除
     *
     * @param id 任务信息ID
     * @return
     */
    public ReturnMsg deleteById(Integer id,Integer userId,String userName) {
        Task task = getTaskInfoById(id);
        logService.addLog(ServiceConstants.delete_operate, id + "", JsonUtil.toJson(task), null, "task_base",userName,userId , "",
                task.getTask_name());
        this.taskRepository.deleteTaskById(id);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }

    /**
     * 计划信息删除
     *
     * @param id 计划信息ID
     * @return
     */
    public ReturnMsg deletePlanById(Integer id,Integer userId,String userName) {
        Plan plan = getPlanInfoById(id);
        logService.addLog(ServiceConstants.delete_operate, id + "", JsonUtil.toJson(plan), null, "plan_base",userName,userId , "",
                plan.getPlan_name());
        this.planRepository.deletePlanById(id);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }

    /**
     * 计划信息删除
     *
     * @param taskId 计划信息ID
     * @return
     */
    public ReturnMsg deletePlanByTaskId(Integer taskId) {
        this.planRepository.deletePlanByTaskId(taskId);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }

/*    public Map setTaskUserId(Integer taskId,Integer userId){
        this.taskRepository.setTaskUserId(taskId,userId);
    }*/

    public Task getTaskInfoById(Integer id) {
        if (id != null && id != -1) {
            return this.taskRepository.getTaskInfoById(id);
        } else {
            return new Task();
        }
    }

    public Plan getPlanInfoById(Integer id) {
        if (id != null && id != -1) {
            return this.planRepository.getPlanInfoById(id);
        } else {
            return new Plan();
        }
    }

    /**
     * 任务信息保存
     *
     * @param task 任务信息
     * @return
     */
    public ReturnMsg saveTask(Task task,Integer userId,String userName) {
        String operate= ServiceConstants.modify_operate;
        Task oldTask=null;
        if(task.getId()==null||task.getId()==-1){
            operate= ServiceConstants.add_operate;
        }else{
            oldTask=getOldTask(task.getId());
        }
        logService.addLog(operate, task.getId() + "", JsonUtil.toJson(oldTask), JsonUtil.toJson(task), "task_base",userName,userId , "",
                task.getTask_name());
        this.taskRepository.save(task);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(task));
    }



    /**
     * 根据计划完成情况获取任务进度，并设置到task的complete里面。
     *
     * @param taskId
     * @return 进度
     */
    public Map getTaskSchedulePercent(Integer taskId,Integer userId,String userName) {
        Map map = this.taskExtends.getTaskSchedulePercent(taskId);
        Task task = getTaskInfoById(taskId);
        String str = String.valueOf(map.get("percent")) + "%";
        task.setComplete(str);
        saveTask(task,userId,userName); //保存进度
        return map;
    }

    /**
     * 重置计划修改标志
     *
     * @param taskId 任务id
     * @return
     */
    public Map resetModifiedFlag(Integer taskId) {
        Map map = this.taskExtends.resetModifiedFlag(taskId);
        return map;
    }


    /**
     * 根据指定审核人id获取待审核的任务列表
     */
    public List getUncheckedTaskList(Integer assigned_checker_id) {
        List list = taskExtends.getUncheckedTaskList(assigned_checker_id);
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                Map map = (Map) list.get(i);
                if (StringUtils.isNotBlankOrNull(map.get("report_cycle"))) {
                    if (map.get("report_cycle").equals("DAY")) {
                        map.put("report_cycle_name", "每天");
                    } else if (map.get("report_cycle").equals("WEEK")) {
                        map.put("report_cycle_name", "每周");
                    }
                }
                if (StringUtils.isNotBlankOrNull(map.get("participants"))) {
                    System.out.println(map.get("participants"));
                    /*List participantList = JsonUtil.fromJsonToList(JsonUtil.toJson(map.get("participants")));
                    map.put("participants", participantList);*/
                }
            }
        }
        return list;
    }
    public String getAverageCompleteByProjectId(Integer project_id){
        return taskExtends.getAverageCompleteByProjectId(project_id);
    }

    public ReturnMsg resetTaskAndPlanCondition(Integer moduleId){
        return taskExtends.resetTaskAndPlanCondition(moduleId);
    }

    public ReturnMsg multiDistribute(String query,Integer userId,String userName){
        Map queryMap=JsonUtil.fromJsonToMap(query);
        String [] taskIdList =((String) queryMap.get("taskIdListStr")).split(",");
        for (int i=1;i<taskIdList.length;i++){
            Task task = getTaskInfoById(Integer.valueOf(taskIdList[i]));//taskIdList[0]是空的。
            task.setTask_condition_code("YXF");
            saveTask(task,userId,userName);
        }
        ReturnMsg returnMsg =new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, null);
    }

    public Task getOldTask(Integer id){
        return taskExtends.getOldTask(id);
    }

}
