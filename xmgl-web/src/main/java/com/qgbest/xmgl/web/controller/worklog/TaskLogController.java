package com.qgbest.xmgl.web.controller.worklog;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.client.TaskLogFeignClient;
import com.qgbest.xmgl.worklog.client.WorkLogDictionaryFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wch on 2017-07-13.
 */
@Controller
@RequestMapping(value = "/manage/taskLog")
public class TaskLogController extends BaseController {
    @Autowired
    private TaskLogFeignClient taskLogFeignClient;
    @Autowired
    private WorkLogDictionaryFeignClient workLogDictionaryFeignClient;

    /**
     * 初始项目任务日志列表页面
     * @return
     */
    @RequestMapping(value = "/initTaskLogList")
    public ModelAndView initTaskLogList() {
        Map model = new HashMap();
        List periodList= taskLogFeignClient.getPeriodList();
        HashMap<String, String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        model.put("periodList", periodList);
        return new ModelAndView("/projectTaskLog/taskLogList", model);
    }
    /**
     * 任务日志列表页面
     * @return
     */
    @RequestMapping(value = "/queryTaskLogList")
    @ResponseBody
    public Map queryTaskLogList(){

        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = taskLogFeignClient.queryTaskLogList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }

    @RequestMapping (value = "/getCompleteStatusListDic")
    @ResponseBody
    public Map getCompleteStatusListDic() {
        Map model =new HashMap();
        List completeStatusList= workLogDictionaryFeignClient.getDicListByBusinessCode("complete_status");
        model.put("completeStatusList", completeStatusList);
        return model;
    }
}
