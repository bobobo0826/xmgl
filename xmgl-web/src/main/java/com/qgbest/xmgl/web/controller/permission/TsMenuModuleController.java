package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.permission.TsMenuModule;
import com.qgbest.xmgl.permission.client.permission.TSMenuModuleFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/menuModule")
public class TsMenuModuleController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TsMenuModuleController.class);
    @Autowired
    private TSMenuModuleFeignClient tsMenuModuleFeignClient;
    @RequestMapping(value = "/menuTreeIndex")
    public String menuTreeIndex() {
        logger.info("进入添加用户角色页面");
        return "/permission/menuAndModule/menuManagerMain";
    }
    @RequestMapping(value = "/menuItemAddIndex")
    public String menuItemAddIndex(ModelMap modelMap,HttpServletRequest request) {
        logger.info("进入新增");
        modelMap.addAttribute("subSysId",request.getParameter("subSysId"));
        modelMap.addAttribute("_parentId",request.getParameter("parentItemId"));
        modelMap.addAttribute("_pid",request.getParameter("pid"));
        return "/permission/menuAndModule/menuManagerRight";
    }
    @RequestMapping(value = "/menuItemIndex")
    public String menuItemIndex(ModelMap modelMap,HttpServletRequest request) {
        logger.info("进入详情");
        modelMap.addAttribute("_id",request.getParameter("_id"));
        return "/permission/menuAndModule/menuManagerRight";
    }
   @RequestMapping(value="/menuTreeList",method = RequestMethod.POST)
    @ResponseBody
    public List menuTreeList(){
        List list = tsMenuModuleFeignClient.getMenuTreeList(httpServletRequest.getParameter("_id"));
        return list;
    }

    @RequestMapping(value="/getMenuModuleInfo",produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getMenuModuleInfo(ModelMap modelMap,HttpServletRequest request){
        Map map = new HashMap();
        TsMenuModule model = null;
        if (StringUtils.isNotBlankOrNull(request.getParameter("_id"))){
            try{
                model=tsMenuModuleFeignClient.getMenuModuleInfo(request.getParameter("_id"));
                String _modelIdOld = model.getModuleId();
                modelMap.addAttribute("_modelIdOld",_modelIdOld);
                modelMap.addAttribute("menuModuleId",model.getMenuModuleId());
                modelMap.addAttribute("subSysId",model.getSubSysId());
                modelMap.addAttribute("menuItemId",model.getMenuItemId());
                modelMap.addAttribute("level",model.getLevel());
                modelMap.addAttribute("isLeaf",model.getIsLeaf());
                modelMap.addAttribute("menuItemIndex",_modelIdOld);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            model = new TsMenuModule();
        }
        map.put("_model",model);
        return map;
    }
    @RequestMapping(value="/getMenuModuleAddInfo",produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getMenuModuleAddInfo(ModelMap modelMap,HttpServletRequest request){
        Map map = new HashMap();
        TsMenuModule model = new TsMenuModule();
        String parentId = request.getParameter("_parentId");
        String subSysId = request.getParameter("subSysId");
        String pid = request.getParameter("_pid");
        System.out.print("parentId="+parentId+"subSysId="+subSysId+"pid="+pid);
        model.setSubSysId(subSysId);
        modelMap.addAttribute("subSysId", subSysId);
        model.setMenuModuleId(String.valueOf(UUID.randomUUID()));
        if ("0".equals(pid)){
            model.setLevel("1");
            model.setIsLeaf("0");
        }else{
            model.setIsLeaf("1");
            try{
                TsMenuModule model1=tsMenuModuleFeignClient.getMenuModuleInfoByMenuFlag(parentId);
                model.setLevel((Integer.parseInt(model1.getLevel()) + 1) + "");
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        Integer maxMenuFlag = tsMenuModuleFeignClient.getMaxMenuFlag(parentId,"MENUFLAG");
        if (maxMenuFlag != null && maxMenuFlag != 0) {
            model.setIsLeaf("0");
            model.setMenuFlag((maxMenuFlag) + 1+"");
        } else {
            if ("0".equals(parentId)) {
                model.setMenuFlag("10");
            } else {
                model.setMenuFlag(parentId + "01");
            }
        }

        Integer maxMenuIndex = tsMenuModuleFeignClient.getMaxMenuFlag(parentId,"MENUITEMINDEX");
        if (maxMenuIndex != null && maxMenuIndex != 0) {
            model.setMenuItemIndex(maxMenuIndex + 1);
        } else {
           model.setMenuItemIndex(1);
        }
        model.setParentItemId(parentId);
        map.put("_model",model);
        return map;
    }
    @RequestMapping(value = "/saveMenuModuleInfo",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveMenuModuleInfo(@ModelAttribute TsMenuModule tsMenuModule) {
        Map map = new HashMap();
        TsMenuModule tsMenuModule1=tsMenuModuleFeignClient.saveMenuModuleInfo(tsMenuModule);
        map.put("_model",tsMenuModule1);
        map.put("msgCode","success");
        map.put("msgDesc","操作成功");
        return map;
    }

    @RequestMapping(value="/delMenuItem")
    @ResponseBody
    public Map delMenuItem(HttpServletRequest request){
        //保存用户信息
        String id=request.getParameter("_id");
       // _sysId,_param
        Map map = tsMenuModuleFeignClient.deMenuModuleInfo(id);
       return map;
    }
    @RequestMapping(value="/getModuleIdList",method = RequestMethod.POST)
    @ResponseBody
    public List getModuleIdList(HttpServletRequest request){
        List list = tsMenuModuleFeignClient.getModuleIdList();
        return list;
    }

    @RequestMapping(value = "/createSysRoleMenuTree",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map createSysRoleMenuTree() {
        Map map = new HashMap();
        tsMenuModuleFeignClient.createSysRoleMenuTree();
        tsMenuModuleFeignClient.createSysUserMenuTree();
        map.put("msg","成功生成菜单");
        return map;
    }
}
