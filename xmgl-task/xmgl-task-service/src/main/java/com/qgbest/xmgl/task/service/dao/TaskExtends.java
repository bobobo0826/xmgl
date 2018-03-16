package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Repository
public class TaskExtends {
    @Autowired
    private CommonDao commonDao;

    public PageControl findTaskList(Map queryMap, int cpage, int len, TcUser user, String employee) {
        String sql = "";
        //联合查询两张表task_base 和task_temp
        // 合并 （task_temp里面创建人是当前用户的task数据）,记为表a， 和 task_base 中 去除了（和表a的数据是同一个task的数据）。


        //相同字段的sql
        String selectSql1 = " participants,task_name, sup_project_name,sup_project_id, " +
                " sup_module_name,sup_module_id, creator,creator_id,expected_end_time, " +
                " create_time, modifier, modify_time, complete, task_desc, urgency, importance " +
                " , " ;
        //查询task 里面 的code 字段 （有对应的字典）
        String selectSql2 = " task_type_code, report_cycle_code,task_condition_code ";
        //code 转换成汉字
        String selectSql3 = " b.data_name AS task_type, d.data_name AS report_cycle, c.data_name AS task_condition ";
        //联合字典查询
        String selectSql4 = " LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='task_type') b ON a.task_type_code =b.data_code " +
                " LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='task_condition') c ON a.task_condition_code =c.data_code " +
                " LEFT JOIN (  SELECT   data_name,   data_code " +
                " FROM d_common_dic  WHERE   business_type = 'report_cycle' ) d ON A .report_cycle_code = d.data_code";
        //去除 有临时数据的task_base数据
        String selectSql5 = " WHERE NOT ID IN ( SELECT task_id FROM task_temp WHERE creator_id = "+user.getId()+")" ;
        //查询基本数据集的 总的sql语句。
        sql += " SELECT id, " + selectSql1 + selectSql3 + //最后的输出结果字段
                " FROM ( SELECT id, " + selectSql1+selectSql2 + " FROM task_base" +selectSql5+ //查询task_base
                " UNION ALL " +//合并两张表
                //查询表task_temp
                " SELECT task_id, " + selectSql1+selectSql2 + " FROM task_temp WHERE creator_id = "+user.getId()+")A " +
                selectSql4+" WHERE 1=1 ";//联合字典查询
        if (user.getRoleCode().equals("KFRY") || StringUtils.isNotBlankOrNull (queryMap.get("isToAddNewPlan"))){
            sql+= "AND (creator_id = " + user.getId() + " OR participants like '%"+employee+"%') ";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("isToAddNewPlan"))) {
            sql += " AND task_condition_code in ('DCJ','BGDPG') "; //是否为 选择任务 新建计划
        }
        // 其他查询条件
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryType"))) {
            if (queryMap.get("queryType").equals("DCL")) {
                sql += " AND task_condition_code in ('CG','DCJ','BGDTJ','BGDPG')";
            } else if (queryMap.get("queryType").equals("CK")) {
                sql += " AND task_condition_code in ('JXZ','YWC','YKP','YZX')";
            }
        }


        if (StringUtils.isNotBlankOrNull(queryMap.get("task_name"))) {
            sql += " AND task_name like '%" + queryMap.get("task_name") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_type"))) {
            sql += " AND task_type_code = '" + queryMap.get("task_type") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("creator"))) {
            sql += " AND creator like '%" + queryMap.get("creator") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("task_desc"))) {
            sql += " AND task_desc like '%" + queryMap.get("task_desc") + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("importance"))) {
            sql += " AND importance = '" + queryMap.get("importance") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("urgency"))) {
            sql += " AND urgency = '" + queryMap.get("urgency") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("report_cycle"))) {
            sql += " AND report_cycle_code = '" + queryMap.get("report_cycle") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("complete"))) {
            sql += " AND complete = '" + queryMap.get("complete") + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("task_condition"))) {
            sql += " AND task_condition_code = '" + queryMap.get("task_condition") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("sup_project_name"))) {
            sql += " AND sup_project_name like '%" + queryMap.get("sup_project_name") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("sup_module_name"))) {
            sql += " AND sup_module_name like '%" + queryMap.get("sup_module_name") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("modifier"))) {
            sql += " AND modifier like '%" + queryMap.get("modifier") + "%'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("query_create_time_begin"))) {
            sql += " AND to_date(create_time,'yyyy-MM-dd') >= to_date('" + queryMap.get("query_create_time_begin") + "','yyyy-MM-dd')";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("query_create_time_end"))) {
            sql += " AND to_date(create_time,'yyyy-MM-dd') <= to_date('" + queryMap.get("query_create_time_end") + "','yyyy-MM-dd')";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("modify_time"))) {
            String[] order_date = ((String) queryMap.get("modify_time")).split("~");
            sql += " and to_date(modify_time,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(modify_time,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }

        if (StringUtils.isNotBlankOrNull(queryMap.get("create_time"))) {
            String[] order_date = ((String) queryMap.get("create_time")).split("~");
            sql += " and to_date(create_time,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(create_time,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        String sortCondition = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("sortField"))) {
            sortCondition = queryMap.get("sortField") + " " + queryMap.get("sortOrder") + ",";
        }
        sql += " ORDER BY " + sortCondition + "POSITION (task_condition_code in 'DCJ,BG,CG,JXZ,YWC,YKP,YZX'), sup_project_id, POSITION (urgency in '紧急,不紧急')," +
                "POSITION (importance in '重要,不重要')," +
                "create_time DESC ";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }


    public PageControl selectTaskByEmployee(Map queryMap, int cpage, int len, Integer participants_id) {
        String sql = "";
        sql += "SELECT * from (SELECT id, task_name, b.data_name AS task_type, d.data_name AS report_cycle, c.data_name AS task_condition , sup_project_name,sup_project_id," +
                "sup_module_name,sup_module_id, creator,creator_id, create_time, modifier, modify_time, complete, task_desc, urgency, importance " +
                ", jsonb_array_elements(participants)->>'id' AS participants_id " +
                "FROM task_base A " +
                "LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='task_type') b ON a.task_type_code =b.data_code " +
                "LEFT JOIN (SELECT data_name ,data_code FROM d_common_dic WHERE business_type='task_condition') c ON a.task_condition_code =c.data_code " +
                "LEFT JOIN (  SELECT   data_name,   data_code " +
                "FROM   d_common_dic  WHERE   business_type = 'report_cycle' ) d ON A .report_cycle = d.data_code  WHERE task_condition_code in ('YXF','ZJXF') )m" +
                " WHERE 1=1 AND participants_id = '" + participants_id + "'";
        String count = "SELECT count(*) FROM  (" + sql + ")m ";
        PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
        return pc;
    }


    public Map getTaskSchedulePercent(Integer taskId) {
        String sql = "";
        sql += "SElECT id FROM plan_base WHERE task_id = '" + taskId + "' AND is_cancel <> '已注销'";
        List total = commonDao.getSql(sql);
        sql += " AND complete = '已完成'";
        List complete = commonDao.getSql(sql);
        Integer totalNum = total.size();
        Integer completeNum = complete.size();
        Integer percent = (Integer) (completeNum * 100) / totalNum;
        Map map = new HashMap();
        map.put("totalNum", totalNum);
        map.put("completeNum", completeNum);
        map.put("percent", percent);
        return map;
    }

    public Map resetModifiedFlag(Integer taskId) {
        String sql = "";
        sql += "UPDATE plan_base SET modified_flag= '0' WHERE task_id = " + taskId;
        commonDao.updateBySql(sql);
        Map map = new HashMap();
        map.put("success", true);
        return map;
    }

    /**
     * 根据指定审核人id获取待审核的任务列表
     */
    public List getUncheckedTaskList(Integer assigned_checker_id) {
        String sql = "";
        sql += "SELECT id as task_id, task_name, report_cycle, importance, urgency, CAST (participants AS VARCHAR) AS participants from task_base where task_condition_code = 'DSH' AND assigned_checker_id = " + assigned_checker_id + " order by sup_project_id";
        List list = commonDao.getSql(sql);
        return list;
    }

    public String getAverageCompleteByProjectId(Integer project_id) {
        String sql = "";
        sql += "select complete from task_base where sup_project_id='" + project_id + "' AND task_condition_code in ('YXF','ZJXF')";
        List list = commonDao.getSql(sql);
        Integer i = 0;
        String str = "";
        Integer total = 0;
        Integer tt = 0;
        Integer average;
        if (list.size() > 0) {
            for (i = 0; i < list.size(); i++) {
                str = String.valueOf(list.get(i));
                tt = Integer.valueOf(str.substring(10, str.length() - 2));
                total += tt;
            }
            average = total / list.size();
        } else {
            average = 0;
        }
        return average + "%";
    }

    public Task getOldTask(Integer id) {
        return (Task) commonDao.getWithEvict(Task.class, id);
    }

    /**
     * 设置任务终止  （当所属模块终止时）
     *
     * @param moduleId
     * @return
     */
    public ReturnMsg resetTaskAndPlanCondition(Integer moduleId) {
        String sql = "UPDATE task_base SET task_condition_code = 'ZZ' WHERE sup_module_id = '" + moduleId + "'";
        commonDao.updateBySql(sql);
        resetPlanCondition(moduleId);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }

    public ReturnMsg updateTaskModuleName(Integer moduleId, String moduleName) {
        String sql = "UPDATE task_base SET sup_module_name = '" + moduleName + "' WHERE sup_module_id = '" + moduleId + "'";
        commonDao.updateBySql(sql);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }


    /**
     * 设置计划撤销或者终止
     *
     * @param moduleId
     * @return
     */
    public ReturnMsg resetPlanCondition(Integer moduleId) {
        String sql = "UPDATE plan_base SET is_cancel = '已注销' where complete_type = 'WKS' AND task_id in " +
                "(SELECT ID AS task_id FROM task_base WHERE sup_module_id = '" + moduleId + "') ";

        commonDao.updateBySql(sql);
        sql = " UPDATE plan_base SET complete_type = 'ZZ' where complete_type <> 'WKS' AND task_id in " +
                "(SELECT ID AS task_id FROM task_base WHERE sup_module_id = '" + moduleId + "')";
        commonDao.updateBySql(sql);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }

    public PageControl getTaskOperateLog(Map queryMap, int cpage, int len, TcUser user) {
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
            String actiontype = ((String) queryMap.get("actiontype"));
            sql += " and actiontype like '%" + StringUtils.filterBadCharsForAntiSqlInject(actiontype) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("title"))) {
            String title = ((String) queryMap.get("title"));
            sql += " and title like '%" + StringUtils.filterBadCharsForAntiSqlInject(title) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("datapermission"))) {
            String datapermission = ((String) queryMap.get("datapermission"));
            sql += " and datapermission like '%" + StringUtils.filterBadCharsForAntiSqlInject(datapermission) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("operaterdescrip"))) {
            String operaterdescrip = ((String) queryMap.get("operaterdescrip"));
            sql += " and operaterdescrip like '%" + StringUtils.filterBadCharsForAntiSqlInject(operaterdescrip) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("operatetime"))) {
            String[] order_date = ((String) queryMap.get("operatetime")).split("~");
            sql += " and to_date(operatetime,'yyyy_MM_dd') >= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[0]) + "'";
            sql += " and to_date(operatetime,'yyyy_MM_dd') <= '"
                    + StringUtils.filterBadCharsForAntiSqlInject(order_date[1]) + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("newmodel"))) {
            String newmodel = ((String) queryMap.get("newmodel"));
            sql += " and newmodel like '%" + StringUtils.filterBadCharsForAntiSqlInject(newmodel) + "%'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("oldmodel"))) {
            String oldmodel = ((String) queryMap.get("oldmodel"));
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

    public void updateAttachment(Integer taskId, String attachmentInfo){
        String sql = "";
        if(StringUtils.isNotBlankOrNull(taskId)){
            sql = "UPDATE task_base SET attachment = '"+attachmentInfo+"' WHERE id = '"+taskId+"'";
        }
        commonDao.updateBySql(sql);
    }

}
