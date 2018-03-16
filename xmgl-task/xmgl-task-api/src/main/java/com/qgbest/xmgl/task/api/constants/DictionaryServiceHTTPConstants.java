package com.qgbest.xmgl.task.api.constants;
/**
 * Created by ccr on 2017/7/31.
 */
public interface DictionaryServiceHTTPConstants {

    /**
     * 获取字典类型列表
     * */
    public final static String RequestMapping_getBusinessTypeList = "/manage/dictionaryTask/getBusinessTypeList";

    /**
     * 查询字典列表
     * */
    public final static String RequestMapping_queryDictionaryList = "/manage/dictionaryTask/queryDictionaryList";
    /**
     * 获取字典信息
     */
    public final static String RequestMapping_getDictionaryInfoById = "/manage/dictionaryTask/getDictionaryInfoById/{id}";
    /**
     *删除字典信息
     */
    public final static String RequestMapping_delDictionaryInfoById= "/manage/dictionaryTask/delDictionaryInfoById/{id}";
    /**
     *启用字典
     */
    public final static String RequestMapping_forbiddenDictionaryById= "/manage/dictionaryTask/forbiddenDictionaryById/{id}";
    /**
     *禁用字典
     */
    public final static String RequestMapping_startDictionaryById= "/manage/dictionaryTask/startDictionaryById/{id}";
    /**
     *保存字典信息
     */
    public final static String RequestMapping_saveDictionary= "/manage/dictionaryTask/saveDictionary";

}
