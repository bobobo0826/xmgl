package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.api.entity.permission.TsSubSys;
import com.qgbest.xmgl.permission.client.permission.TsSubSysFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by mjq on 2017/6/6.
 */

@Controller
@RequestMapping(value = "/manage/tsSubSys")
public class TsSubSysController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(TsSubSysController.class);
    @Autowired
    public TsSubSysFeignClient tsSubSysFeignClient;
    /**
     * 初始化子系统列表
     */
    @RequestMapping(value = "/tsSubSysQueryIndex")
    public String tsSubSysQueryIndex(){
        return "/permission/subSysManager/tsSubSysList";
    }

    /**
     * 初始化详情
     * @return
     */
    @RequestMapping(value = "/tsSubSysInfoIndex")
    public String tsSubSysInfoIndex(@RequestParam("subSysId") String subSysId,ModelMap modelMap) throws Exception {
        modelMap.addAttribute("subSysId",subSysId);
        return "/permission/subSysManager/tsSubSysInfo";
    }

    /**
     * 根据Id获取详情信息
     * @return
     */
    @RequestMapping(value = "/getSubSysInfo/{id}")
    @ResponseBody
    public Map getSubSysInfo(@PathVariable String id)  {
        Map map = new HashMap();
        TsSubSys subSys=null;
        subSys = tsSubSysFeignClient.getSubSysInfo(id);
        map.put("_model",subSys);
        return map;
    }

    /**
     * 保存
     * @return
     */
    @RequestMapping(value = "/saveSubSysInfo/{isNew}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveSubSysInfo(@ModelAttribute TsSubSys subSys,@PathVariable Boolean isNew ) {
        return tsSubSysFeignClient.saveSubSysInfo(subSys,isNew);
    }

    /**
     * 删除
     * @return
     */
    @RequestMapping(value = "/delSubSysInfo")
    @ResponseBody
    public ReturnMsg delSubSysInfo()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String id=String.valueOf(String.valueOf(queryMap.get("subSysId")));
        ReturnMsg returnMsg = tsSubSysFeignClient.delSubSysInfo(id);
        return returnMsg;
    }
    /**
     * 获取列表
     * @return
     */
    @RequestMapping(value = "/tsSubSysQueryList")
    @ResponseBody
    public Map tsSubSysQueryList()  {
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = tsSubSysFeignClient.getSubSysList(JsonUtil.toJson(queryMap), len, cpage,getCurUser());
        return map;
    }

}
