package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by quangao on 2017/7/4.
 */
public interface DayLogServiceHTTPConstants {
    /**
     * 获取日志列表
     */
    public final static String RequestMapping_listDayLog = "/manage/dayLog/getDayLogList";
    public final static String RequestMapping_getWorkOperateLog = "/manage/dayLog/getWorkOperateLog";

    /**
     * 获取日志详情
     */
    public final static String RequestMapping_getDayLogInfoById = "/manage/dayLog/getDayLogInfoById/{id}";

    /**
     * 获取任务列表详情
     *
     */
    public final static String RequestMapping_getDayLogContentListById = "/manage/dayLog/getDayLogContentListById/{id}";
    /**
     * 保存日志
     */
    public final static String RequestMapping_saveDayLog = "/manage/dayLog/saveDayLog";
    /**
     * 删除日志
     */
    public final static String RequestMapping_delDayLog = "/manage/dayLog/delDayLog/{id}/{userId}/{userName}";

    public final static String RequestMapping_getNewDayLogNumbers = "/manage/dayLog/getNewDayLogNumbers";

    String RequestMapping_checkWorkLogRepeat = "/manage/dayLog/checkWorkLogRepeat";


}
