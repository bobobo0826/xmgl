package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by quangao on 2017/7/24.
 */
public interface UpdateLogServiceHTTPConstants {
    /**
     * 获取列表
     */
    public final static String RequestMapping_getUpdateLogList = "/manage/updateLogManage/getUpdateLogList";


    /**
     * 获取用户信息
     */
    public final static String RequestMapping_getUpdateLogInfo = "/manage/updateLogManage/getUpdateLogInfoById/{id}";

    /**
     * 保存
     */
    public final static String RequestMapping_saveUpdateLogInfo = "/manage/updateLogManage/saveUpdateLogInfo";

    /**
     * 删除
     */
    public final static String RequestMapping_delUpdateLogInfo = "/manage/updateLogManage/delUpdateLogInfoById/{id}";


    public final static String RequestMapping_getNewUpdateLogNumbers = "/manage/updateLogManage/getNewUpdateLogNumbers";

    /**
     * 获取更新日志
     */
    public final static String RequestMapping_getLatestUpdateLog="/manage/updateLogManage/getLatestUpdateLog";

    public final static String RequestMapping_publishUpdateLog="/manage/updateLogManage/publishUpdateLogById/{id}";
    public final static String RequestMapping_unPublishUpdateLog="/manage/updateLogManage/unPublishUpdateLogById/{id}";
}

