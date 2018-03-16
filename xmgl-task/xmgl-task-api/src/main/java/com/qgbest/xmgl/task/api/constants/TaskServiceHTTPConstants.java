package com.qgbest.xmgl.task.api.constants;

/**
 * Created by wjy on 2017/7/18.
 */
public interface TaskServiceHTTPConstants {
    /**
     * 获取任务列表
     */
	 
    public final static String RequestMapping_listTask = "/manage/task/getTaskList";
    public final static String RequestMapping_getTaskOperateLog = "/manage/task/getTaskOperateLog";

    /**
     * 获取任务列表
     */
    public final static String RequestMapping_selectTaskByEmployee = "/manage/task/selectTaskByEmployee";
    /**
     * 获取计划列表
     */
    public final static String RequestMapping_listPlan = "/manage/task/getPlanList";
    /**
     * 获取任务详情
     */
    public final static String RequestMapping_getTaskInfoById = "/getTaskInfoById/{id}";
    /**
     * 获取任务详情
     */
    public final static String RequestMapping_getPlanInfoById = "/manage/task/getPlanInfoById/{id}";

    /**
     * 保存任务
     */
    public final static String RequestMapping_saveTask = "/saveTask";
    /**
     * 保存计划列表
     */

    public final static String RequestMapping_savePlanList = "/manage/task/savePlanList";

    /**
     * 重置计划修改标志
     */
    public final static String RequestMapping_resetModifiedFlag = "/manage/task/resetModifiedFlag";
    /**
     * 保存计划
     */
    public final static String RequestMapping_savePlan = "/manage/task/savePlan";
    /**
     * 删除任务
     */
    public final static String RequestMapping_delTask = "/manage/task/delTask/{id}";

    /**
     * 删除计划
     */
    public final static String RequestMapping_delPlan = "/manage/task/delPlan/{id}";
    /**
     * 删除计划
     */
   public final static String RequestMapping_deletePlanByTaskId = "/manage/task/deletePlanByTaskId/{taskId}";

    /**
     * 根据TaskId获取其对应得未完成任务数量
     */
    String RequestMapping_getPlanIncompleteCountByTaskId = "/manage/task/getPlanIncompleteCountByTaskId/{task_id}";


    String RequestMapping_getTaskSchedulePercent = "/manage/task/getTaskSchedulePercent";

    /**
     * 领导审核后保存操作
     */
    String RequestMapping_saveAfterCheck = "/manage/task/saveAfterCheck";
    /**
     * 根据指定审核人id获取未审核的任务
     */
    String RequestMapping_getUncheckedTaskList = "/manage/task/getUncheckedTaskList/{assigned_checker_id}";


    String RequestMapping_multiSubmit = "/manage/task/multiSubmit";

    String RequestMapping_saveMultiCheckDesc = "/manage/task/saveMultiCheckDesc";

    String RequestMapping_multiDistribute = "/manage/task/multiDistribute";


    String RequestMapping_getAverageCompleteByProjectId = "/manage/task/getAverageCompleteByProjectId";


    String RequestMapping_resetTaskAndPlanCondition = "/manage/task/resetTaskAndPlanCondition";

    String RequestMapping_updateTaskModuleName = "/manage/task/updateTaskModuleName";


    String RequestMapping_resetPlanCondition = "/manage/task/resetPlanCondition";








}
