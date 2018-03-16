package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PlanAlterExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl getPlanAlterList(Map queryMap, int cpage, int len, TcUser user){
        String sql = "";

        sql += "SELECT id,plan_id,alter_desc,alter_affect,alter_person,plan_name,alter_time,CAST (alter_content AS varchar) FROM plan_alter WHERE 1=1";

        if (StringUtils.isNotBlankOrNull(queryMap.get("planId"))) {
            sql += " AND plan_id = " + queryMap.get("planId") ;
        }
        else {
            sql += " AND plan_id = -1" ;
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("alter_person"))) {
            sql += " AND alter_person = '" + queryMap.get("alter_person")+"'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("alter_starttime")) && StringUtils.isNotBlankOrNull(queryMap.get("alter_endtime"))) {
            sql += " AND to_date(alter_time,'yyyy-MM-dd') >= '" + queryMap.get("alter_starttime")+"'";
            sql += " AND to_date(alter_time,'yyyy-MM-dd') <= '" + queryMap.get("alter_endtime")+"'";
        }

        sql += " ORDER BY alter_time desc";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }
    public List getLastAlterInfo(Integer plan_id){
        String sql = "SELECT jsonb_array_elements(alter_content)->>'field_name' AS field_name FROM " +
                " (SELECT alter_content FROM plan_alter WHERE plan_id = "+plan_id+
                " ORDER By alter_time DESC LIMIT 1 )m";
        List alterList =commonDao.getSql(sql);
        return alterList;
    }
}
