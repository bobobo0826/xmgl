package com.qgbest.xmgl.worklog.service.dao;


import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Repository
public class SysdataGridDefaultExtends {
    @Autowired
    private CommonDao commonDao;
    public PageControl getSysdataGridDefaultConfig(Map queryMap, int cpage, int len) {
        String sql = "";
        sql += "SELECT id as id, module_code as module_code,conf_val as conf_val,create_date as create_date from sysdata_grid_default_config  where 1=1 ";
        if (StringUtils.isNotBlankOrNull(queryMap.get("module_code"))) {
            sql += " and module_code like '%" + queryMap.get("module_code") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("create_date"))) {
            sql += " and create_date like '%" + queryMap.get("create_date") + "%'";
        }
        sql += " ORDER BY id";
        String count = "select count(*) from  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }

}
