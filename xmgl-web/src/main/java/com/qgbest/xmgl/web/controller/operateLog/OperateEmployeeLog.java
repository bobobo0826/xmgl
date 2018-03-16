package com.qgbest.xmgl.web.controller.operateLog;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by quangao on 2017/9/25.
 */
@Controller
@RequestMapping(value = "/manage/operateEmployeeLog")
public class OperateEmployeeLog extends BaseController{
    @Autowired
    private EmployeeFeignClient employeeFeignClient;

    @RequestMapping(value = "/initEmployeeOperateLog")
    public ModelAndView initEmployeeOperateLog() {
        Map model = new HashMap();
        HashMap<String, String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/operateLog/operateEmployeeLog", model);
    }

    @RequestMapping(value = "/getEmployeeOperateLog")
    @ResponseBody
    public Map getEmployeeOperateLog(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return employeeFeignClient.getEmployeeOperateLog(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }
}
