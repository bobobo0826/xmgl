package com.qgbest.xmgl.plan.api.constants;

/**
 * Created by quangao on 2017/10/31.
 */
public interface PlanServiceHTTPConstants {
    /**
     * 选择计划列表
     */
    public final static String RequestMapping_getPlanQueryList = "/manage/selectPlan/getPlanQueryList";
    /**
     * 根据ID获取计划
     */
    public final static String RequestMapping_getPlanInfoById = "/manage/selectPlan/getPlanInfoById/{id}";

    /**
     * 保存计划
     */
    public final static String RequestMapping_savePlan = "/manage/selectPlan/savePlan";

    /**
     * 计算计划完成情况
     */
    String RequestMapping_getPlanPercent = "/manage/selectPlan/getPlanPercent";


}
