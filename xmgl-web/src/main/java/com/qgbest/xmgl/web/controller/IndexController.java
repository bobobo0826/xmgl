package com.qgbest.xmgl.web.controller;

import com.qgbest.xmgl.permission.client.permission.TSRoleFeignClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/manage/index")
public class IndexController extends BaseController {
    @Autowired
    private TSRoleFeignClient tsRoleFeignClient;
    public static final Logger logger = LoggerFactory.getLogger(IndexController.class);

    @RequestMapping(value = "/indexLoginPage")
    public String indexLoginPage() {
        logger.info("进入登录页面");
        return "../../loginOne";
    }

    @RequestMapping(value = "/indexPage")
    public String indexPage(ModelMap modelMap) {
        logger.info

          ("进入首页页面");
        modelMap.addAttribute("roleCode", getCurUser().getRoleCode());
        modelMap.addAttribute("imageUrl", imageUrl);
        modelMap.addAttribute("userID", getCurUser().getId());
        String URL=tsRoleFeignClient.getRoleIndexByRoleCode(getCurUser().getRoleCode());
        if ("ROOT".equals(getCurUser().getRoleCode())||"GSLD".equals(getCurUser().getRoleCode())){
            return ".."+URL;
        }
        else if ("XMJL".equals(getCurUser().getRoleCode())){
            return ".."+URL;
        }
        else if ("KFRY".equals(getCurUser().getRoleCode())){
            return ".."+URL;
        }
        return "../index/index";
    }


    @RequestMapping(value = "/logout")
    public String logout() {
        logger.info("退出");
        return "../../loginOne";
    }

    @RequestMapping(value = "/updatePassWordIndex")
    public String updatePassWordIndex() {
        logger.info("进入修改密码界面");
        return "../index/password";
    }
}

