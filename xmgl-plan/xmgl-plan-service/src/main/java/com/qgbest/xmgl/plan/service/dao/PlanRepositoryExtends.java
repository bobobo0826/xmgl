package com.qgbest.xmgl.plan.service.dao;

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
 * Created by quangao on 2017/10/12.
 */
@Repository
public class PlanRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl getPlanList(Map queryMap, int cpage, int len, TcUser user, String employee) {
        String sql = "SELECT ID,task_id,task_name,plan_name,plan_desc,plan_start_time,plan_end_time,plan_result_summary, " +
                "plan_result_condition_code,plan_condition_code,creator,creator_id,contractor,modify_time,actual_plan_start_time," +
                "actual_plan_end_time,create_time, b.data_name AS plan_result_condition,C .data_name AS plan_condition " +
                "FROM plan_base A  " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'plan_result_condition_code') b ON A .plan_result_condition_code = b.data_code  " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'plan_condition_code') C ON A .plan_condition_code = C .data_code  " +
                "WHERE 1 = 1";
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryType"))) {
            if (queryMap.get("queryType").equals("DCL")) {
                sql += " AND plan_condition_code in ('CG','BGDTJ','DZX')";
            } else if (queryMap.get("queryType").equals("CK")) {
                sql += " AND plan_condition_code in ('JXZ','YWC','YKP','YZX')";
            }
        }
        if (user.getRoleCode().equals("KFRY") || StringUtils.isNotBlankOrNull(queryMap.get("isToAddWorkLog"))) {
            sql += "AND (creator_id = " + user.getId() + " OR contractor like '%" + employee + "%') ";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("isToAddWorkLog"))){
            sql += "AND plan_condition_code in ('DZX','JXZ')";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_name"))) {
            sql += " AND plan_name like '%" + queryMap.get("plan_name") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_condition"))) {
            sql += " AND plan_condition_code = '" + queryMap.get("plan_condition") + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_result_condition"))) {
            sql += " AND plan_result_condition_code = '" + queryMap.get("plan_result_condition") + "'";
        }

        sql += " ORDER BY POSITION (plan_condition_code in 'DCJ,BG,CG,JXZ,YWC,YKP,YZX'),create_time DESC,task_name ";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }

    public void updateAttachment(Integer planId, String attachmentInfo) {
        String sql = "";
        if (StringUtils.isNotBlankOrNull(planId)) {
            sql = "UPDATE plan_base SET attachment = '" + attachmentInfo + "' WHERE id = '" + planId + "'";
        }
        commonDao.updateBySql(sql);
    }

    /**
     * 选择计划列表查询
     *
     * @param queryMap
     * @param cpage
     * @param len
     * @return
     */
    public PageControl getPlanQueryList(Map queryMap, int cpage, int len, TcUser user, String taskType, String contractor) {
        String count = "";
        String sql = "select ID,task_id,plan_name,plan_desc,plan_start_time,plan_end_time,plan_result_condition_code," +
                "plan_result_summary,creator,contractor,plan_condition_code,modify_time,task_name," +
                "actual_plan_start_time,actual_plan_end_time,create_time,task_type_code,sup_project_name," +
                "sup_module_name,b.data_name as task_type from plan_base a " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'task_type') b ON a .task_type_code = b.data_code " +
                "where plan_condition_code in ('DZX','JXZ') and task_type_code='" + taskType + "' and contractor='" + contractor + "'";


        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
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

        sql += " ORDER BY modify_time asc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }

    public void setPlanConditionCodeByTaskId(Integer taskId, String condition_code) {
        String sql = "UPDATE plan_base SET plan_condition_code = '" + condition_code + "' WHERE task_id = " + taskId;
        commonDao.updateBySql(sql);
    }

    public Map getPlanPercent(Integer taskId) {
        String sql = "";
        sql = "SElECT id FROM plan_base WHERE task_id = '" + taskId + "' AND plan_condition_code <> 'YZX'";
        List total = commonDao.getSql(sql);
        sql = "SElECT id FROM plan_base WHERE task_id = '" + taskId + "' AND plan_condition_code='YWC'";
        List complete = commonDao.getSql(sql);
        Integer totalNum = total.size();
        Integer completeNum = complete.size();
        Integer percent = (Integer) (completeNum * 100) / totalNum;
        Map map = new HashMap();
        map.put("totalNum", totalNum);
        map.put("completeNum", completeNum);
        map.put("percent", percent);
        return map;
    }

}
