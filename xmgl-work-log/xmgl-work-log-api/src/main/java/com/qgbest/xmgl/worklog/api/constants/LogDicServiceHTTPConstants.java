package com.qgbest.xmgl.worklog.api.constants;

/**
 * Created by ccr on 2017/8/11.
 */
public interface LogDicServiceHTTPConstants {
    /**
     * 查询字典列表
     * */
    public final static String RequestMapping_queryLogDictionaryList = "/manage/dictionary/queryLogDictionaryList";
    /**
     * 获取字典信息
     */
    public final static String RequestMapping_getLogDictionaryInfoById = "/manage/dictionary/getLogDictionaryInfoById/{id}";
    /**
     *删除字典信息
     */
    public final static String RequestMapping_delLogDictionaryInfoById= "/manage/dictionary/delLogDictionaryInfoById/{id}";
    /**
     *启用字典
     */
    public final static String RequestMapping_forbiddenLogDictionaryById= "/manage/dictionary/forbiddenLogDictionaryById/{id}";
    /**
     *禁用字典
     */
    public final static String RequestMapping_startLogDictionaryById= "/manage/dictionary/startLogDictionaryById/{id}";
    /**
     *保存字典信息
     */
    public final static String RequestMapping_saveLogDictionary= "/manage/dictionary/saveLogDictionary";
    /**
     * 获取字典类型列表
     * */
    public final static String RequestMapping_getBusinessTypeList = "/manage/dictionary/getBusinessTypeList";
}
