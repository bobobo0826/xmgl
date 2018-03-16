package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.api.entity.permission.TsModuleRole;
import com.qgbest.xmgl.permission.client.permission.TSMenuModuleFeignClient;
import com.qgbest.xmgl.permission.client.permission.TSModuleRoleFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/moduleRole")
public class TSModuleRoleController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TSModuleRoleController.class);
    @Autowired
    private TSModuleRoleFeignClient tsModuleRoleFeignClient;
    @Autowired
    private TSMenuModuleFeignClient tsMenuModuleFeignClient;

    @RequestMapping(value = "/tsMRQuery")
    public String tsMRQuery() {
        return "/permission/moduleAndRole/tsModuleRoleList";
    }

    @RequestMapping(value = "/tsMRIndex")
    public String tsMRIndex(ModelMap modelMap) {
        modelMap.addAttribute("roleCode", httpServletRequest.getParameter("roleCode"));
        return "/permission/moduleAndRole/tsModuleRoleInfo";
    }

    @RequestMapping(value = "/tsMRQueryList")
    @ResponseBody
    public Map tsMRQueryList() throws IOException {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = new HashMap();
        try {
            map = tsModuleRoleFeignClient.getTsModuleRoleList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    @RequestMapping(value = "/tsMRSave", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public String tsMRSave(ModelMap modelMap) {
        String[] str2 = httpServletRequest.getParameter("opr").split(",");
        String[] moduleIds = httpServletRequest.getParameterValues("moduleIds");
        String roleCode = httpServletRequest.getParameter("roleCodeS");
        tsModuleRoleFeignClient.delTsModuleRoleInfo(roleCode);
        for (int i = 0; i < moduleIds.length; i++) {
            TsModuleRole temp = new TsModuleRole();
            temp.setModuleroleId(moduleIds[i] + "-" + roleCode);
            temp.setRoleCode(roleCode);
            temp.setModuleId(moduleIds[i]);
            String opr = null;
            try {
                opr = URLEncoder.encode(str2[i], "utf-8");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            temp.setOprSet(new BigInteger(new BigDecimal(opr).toPlainString()));
            temp.setUpdateDateTime(new Date());
            try {
                tsModuleRoleFeignClient.saveTsModuleRoleInfo(temp);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        tsMenuModuleFeignClient.createSysRoleMenuTree();
        String msgDesc = "操作成功";
        modelMap.addAttribute("msgDesc", msgDesc);
        modelMap.addAttribute("roleCode", roleCode);
        return "/permission/moduleAndRole/tsModuleRoleInfo";
    }

    @RequestMapping(value = "/getModuleRoleList")
    @ResponseBody
    public Map getModuleRoleList(ModelMap modelMap) {
        String roleCode = httpServletRequest.getParameter("roleCode");
        List mlist = tsModuleRoleFeignClient.getModuleList();
        List list = tsModuleRoleFeignClient.getModuleRoleList(roleCode);
        Map map = new HashMap();
        String[] moduleIds = new String[list.size()];
        String[] operSet = new String[list.size()];
        for (int i = 0; i < list.size(); i++) {
            Map tmp = (Map) list.get(i);
            moduleIds[i] = tmp.get("moduleid").toString();
            operSet[i] = new BigInteger(tmp.get("oprset").toString()).toString();
        }
        modelMap.addAttribute("msgDesc", "no");
        map.put("moduleIds", moduleIds);
        map.put("mlist", mlist);
        map.put("operSet", operSet);
        return map;
    }

    @RequestMapping(value = "/getRoleCodeSList")
    @ResponseBody
    public List getRoleCodeSList() {
        //保存用户信息
        String roleCode = httpServletRequest.getParameter("roleCode");
        List list = tsModuleRoleFeignClient.getRoleCodeSList(roleCode);
        return list;
    }

}
