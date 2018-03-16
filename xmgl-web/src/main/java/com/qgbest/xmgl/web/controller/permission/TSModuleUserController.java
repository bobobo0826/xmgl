package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.permission.TsModuleUser;
import com.qgbest.xmgl.permission.client.permission.TSMenuModuleFeignClient;
import com.qgbest.xmgl.permission.client.permission.TSModuleUserFeignClient;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
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
import java.math.BigInteger;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/moduleUser")
public class TSModuleUserController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TSModuleUserController.class);
    @Autowired
    private TSModuleUserFeignClient tsModuleUserFeignClient;
    @Autowired
    private TSMenuModuleFeignClient tsMenuModuleFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;
    @RequestMapping(value = "/tsMUQuery")
    public String tsMUQuery() {
        return "/permission/moduleAndUser/tsModuleUserList";
    }
    @RequestMapping(value = "/tsMUIndex")
    public String tsMUIndex(ModelMap modelMap) {
        modelMap.addAttribute("userId",httpServletRequest.getParameter("userId"));
        return "/permission/moduleAndUser/tsModuleUserInfo";
    }

    @RequestMapping(value = "/tsMUQueryList")
    @ResponseBody
    public Map tsMUQueryList() throws IOException {
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = new HashMap();
        try
        {
            map =tsModuleUserFeignClient.getTsModuleUserList(JsonUtil.toJson(queryMap), len, cpage);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return map;
    }
    @RequestMapping(value = "/tsMUSave",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    public String tsMUSave(ModelMap modelMap) throws Exception{
        String[] str2 = httpServletRequest.getParameter("opr").split(",");
        String[] moduleIds = httpServletRequest.getParameterValues("moduleIds");
        String userIdS = httpServletRequest.getParameter("userIdS");
        tsModuleUserFeignClient.delTsModuleUserInfo(userIdS);
        for (int i = 0; i < moduleIds.length; i++) {
            TsModuleUser temp = new TsModuleUser();
            temp.setModuleuserId(moduleIds[i] + "-" + userIdS);
            TcUser user = userFeignClient.getUserById(Integer.valueOf(userIdS));
            temp.setUserDesc(user.getDisplayName());
            temp.setUserName(user.getUserName());
            temp.setUserId(Integer.valueOf(userIdS));
            temp.setModuleId(moduleIds[i]);
            temp.setOprSet(new BigInteger(str2[i]));
            temp.setUpdateDateTime(new Date());
            try {
                tsModuleUserFeignClient.saveTsModuleUserInfo(temp);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        tsMenuModuleFeignClient.createSysUserMenuTree();
        String msgDesc = "操作成功";
        modelMap.addAttribute("msgDesc",msgDesc);
        modelMap.addAttribute("userIdS",userIdS);
        modelMap.addAttribute("userId",userIdS);
        return "/permission/moduleAndUser/tsModuleUserInfo";
    }
    @RequestMapping(value="/getModuleUserList")
    @ResponseBody
    public Map getModuleUserList(ModelMap modelMap){
        //保存用户信息
        String userId=httpServletRequest.getParameter("userId");
        List mlist = tsModuleUserFeignClient.getModuleList();
        List list = tsModuleUserFeignClient.getModuleUserList(userId);
        Map map = new HashMap();
        String[] moduleIds = new String[list.size()];
        BigInteger[] operSet = new BigInteger[list.size()];
        for (int i = 0; i < list.size(); i++) {
            Map tmp = (Map)list.get(i);
            moduleIds[i] = tmp.get("moduleid").toString();
            operSet[i] = new BigInteger(tmp.get("oprset").toString());
        }
        modelMap.addAttribute("msgDesc","no");
        map.put("moduleIds",moduleIds);
        map.put("mlist",mlist);
        map.put("operSet",operSet);
        return map;
    }

    @RequestMapping(value="/getUserIdsList")
    @ResponseBody
    public List getUserIdsList(){
        //保存用户信息
        String userId=httpServletRequest.getParameter("userId");
        if (!StringUtils.isNotBlankOrNull(userId)){
            userId="0";
        }
        List list = userFeignClient.getUserIdList(Integer.valueOf(userId));
        return list;
    }

}
