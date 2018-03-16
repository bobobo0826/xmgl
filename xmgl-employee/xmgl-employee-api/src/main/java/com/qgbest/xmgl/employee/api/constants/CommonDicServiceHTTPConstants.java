package com.qgbest.xmgl.employee.api.constants;

/**
 * Created by qianmeng on 2017/05/07.
 */
public interface CommonDicServiceHTTPConstants {
    /**
     * 变量名称简称
     */
    public final static String Variable_DicId = "cid";
    /**
     * 获取业务类型列表
     */
    public final static String RequestMapping_getBusinessTypeList= "/manage/dic/getBusinessTypeList";
    /**
     * 根据业务类型编码获取字典列表
     */
    public final static String RequestMapping_getDicListByBusinessCode= "/manage/dic/getDicListByBusinessCode/{businessCode}";
    /**
     * 根据id获取字典信息
     */
    public final static String RequestMapping_getDicById= "/manage/dic/getDicById/{cid}";
    /**
     * 获取字典列表
     */
    public final static String RequestMapping_listDic= "/manage/dic/getDicList";
    /**
     * 删除字典信息
     */
    public final static String RequestMapping_delDic = "/manage/dic/delDic";
    /**
     * 保存字典信息
     */
    public final static String RequestMapping_save = "/manage/dic/save";
    /**
     * 根据code获取name
     */
    public final static String RequestMapping_getDataNameByDataCode = "/manage/dic/getDataNameByDataCode/{businessCode}/{dataCode}";
}
