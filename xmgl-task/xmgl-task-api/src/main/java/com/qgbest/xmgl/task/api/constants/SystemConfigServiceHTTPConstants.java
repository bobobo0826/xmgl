package com.qgbest.xmgl.task.api.constants;

public interface SystemConfigServiceHTTPConstants {
    /**
        * 操作system_conf表信息
    */
    public final static String Variable_SystemId = "id";
    /**
     *  详情查询
     */
    public final static String RequestMapping_getSystem = "/manage/systemConf/getSystem/{id}";

    public final static String RequestMapping_getSyetemConf = "/manage/systemConf/getSystemConf";
    /**
     * 通过code查询value
     */
    public final static String RequestMapping_getSyetemConfDataValue = "/manage/systemConf/getDataValueByCode/{dataCode}";
    /**
     * 删除
     */
    public final static String RequestMapping_delSystem = "/manage/systemConf/delSystemById";
    /**
     * 保存
     */
    public final static String RequestMapping_saveSystem= "/manage/systemConf/saveSystem";

}
