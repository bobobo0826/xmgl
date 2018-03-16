package com.qgbest.xmgl.plan.service.controller;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.plan.api.entity.PlanAlter;
import com.qgbest.xmgl.plan.service.dao.*;
import com.qgbest.xmgl.plan.api.entity.Plan;
import com.qgbest.xmgl.plan.service.service.PlanProcessService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by quangao on 2017/10/10.
 */
@RestController
public class PlanController extends BaseController {
    @Autowired
    private PlanRepository planRepository;
    @Autowired
    private PlanRepositoryExtends planRepositoryExtends;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;
    @Autowired
    private UserFeignClient userFeignClient;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;

    @Autowired
    private PlanAlterRepository planAlterRepository;
    @Autowired
    private PlanAlterExtends planAlterExtends;




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
    @PostMapping(value = "/getPlanList")
    public PageControl getPlanList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        System.out.println("queryMap");
        System.out.println(queryMap);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))) {
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))) {
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))) {
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        Employee curEmp = employeeFeignClient.getEmployeeInfoByUserId(curUser.getId());
        String empStr = curEmp.getId()+"~"+curEmp.getDept_name()+"~"+curEmp.getEmployee_name();
        PageControl pc = planRepositoryExtends.getPlanList(queryOptions,cpage,len,curUser,empStr);
        System.out.println(pc);
        return pc;
    }
    @RequestMapping(value = "/savePlanInfo")
    @ResponseBody
    public Map savePlanInfo(HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Plan plan = JsonUtil.fromJson(JsonUtil.toJson(dataMap), Plan.class);
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        if (plan!=null){
            plan.setCreator(curUser.getDisplayName());
            plan.setCreator_id(curUser.getId());
            if(StringUtils.isNotBlankOrNull(plan.getCreate_time())){
                plan.setModify_time(DateUtils.getCurDateTime2Minute());
            }else{
                plan.setCreate_time(DateUtils.getCurDateTime2Minute());
            }
            planRepository.save(plan);
        }
        Map map = new HashMap();
        map.put("plan",plan);
        map.put("success",true);
        return map;
    }

    @PostMapping(value = "/deletePlanById")
    public Map deletePlanById (HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))){
            Integer id = (((Double)dataMap.get("id")).intValue());
            planRepository.deletePlanById(id);
            map.put("success",true);
        }else{
            map.put("success",false);
        }
        return map;
    }

    @PostMapping(value = "/deletePlanByTaskId")
    public Map deletePlanByTaskId (HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("taskId"))){
            Integer task_id = (((Double)dataMap.get("taskId")).intValue());
            planRepository.deletePlanByTaskId(task_id);
            map.put("success",true);
        }else{
            map.put("success",false);
        }
        return map;
    }

    @PostMapping(value = "/cancelPlanByTaskId")
    public Map cancelPlanByTaskId (HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("taskId"))){
            Integer task_id = (((Double)dataMap.get("taskId")).intValue());
            planRepositoryExtends.setPlanConditionCodeByTaskId(task_id,"YZX");
            map.put("success",true);
        }else{
            map.put("success",false);
        }
        return map;
    }
    @PostMapping(value = "/cancelPlan")
    public Map cancelPlan(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            Integer id = (((Double) dataMap.get("id")).intValue());
            Plan plan = planRepository.getPlanInfoById(id);
            plan.setPlan_condition_code("YZX");
            planRepository.save(plan);
            map.put("success", true);
        } else {
            map.put("success", false);
        }
        return map;
    }

//获取下拉框
    @RequestMapping(value = "/getPlanResultDic")
    @ResponseBody
    public List getPlanResultDic() {
        return dicRepositoryExtends.getDicListByBusinessCode("plan_result_condition_code");
    }

    @RequestMapping(value = "/getPlanConditionDic")
    @ResponseBody
    public List getPlanConditionDic() {
        return dicRepositoryExtends.getDicListByBusinessCode("plan_condition_code");
    }

    @RequestMapping(value = "/getPlanInfoById/{id}")
    public Plan getPlanInfoById(@PathVariable Integer id,HttpServletRequest request) {
        Plan plan = new Plan();
        if (id != null && id != -1)
            plan = this.planRepository.getPlanInfoById(id);
        else{
            TcUser user = userFeignClient.getCurUser(request.getHeader("token"));
            System.out.println(user);
            if (user != null){
                plan.setCreator(getCurUser().getDisplayName());
            }
            System.out.println(DateUtils.getCurDateTime());
            plan.setCreate_time(DateUtils.getCurDateTime());
        }
        if (plan == null ){
            plan = new Plan();
        }
        return plan;
    }


    @PostMapping(value = "/recordPlanAlter")
    @ResponseBody
    public Map recordPlanAlter(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        Plan newPlan = JsonUtil.fromJson(JsonUtil.toJson(dataMap.get("planData")), Plan.class);
        Plan oldPlan = getPlanInfoById(newPlan.getId(),request);
        PlanAlter planAlter = generatePlanAlter(JsonUtil.toJson(newPlan), JsonUtil.toJson(oldPlan));
        TcUser user = userFeignClient.getCurUser(request.getHeader("token"));
        planAlter.setAlter_person(user.getDisplayName());
        planAlter.setAlter_person_id(user.getId());
        planAlter.setPlan_name(newPlan.getPlan_name());
        planAlter.setAlter_time(DateUtils.getCurDateTime2Minute());
        planAlter.setPlan_id(newPlan.getId());
        planAlter.setPlan_name(newPlan.getPlan_name());
        planAlter.setAlter_desc(String.valueOf(dataMap.get("alterDesc")));
        planAlterRepository.save(planAlter);
        map.put("data", planAlter);
        return map;
    }

    public PlanAlter generatePlanAlter(String newObject, String oldObject) {
        List<String> compareFieldList = new ArrayList<>
                (Arrays.asList(
                        "plan_name", "plan_type_code", "sup_project_name", "sup_module_name", "plan_desc", "participants"
                        , "report_cycle", "importance", "urgency", "detail", "expected_end_time"
                ));
        String propertyName = "";
        List<Map> alterList = new ArrayList<>();
        for (int i = 0; i < compareFieldList.size(); i++) {
            propertyName = compareFieldList.get(i);
            String oldValue = String
                    .valueOf((JsonUtil.fromJsonToMap(oldObject)).get(propertyName));
            String newValue = String
                    .valueOf((JsonUtil.fromJsonToMap(newObject)).get(propertyName));
            if (!equals(oldValue, newValue)) {
                Map alterContent = new HashMap();
                alterContent.put("field_name", propertyName);
                alterContent.put("new_value", newValue);
                alterContent.put("old_value", oldValue);
                alterList.add(alterContent);
            }
        }
        PlanAlter planAlter = new PlanAlter();
        planAlter.setAlter_content(JsonUtil.toJson(alterList));
        return planAlter;
    }
    @RequestMapping(value = "/getAlterMark/{plan_id}")
    @ResponseBody
    public List getAlterMark(@PathVariable Integer plan_id) {
        List lastAlterInfo = this.planAlterExtends.getLastAlterInfo(plan_id);
        return lastAlterInfo;
    }

    @RequestMapping(value = "/updateAttachment")
    public void updateAttachment(HttpServletRequest request){
        Map queryMap = getRequestPayload(request);
        if(queryMap!=null&& StringUtils.isNotBlankOrNull(queryMap.get("planId"))){
            Integer planId = ((Double)queryMap.get("planId")).intValue();
            System.out.println(JsonUtil.toJson(queryMap.get("attachmentInfo")));
            planRepositoryExtends.updateAttachment(planId,JsonUtil.toJson(queryMap.get("attachmentInfo")));
        }
    }
    @PostMapping(value = "/alterPlanByTaskId")
    @ResponseBody
    public Map alterPlanByTaskId(HttpServletRequest request) {
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        Integer taskId = ((Double)dataMap.get("taskId")).intValue();
        planRepositoryExtends.setPlanConditionCodeByTaskId(taskId,"BGDTJ");
        map.put("SUCCESS",true);
        return map;
    }


}
