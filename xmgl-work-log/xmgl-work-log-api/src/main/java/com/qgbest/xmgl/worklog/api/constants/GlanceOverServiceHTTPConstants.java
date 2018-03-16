package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by mjq on 2017/7/19.
 */
public interface GlanceOverServiceHTTPConstants {
    /**
     * 保存浏览信息
     */
    public final static String RequestMapping_saveGlanceOverInfo = "/manage/glanceOver/saveGlanceOverInfo";

    /**
     * 根据id查询浏览信息
     *
     * @param id ID
     * @return
     */
    public final static String RequestMapping_getGlanceOverListById = "/manage/glanceOver/getGlanceOverListById";


    /**
     * 更新保存浏览信息
     */
    public final static String RequestMapping_UpdateAndSaveGlanceOver = "/manage/glanceOver/UpdateAndSaveGlanceOver";



}
