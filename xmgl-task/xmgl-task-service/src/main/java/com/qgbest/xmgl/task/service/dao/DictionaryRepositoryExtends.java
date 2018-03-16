package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/8/1.
 */
@Repository
public class DictionaryRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

        public PageControl queryDictionaryList(Map queryMap, int cpage, int len )
        {
            String sql="";
            sql+="select id, data_name,  data_desc,  data_code,   is_used,  business_type,  business_name from d_common_dic   where 1=1";

            if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
                List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
                for (int m = 0; m < filterRulesList.size(); m++) {
                    Map conditionMap = (Map) filterRulesList.get(m);
                    queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
                }
            }

            if(StringUtils.isNotBlankOrNull(queryMap.get("is_used"))){
                sql+=" and is_used = '"+queryMap.get("is_used")+"'";
            }
            if(StringUtils.isNotBlankOrNull(queryMap.get("data_name"))){
                sql+=" and data_name like '%"+queryMap.get("data_name")+"%'";
            }
            if(StringUtils.isNotBlankOrNull(queryMap.get("business_type"))){
                sql+=" and business_type = '"+queryMap.get("business_type")+"'";
            }
            String sortCondition = "";
            if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
                sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
            }


            sql+="ORDER BY "+sortCondition+ " business_name,is_used";
            String count = "select count(*) from  (" + sql + ")m ";
            PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
            return pc;
        }
        /**
         * 查询项目类型列表
         * @return
         */
        public List getBusinessTypeList(){
            String sql="";
           sql += "select distinct business_type as data_code,business_name as data_name from d_common_dic order by data_name";
            //sql += "select distinct u.business_type as business_type,u.business_name as business_name from d_common_dic u order by business_name";
            List list = commonDao.getSql(sql);
            return  list;
        }
    }

