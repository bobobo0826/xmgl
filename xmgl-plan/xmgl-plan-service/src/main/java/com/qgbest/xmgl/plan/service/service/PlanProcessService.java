package com.qgbest.xmgl.plan.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.api.entity.PlanProcess;
import com.qgbest.xmgl.plan.service.dao.DicRepositoryExtends;
import com.qgbest.xmgl.plan.service.dao.PlanProcessRepository;
import com.qgbest.xmgl.plan.service.dao.PlanRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 保存计划过程的接口，供controller层计划保存方法调用
 * Created by wangchao on 2017/10/10.
 */
@Service
@Transactional
public class PlanProcessService {

    @Autowired
    private PlanProcessRepository planProcessRepository;
    @Autowired
    private PlanRepository planRepository;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;


    public void savePlanProcess(String oldPlan,String newPlan, TcUser curUser) {

        PlanProcess planProcess = setPlanProcess(newPlan, curUser);
        if (oldPlan!=null){
            List changeList = getChangeList(oldPlan, newPlan);
            planProcess.setChange_info(JsonUtil.toJson(changeList));
        }
        String newCondition = String.valueOf(JsonUtil.fromJsonToMap(newPlan).get("plan_condition_code"));
        String process_opr = "";
        if (newCondition.equals("CG")){
            process_opr = "修改";
        }else if(newCondition.equals("DZX")) {
            process_opr = "提交";
        }else if(newCondition.equals("BGDTJ")){
            process_opr = "变更";
        }else if(newCondition.equals("JXZ")){
            process_opr = "确认承接";
        }else if(newCondition.equals("YWC")){
            process_opr = "确认完成";
        }else if(newCondition.equals("YZX")){
            process_opr = "注销";
        } else if(newCondition.equals("YKP")){
            process_opr = "考评";
        }
        planProcess.setProcess_opr(process_opr);
        planProcessRepository.save(planProcess);
    }


    private PlanProcess setPlanProcess(String newPlan, TcUser curUser) {
        PlanProcess planProcess = new PlanProcess();
        Plan plan = JsonUtil.fromJson(newPlan,Plan.class);
        Map planMap = JsonUtil.fromJsonToMap(newPlan);
        Map processMap = new HashMap();
        if (plan != null) {
            //从计划字段相同部分
            for (Object key : planMap.keySet()){
                if (String.valueOf(key).equals("id")){
                    processMap.put("plan_id",planMap.get(key));
                }else{
                    processMap.put(key,planMap.get(key));
                }
            }
            planProcess = JsonUtil.fromJson(JsonUtil.toJson(processMap),PlanProcess.class);
            //不同部分
            planProcess.setOperator_id((curUser != null) ? curUser.getId() : null);
            planProcess.setOperator((curUser != null) ? curUser.getDisplayName() : null);
            planProcess.setRecord_time(DateUtils.getCurDateTime2Minute());
        }

        return planProcess;
    }

    private List getChangeList(String oldPlan, String newPlan) {
        List<String> compareFieldList = new ArrayList<>
                (Arrays.asList("task_id",
                        "plan_name",
                        "plan_desc",
                        "plan_start_time",
                        "plan_end_time",
                        "plan_result_condition_code",
                        "plan_result_summary",
                        "creator",
                        "creator_id",
                        "contractor",
                        "plan_condition_code",
                        "modify_time",
                        "task_name",
                        "actual_plan_start_time",
                        "actual_plan_end_time",
                        "create_time",
                        "task_type_code",
                        "sup_project_name",
                        "sup_module_name",
                        "delay_reason"
                ));//应该从数据库里读取
        List<Map> changeList = new ArrayList<>();
        String propertyName = "";
        for (int i = 0; i < compareFieldList.size(); i++) {
            propertyName = compareFieldList.get(i);
            String oldValue = String
                    .valueOf((JsonUtil.fromJsonToMap(oldPlan)).get(propertyName));
            String newValue = String
                    .valueOf((JsonUtil.fromJsonToMap(newPlan)).get(propertyName));
            if (!equals(oldValue, newValue)) {
                Map changeInfoMap = new HashMap();
                changeInfoMap.put("change_field", propertyName);
                changeInfoMap.put("new_value", newValue);
                changeInfoMap.put("old_value", oldValue);
                changeList.add(changeInfoMap);
            }
        }
        return changeList;
    }

    private Boolean equals(String str1, String str2) {
        if (str1 == null)
            str1 = "";
        if (str2 == null)
            str2 = "";
        if (str1.equals(str2))
            return true;
        else
            return false;
    }

    /**
     * 将下拉列表的code转化为name
     * list为空则直接返回code
     * */
    public String getNameByCode(List list, String code){
        String name = "";
        if(list!=null&&list.size()>0){
            for(int i= 0;i<list.size();i++){
                Map map = (Map)list.get(i);
                if(code.equals(map.get("data_code")+"")){
                    name = map.get("data_name")+"";
                }
            }
        }else{
            name = code;
        }
        return name;
    }

}
