package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.client.permission.ModuleAndRoleOprStatusFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/moduleAndRoleOprStatus")
public class ModuleAndRoleOprStatusController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(ModuleAndRoleOprStatusController.class);
    @Autowired
    private ModuleAndRoleOprStatusFeignClient moduleAndRoleOprStatusFeignClient;

    /**
     * 初始化模块角色操作状态管理界面
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/tsMROQuery")
    public String tsMROQuery(ModelMap modelMap){
        List oprList= moduleAndRoleOprStatusFeignClient.getOprList();
        modelMap.addAttribute("oprList",oprList);
        return "/permission/moduleOprRoleStatus/tsModuleOprRoleStatus";
    }

    /**
     * 获取列表信息
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/tsMROQueryList")
    @ResponseBody
    public Map tsMROQueryList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map  = moduleAndRoleOprStatusFeignClient.tsMROQueryList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }

    /**
     * 根据id删除信息
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/tsMROdel")
    @ResponseBody
    public ReturnMsg tsMROdel(){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        String id=String.valueOf(queryMap.get("id"));
        ReturnMsg returnMsg = moduleAndRoleOprStatusFeignClient.tsMROdel(id);
        return returnMsg;
    }

    /**
     * 初始化模块角色操作状态详情信息
     * @return
     */
    @RequestMapping(value="/tsMROIndex")
    public ModelAndView tsMROIndex(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map modelMap = new HashMap();
        List moduleList= moduleAndRoleOprStatusFeignClient.getModuleList();
        modelMap.put("moduleId",queryMap.get("moduleId"));
        modelMap.put("roleCode",queryMap.get("roleCode"));
        modelMap.put("moduleList",moduleList);
        return new ModelAndView("/permission/moduleOprRoleStatus/tsModuleOprRoleStatusInfo",modelMap);
    }
    /**
     * 根据模块id和角色获取模块角色操作详细信息
     * @return
     */
    @RequestMapping(value = "/getMRSByModuleIdAndRoleCode")
    @ResponseBody
    public Map getMRSByModuleIdAndRoleCode(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map=new HashMap();
        map.put("moduleId",queryMap.get("moduleId"));
        map.put("roleCode",queryMap.get("roleCode"));
        return map;
    }

    /**
     * 根据模块id和角色获取模块角色操作状态列表
     * @return
     */
    @RequestMapping(value = "/getMRSListByModuleIdAndRoleCode")
    @ResponseBody
    public Map getMRSListByModuleIdAndRoleCode(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map = new HashMap();
        String moduleId = String.valueOf(queryMap.get("moduleId"));
        String roleCode = String.valueOf(queryMap.get("roleCode"));
        List list = moduleAndRoleOprStatusFeignClient.getMRSByModuleIdAndRoleCode(moduleId, roleCode);
        map.put("list",list);
        return map;
    }

    /**
     * 根据模块id获取角色列表
     * @return
     */
    @RequestMapping(value = "/getRoleInfoByModuleId")
    @ResponseBody
    public Map getRoleInfoByModuleId(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map=new HashMap();
        String moduleId = String.valueOf(queryMap.get("moduleId"));
        if(StringUtils.isNotBlankOrNull(moduleId)){
            List list= moduleAndRoleOprStatusFeignClient.getRoleInfoByModuleId(moduleId);
            map.put("list",list);
        }
        return map;
    }

    /**
     * 根据模块id和角色获取操作列表
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getTcOprList")
    @ResponseBody
    public Map getTcOprList() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map=new HashMap();
        String moduleId = String.valueOf(queryMap.get("moduleId"));
        String roleCode = String.valueOf(queryMap.get("roleCode"));
        if (StringUtils.isEmpty(moduleId))
            moduleId = "0";
        if (StringUtils.isEmpty(roleCode))
            roleCode = "0";
        List list= moduleAndRoleOprStatusFeignClient.getTcOprList(moduleId, roleCode);
        map.put("list",list);
        return map;
    }

    /**
     * 获取状态列表
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getStatus")
    @ResponseBody
    public Map getStatus() throws Exception {
        Map map=new HashMap();
        List list= moduleAndRoleOprStatusFeignClient.getStatusList();
        map.put("list",list);
        return map;
    }

    /**
     * 获取返回值列表
     * @return
     */
    @RequestMapping(value = "/getMapRetValue")
    @ResponseBody
    public Map getMapRetValue() {
        Map map=new HashMap();
        List list= moduleAndRoleOprStatusFeignClient.getMapRetValueList();
        map.put("list",list);
        return map;
    }

    /**
     * 保存模块角色操作状态信息
     * @return
     */
    @RequestMapping(value = "/save",method= RequestMethod.PUT,produces="application/json;charset=UTF-8")
    @ResponseBody
    public Map save(@RequestParam("moduleId") String moduleId, @RequestParam("roleCode") String roleCode, @RequestParam("oprListData") String oprListData){
        Map map=new HashMap();
        if(StringUtils.isNotBlankOrNull(oprListData)){
            try {
                moduleAndRoleOprStatusFeignClient.save(oprListData);
                map.put("msgCode","success");
                map.put("msgDesc","保存成功");
            } catch (Exception e) {
                e.printStackTrace();
                map.put("msgCode","failure");
                map.put("msgDesc","保存失败");
            }
        }else{
            map.put("msgCode","failure");
            map.put("msgDesc","保存失败");
        }
        map.put("moduleId",moduleId);
        map.put("roleCode",roleCode);
        map.put("list",oprListData);
        return map;
    }
}
