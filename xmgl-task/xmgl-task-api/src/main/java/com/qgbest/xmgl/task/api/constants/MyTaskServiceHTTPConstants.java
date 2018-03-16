package com.qgbest.xmgl.task.api.constants;

/**
 * Created by mjq on 2017/7/26.
 */
public interface MyTaskServiceHTTPConstants {
    /**
     * 获取我的任务列表
     */
    public final static String RequestMapping_getMyTaskQueryList = "/manage/myTask/getMyTaskQueryList";


    /**
     * 根据ID获取计划
     */
    public final static String RequestMapping_getMyTaskInfoById = "/manage/myTask/getMyTaskInfoById/{id}";
    /**
     * 根据id获取参与人员信息
     *
     * @param id ID
     * @return
     */
    public final static String RequestMapping_getParticipantsListById = "/manage/myTask/getParticipantsListById/{id}";

    public final static String RequestMapping_getUnCompletePlan = "/manage/myTask/getUnCompletePlan";


}
