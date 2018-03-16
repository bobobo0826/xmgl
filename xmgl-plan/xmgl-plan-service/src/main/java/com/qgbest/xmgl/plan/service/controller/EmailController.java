package com.qgbest.xmgl.plan.service.controller;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.service.dao.EmailRepositoryExtends;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;


/**
 * Created by wangchao on 2017/9/30.
 */
@RestController
public class EmailController extends BaseController {
    @Autowired
    private EmailRepositoryExtends emailRepositoryExtends;
    @Autowired
    private UserFeignClient userFeignClient;

    @RequestMapping(value = "/sendBusinessEmail")
    @ResponseBody
    public Map sendBusinessEmail(HttpServletRequest request,TcUser user){
        user = userFeignClient.getCurUser(request.getHeader("token"));
        Map map = new HashMap();
        Map queryMap = getRequestPayload(request);
        System.out.println(queryMap);
        try {
            String result = emailRepositoryExtends.sendEmailByTemplet(queryMap,user);
            if(StringUtils.isNotBlankOrNull(result)){
                map= JsonUtil.fromJsonToMap(result);
            }
        }catch(UnsupportedEncodingException e){
            e.printStackTrace();
        }
        return map;
    }



}
