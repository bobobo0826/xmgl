package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by wangchao on 2017/10/13.
 */
@Repository
public class PlanOutputExtends {
    @Autowired
    private CommonDao commonDao;

    public List getPlanOutputList(Integer planId){
        String sql = "";
        sql += "SELECT id, plan_id,b.data_name AS output_category, order_num,c.data_name AS output_type, doc_name, output_desc " +
                "FROM plan_output a " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'output_category') b ON a.output_category = b.data_code " +
                "LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'output_type') c ON a.output_type = c.data_code " +
                "WHERE 1=1 ";
        if(StringUtils.isNotBlankOrNull(planId)){
            sql += "and plan_id = '"+planId+"'";
        }
        sql += "order by id";
        List list = commonDao.getSql(sql);
        return  list;

    }
    public List getPlanByBusinessCode(String businessCode){
        String sql = "select data_code,data_name from d_common_dic where business_type='"+businessCode+"' order by id";
        List list = commonDao.getSql(sql);
        return list;
    }
}
