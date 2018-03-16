package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.api.entity.TaskProcess;
import com.qgbest.xmgl.task.service.dao.DicRepositoryExtends;
import com.qgbest.xmgl.task.service.dao.TaskProcessRepository;
import com.qgbest.xmgl.task.service.dao.TaskRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import springfox.documentation.spring.web.json.Json;

import java.util.*;

/**
 * Created by wangchao on 2017/10/12.
 */
@Service
@Transactional
public class TaskProcessService {
    @Autowired
    private TaskProcessRepository taskProcessRepository;
    @Autowired
    private TaskRepository taskRepository;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;

    /**
     * 已有该task情况下
     * 在保存之前调用
     */
    public void saveTaskProcess(String oldTask,String newTask, TcUser curUser) {

        TaskProcess taskProcess = setTaskProcess(newTask, curUser);
        if (oldTask!=null){
            List changeList = getChangeList(oldTask, newTask);
            taskProcess.setChange_info(JsonUtil.toJson(changeList));
        }
        String newCondition = String.valueOf(JsonUtil.fromJsonToMap(newTask).get("task_condition_code"));
        String process_opr = "";
        if (newCondition.equals("CG")){
            process_opr = "修改";
        }else if(newCondition.equals("DCJ")) {
            process_opr = "提交";
        }else if(newCondition.equals("BGDPG")){
            process_opr = "变更";
        }else if(newCondition.equals("BGDTJ")){
            process_opr = "修改";
        }else if(newCondition.equals("JXZ")){
            process_opr = "确认承接";
        }else if(newCondition.equals("YWC")){
            process_opr = "确认完成";
        }else if(newCondition.equals("YKP")){
            process_opr = "考评";
        }
        taskProcess.setProcess_opr(process_opr);
        taskProcessRepository.save(taskProcess);
    }


    private TaskProcess setTaskProcess(String newTask, TcUser curUser) {
        TaskProcess taskProcess = new TaskProcess();
        Task task = JsonUtil.fromJson(newTask,Task.class);
        Map taskMap = JsonUtil.fromJsonToMap(newTask);
        Map processMap = new HashMap();
        if (task != null) {
            //从计划字段相同部分
            for (Object key : taskMap.keySet()){
                if (String.valueOf(key).equals("id")){
                    processMap.put("task_id",taskMap.get(key));
                }else{
                    processMap.put(key,taskMap.get(key));
                }
            }
            taskProcess = JsonUtil.fromJson(JsonUtil.toJson(processMap),TaskProcess.class);
            //不同部分
            taskProcess.setOperator_id((curUser != null) ? curUser.getId() : null);
            taskProcess.setOperator((curUser != null) ? curUser.getDisplayName() : null);
            taskProcess.setRecord_time(DateUtils.getCurDateTime2Minute());
        }

        return taskProcess;
    }

    private List getChangeList(String oldTask, String newTask) {
        List<String> compareFieldList = new ArrayList<>
                (Arrays.asList(
                        "task_name", "task_type_code", "sup_project_id", "sup_project_name",
                        "sup_module_id","sup_module_name","complete", "task_desc", "participants",
                        "report_cycle_code","sup_task_id","sup_task_name", "importance",
                        "task_condition_code","urgency", "detail", "expected_end_time"
                ));//应该从数据库里读取
        List<Map> changeList = new ArrayList<>();
        String propertyName = "";
        for (int i = 0; i < compareFieldList.size(); i++) {
            propertyName = compareFieldList.get(i);
            String oldValue = String
                    .valueOf((JsonUtil.fromJsonToMap(oldTask)).get(propertyName));
            String newValue = String
                    .valueOf((JsonUtil.fromJsonToMap(newTask)).get(propertyName));
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

    /**
     * 将下拉列表的code转化为name
     * list为空则直接返回code
     */
    public String getNameByCode(List list, String code) {
        String name = "";
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                Map map = (Map) list.get(i);
                if (code.equals(map.get("data_code") + "")) {
                    name = map.get("data_name") + "";
                }
            }
        } else {
            name = code;
        }
        return name;
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

}

