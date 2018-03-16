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
 * Created by quangao on 2017/10/9.
 */
@Repository
public class TaskEvaluateResultExtends {
    @Autowired
    private CommonDao commonDao;
    public PageControl getTaskEvaluateResultList(Map queryMap, int cpage, int len, TcUser user) {
        String count = "";
        String sql="select id,task_id,task_name,average_score,modify_time from task_evaluate_result WHERE 1=1";

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_score"))) {
            sql += " AND average_score = " + queryMap.get("average_score");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public PageControl getTaskEvaluateResultListByTaskId(Map queryMap, int cpage, int len, TcUser user,int task_id) {
        String count = "";
        String sql="select id,task_id,task_name,average_score,modify_time from task_evaluate_result where task_id='"+task_id+"'";
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_score"))) {
            sql += " AND average_score = " + queryMap.get("average_score");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public List getTaskEvaluateResultByTaskId(int task_id){
        String sql="SELECT ID,task_id,task_name,modify_time,average_score FROM task_evaluate_result WHERE task_id ='"+task_id+"'";
        List list=commonDao.getSql(sql);
        return list;

    }
    public void UpdateTaskEvaluateResultInfo(Integer task_id,String modify_time,Integer average_score){

        String sql="update task_evaluate_result set modify_time='"+modify_time+"',average_score='"+average_score+"' where task_id ='"+task_id+"'";
        commonDao.updateBySql(sql);


    }
}
