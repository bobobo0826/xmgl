package com.qgbest.xmgl.employee.api.constants;

/**
 * Created by ccr on 2017/7/31.
 */
public interface DictionaryServiceHTTPConstants {

    /**
     * 获取字典类型列表
     * */
    public final static String RequestMapping_getBusinessTypeList = "/manage/dictionaryEmp/getBusinessTypeList";

    /**
     * 查询字典列表
     * */
    public final static String RequestMapping_queryDictionaryList = "/manage/dictionaryEmp/queryDictionaryList";
    /**
     * 获取字典信息
     */
    public final static String RequestMapping_getDictionaryInfoById = "/manage/dictionaryEmp/getDictionaryInfoById/{id}";
    /**
     *删除字典信息
     */
    public final static String RequestMapping_delDictionaryInfoById= "/manage/dictionaryEmp/delDictionaryInfoById/{id}";
    /**
     *启用字典
     */
    public final static String RequestMapping_forbiddenDictionaryById= "/manage/dictionaryEmp/forbiddenDictionaryById/{id}";
    /**
     *禁用字典
     */
    public final static String RequestMapping_startDictionaryById= "/manage/dictionaryEmp/startDictionaryById/{id}";
    /**
     *保存字典信息
     */
    public final static String RequestMapping_saveDictionary= "/manage/dictionaryEmp/saveDictionary";

}
