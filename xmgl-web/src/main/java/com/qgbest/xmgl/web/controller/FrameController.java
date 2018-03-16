package com.qgbest.xmgl.web.controller;

import com.qgbest.xmgl.common.utils.CharsetUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping
public class FrameController extends BaseController {
    @Autowired
    UserFeignClient userFeignClient;

    @RequestMapping(value = "/init")
    public ModelAndView init() {
        String token = httpServletRequest.getParameter("token");
        String name=CharsetUtil.filterCharset(httpServletRequest.getParameter("name"), CharsetUtil.UTF_8);
        String url = httpServletRequest.getParameter("url");
        HttpSession session = httpServletRequest.getSession();
        TcUser user=userFeignClient.getCurUser(token);
        if(user!=null){
            session.setAttribute("curUser", userFeignClient.getCurUser(token));
            Map model = new HashMap();
            model.put("url", url);
            model.put("name", name);
            return new ModelAndView("/frame/frame", model);
        }else{
            return null;
        }

    }


}
