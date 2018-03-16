package com.qgbest.xmgl.task.service.controller;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.task.api.entity.*;
import com.qgbest.xmgl.task.service.dao.*;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.user.client.UserFeignClient;
/**
 * Created by quangao on 2017/9/28.
 */
@Api(value = "任务考评结果", description = "提供任务考评结果增删改查API")
@RestController
@Transactional
public class EvaluateController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(EvaluateController.class);
    @Autowired
    private EvaluateExtends evaluateExtends;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;
    @Autowired
    private EvaluateRepository evaluateRepository;
    @Autowired
    private TaskEvaluateResultRepository taskEvaluateResultRepository;
    @Autowired
    private TaskEvaluateResultExtends taskEvaluateResultExtends;
    @Autowired
    private EmployeeEvaluateResultExtends employeeEvaluateResultExtends;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;
    @Autowired
    private EmployeeEvaluateResultRepository employeeEvaluateResultRepository;
    @Autowired
    private TaskRepository taskRepository;
    @Autowired
    private UserFeignClient userFeignClient;

//任务评估结果表
    /**
     * 获取任务评估结果
     * @return
     */
    @PostMapping(value = "/getTaskEvaluateResultList")
    public PageControl getTaskEvaluateResultList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = taskEvaluateResultExtends.getTaskEvaluateResultList(queryOptions,cpage,len,getCurUser());
        return pc;
    }
    /**
     * 根据任务id获取任务评估结果
     * @return
     */
    @PostMapping(value = "/getTaskEvaluateResultListByTaskId/{task_id}")
    public PageControl getTaskEvaluateResultListByTaskId(@PathVariable Integer task_id,HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = taskEvaluateResultExtends.getTaskEvaluateResultListByTaskId(queryOptions,cpage,len,getCurUser(),task_id);
        return pc;
    }
    /**
     * 保存更新任务结果表
     * @return
     */
    @PostMapping(value = "/updateAndSaveTaskResult/{task_id}")
    public void updateAndSaveTaskResult (@PathVariable Integer task_id){
        List list= evaluateExtends.getEvaluationByTaskId(task_id);
        Task task=taskRepository.getTaskInfoById(task_id);
        String str="";
        String[] strArray1=new String[50];
        String[] strArray2=new String[50];
        String[] strArray3=new String[50];
        String level="";
        Integer level_score=0;
        Integer score_sum=0;
        Integer average_score=0;
        String[] modify_time=new String[50];
        Integer modify_time_id=0;
        String biggest_modify_time="";
        String task_name=task.getTask_name();
        if (list.size()>0){
            for(int i=0;i<list.size();i++)
            {
                str = String.valueOf(list.get(i));
                strArray1=str.split(",");
                strArray2=strArray1[10].split("=");
                if(strArray2.length>1){
                    level=strArray2[1];
                    if(level.equals("YX"))
                    {
                        level_score=90;
                    }
                    if(level.equals("LH"))
                    {
                        level_score=80;
                    }
                    if(level.equals("YB"))
                    {
                        level_score=70;
                    }
                    if(level.equals("C"))
                    {
                        level_score=60;
                    }
                    if(level.equals("JC"))
                    {
                        level_score=50;
                    }
                }
                score_sum=score_sum+level_score;
                strArray3=strArray1[11].split("=");
                if(strArray3.length>1){
                    String[] strArray4=strArray3[1].split("}");
                    modify_time[modify_time_id]=strArray4[0];
                    modify_time_id++;
                }/*else{
                    String[] strArray4=strArray1[11].split("=");
                    String[] strArray5=strArray4[1].split("}");
                    biggest_modify_time=strArray5[0];
                }*/

            }
            average_score=score_sum/list.size();
            if(modify_time_id>0){
                biggest_modify_time=modify_time[0];
                for(int j=0;j<modify_time_id-1;j++){

                    if(biggest_modify_time.compareTo(modify_time[j])<0){
                        biggest_modify_time=modify_time[j];
                    }
                }
            }

        }

        TaskEvaluateResult taskEvaluateResult=new TaskEvaluateResult();
        List taskEvaluateResultList=taskEvaluateResultExtends.getTaskEvaluateResultByTaskId(task_id);
        if(taskEvaluateResultList.size()>0){
            taskEvaluateResultExtends.UpdateTaskEvaluateResultInfo(task_id,biggest_modify_time,average_score);
        }else{
            taskEvaluateResult.setTask_id(task_id);
            taskEvaluateResult.setTask_name(task_name);
            taskEvaluateResult.setModify_time(biggest_modify_time);
            taskEvaluateResult.setAverage_score(average_score);
            taskEvaluateResultRepository.save(taskEvaluateResult);
        }
    }


    //考评详情表
    /**
     * 获取考评详情表
     * @return
     */
    @PostMapping(value = "/getEvaluationList")
    public PageControl getEvaluationList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = evaluateExtends.getEvaluationList(queryOptions,cpage,len,getCurUser());
        return pc;
    }
    /**
     * 根据任务id获取考评详情
     * @return
     */
    @PostMapping(value = "/getEvaluationListByTaskId/{task_id}")
    public PageControl getEvaluationListByTaskId(@PathVariable Integer task_id,HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = evaluateExtends.getEvaluationListByTaskId(queryOptions,cpage,len,getCurUser(),task_id);
        return pc;
    }
    /**
     * 根据任务ID员工ID获取考评详情
     * @return
     */
    @PostMapping(value = "/getEvaluationListByEmployeeId/{task_id}/{employee_id}")
    public PageControl getEvaluationListByEmployeeId(@PathVariable Integer task_id,@PathVariable Integer employee_id,HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        Employee employee=employeeFeignClient.getEmployeeInfoById(employee_id);
        String single_contractor=employee.getId()+"~"+employee.getDept_name()+"~"+employee.getEmployee_name();
        PageControl pc = evaluateExtends.getEvaluationListByEmployeeId(queryOptions,cpage,len,getCurUser(),single_contractor,task_id);
        return pc;
    }

    /**
     * 根据id读取考评详情表
     * @return
     */
    @PostMapping(value = "/getEvaluationInfoById/{id}")
    public Evaluation getEvaluationInfoById(@PathVariable Integer id) {
        Evaluation evaluation;
        evaluation = evaluateRepository.getEvaluationInfoById(id);
        return evaluation;
    }
    /**
     * 根据task_id读取考评详情表
     * @return
     */
    @PostMapping(value = "/getEvaluationByTaskId")
    public List getEvaluationByTaskId(@PathVariable Integer task_id) {
        List list = evaluateExtends.getEvaluationByTaskId(task_id);
        return list;
    }
    /**
     * 保存考评详情
     * @return
     */
    @RequestMapping(value = "/saveEvaluation")
    @ResponseBody
    public Map saveEvaluation(HttpServletRequest request) {
        Map data = getRequestPayload(request);
        Evaluation evaluation= JsonUtil.fromJson(JsonUtil.toJson(data), Evaluation.class);
        if(evaluation!=null){
            String evaluate_object=evaluation.getEvaluate_object_code();
            if(StringUtils.isNotBlankOrNull(evaluation.getEvaluate_time())){
                evaluation.setModify_time(DateUtils.getCurDateTime2Minute());
            }else{
                evaluation.setEvaluate_time(DateUtils.getCurDateTime2Minute());
            }
            if(evaluate_object.equals("TASK")){
                evaluation.setSingle_contractor(" ");
            }
            if(evaluation.getModify_time()==null){
                evaluation.setModify_time("");
            }
            TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
            evaluation.setEvaluate_people(curUser.getDisplayName());
            evaluateRepository.save(evaluation);
            System.out.println("!!!!!!!!!!!!evaluation="+evaluation);
            if(evaluate_object.equals("TASK")){
                updateAndSaveTaskResult(evaluation.getTask_id());
            }
            else if(evaluate_object.equals("PEOPLE")){
                String[] employee=evaluation.getSingle_contractor().split("~");
                Integer employee_id= Integer.valueOf(employee[0]);
                updateAndSaveEmployeeResult(evaluation.getTask_id(),employee_id,evaluation.getEvaluate_type_code());
            }

        }
        Map map = new HashMap();
        map.put("success",true);
        return map;

    }
    /**
     * 删除考评详情
     * @return
     */
    @PostMapping(value = "/deleteEvaluation")
    public Map deleteEvaluation (HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (StringUtils.isNotBlankOrNull(dataMap.get("id"))){
            Integer id = (((Double)dataMap.get("id")).intValue());
            Evaluation evaluation=evaluateRepository.getEvaluationInfoById(id);
            evaluateRepository.delEvaluation(id);
            if(evaluation.getEvaluate_object_code().equals("TASK")){
                updateAndSaveTaskResult(evaluation.getTask_id());
            }else if(evaluation.getEvaluate_object_code().equals("PEOPLE")){
                String[] employee=evaluation.getSingle_contractor().split("~");
                Integer employee_id= Integer.valueOf(employee[0]);
                updateAndSaveEmployeeResult(evaluation.getTask_id(),employee_id,evaluation.getEvaluate_type_code());
            }
            map.put("success",true);
        }else{
            map.put("success",false);
        }
        return map;
    }

    //字典表
    /**
     * 获取下拉框
     * @return
     */
    @RequestMapping(value = "/getEvaluateLevelDic")
    @ResponseBody
    public List getEvaluateLevelDic() {
        return dicRepositoryExtends.getDicListByBusinessCode("evaluate_level_code");
    }

    @RequestMapping(value = "/getEvaluateTypeDic")
    @ResponseBody
    public List getEvaluateTypeDic() {
        return dicRepositoryExtends.getDicListByBusinessCode("evaluate_type_code");
    }

    @RequestMapping(value = "/getEvaluateObjectDic")
    @ResponseBody
    public List getEvaluateObjectDic() {
        return dicRepositoryExtends.getDicListByBusinessCode("evaluate_object_code");
    }

    @RequestMapping(value = "/getEvaluateSupTypeList/{evaluate_type}")
    @ResponseBody
    public List getEvaluateSupTypeList(@PathVariable String evaluate_type) {
        return  dicRepositoryExtends.getDicSupTypeListByParentCode(evaluate_type);
    }
    @PostMapping(value = "/getTaskTypeDic")
    public List getTaskTypeDic () {
        return dicRepositoryExtends.getDicListByBusinessCode("task_type");
    }

    /**
     * 根据parentCode获取子类别
     * @return
     */
    @RequestMapping(value = "/getDicSupTypeListByParentCode/{parentCode}",method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    public List getDicSupTypeListByParentCode(@PathVariable String parentCode){
        List list = dicRepositoryExtends.getDicSupTypeListByParentCode(parentCode);
        return list;
    }




   //员工结果表
    /**
     * 获取员工评估结果表
     * @return
     */
    @PostMapping(value = "/getEmployeeEvaluateResultList")
    public PageControl getEmployeeEvaluateResultList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = employeeEvaluateResultExtends.getEmployeeEvaluateResultList(queryOptions,cpage,len,getCurUser());
        return pc;
    }
    /**
     * 根据员工id获取员工评估结果
     * @return
     */
    @PostMapping(value = "/getEmployeeEvaluateResultListByEmployeeId/{employeeId}/{task_id}")
    public PageControl getEmployeeEvaluateResultListByEmployeeId(@PathVariable String employeeId,@PathVariable Integer task_id,HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("curPage"))){
            cpage = ((Double) queryMap.get("curPage")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        PageControl pc = employeeEvaluateResultExtends.getEmployeeEvaluateResultListByEmployeeId(queryOptions,cpage,len,getCurUser(),employeeId,task_id);
        return pc;
    }

    /**
     * 保存更新员工结果表
     * @return
     */
    @PostMapping(value = "/updateAndSaveEmployeeResult/{task_id}/{employee_id}/{evaluate_type_code}")
    public void updateAndSaveEmployeeResult (@PathVariable Integer task_id,@PathVariable Integer employee_id,@PathVariable String evaluate_type_code){
        Employee employee=employeeFeignClient.getEmployeeInfoById(employee_id);
        String single_contractor=employee.getId()+"~"+employee.getDept_name()+"~"+employee.getEmployee_name();
        List list= evaluateExtends.getEvaluationByEmpIdAndEvaType(task_id,single_contractor,evaluate_type_code);
        Task task=taskRepository.getTaskInfoById(task_id);
        System.out.println("!!!!!!!!!!!!!list="+list);
        String str="";
        String[] strArray1=new String[50];
        String[] strArray2=new String[50];
        String[] strArray3=new String[50];
        String level="";
        Integer level_score=0;
        Integer score_sum=0;
        Integer average_score=0;
        String[] modify_time=new String[50];
        Integer modify_time_id=0;
        String biggest_modify_time="";
        String employee_name=employee.getEmployee_name();
        String task_name=task.getTask_name();
        if (list.size()>0){
            for(int i=0;i<list.size();i++)
            {
                str = String.valueOf(list.get(i));
                strArray1=str.split(",");
                strArray2=strArray1[10].split("=");
                if(strArray2.length>1){
                    level=strArray2[1];
                    if(level.equals("YX"))
                    {
                        level_score=90;
                    }
                    if(level.equals("LH"))
                    {
                        level_score=80;
                    }
                    if(level.equals("YB"))
                    {
                        level_score=70;
                    }
                    if(level.equals("C"))
                    {
                        level_score=60;
                    }
                    if(level.equals("JC"))
                    {
                        level_score=50;
                    }
                }
                score_sum=score_sum+level_score;
                strArray3=strArray1[11].split("=");
                if(strArray3.length>1){
                    String[] strArray4=strArray3[1].split("}");
                    modify_time[modify_time_id]=strArray4[0];
                    modify_time_id++;
                }/*else{
                    String[] strArray4=strArray1[11].split("=");
                    String[] strArray5=strArray4[1].split("}");
                    biggest_modify_time=strArray5[0];
                }*/
                //System.out.println("!!!!!!!!!!!!!biggest_modify_time1="+biggest_modify_time);
            }
            average_score=score_sum/list.size();
            if(modify_time_id>0){
                biggest_modify_time=modify_time[0];
                for(int j=0;j<modify_time_id-1;j++){

                    if(biggest_modify_time.compareTo(modify_time[j])<0){
                        biggest_modify_time=modify_time[j];
                    }
                }
            }
        }
        EmployeeEvaluateResult employeeEvaluateResult=new EmployeeEvaluateResult();
        List employeeEvaluateResultList=employeeEvaluateResultExtends.getTaskEvaluateResultByTaskIdAndEmpId(task_id,employee_id,evaluate_type_code);
        if(employeeEvaluateResultList.size()>0){
            employeeEvaluateResultExtends.UpdateTaskEvaluateResultInfo(task_id,employee_id,biggest_modify_time,average_score);
        }else{
            employeeEvaluateResult.setTask_id(task_id);
            employeeEvaluateResult.setModify_time(biggest_modify_time);
            employeeEvaluateResult.setEmployee_id(employee_id);
            employeeEvaluateResult.setEvaluate_type_code(evaluate_type_code);
            employeeEvaluateResult.setAverage_type(average_score);
            employeeEvaluateResult.setEmployee_name(employee_name);
            employeeEvaluateResult.setTask_name(task_name);
            employeeEvaluateResultRepository.save(employeeEvaluateResult);
        }

    }


}
