package com.qgbest.xmgl.web.controller.operateLog;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.client.DayLogFeignClient;
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
@RequestMapping(value = "/manage/operateWorkLog")
public class OperateWorkLog extends BaseController{
    @Autowired
    private DayLogFeignClient dayLogFeignClient;

    /**
     * 初始项目任务日志列表页面
     * @return
     */
    @RequestMapping(value = "/initWorkOperateLog")
    public ModelAndView initWorkOperateLog() {
        Map model = new HashMap();
        HashMap<String, String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/operateLog/operateWorkLog", model);
    }

    @RequestMapping(value = "/getWorkOperateLog")
    @ResponseBody
    public Map getWorkOperateLog(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return dayLogFeignClient.getWorkOperateLog(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }
}
