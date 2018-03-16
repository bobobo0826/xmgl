package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by wch on 2017-07-13.
 */
@Repository
public class TaskLogExtend {

    @Autowired
    private CommonDao commonDao;

    /**
     * 查询项目任务日志列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     */
    public PageControl queryTaskLogList(Map queryMap, int cpage, int len)
    {
        String sql="";
        if(queryMap.get("period").equals("DAY")){
            sql += "SELECT content_json ->> 'sup_project' AS project_name, content_json ->> 'sup_module' AS module_name, "+
            "content_json ->> 'task_name' AS task_name, content_json ->> 'record' AS record, content_json ->> 'complete' AS complete, "+
            "content_json ->> 'task_start_time' AS task_start_time, content_json ->> 'task_end_time' AS task_end_time, modifier, modify_date "+
            "FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier, modify_date FROM log_day) a WHERE 1 = 1";
        }else if(queryMap.get("period").equals("WEEK")){
            sql += "SELECT content_json ->> 'sup_project' AS project_name, content_json ->> 'sup_module' AS module_name, "+
                    "content_json ->> 'task_name' AS task_name, content_json ->> 'record' AS record, content_json ->> 'complete' AS complete, "+
                    "content_json ->> 'task_start_time' AS task_start_time, content_json ->> 'task_end_time' AS task_end_time, modifier, modify_date "+
                    "FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier, modify_date FROM log_week) a WHERE 1 = 1";

        }else{//queryMap.get("period").equals("MONTH")的情况
            sql += "SELECT content_json ->> 'sup_project' AS project_name, content_json ->> 'sup_module' AS module_name, "+
                    "content_json ->> 'task_name' AS task_name, content_json ->> 'record' AS record, content_json ->> 'complete' AS complete, "+
                    "content_json ->> 'task_start_time' AS task_start_time, content_json ->> 'task_end_time' AS task_end_time, modifier, modify_date "+
                    "FROM ( SELECT jsonb_array_elements (CONTENT) AS content_json, modifier AS modifier, modify_date FROM log_month) a WHERE 1 = 1";
        }
        //表头查询条件
        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            System.out.println("==============="+filterRulesList);
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
        }
        //验证提交日期
        if (StringUtils.isNotBlankOrNull(queryMap.get("modify_date"))) {
            String [] order_date =((String) queryMap.get("modify_date")).split("~");
            sql += " and to_date(modify_date,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(modify_date,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        //验证开始时间（只有时分），直接比较字符串
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_start_time"))) {
            String [] order_date =((String) queryMap.get("task_start_time")).split("~");
            sql += " and content_json ->> 'task_start_time' >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and content_json ->> 'task_start_time' <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        //验证结束时间
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_end_time"))) {
            String [] order_date =((String) queryMap.get("task_end_time")).split("~");
            sql += " and content_json ->> 'task_end_time' >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and content_json ->> 'task_end_time' <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        //验证所属项目
        if(StringUtils.isNotBlankOrNull(queryMap.get("project_name"))){
            sql+=" and content_json ->> 'sup_project' like '%"+queryMap.get("project_name")+"%'";
        }
        //验证所属模块
        if(StringUtils.isNotBlankOrNull(queryMap.get("module_name"))){
            sql+=" and content_json ->> 'sup_module' like '%"+queryMap.get("module_name")+"%'";
        }
        //验证任务名称
        if(StringUtils.isNotBlankOrNull(queryMap.get("task_name"))){
            sql+=" and content_json ->> 'task_name' like '%"+queryMap.get("task_name")+"%'";
        }
        //验证任务记录
        if(StringUtils.isNotBlankOrNull(queryMap.get("record"))){
            sql+=" and content_json ->> 'record' like '%"+queryMap.get("record")+"%'";
        }
        //验证完成情况
        if(StringUtils.isNotBlankOrNull(queryMap.get("complete"))){
            sql+=" and content_json ->> 'complete' like '%"+queryMap.get("complete")+"%'";
        }
        //验证提交人
        if(StringUtils.isNotBlankOrNull(queryMap.get("modifier"))){
            sql+=" and modifier like '%"+queryMap.get("modifier")+"%'";
        }
        //全局排序
        String sortCondition = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
            sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
        }
        sql+=" and content_json ->> 'sup_project_id' != ''";
        sql+=" ORDER BY "+sortCondition+ " project_name, modifier, modify_date, task_start_time, task_end_time";

        String count = "select count(*) from  (" + sql + ")m ";
        PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }

}
