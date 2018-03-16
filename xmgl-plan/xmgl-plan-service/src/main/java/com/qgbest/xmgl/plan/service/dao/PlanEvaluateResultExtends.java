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
 * Created by quangao on 2017/10/16.
 */
@Repository
public class PlanEvaluateResultExtends {
    @Autowired
    private CommonDao commonDao;
    public PageControl getPlanEvaluateResultList(Map queryMap, int cpage, int len, TcUser user) {
        String count = "";
        String sql="select id,plan_id,plan_name,average_score,modify_time from plan_evaluate_result WHERE 1=1";

        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_name"))) {
            sql += " AND plan_name like '%" + queryMap.get("plan_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_score"))) {
            sql += " AND average_score = " + queryMap.get("average_score");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public PageControl getPlanEvaluateResultListByPlanId(Map queryMap, int cpage, int len, TcUser user,int plan_id) {
        String count = "";
        String sql="select id,plan_id,plan_name,average_score,modify_time from plan_evaluate_result where plan_id='"+plan_id+"'";
        if (StringUtils.isNotBlankOrNull(queryMap.get("plan_name"))) {
            sql += " AND plan_name like '%" + queryMap.get("plan_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("average_score"))) {
            sql += " AND average_score = " + queryMap.get("average_score");
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public List getPlanEvaluateResultByPlanId(int plan_id){
        String sql="SELECT ID,plan_id,plan_name,modify_time,average_score FROM plan_evaluate_result WHERE plan_id ='"+plan_id+"'";
        List list=commonDao.getSql(sql);
        return list;

    }
    public void UpdatePlanEvaluateResultInfo(Integer plan_id,String modify_time,Integer average_score){

        String sql="update plan_evaluate_result set modify_time='"+modify_time+"',average_score='"+average_score+"' where plan_id ='"+plan_id+"'";
        commonDao.updateBySql(sql);


    }
}
