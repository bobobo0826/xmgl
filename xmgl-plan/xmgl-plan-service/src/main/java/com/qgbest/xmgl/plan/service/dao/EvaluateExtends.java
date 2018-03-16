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
 * Created by quangao on 2017/9/28.
 */
@Repository
public class EvaluateExtends {
    @Autowired
    private CommonDao commonDao;
    public PageControl getEvaluationList(Map queryMap, int cpage, int len, TcUser user) {
        String count = "";
        String sql="SELECT ID,plan_id,plan_name,evaluate_object_code,single_contractor,evaluate_type_code," +
                "evaluate_sup_type_code,evaluate_level_code,evaluate_description,evaluate_people,evaluate_time," +
                "b.data_name AS evaluate_object,C .data_name AS evaluate_type,d.data_name AS evaluate_sup_type," +
                "e.data_name AS evaluate_level,modify_time FROM evaluation A " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_object_code') b ON A .evaluate_object_code = b.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_type_code') C ON A .evaluate_type_code = C .data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_sup_type_code') d ON A .evaluate_sup_type_code = d.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_level_code') e ON A .evaluate_level_code = e.data_code " +
                "WHERE 1=1";
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_level"))) {
            sql += " AND evaluate_level_code = '" + queryMap.get("evaluate_level") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_type"))) {
            sql += " AND evaluate_type_code = '" + queryMap.get("evaluate_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_object"))) {
            sql += " AND evaluate_object_code = '" + queryMap.get("evaluate_object") + "'";
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public PageControl getEvaluationListByPlanId(Map queryMap, int cpage, int len, TcUser user,int plan_id) {
        String count = "";
        String sql="SELECT ID,plan_id,plan_name,evaluate_object_code,single_contractor,evaluate_type_code," +
                "evaluate_sup_type_code,evaluate_level_code,evaluate_description,evaluate_people,evaluate_time," +
                "b.data_name AS evaluate_object,C .data_name AS evaluate_type,d.data_name AS evaluate_sup_type," +
                "e.data_name AS evaluate_level,modify_time FROM evaluation A " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_object_code') b ON A .evaluate_object_code = b.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_type_code') C ON A .evaluate_type_code = C .data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_sup_type_code') d ON A .evaluate_sup_type_code = d.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_level_code') e ON A .evaluate_level_code = e.data_code " +
                "WHERE plan_id ='"+plan_id+"' and evaluate_object_code='PLAN'";
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_level"))) {
            sql += " AND evaluate_level_code = '" + queryMap.get("evaluate_level") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_type"))) {
            sql += " AND evaluate_type_code = '" + queryMap.get("evaluate_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_object"))) {
            sql += " AND evaluate_object_code = '" + queryMap.get("evaluate_object") + "'";
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public PageControl getEvaluationListByEmployeeId(Map queryMap, int cpage, int len, TcUser user,String single_contractor,int plan_id) {
        String count = "";
        String sql="SELECT ID,plan_id,plan_name,evaluate_object_code,single_contractor,evaluate_type_code," +
                "evaluate_sup_type_code,evaluate_level_code,evaluate_description,evaluate_people,evaluate_time," +
                "b.data_name AS evaluate_object,C .data_name AS evaluate_type,d.data_name AS evaluate_sup_type," +
                "e.data_name AS evaluate_level,modify_time FROM evaluation A " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_object_code') b ON A .evaluate_object_code = b.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_type_code') C ON A .evaluate_type_code = C .data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_sup_type_code') d ON A .evaluate_sup_type_code = d.data_code " +
                "LEFT JOIN (SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'evaluate_level_code') e ON A .evaluate_level_code = e.data_code " +
                "WHERE single_contractor ='"+single_contractor+"' and plan_id='"+plan_id+"' and evaluate_object_code='PEOPLE'";
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_level"))) {
            sql += " AND evaluate_level_code = '" + queryMap.get("evaluate_level") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_type"))) {
            sql += " AND evaluate_type_code = '" + queryMap.get("evaluate_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("evaluate_object"))) {
            sql += " AND evaluate_object_code = '" + queryMap.get("evaluate_object") + "'";
        }
        sql += " ORDER BY modify_time desc";
        count = "select count(*) from  (" + sql + ")m ";
        return commonDao.getDataBySql(count, sql, cpage, len);
    }
    public List getEvaluationByPlanId(int plan_id){
        String sql="SELECT ID,plan_id,plan_name,evaluate_object_code,single_contractor,evaluate_type_code,evaluate_sup_type_code,evaluate_level_code,evaluate_description,evaluate_people,evaluate_time,modify_time FROM evaluation WHERE plan_id ='"+plan_id+"' AND evaluate_object_code = 'PLAN'";
        List list=commonDao.getSql(sql);
        return list;

    }

    public List getEvaluationByEmpIdAndEvaType(int plan_id,String single_contractor,String evaluate_type_code){
        String sql="SELECT ID,plan_id,plan_name,evaluate_object_code,single_contractor,evaluate_type_code,evaluate_sup_type_code,evaluate_level_code,evaluate_description,evaluate_people,evaluate_time,modify_time FROM evaluation WHERE plan_id ='"+plan_id+"' and single_contractor ='"+single_contractor+"' and  evaluate_type_code='"+evaluate_type_code+"' AND evaluate_object_code= 'PEOPLE'";
        List list=commonDao.getSql(sql);
        return list;

    }


}
