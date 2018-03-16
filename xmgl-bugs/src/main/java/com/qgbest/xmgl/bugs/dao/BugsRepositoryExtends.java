package com.qgbest.xmgl.bugs.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/8/29.
 */
@Repository
public class BugsRepositoryExtends {

    @Autowired
    private CommonDao commonDao;

    public PageControl queryBugsList(Map queryMap) {

        Map queryOptions = (Map) queryMap.get("queryOptions");
        System.out.println(queryOptions);
        int cpage = ((Double) queryMap.get("page")).intValue();
        int len = ((Double) queryMap.get("pageSize")).intValue();
        String sql = "SELECT id,create_date,creator,description,status,responsible_person,module,project from bug WHERE 1=1 ";
               /* "AND (status<>'CG' OR creator='" + queryMap.get("user") + "')";*/

        if (StringUtils.isNotBlankOrNull(queryOptions.get("creator"))) {
            sql += " AND creator like '%" + queryOptions.get("creator") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryOptions.get("module"))) {
            sql += " AND module like '%" + queryOptions.get("module") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryOptions.get("project"))) {
            sql += " AND project like '%" + queryOptions.get("project") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryOptions.get("status"))) {
            sql += " AND status ='" + queryOptions.get("status") + "'";
        }

        sql += "ORDER BY POSITION (status in 'CG,DJJ,DHJ,YJJ'), create_date DESC";

        String count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }

    public List getBugsOprInfoById(Integer id) {
        String sql = "SELECT jsonb_array_elements(record)->>'operator' AS operator, " + "jsonb_array_elements(record)->>'operate_time' AS operate_time, " + "jsonb_array_elements(record)->>'remarks' AS remarks," + "jsonb_array_elements(record)->>'status_code' AS status_code " + "FROM bug WHERE id = " + id + " ORDER BY operate_time DESC";
        return commonDao.getSql(sql);
    }

}
