package com.qgbest.xmgl.web.controller.operateLog;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.task.client.TaskFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/9/21.
 */
@Controller
@RequestMapping(value = "/manage/operateTaskLog")
public class OperateTaskLog extends BaseController{
    @Autowired
    private TaskFeignClient taskClient;

    @RequestMapping(value = "/initTaskOperateLog")
    public ModelAndView initTaskOperateLog() {
        Map model = new HashMap();
        HashMap<String, String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/operateLog/operateTaskLog", model);
    }

    @RequestMapping(value = "/getTaskOperateLog")
    @ResponseBody
    public Map getTaskOperateLog(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return taskClient.getTaskOperateLog(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

}

