package com.qgbest.xmgl.worklog.api.constants;


public interface LogHTTPConstants {


    /**
     *获得模块类型
     */
    public final  static  String RequestMapping_getModelTypes="/manage/logg/getModelTypesList";

    /**
     * 获得操作类型
     */

    public final  static  String RequestMapping_getOperateTypes="/manage/logg/getOperateTypes/{id}";
    /**
     *
     */
    public final  static  String RequestMapping_getLogList="/manage/logg/getLogList";



    /**
     * 新增日志
     */

    public final  static  String RequestMapping_addLog="/manage/log/addLog";



}
