package com.qgbest.xmgl.web.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * Created by qm on 2017-03-17.
 */
@Configuration
public class WebMvcConf extends WebMvcConfigurerAdapter {
    @Autowired
    private UserSecurityInterceptor securityInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        //配置登录拦截器拦截路径
        registry.addInterceptor(securityInterceptor).addPathPatterns(
                "/admin/**"
                ,"/manage/project/**"
                ,"/manage/file/**"
                ,"/manage/log/**"
                ,"/manage/moduleAndRoleOprStatus/**"
                ,"/manage/opr/**"
                ,"/manage/status/**"
                ,"/manage/dept/**"
                ,"/manage/menuModule/**"
                ,"/manage/module/**"
                ,"/manage/moduleRole/**"
                ,"/manage/moduleUser/**"
                ,"/manage/permission/**"
                ,"/manage/tsSubSys/**"
                ,"/manage/projectModule/**"
                ,"/manage/dayLog/**"
                ,"/manage/monthLog/**"
                ,"/manage/weekLog/**"
                ,"/manage/task/**"
                ,"/manage/myTask/**"
                ,"/manage/employee/**"
                ,"/manage/message/**"
                ,"/manage/user/login"
        ).excludePathPatterns(

        );
    }
}
