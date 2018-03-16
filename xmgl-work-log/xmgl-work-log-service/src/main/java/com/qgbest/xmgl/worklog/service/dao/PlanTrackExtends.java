package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by wangchao on 2017/9/28.
 */
@Repository
public class PlanTrackExtends {
    @Autowired
    private CommonDao commonDao;


    public PageControl getPlanLogList(Map queryMap) {
        Map queryOptions = (Map) queryMap.get("queryOptions");
        System.out.println(queryOptions);
        System.out.println("===queryMap===" + queryMap);
        int cpage = ((Double) queryMap.get("page")).intValue();
        int len = ((Double) queryMap.get("pageSize")).intValue();
        String sql = "";
        PageControl pc = new PageControl();
        if (StringUtils.isNotBlankOrNull(queryOptions.get("period"))) {
            sql += "SELECT content_json ->> 'task_name' AS work_log_name,  content_json ->> 'plan_id' as plan_id, content_json ->> 'plan_name' AS plan_name, " +
                    " content_json ->> 'sup_project' AS sup_project, content_json ->> 'sup_module' AS sup_module, " +
                    " content_json ->> 'mission_name' AS sup_task, content_json ->> 'record' AS record, content_json ->> 'complete' AS complete, " +
                    " content_json ->> 'task_start_time' AS task_start_time, content_json ->> 'task_end_time' AS task_end_time, modifier, modify_date ";
            if (queryOptions.get("period").equals("DAY")) {
                sql += " FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier, modify_date FROM log_day) a WHERE 1 = 1";
            } else if (queryOptions.get("period").equals("WEEK")) {
                sql += " FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier, modify_date FROM log_week) a WHERE 1 = 1";

            } else {//queryOptions.get("period").equals("MONTH")的情况
                sql += " FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier AS modifier, modify_date FROM log_month) a WHERE 1 = 1";
            }
            if (StringUtils.isNotBlankOrNull(queryOptions.get("plan_id"))) {
                sql += " AND content_json ->> 'plan_id'  = '" + queryOptions.get("plan_id") + "'";
            }
            if (StringUtils.isNotBlankOrNull(queryOptions.get("plan_name"))) {
                sql += " AND content_json ->> 'plan_name' like '%" + queryOptions.get("plan_name") + "%'";
            }
            if (StringUtils.isNotBlankOrNull(queryOptions.get("sup_task"))) {
                sql += " AND content_json ->> 'mission_name' like '%" + queryOptions.get("sup_task") + "%'";
            }
            sql+=" and content_json ->> 'plan_id' != ''";
            sql += " ORDER BY  sup_project, plan_name, modifier, modify_date, task_start_time, task_end_time";
            String count  = "select count(*) from  (" + sql + ")m ";
            pc = commonDao.getDataBySql(count, sql, cpage, len);
        }
        return pc;
    }

}
