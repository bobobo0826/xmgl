package com.qgbest.xmgl.web.controller.log;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.log.client.LogManagerFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by SheTaoTao on 2017/6/5.
 */

@Controller
//requestMapping注解，是一个用来处理请求地址映射的注解，可用于类或方法上
@RequestMapping(value = "/manage/log")
public class LogManagerController extends BaseController {
    @Autowired
    private LogManagerFeignClient logManagerClient;

    /**
     * 初始化日志管理界面
     *
     * @return
     */
    @RequestMapping(value = "/logmanager")
    public String LogManager(ModelMap modelMap) {
        //获得模块类型
        List modelTypeList = logManagerClient.getModelTypeList();
        modelMap.addAttribute("modelTypeList", modelTypeList);
        return "/permission/logmanager/LogManagerList";
    }

    /**
     * 获取日志操作类型
     * @return
     */
    @RequestMapping(value = "/getOperate/{id}")
    @ResponseBody
    public Map getOperate(@PathVariable Integer id) {
        Map map = new HashMap();
        List operateType = logManagerClient.getOperateTypeList(id);
        map.put("operateTypeList", operateType.toString());
        return map;
    }

    /**
     * 日志分页查询
     * @return
     */
    @RequestMapping(value = "/getLogList")
    @ResponseBody
    public Map getLogList()  {
        Map conditionMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map resultMap = new HashMap();
        resultMap = logManagerClient.getPagingList(JsonUtil.toJson(conditionMap), len, cpage);
        return resultMap;
    }

    /**
     * 初始化日志详情
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/indexLogInfo")
    public ModelAndView indexLogInfo() throws IOException {
        Map conditionMap = getRequestMapStr2Str(httpServletRequest);
        String detail = String.valueOf(conditionMap.get("_logInfoStr"));
        Map model = new HashMap();
        model.put("detailInfo", detail);
        return new ModelAndView("/permission/logmanager/LogMangerInfo", model);
    }

}
