package com.qgbest.xmgl.task.api.constants;

/**
 * Created by fcy on 2017/8/8.
 */
public interface StandardsServiceHTTPConstants {
    /**
     * 获取列表
     */
    public final static String RequestMapping_getStandardsList = "/manage/writingStandards/getStandardsList";
    public final static String RequestMapping_getStandardsShowList = "/manage/writingStandards/getStandardsShowList";
    /**
     * 获取信息
     */
    public final static String RequestMapping_getStandardsInfo = "/manage/writingStandards/getStandardsInfo/{id}";
    /**
     * 保存
     */
    public final static String RequestMapping_saveStandardsInfo = "/manage/writingStandards/saveStandardsInfo";

    public final static String RequestMapping_delStandardsInfo = "/manage/writingStandards/delStandardsInfo/{id}";
    public final static String RequestMapping_publishStandards="/manage/writingStandards/publishStandardsById/{id}";
    public final static String RequestMapping_unPublishStandards="/manage/writingStandards/unPublishStandardsById/{id}";
    /**
     * 获取规范页面
     */
    public final static String RequestMapping_getStandardsPage="/manage/writingStandards/getStandardsPage";
}
