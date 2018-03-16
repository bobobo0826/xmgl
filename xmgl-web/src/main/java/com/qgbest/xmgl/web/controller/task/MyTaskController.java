package com.qgbest.xmgl.web.controller.task;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.task.client.*;
import com.qgbest.xmgl.plan.client.PlanFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by mjq on 2017/7/26.
 */
@Controller
@RequestMapping(value = "/manage/myTask")
public class MyTaskController extends BaseController {
    @Autowired
    private MyTaskFeignClient myTaskFeignClient;
    @Autowired
    private TaskSysdataGridPersonConfigFeginClient taskSysdataGridPersonConfigFeginClient;
    @Autowired
    private TaskSysdataGridDefaultConfigFeginClient taskSysdataGridDefaultConfigFeginClient;
    @Autowired
    private TaskSystemConfigFeignClient taskSystemConfigFeignClient;
    @Autowired
    private TaskDictionaryFeignClient taskDictionaryFeignClient;
    @Autowired
    private TaskFeignClient taskFeignClient;
    @Autowired
    private PlanFeignClient planFeignClient;


    /**
     * 初始化我的任务列表
     */

    @RequestMapping(value = "/initMyTaskList")
    public ModelAndView initMyTaskList() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        Integer UserId=getCurUser().getId();
        model.put("UserId", UserId);
        return new ModelAndView( "/taskManager/myTask/myTaskList",model);
    }
    /**
     * 初始化详情
     *
     * @return
     */
    @RequestMapping(value = "/initMyTaskInfo/{plan_id}/{task_id}")
    public ModelAndView initMyTaskInfo(@PathVariable Integer plan_id,@PathVariable Integer task_id) {
        Map model =new HashMap();
        model.put("plan_id", plan_id);
        model.put("task_id", task_id);
        Integer UserId=getCurUser().getId();
        model.put("UserId", UserId);
        model.put("imageUrl",this.imageUrl);
        return new ModelAndView("/taskManager/myTask/myTaskInfo",model);
    }
    /**
     * 获取我的任务管理列表
     *
     * @return
     */
    @RequestMapping(value = "/myTaskQueryList/{taskType}")
    @ResponseBody
    public Map myTaskQueryList(@PathVariable String taskType) {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        return planFeignClient.getPlanQueryList(JsonUtil.toJson(queryMap), len, cpage, getCurUser(),taskType);

    }

    /**
     * 根据Id获取详情信息
     *
     * @return
     */
    @RequestMapping(value = "/getMyTaskInfo/{id}")
    @ResponseBody
    public Map getMyTaskInfo(@PathVariable Integer id) {
        Map map = new HashMap();
        Plan plan = myTaskFeignClient.getMyTaskInfoById(id);
        map.put("plan", plan);
        return map;
    }

    @RequestMapping(value = "/getMyTaskTaskTypeDic")
    @ResponseBody
    public Map getMyTaskTaskTypeDic() {
        Map model =new HashMap();
        List taskTypeList= taskDictionaryFeignClient.getDicListByBusinessCode("task_type");
        model.put("taskTypeList", taskTypeList);
        return model;
    }

    @RequestMapping(value = "/getPlanCompleteDic")
    @ResponseBody
    public Map getPlanCompleteDic() {
        Map model =new HashMap();
        List planComplete= taskDictionaryFeignClient.getDicListByBusinessCode("plan_complete");
        model.put("planComplete", planComplete);
        return model;
    }

    @RequestMapping(value = "/getGridStyle")
    @ResponseBody
    public Map getGridStyle()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map map =new HashMap();
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        SysdataGridPersonConfig personConfig= taskSysdataGridPersonConfigFeginClient.getConfvalByIdAndCode(getCurUser().getId(), curModuleCode);
        if (null != personConfig) {
            map.put("gridStyle", personConfig.getConf_val());
        } else {
            List defaultConfig = taskSysdataGridDefaultConfigFeginClient.getConfVal(curModuleCode);
            map.put("gridStyle",defaultConfig.get(0));
        }
        return map;
    }

    /**
     * datagrid样式保存
     * @return
     */
    @RequestMapping(value = "/saveGridStyle")
    @ResponseBody
    public ReturnMsg saveGridStyle() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        String gridStyle=String.valueOf(queryMap.get("_gridStyle"));
        ReturnMsg returnMsg= taskSysdataGridPersonConfigFeginClient.savePersonGridStyle(gridStyle, curModuleCode,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }
    @RequestMapping(value = "/showGridColumn")
    public ModelAndView showGridColumn()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String columnFiled=String.valueOf(queryMap.get("_columnFiled"));
        String columnTitle=String.valueOf(queryMap.get("_columnTitle"));
        String columnsHidden=String.valueOf(queryMap.get("_columnsHidden"));
        Map model =new HashMap();
        model.put("_columnFiled",columnFiled);
        model.put("_columnTitle",columnTitle);
        model.put("_columnsHidden",columnsHidden);
        return new ModelAndView("/sysdataGridDefaultConfig/showDataGridColumn",model);
    }


    @RequestMapping(value = "/getParticipantsListById/{id}")
    @ResponseBody
    public Map getParticipantsListById(@PathVariable Integer id){
        return myTaskFeignClient.getParticipantsListById(id);
    }

    @RequestMapping(value = "/selectMyPlan/{taskType}")
    public ModelAndView selectTask(@PathVariable String taskType){
        Map model= getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode","XZMYJH");
        model.put("taskType",taskType);
        return new ModelAndView("/taskManager/myTask/selectMyPlan",model);
    }
    @RequestMapping(value = "/getUnCompletePlan")
    @ResponseBody
    public Map getUnCompletePlan() {
        return myTaskFeignClient.getUnCompletePlan(getCurUser());

    }
    @RequestMapping(value = "/getPlanFlag")
    @ResponseBody
    public Map getPlanFlag() {
        return myTaskFeignClient.getUnCompletePlan(getCurUser());

    }
    @RequestMapping(value = "/getCompleteTypeDic")
    @ResponseBody
    public Map getCompleteTypeDic() {
        Map model =new HashMap();
        List complete_type= taskDictionaryFeignClient.getDicListByBusinessCode("complete_type");
        model.put("complete_type", complete_type);
        return model;
    }








}
