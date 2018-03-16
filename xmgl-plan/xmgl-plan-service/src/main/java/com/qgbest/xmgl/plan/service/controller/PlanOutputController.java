package com.qgbest.xmgl.plan.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.service.dao.PlanOutputExtends;
import com.qgbest.xmgl.plan.service.dao.PlanOutputRepository;
import com.qgbest.xmgl.plan.api.entity.PlanOutput;
import com.qgbest.xmgl.plan.service.service.OutputProcessService;
import com.qgbest.xmgl.plan.service.service.PlanProcessService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lfm on 2017/10/27.
 */
@RestController
@Transactional
public class PlanOutputController extends BaseController{

    @Autowired
    private PlanOutputExtends planOutputExtends;
    @Autowired
    private PlanOutputRepository planOutputRepository;
    @Autowired
    private UserFeignClient userFeignClient;
    @Autowired
    private OutputProcessService outputProcessService;


    @RequestMapping(value = "/getPlanOutputList/{planId}", method = RequestMethod.GET)
    public List getPlanOutputList(@PathVariable("planId") Integer planId){
        return planOutputExtends.getPlanOutputList(planId);
    }
    @RequestMapping(value = "/getPlanOutputById/{id}", method = RequestMethod.GET)
    public PlanOutput getPlanOutputById(@PathVariable("id") Integer id){
        return planOutputRepository.getPlanOutputById(id);
    }

    @RequestMapping(value = "/deleteOutputById", method = RequestMethod.DELETE)
    public Map deleteOutputList(HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if (dataMap != null && StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            String process_status = dataMap.get("planStatus") + "";
            Integer id = ((Double) dataMap.get("id")).intValue();
            PlanOutput planOutput = planOutputRepository.getPlanOutputById(id);
            TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
            outputProcessService.saveOutputProcess(planOutput, process_status, OutputProcessService.Operate.delete, curUser);
            try {
                planOutputRepository.delPlanOutput(id);
                map.put("success", true);
            } catch (Exception e) {
                map.put("success", false);
                e.printStackTrace();
            }
        }
        return map;
    }
    @RequestMapping(value = "/savePlanOutput", method = RequestMethod.POST)
    @ResponseBody
    public Map savePlanOutput(HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        if(dataMap!=null && StringUtils.isNotBlankOrNull(dataMap.get("planOutputData"))) {
            PlanOutput planOutput = JsonUtil.fromJson(JsonUtil.toJson(dataMap.get("planOutputData")), PlanOutput.class);
            TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
            String process_status = dataMap.get("planStatus")+"";
            if(planOutput.getId()!=null){
                PlanOutput oldPlanOutput = planOutputRepository.getPlanOutputById(planOutput.getId());
                if(!planOutput.equals(oldPlanOutput)){
                    planOutputRepository.save(planOutput);
                    outputProcessService.saveOutputProcess(planOutput, process_status, OutputProcessService.Operate.update, curUser);
                }
            }else {
                planOutputRepository.save(planOutput);
                outputProcessService.saveOutputProcess(planOutput, process_status, OutputProcessService.Operate.add, curUser);
            }
        }
        Map map = new HashMap();
        map.put("success", true);
        return map;
    }
    @RequestMapping(value = "/getPlanDic/{businessType}")
    @ResponseBody
    public List getPlanDic(@PathVariable String businessType) {
        return planOutputExtends.getPlanByBusinessCode(businessType);
    }



}
