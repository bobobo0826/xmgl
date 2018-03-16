package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by mjq on 2017/7/26.
 */
@Repository
public class MyTaskExtends {
    @Autowired
    private CommonDao commonDao;
    /**
     * 我的任务计划列表查询
     *
     * @param queryMap
     * @param cpage
     * @param len
     * @return
     */
    public PageControl getMyTaskQueryList(Map queryMap, int cpage, int len, TcUser user,String taskType,String contractor) {
        String count = "";
        String sql="";
        if (StringUtils.isNotBlankOrNull(queryMap.get("_curModuleCode"))) {
            if (queryMap.get("_curModuleCode").equals("MY_RWGL")) {
                sql="" ;
            } else if (queryMap.get("_curModuleCode").equals("XZMYJH")) {
                sql="select ID,task_id,plan_name,plan_desc,plan_start_time,plan_end_time,plan_result_condition_code," +
                        "plan_result_summary,creator,contractor,plan_condition_code,modify_time,task_name," +
                        "actual_plan_start_time,actual_plan_end_time,create_time,task_type_code,sup_project_name," +
                        "sup_module_name,b.data_name as task_type from plan_base a " +
                        "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'task_type') b ON a .task_type_code = b.data_code " +
                        "where plan_condition_code in ('DZX','JXZ') and task_type_code='"+taskType+"' and contractor='"+contractor+"'";

            }
        }


        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_name"))) {
            String plan_name =((String) queryMap.get("plan_name"));
            sql += " and plan_name like '%" + StringUtils.filterBadCharsForAntiSqlInject(plan_name) + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_start_time"))) {
            String [] order_date =((String) queryMap.get("plan_start_time")).split("~");
            sql += " and to_date(plan_start_time,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(plan_start_time,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_end_time"))) {
            String [] order_date =((String) queryMap.get("plan_end_time")).split("~");
            sql += " and to_date(plan_end_time,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(plan_end_time,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_desc"))) {
            String plan_desc =((String) queryMap.get("plan_desc"));
            sql += " and plan_desc like '%" + StringUtils.filterBadCharsForAntiSqlInject(plan_desc) + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("sup_project_name"))) {
            String sup_project_name =((String) queryMap.get("sup_project_name"));
            sql += " and sup_project_name like '%" + StringUtils.filterBadCharsForAntiSqlInject(sup_project_name) + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("sup_module_name"))) {
            String sup_module_name =((String) queryMap.get("sup_module_name"));
            sql += " and sup_module_name like '%" + StringUtils.filterBadCharsForAntiSqlInject(sup_module_name) + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            String task_name =((String) queryMap.get("task_name"));
            sql += " and task_name like '%" + StringUtils.filterBadCharsForAntiSqlInject(task_name) + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_type"))) {
            sql += " and task_type_code = '" + StringUtils.filterBadCharsForAntiSqlInject(queryMap.get("task_type")) + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("actual_plan_start_time"))) {
            String [] order_date =((String) queryMap.get("actual_plan_start_time")).split("~");
            sql += " and to_date(actual_plan_start_time,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(actual_plan_start_time,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("actual_plan_end_time"))) {
            String [] order_date =((String) queryMap.get("actual_plan_end_time")).split("~");
            sql += " and to_date(actual_plan_end_time,'yyyy_MM_dd') >= '"
                   + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(actual_plan_end_time,'yyyy_MM_dd') <= '"
                   + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_type"))) {
            sql += " AND task_type_code = '" + queryMap.get("task_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_name"))) {
            sql += " AND plan_name like '%" + queryMap.get("plan_name") + "%'";
        }



       /* if(StringUtils.isNotBlankOrNull(queryMap.get("query_work_date_begin"))){
            sql+=" and to_date(start_date,'yyyy-MM-dd') >= to_date('"+queryMap.get("query_work_date_begin")+"','yyyy-MM-dd')";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("query_work_date_end"))){
            sql+=" and to_date(end_date,'yyyy-MM-dd') <= to_date('"+queryMap.get("query_work_date_end")+"','yyyy-MM-dd')";
        }*/

        String sortCondition = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
            sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("_curModuleCode"))) {
            if (queryMap.get("_curModuleCode").equals("MY_RWGL")) {
                sql += " ORDER BY "+sortCondition+" modify_time asc";
            } else if (queryMap.get("_curModuleCode").equals("XZMYJH")) {
                sql += " ORDER BY "+sortCondition+" modify_time asc";

            }
        }

        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }

    public Map getParticipantsListById(int id){
        Map map=new HashMap();
        String sql= "";
        sql+="SELECT jsonb_array_elements(participants)->>'employee_id' AS employee_id, jsonb_array_elements(participants)->>'name' AS name, jsonb_array_elements(participants)->>'photo' AS photo, jsonb_array_elements(participants)->>'mobilephone_number' AS mobilephone_number FROM plan_base WHERE id ="+id+"";
        sql+="ORDER BY employee_id";
        List list=commonDao.getSql(sql);
        map.put("participantsList",list);
        return map;
    }
    public Map getUnCompletePlan(TcUser user){
        Map map=new HashMap();
        String sql="";
        sql="SELECT ID,task_condition_code,task_type_code,task_name,task_type,sup_project_name,sup_module_name,task_id," +
                "plan_name,start_date,actual_start_time,actual_end_time,end_date,plan_desc,complete," +
                "task_complete,CAST (array_to_string(ARRAY_AGG(NAME), ',') AS VARCHAR) AS NAME FROM (" +
                "SELECT A . ID, jsonb_array_elements (A .participants) ->> 'name' AS NAME,C .task_name,C .complete AS task_complete," +
                "d.data_name AS task_type,sup_project_name,sup_module_name,task_id,actual_start_time,actual_end_time," +
                "plan_name,start_date,end_date,plan_desc,C .task_condition_code,C .task_type_code,A .complete FROM plan_base A " +
                "LEFT JOIN task_base C ON A .task_id = C . ID " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'task_type' ) d ON C .task_type_code = d.data_code ) aa " +
                "WHERE NAME LIKE '%"+user.getDisplayName()+"%' AND task_condition_code in ('YXF','ZJXF') AND complete = '未完成' " +
                "GROUP BY ID,task_name,task_type_code,task_condition_code,task_type,sup_project_name,actual_start_time," +
                "actual_end_time,sup_module_name,task_id,plan_name,start_date,end_date,plan_desc,task_complete,complete";
        List list=commonDao.getSql(sql);
        map.put("plan",list);
        return map;

    }

}
