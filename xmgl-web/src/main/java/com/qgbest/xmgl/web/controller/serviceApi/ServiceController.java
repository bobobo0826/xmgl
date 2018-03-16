package com.qgbest.xmgl.web.controller.serviceApi;

import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by lbb on 2017/7/14.
 * api服务
 */
@Controller
@RequestMapping(value = "/manage/serviceApi")
public class ServiceController extends BaseController{
    public static final String urlIp = "localhost";
    @RequestMapping(value = "/eurekaShow")
    public String eurekaShow() {
        return "redirect:http://"+urlIp+":8050/";
    }
    @RequestMapping(value = "/workLogApi")
    public String workLogApi() {
        return "redirect:http://"+urlIp+":8085/swagger-ui.html";
    }
    @RequestMapping(value = "/permissionApi")
    public String permissionApi() {
        return "redirect:http://"+urlIp+":8089/swagger-ui.html";
    }
    @RequestMapping(value = "/logApi")
    public String logApi() {
        return "redirect:http://"+urlIp+":8083/swagger-ui.html";
    }
    @RequestMapping(value = "/divisionApi")
    public String divisionApi() {
        return "redirect:http://"+urlIp+":8088/swagger-ui.html";
    }
    @RequestMapping(value = "/fileApi")
    public String fileApi() {
        return "redirect:http://"+urlIp+":8084/swagger-ui.html";
    }
    @RequestMapping(value = "/projectApi")
    public String projectApi() {
        return "redirect:http://"+urlIp+":8086/swagger-ui.html";
    }
    @RequestMapping(value = "/userApi")
    public String userApi() {
        return "redirect:http://"+urlIp+":8081/swagger-ui.html";
    }
}
