package com.qgbest.xmgl.employee.api.constants;

public interface SysDatagridDefaultConfigServiceHTTPConstants {
    /**
     * 操作system_conf表信息
     */
    public final static String Variable_SystemId = "id";
    /**
     * 获取SysdataGridDefaultConfig表格信息
     */
    public final static String RequestMapping_SysdataGridDefaultConfig="/manage/Sysdata/getSysdataGridDefaultConfig";
    /**
     *  详情查询
     */
    public final static String RequestMapping_getSysdata = "/manage/Sysdata/getSysdata/{id}";
    /**
     * 删除
     */
    public final static String RequestMapping_delSysdataById = "/manage/Sysdata/delSysdataById";
    /**
     * 保存
     */
    public final static String RequestMapping_saveSysdata= "/manage/Sysdata/saveSysdata";
    /**
     * 通过code查询value
     */
    public final static String RequestMapping_getSysdataDefaultConfVal = "/manage/Sysdata/getConfVal/{modelCode}";
}
