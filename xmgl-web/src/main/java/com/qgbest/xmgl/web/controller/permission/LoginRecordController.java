package com.qgbest.xmgl.web.controller.permission;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.client.permission.LoginRecordFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liubo on 2017/8/14.
 * description:
 */
@Controller
@RequestMapping(value = "/manage/loginRecord")
public class LoginRecordController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(LoginRecordController.class);
    @Autowired
    public LoginRecordFeignClient loginRecordFeignClient;
    /**
     * 获取登录信息
     *
     * @return
     */
    @RequestMapping(value = "/getLoginRecordInfo")
    @ResponseBody
    public Map getLoginRecordInfo() {
        return loginRecordFeignClient.getLoginRecordInfo(getCurUser());
    }
    /**
     * 打开登录信息列表页面
     */
    @RequestMapping(value = "/initLoginRecord")
    public ModelAndView initLoginRecord() {
        Integer userId=getCurUser().getId();
        Map model =new HashMap();
        model.put("userId", userId);
        return new ModelAndView( "/permission/loginRecordList",model);

    }
    /**
     * 获取登录信息列表
     */
    @RequestMapping(value = "/loginRecordQueryList")
    @ResponseBody
    public Map loginRecordQueryList() {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        return loginRecordFeignClient.getLoginRecordQueryList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }
    /**
     * 删除
     */
    @RequestMapping(value = "/delLoginRecord")
    @ResponseBody
    public ReturnMsg delLoginRecord() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = loginRecordFeignClient.delLoginRecord(id);
        return returnMsg;
    }

}
