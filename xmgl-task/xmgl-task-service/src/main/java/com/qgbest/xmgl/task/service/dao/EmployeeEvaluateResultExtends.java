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
 * Created by quangao on 2017/10/10.
 */
@Repository
public class EmployeeEvaluateResultExtends {
    @Autowired
    private CommonDao commonDao;
    public PageControl getEmployeeEvaluateResultListByEmployeeId(Map queryMap, int cpage, int len, TcUser user,String employeeId,Integer task_id) {
        String count = "";
        String sql="select id,task_id,task_name,employee_id,employee_name,evaluate_type_code,average_type,modify_time " +
                "from employee_evaluate_result A " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_type_code') C ON A .evaluate_type_code = C .data_code " +
                "WHERE  employee_id in ("+employeeId+") and task_id='"+task_id+"'";
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_type"))) {
            sql += " AND evaluate_type_code = '" + queryMap.get("evaluate_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_type"))) {
            sql += " AND average_type = " + queryMap.get("average_type");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public PageControl getEmployeeEvaluateResultList(Map queryMap, int cpage, int len, TcUser user) {
        String count = "";
        String sql="SELECT ID,task_id,task_name,employee_id,c.data_name AS evaluate_type,employee_name,evaluate_type_code," +
                "average_type,modify_time FROM employee_evaluate_result A " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_type_code') C ON A .evaluate_type_code = C .data_code " +
                "WHERE 1 = 1";

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_type"))) {
            sql += " AND evaluate_type_code = '" + queryMap.get("evaluate_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_type"))) {
            sql += " AND average_type = " + queryMap.get("average_type");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public List getTaskEvaluateResultByTaskIdAndEmpId(int task_id,int employee_id,String evaluate_type_code){
        String sql="SELECT ID,task_id,employee_id,employee_name,task_name,evaluate_type_code,modify_time,average_type " +
                "FROM employee_evaluate_result WHERE task_id ='"+task_id+"' and employee_id ='"+employee_id+"' and evaluate_type_code='"+evaluate_type_code+"'";
        List list=commonDao.getSql(sql);
        return list;

    }
    public void UpdateTaskEvaluateResultInfo(Integer task_id,Integer employee_id,String modify_time,Integer average_score){

        String sql="update employee_evaluate_result set modify_time='"+modify_time+"',average_type='"+average_score+"' where task_id ='"+task_id+"' and employee_id ='"+employee_id+"'";
        commonDao.updateBySql(sql);


    }
}
