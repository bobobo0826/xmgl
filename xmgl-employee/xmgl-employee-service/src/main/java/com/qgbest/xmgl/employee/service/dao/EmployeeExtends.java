package com.qgbest.xmgl.employee.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Repository
public class EmployeeExtends {
    @Autowired
    private CommonDao commonDao;
    //查询员工列表界面
    public PageControl findEmployeeList(Map queryMap, int cpage, int len, TcUser user )
    {
        String sql="";
        sql+="SELECT id, user_id, employee_name,photo, basic_info->>'gender' as gender, b.data_name AS employment_status, position_name, dept_name," +
                "basic_info->>'mobilephone_number' AS mobilephone_number, creator, create_date, modifier, modify_date, " +
                "basic_info->>'entry_date' AS entry_date,basic_info->>'leave_date' AS leave_date,basic_info->>'address' AS address, " +
                "basic_info->>'id_number' AS id_number "+
                "FROM employees a " +
                "LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='employment_status') b ON a.employment_code =b.data_code "+
               " WHERE 1=1 ";

        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("employee_name"))){
            sql+=" AND employee_name like '%"+queryMap.get("employee_name")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("gender"))){
            sql+=" AND basic_info->> 'gender' = '"+queryMap.get("gender")+"'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("creator"))){
            sql+=" AND creator like '%"+queryMap.get("creator")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("dept_name"))){
            sql+=" AND dept_name like '%"+queryMap.get("dept_name")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("position_name"))){
            sql+=" AND position_name like '%"+queryMap.get("position_name")+"%'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("id_number"))){
            sql+=" AND basic_info->> 'id_number' like '%"+queryMap.get("id_number")+"%'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("mobilephone_number"))){
            sql+=" AND basic_info->> 'mobilephone_number' like '%"+queryMap.get("mobilephone_number")+"%'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("query_create_date_begin"))){
            sql+=" AND to_date(create_date,'yyyy-MM-dd') >= to_date('"+queryMap.get("query_create_date_begin")+"','yyyy-MM-dd')";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("query_create_date_end"))){
            sql+=" AND to_date(create_date,'yyyy-MM-dd') <= to_date('"+queryMap.get("query_create_date_end")+"','yyyy-MM-dd')";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("idList"))){
            sql+=" AND id in ("+queryMap.get("idList")+" )";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("entry_date"))) {
            String [] order_date =((String) queryMap.get("entry_date")).split("~");
            sql += " and to_date(basic_info->>'entry_date','yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(basic_info->>'entry_date','yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("leave_date"))) {
            String [] order_date =((String) queryMap.get("leave_date")).split("~");
            sql += " and to_date(basic_info->>'leave_date','yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(basic_info->>leave_date','yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("create_date"))) {
            String [] order_date =((String) queryMap.get("create_date")).split("~");
            sql += " and to_date(create_date,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(create_date,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("employment_code"))){
            sql+=" AND employment_code = '"+queryMap.get("employment_code")+"'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("employment_code"))&&(!queryMap.get("_curModuleCode").equals("YGXXGL"))){
            sql+=" AND employment_code in ('ZZ','SX')";
        }
        sql+=" ORDER BY POSITION (employment_code in 'ZZ,SX,LZ'), dept_name, position_name, employee_name";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }
    //选择员工列表
    public PageControl selectEmployeeList(Map queryMap, int cpage, int len, TcUser user )
    {
        String sql="";
        sql+="SELECT id, user_id, employee_name,photo, basic_info->>'gender' as gender, b.data_name AS employment_status,position_name, dept_name," +
                "basic_info->>'mobilephone_number' AS mobilephone_number," +
                "basic_info->>'id_number' AS id_number "+
                "FROM employees a " +
                "LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='employment_status') b ON a.employment_code =b.data_code "+
               " WHERE 1=1 ";
        if(StringUtils.isNotBlankOrNull(queryMap.get("employee_name"))){
            sql+=" AND employee_name like '%"+queryMap.get("employee_name")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("gender"))){
            sql+=" AND basic_info->> 'gender' = '"+queryMap.get("gender")+"'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("dept_name"))){
            sql+=" AND dept_name like '%"+queryMap.get("dept_name")+"%'";
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("position_name"))){
            sql+=" AND position_name like '%"+queryMap.get("position_name")+"%'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("mobilephone_number"))){
            sql+=" AND basic_info->> 'mobilephone_number' like '%"+queryMap.get("mobilephone_number")+"%'";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("idList"))){
            sql+=" AND id in ("+queryMap.get("idList")+" )";
        }

        if(StringUtils.isNotBlankOrNull(queryMap.get("employment_code"))&&(!queryMap.get("_curModuleCode").equals("YGXXGL"))){
            sql+=" AND employment_code in ('ZZ','SX')";
        }
//选择指定审核人，必须是公司领导和项目经理
        if(queryMap.get("_curModuleCode").equals("XZZDSHR")){
            sql+=" AND position_name in ('公司领导','项目经理')";
        }

        sql+=" ORDER BY POSITION (employment_code in 'ZZ,SX,LZ'), dept_name, position_name, employee_name";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc =commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }
    public Employee getOldEmployee(Integer id){
        return (Employee) commonDao.getWithEvict(Employee.class,id);
    }
    public List getEmployeeListByDept(String dept_name){
        String sql="select dept_name,employee_name from employees ";
        if(!dept_name.equals(" ")){
            sql+="where dept_name='"+dept_name+"'";
        }
        sql+=" order by dept_name";
        return commonDao.getSql(sql);
    }
    public List getEmployeeListName(Map queryMap) {
        String sql="";
        sql+="SELECT id, user_id, employee_name,photo, basic_info->>'gender' as gender, basic_info->>'email' as email, b.data_name AS employment_status, position_name, dept_name," +
                "basic_info->>'mobilephone_number' AS mobilephone_number, creator, create_date, modifier, modify_date, " +
                "basic_info->>'entry_date' AS entry_date,basic_info->>'leave_date' AS leave_date,basic_info->>'address' AS address, " +
                "basic_info->>'id_number' AS id_number "+
                "FROM employees a " +
                "LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='employment_status') b ON a.employment_code =b.data_code "+
                " WHERE 1=1 ";
        return commonDao.getSql(sql);
    }
    public PageControl getEmployeeOperateLog(Map queryMap, int cpage, int len, TcUser user) {
        String sql = "";
        sql += "select id,actiontype,businesspk,datapermission,formtype,newmodel,oldmodel,operaterdescrip,operatetime,operatetypeid,operator,tablepk,title from form_operate WHERE 1=1 ";

        if (StringUtils.isNotBlankOrNull(queryMap.get("filterRules"))) {
            List filterRulesList = JsonUtil.fromJsonToList(String.valueOf(queryMap.get("filterRules")));
            for (int m = 0; m < filterRulesList.size(); m++) {
                Map conditionMap = (Map) filterRulesList.get(m);
                queryMap.put(conditionMap.get("field"), conditionMap.get("value"));
            }
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("actiontype"))) {
            String actiontype =((String) queryMap.get("actiontype"));
            sql += " and actiontype like '%" + StringUtils.filterBadCharsForAntiSqlInject(actiontype) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("title"))) {
            String title =((String) queryMap.get("title"));
            sql += " and title like '%" + StringUtils.filterBadCharsForAntiSqlInject(title) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("datapermission"))) {
            String datapermission =((String) queryMap.get("datapermission"));
            sql += " and datapermission like '%" + StringUtils.filterBadCharsForAntiSqlInject(datapermission) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("operaterdescrip"))) {
            String operaterdescrip =((String) queryMap.get("operaterdescrip"));
            sql += " and operaterdescrip like '%" + StringUtils.filterBadCharsForAntiSqlInject(operaterdescrip) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("operatetime"))) {
            String [] order_date =((String) queryMap.get("operatetime")).split("~");
            sql += " and to_date(operatetime,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(operatetime,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("newmodel"))) {
            String newmodel =((String) queryMap.get("newmodel"));
            sql += " and newmodel like '%" + StringUtils.filterBadCharsForAntiSqlInject(newmodel) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("oldmodel"))) {
            String oldmodel =((String) queryMap.get("oldmodel"));
            sql += " and oldmodel like '%" + StringUtils.filterBadCharsForAntiSqlInject(oldmodel) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("title"))) {
            sql += " and title like '%" + queryMap.get("title") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("actiontype"))) {
            sql += " and actiontype like '%" + queryMap.get("actiontype") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("datapermission"))) {
            sql += " and datapermission like '%" + queryMap.get("datapermission") + "%'";
        }


        String sortCondition = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
            sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
        }
        sql += " ORDER BY " + sortCondition + "operatetime";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }



}
