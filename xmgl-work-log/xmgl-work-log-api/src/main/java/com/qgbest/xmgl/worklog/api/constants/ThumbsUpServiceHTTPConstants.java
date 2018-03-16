package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by mjq on 2017/7/18.
 */
public interface ThumbsUpServiceHTTPConstants {
    /**
     * 保存点赞信息
     */
    public final static String RequestMapping_saveThumbsUpInfo = "/manage/thumbsUp/saveThumbsUpInfo";
    /**
     * 删除点赞信息
     *
     * @param id ID
     * @return
     */
    public final static String RequestMapping_delThumbsUpInfo = "/manage/thumbsUp/delThumbsUpInfo";

    /**
     * 根据id查询点赞信息
     *
     * @param id ID
     * @return
     */
    public final static String RequestMapping_getThumbsUpListById = "/manage/thumbsUp/getThumbsUpListById";




}
