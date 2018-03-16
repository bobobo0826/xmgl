package com.qgbest.xmgl.task.service.dao;


import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Repository
public class SystemConfigRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl getSystemConf(Map queryMap, int cpage, int len) {
        String sql = "";
        sql += "SELECT id as id, data_code as data_code,data_value as data_value,data_desc as data_desc,is_used as is_used from system_config  where 1=1 ";
        if (StringUtils.isNotBlankOrNull(queryMap.get("data_code"))) {
            sql += " and data_code like '%" + queryMap.get("data_code") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("data_value"))) {
            sql += " and data_value like '%" + queryMap.get("data_value") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("is_used"))) {
            sql += " and is_used = '" + queryMap.get("is_used") + "'";
        }
        sql += " ORDER BY id";
        String count = "select count(*) from  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }



   public List getDataValueByCode(String dataCode){
        String sql="select data_value from system_config where data_code='"+dataCode+"' ";
        List<Map> a =  (List<Map>)commonDao.queryListEntity(sql, null, null);
        List map = (List) a.get(0);
        return map;
    }


}
