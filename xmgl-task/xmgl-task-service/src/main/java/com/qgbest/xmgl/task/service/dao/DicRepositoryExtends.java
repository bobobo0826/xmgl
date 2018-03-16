package com.qgbest.xmgl.task.service.dao;


import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Repository
public class DicRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl findDicList(Map queryMap, int cpage, int len )
    {
        String sql="";
        sql+="SELECT id,data_name,data_code,data_desc,business_type,business_name,is_used FROM d_common_dic WHERE 1 = 1";
        if(StringUtils.isNotBlankOrNull(queryMap.get("business_type"))){
            sql+=" and business_type like '%"+queryMap.get("business_type")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("is_used"))){
            sql+=" and is_used = '"+queryMap.get("is_used")+"'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("data_name"))){
            sql+=" and data_name like '%"+queryMap.get("data_name")+"%'";
        }
        sql+="ORDER BY id";
        String count = "select count(*) from  (" + sql + ")m ";
        PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }

    public String getDataNameByDataCode(String businessTypeCode,String dataCode){
        String sql="select data_code,data_name,business_type,business_name,is_used from d_common_dic where business_type='"+businessTypeCode+"' and data_code='"+dataCode+"'";
        List list = commonDao.getSql(sql);
        if(list!=null && list.size()>0){
            Map map= (Map) list.get(0);
            return String.valueOf(map.get("data_name"));
        }
        return null;
    }
    public List getCSList(){
        String sql = "select moduleid,modulename,moduledesc,oprset,callmothed,modulecallargs from ts_module";
        List list = commonDao.getSql(sql);
        return list;
    }
    public List getDicListByBusinessCode(String businessCode){
        String sql = "select data_code,data_name from d_common_dic where business_type='"+businessCode+"' order by id";
        List list = commonDao.getSql(sql);
        return list;
    }
    public List getDicSupTypeListByParentCode(String parentCode){
        String sql = "select data_code,data_name from d_common_dic where business_type='evaluate_sup_type_code' and parent_code='"+parentCode+"' order by id";
        List list = commonDao.getSql(sql);
        return list;
    }
}
