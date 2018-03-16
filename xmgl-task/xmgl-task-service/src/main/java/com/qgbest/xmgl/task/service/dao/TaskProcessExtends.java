package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by lfm on 2017/10/25.
 */
@Repository
public class TaskProcessExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl findTaskProcessList(Map queryMap, int cpage, int len, TcUser user) {
        String sql = "";
        sql += "SELECT id,task_name,b.data_name AS task_type_code,sup_module_name,c.data_name AS task_condition_code,sup_project_name,operator,d.data_name AS report_cycle,complete,urgency,importance " +
                "FROM task_process a " +
                "LEFT JOIN (SELECT data_name,data_code  FROM d_common_dic WHERE business_type='task_type') b ON a.task_type_code =b.data_code " +
                "LEFT JOIN (SELECT data_name,data_code  FROM d_common_dic WHERE business_type='task_condition') c ON a.task_condition_code =c.data_code " +
                "LEFT JOIN (SELECT data_name,data_code  FROM d_common_dic WHERE business_type='report_cycle') d ON a.report_cycle =d.data_code " +
                "WHERE 1=1 ";

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name")+"%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_condition_code"))) {
            sql += " AND task_condition_code = '" + queryMap.get("task_condition_code")+"'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("operator"))) {
            sql += " AND operator like '%" + queryMap.get("operator")+"%'";
        }

        sql += " ORDER BY task_name desc";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        System.out.println(pc);
        return pc;
    }
}
