package com.qgbest.xmgl.web.controller.navigation;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.client.permission.NavigationFeignClent;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lbb on 2017/7/13.
 * 首页的模块查询
 */
@Controller
@RequestMapping(value = "/manage/navigation")
public class NavigationController extends BaseController{
    @Autowired
    private NavigationFeignClent fgienClent;
    /**
     * 调取前几条此用户的记录
     * @throws Exception
     */
    @RequestMapping(value = "/getNavigationBefore")
    @ResponseBody
    public Map getNavigationBefore() throws Exception{
        List list = fgienClent.getCurNavigationRecord(getCurUser());
        Map map = new HashMap();
        map.put("record",list);
        return map;
    }
    /**
     * 得到模块列表
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getNavigationList")
    @ResponseBody
    public Map getNavigationList() throws Exception{
        List list = fgienClent.getNavigationList(getCurUser());
        Map map = new HashMap();
        map.put("value", list);
        return map;
    }
    /**
     *存储查询的记录
     * @throws Exception
     */
    @RequestMapping(value = "/saveNavigationRecord")
    @ResponseBody
    public Map saveNavigationRecord() throws Exception{
        String _name =  URLDecoder.decode(httpServletRequest.getParameter("_name"), "utf-8");
        String _method = httpServletRequest.getParameter("_method");
        fgienClent.saveNavigation(_name, _method,getCurUser());
        Map map = new HashMap();
        map.put("value", "");
        return map;
    }
    @RequestMapping(value = "/deleNavigationRecord")
    @ResponseBody
    public Map deleNavigationRecord() throws Exception{
        String _id = httpServletRequest.getParameter("_id");
        fgienClent.deleNavigation(Integer.valueOf(_id));
        Map map = new HashMap();
        map.put("success", true);
        return map;
    }
}
