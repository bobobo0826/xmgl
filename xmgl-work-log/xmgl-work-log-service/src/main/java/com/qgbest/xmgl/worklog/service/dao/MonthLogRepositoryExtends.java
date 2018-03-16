package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */
@Repository
public class MonthLogRepositoryExtends {
  @Autowired
  private CommonDao commonDao;

  public PageControl getMonthLogList(Map queryMap, int cpage, int len, TcUser user) {
    String sql="";
    sql+="SELECT d.count,f.COUNT as comments_count,thumbs_up_id,id, work_date, creator, creator_id, create_date, modifier, modifier_id, modify_date," +
            "b.data_name as status_name,c.data_name as create_type from log_month  a " +
            "left join ( select data_name ,data_code from d_common_dic where business_type='log_status') b on a.status_code=b.data_code " +
            "left join ( select data_name ,data_code from d_common_dic where business_type='create_type') c on a.create_type=c.data_code " +
            "left join (select count(id),thumbs_up_subject_id from hd_thumbs_up where thumbs_up_type='MYJH' group by thumbs_up_subject_id)d on a.id=d.thumbs_up_subject_id " +
            "left join(select thumbs_up_subject_id,thumbs_up_id from hd_thumbs_up where thumbs_up_type = 'MYJH' and thumbs_up_id='"+user.getId()+"')e on a.id=e.thumbs_up_subject_id "
         + " left join(select count(id),business_id from hd_comments where parent_id=0 and business_type='MYJH' GROUP BY business_id)f ON A . ID = f.business_id"
         + " where 1=1";


    if(StringUtils.isNotBlankOrNull(queryMap.get("_curModuleCode"))){
      if(queryMap.get("_curModuleCode").equals("MY_MYJH")){
        sql+=" and creator_id="+user.getId();
      }else if(queryMap.get("_curModuleCode").equals("MYJH")){
        sql+=" and status_code='YTJ'";
        if(StringUtils.isNotBlankOrNull(queryMap.get("new_query_date"))){
          sql+=" and to_date(modify_date,'yyyy-MM') >= to_date('"+queryMap.get("new_query_date")+"','yyyy-MM')";
        }
      }
    }

    if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
      List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
      for (int m = 0; m < filterRulesList.size(); m++) {
        Map conditionMap = (Map) filterRulesList.get(m);
        queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
      }
    }
    if (StringUtils.isNotBlankOrNull(queryMap.get("work_date"))) {
      String [] order_date =((String) queryMap.get("work_date")).split("~");
      sql += " and to_date(work_date,'yyyy_MM_dd') >= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
      sql += " and to_date(work_date,'yyyy_MM_dd') <= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
    }
    if (StringUtils.isNotBlankOrNull(queryMap.get("create_date"))) {
      String [] order_date =((String) queryMap.get("create_date")).split("~");
      sql += " and to_date(create_date,'yyyy_MM_dd') >= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
      sql += " and to_date(create_date,'yyyy_MM_dd') <= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
    }
    if (StringUtils.isNotBlankOrNull(queryMap.get("modify_date"))) {
      String [] order_date =((String) queryMap.get("modify_date")).split("~");
      sql += " and to_date(modify_date,'yyyy_MM_dd') >= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
      sql += " and to_date(modify_date,'yyyy_MM_dd') <= '"
             + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
    }


    if(StringUtils.isNotBlankOrNull(queryMap.get("query_work_date_begin"))){
      sql+=" and to_date(work_date,'yyyy-MM-dd') >= to_date('"+queryMap.get("query_work_date_begin")+"','yyyy-MM-dd')";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("query_work_date_end"))){
      sql+=" and to_date(work_date,'yyyy-MM-dd') <= to_date('"+queryMap.get("query_work_date_end")+"','yyyy-MM-dd')";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("creator"))){
      sql+=" and creator like '%"+queryMap.get("creator")+"%'";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("modifier"))){
      sql+=" and modifier like '%"+queryMap.get("modifier")+"%'";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("create_type"))){
      sql+=" and create_type like '%"+queryMap.get("create_type")+"%'";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("status_code"))){
      sql+=" and status_code like '%"+queryMap.get("status_code")+"%'";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("query_create_date_begin"))){
      sql+=" and to_date(create_date,'yyyy-MM-dd') >= to_date('"+queryMap.get("query_create_date_begin")+"','yyyy-MM-dd')";
    }
    if(StringUtils.isNotBlankOrNull(queryMap.get("query_create_date_end"))){
      sql+=" and to_date(create_date,'yyyy-MM-dd') <= to_date('"+queryMap.get("query_create_date_end")+"','yyyy-MM-dd')";
    }
    String sortCondition = "";
    if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
      sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
    }

    sql+=" ORDER BY " + sortCondition + " POSITION (status_code in 'CG,YTJ'), work_date DESC, create_date DESC";
    String count = "select count(*) from  (" + sql + ")m ";
    PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
    return pc;
  }

  public Integer getMonthLogNumber() {
    String month = DateUtils.getCurrDateMonth();
    String sql = "select count(id) from log_month WHERE status_code='YTJ' AND to_date(modify_date,'YYYY-MM') = to_date('"+month+"','yyyy-MM')";
    List list = commonDao.getSql(sql);
    Map map = (Map) list.get(0);
    Integer count = Integer.valueOf(String.valueOf(map.get("count")));
    return count;
  }

  public Map getMonthLogContentListById(int id){
    Map map=new HashMap();
    String sql= "";
    sql+="SELECT jsonb_array_elements(content)->>'record' AS record, jsonb_array_elements(content)->>'complete' AS complete, jsonb_array_elements(content)->>'task_name' AS task_name, jsonb_array_elements(content)->>'task_type' AS task_type, jsonb_array_elements(content)->>'sup_module' AS sup_module," +
            "jsonb_array_elements(content)->>'sup_project' AS sup_project, jsonb_array_elements(content)->>'sup_module_id' AS sup_module_id, jsonb_array_elements(content)->>'task_end_time' AS task_end_time, jsonb_array_elements(content)->>'sup_project_id' AS sup_project_id," +
            "jsonb_array_elements(content)->>'mission_name' AS mission_name, jsonb_array_elements(content)->>'plan_name' AS plan_name,"+
            "jsonb_array_elements(content)->>'task_start_time' AS task_start_time, jsonb_array_elements(content)->>'incomplete_explain' AS incomplete_explain FROM log_month WHERE id = "+
            id+"";
    sql+=" ORDER BY task_start_time";
    List list=commonDao.getSql(sql);

    sql="SELECT month_summary, next_plan, work_explain FROM log_month WHERE id = "+id+"";
    List summaryAndPlan = commonDao.getSql(sql);
    map.put("monthLogTaskList",list);
    map.putAll((Map)summaryAndPlan.get(0));
    return map;
  }

  public List getMonthLogIdByMonth(TcUser user, String month) {
    String sql="SELECT id FROM log_month WHERE 1=1 "
               + "AND work_date='" + month + "'"
               + "And creator_id=" + user.getId();
    sql+=" ORDER BY id DESC";
    List ids = commonDao.getSql(sql);
    return ids;
  }
  public MonthLog getOldMonthLog(Integer id){
    return (MonthLog) commonDao.getWithEvict(MonthLog.class,id);
  }



}
