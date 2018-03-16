package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.permission.TsRole;
import com.qgbest.xmgl.permission.client.permission.TSRoleFeignClient;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/permission")
public class TSRoleController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TSRoleController.class);
    @Autowired
    private TSRoleFeignClient tsRoleFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;
    @RequestMapping(value = "/tsRoleTreeIndex")
    public String tsRoleTreeIndex() {
        logger.info("初始化角色管理界面");
        return "/permission/roleManager/roleTreeInfo";
    }
    @RequestMapping(value = "/roleInfoIndex")
    public String roleInfoIndex(ModelMap modelMap,HttpServletRequest request) {
        logger.info("初始化角色详细信息界面");
        modelMap.addAttribute("_id",request.getParameter("_id"));
        modelMap.addAttribute("_parentId",request.getParameter("_parentId"));

        return "/permission/roleManager/roleInfo";
    }

   @RequestMapping(value="/getRoleTreeList",method = RequestMethod.POST)
    @ResponseBody
    public List getRoleTreeList(HttpServletRequest request){
        logger.info("获取角色树信息");
        String roleCodes = userFeignClient.getRoleColesByUserId(getCurUser().getId());
        List list = tsRoleFeignClient.getRoleTreeList(request.getParameter("_id"),roleCodes);
        return list;
    }

    @RequestMapping(value="/getRoleInfo",produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getRoleInfo(HttpServletRequest request){
        logger.info("获取角色详细信息");
        Map map = new HashMap();
        TsRole model = null;
        System.out.println("11111111111111111113"+request.getParameter("_id"));
        if (StringUtils.isNotBlankOrNull(request.getParameter("_id"))){
            try{
                model=tsRoleFeignClient.getRoleInfo(Integer.valueOf(request.getParameter("_id")));
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            model = new TsRole();
            model.setParentId(Integer.valueOf(request.getParameter("_parentId")));
        }
        map.put("_model",model);
        if (model.getParentId() != -1) {
            TsRole parentRole = null;
            try{
                 parentRole =tsRoleFeignClient.getRoleInfo(model.getParentId());
            }catch (Exception e){
                e.printStackTrace();
            }
            if (parentRole == null)
                map.put("parentRoleName", "无");
            else
                map.put("parentRoleName", parentRole.getRoleName());
        } else
            map.put("parentRoleName", "无");
        return map;
    }
    @RequestMapping(value = "/saveRoleInfo",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveRoleInfo(@ModelAttribute TsRole model) {
        Map map = new HashMap();
        //判断是否重复
         Boolean isExist = tsRoleFeignClient.isExist(model);
        if (isExist){
            map.put("msgCode","failure");
            map.put("msgDesc","保存失败，有相同角色编号或角色名称");
            map.put("_model",model);
            return map;
        }
         TsRole tsRole=tsRoleFeignClient.saveRoleInfo(model);
        map.put("_model",tsRole);
        map.put("msgCode","success");
        map.put("msgDesc","操作成功");
        return map;
    }

    @RequestMapping(value="/delRoleInfo")
    @ResponseBody
    public Map delRoleInfo(HttpServletRequest request){
        //保存用户信息
        String id=request.getParameter("_id");
        Map map = tsRoleFeignClient.delRoleInfo(id);
       return map;
    }
    @RequestMapping(value="/getFunctionList")
    @ResponseBody
    public Map getFunctionList(HttpServletRequest request){
        //保存用户信息
        String _curModuleCode=request.getParameter("_curModuleCode");
        Map map = tsRoleFeignClient.getFunctionList(_curModuleCode,getCurUser());
        return map;
    }

    @RequestMapping(value="/choseRoleWithId")
    public String choseRoleWithId(@RequestParam("_chkStyle") String chkStyle,@RequestParam("_selCodes") String selCodes,ModelMap modelMap) {
        TcUser user = this.getCurUser();
        List roleList = tsRoleFeignClient.getRoleTreeListWithCode(selCodes, user);
        String roleListStr=JsonUtil.toJson(roleList);
        modelMap.addAttribute("roleListStr",roleListStr.replace("\"","'"));
        modelMap.addAttribute("_chkStyle",chkStyle);
        return "/permission/roleManager/selectRoleTree";
    }

}
