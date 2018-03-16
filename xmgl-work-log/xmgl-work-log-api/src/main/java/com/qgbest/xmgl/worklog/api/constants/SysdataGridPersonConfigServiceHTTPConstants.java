package com.qgbest.xmgl.worklog.api.constants;

public interface SysdataGridPersonConfigServiceHTTPConstants {
    /**
     *  confval详情查询
     */
    public final static String RequestMapping_getConfVal = "/manage/personSysdata/getConfval/{id}";
    public final static String RequestMapping_getconfvalByIdAndCode = "/manage/personSysdata/getConfvalByIdAndCode/{userId}/{modelCode}";
    public final static String RequestMapping_savePersonGridStyle = "/manage/personSysdata/savePersonGridStyle";
}
