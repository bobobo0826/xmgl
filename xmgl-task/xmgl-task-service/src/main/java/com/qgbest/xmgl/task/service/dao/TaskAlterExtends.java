package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wjy3
 * Date:2017/10/18
 * Time:14:40
 * description:xmgl-serve
 */
@Repository
public class TaskAlterExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl getTaskAlterList(Map queryMap, int cpage, int len, TcUser user){
        String sql = "";

        sql += "SELECT id,task_id,alter_desc,alter_affect,alter_person,task_name,alter_time,CAST (alter_content AS varchar) FROM task_alter WHERE 1=1";

        if (StringUtils.isNotBlankOrNull(queryMap.get("taskId"))) {
            sql += " AND task_id = " + queryMap.get("taskId") ;
        }
        else {
            sql += " AND task_id = -1" ;
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

    public List getLastAlterInfo(Integer task_id){
        String sql = "SELECT jsonb_array_elements(alter_content)->>'field_name' AS field_name FROM " +
                " (SELECT alter_content FROM task_alter WHERE task_id = "+task_id+
                " ORDER By alter_time DESC LIMIT 1 )m";
        List alterList =commonDao.getSql(sql);
        return alterList;
    }
}
