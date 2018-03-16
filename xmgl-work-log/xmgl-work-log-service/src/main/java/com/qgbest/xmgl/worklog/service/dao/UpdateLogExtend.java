package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.common.utils.JsonUtil;
import java.util.List;
import java.util.Map;
/**
 * Created by quangao on 2017/7/26.
 */
@Repository
public class UpdateLogExtend {
    @Autowired
    private CommonDao commonDao;
    public PageControl queryUpdateLogList(Map queryMap, int cpage, int len ){
        String sql="";
        sql+="SELECT id,title,content,update_date,create_date,creator,creator_id,modifier,modify_date,status from update_log where 1=1   ";
        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("create_date"))) {
            String [] order_date =((String) queryMap.get("create_date")).split("~");
            sql += " and to_date(create_date,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(create_date,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("update_date"))) {
            String [] order_date =((String) queryMap.get("update_date")).split("~");
            sql += " and to_date(update_date,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(update_date,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("title"))){
            sql+=" and title like '%"+queryMap.get("title")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("content"))){
            sql+=" and content like '%"+queryMap.get("content")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("creator"))){
            sql+=" and creator = '"+queryMap.get("creator")+"'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("query_update_date_begin"))){
            sql+=" and to_date(update_date,'yyyy-MM-dd') >= to_date('"+queryMap.get("query_update_date_begin")+"','yyyy-MM-dd')";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("query_update_date_end"))){
            sql+=" and to_date(update_date,'yyyy-MM-dd') <= to_date('"+queryMap.get("query_update_date_end")+"','yyyy-MM-dd')";
        }
//       String sortCondition = "";
//        if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
//            sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
//        }

        sql+="order by status desc   ,update_date DESC , id ";
        String count = "select count(*) from  (" + sql + ")m ";
        System.out.println("++++++++++++++++++ " + sql);
        PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
        return pc;

    }



    public List getLatestUpdateLog()  {
        String sql="select title,content,update_date from update_log  where status='已发布' order by update_date DESC";
        List list = commonDao.getSql(sql);
        return list;

    }
        public  void   publishUpdateLog(Integer id){
        String sql="UPDATE update_log SET status='已发布' where id="+id+"";
                      commonDao.updateBySql(sql);
        }
    public  void   unPublishUpdateLog(Integer id){
        String sql="UPDATE update_log SET status='草稿' where id="+id+"";
        commonDao.updateBySql(sql);
    }

}
