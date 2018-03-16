package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by mjq on 2017/7/4.
 */
public interface WeekLogServiceHTTPConstants {
    /**
     * 获取列表
     */
    public final static String RequestMapping_getWeekLogList = "/manage/weekLog/getWeekLogList";

    /**
     * 获取用户信息
     */
    public final static String RequestMapping_getWeekLogInfo = "/manage/weekLog/getWeekLogInfo/{id}";

    /**
     * 保存
     */
    public final static String RequestMapping_saveWeekLogInfo = "/manage/weekLog/saveWeekLogInfo";

    /**
     * 删除
     */
    public final static String RequestMapping_delWeekLogInfo = "/manage/weekLog/delWeekLogInfo/{id}";


    /**
     * 获得新增周任务数量
     */
    public final static String RequestMapping_getNewWeekLogNumbers = "/manage/weekLog/getNewWeekLogNumbers";

    /**
     * 获取任务列表详情
     *
     */
    public final static String RequestMapping_getWeekLogContentListById = "/manage/weekLog/getWeekLogContentListById/{id}";

    /**
     *查询monday_date为起始日期的周日志id
     */
    String RequestMapping_getWeekLogIdByTaskStartDate = "/manage/weekLog/getWeekLogIdByTaskStartDate";

}
