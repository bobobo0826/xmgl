package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */
public interface MonthLogServiceHTTPConstants {
  String RequestMapping_getMonthLogList = "/manage/monthLog/getMonthLogList";

  String RequestMapping_getMonthLogInfo = "/manage/monthLog/getMonthLogInfo/{id}";

  String RequestMapping_saveMonthLogInfo = "/manage/monthLog/saveMonthLog";

  String RequestMapping_delMonthLogInfo = "/manage/monthLog/delMonthLog/{id}/{userId}/{userName}";

  String RequestMapping_getMonthLogNumber = "/manage/monthLog/getMonthLogNumber";
  /**
   * 获取任务列表详情
   *
   */
  public final static String RequestMapping_getMonthLogContentListById = "/manage/monthLog/getMonthLogContentListById/{id}";

  /**
   *查询month这个月的日志id
   */
  String RequestMapping_getMonthLogIdByMonth = "/manage/monthLog/getMonthLogIdByMonth";

}
