package com.qgbest.xmgl.web.config;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.permission.VisitRecord;
import com.qgbest.xmgl.permission.client.permission.VisitRecordClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Enumeration;


/**
 * Created by IntelliJ IDEA 2017.
 * User:lbb
 * Date:2017/8/14
 * Time:21:07
 * description:实现web层的切面类
 */
@Component
@Aspect
@Configuration
public class WebControllerAop extends BaseController{
    private Logger logger =  LoggerFactory.getLogger(this.getClass());
    long beginTime = 0;
    private VisitRecord visitRecord = new VisitRecord();
    private String conflictOpr = "";

    @Autowired
    private VisitRecordClient visitRecordClient;

    /**
     * 定义一个切入点.
     * 解释下：
     *
     * ~ 第一个 * 代表任意修饰符及任意返回值.
     * ~ 第二个 * 任意包名
     * ~ .. 匹配任意数量的参数.
     */
    @Pointcut("execution(public * com.qgbest.xmgl.web.controller..*(..))")
    public void webLog(){}
    @Before("webLog()")
    public void doBefore(JoinPoint joinPoint){
        beginTime=System.currentTimeMillis();
        // 接收到请求，记录请求内容
        logger.info("WebLogAspect.doBefore()");
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();

        // 记录下请求内容
        logger.info("URL : " + request.getRequestURL().toString());
        logger.info("we need to URL : "+ request.getServletPath());
        logger.info("HTTP_METHOD : " + request.getMethod());
            logger.info("IP : " +request.getRemoteAddr());
        logger.info("CLASS_METHOD : " + joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());
        logger.info("ARGS : " + Arrays.toString(joinPoint.getArgs()));
        //获取所有参数方法一：
        Enumeration<String> enu = request.getParameterNames();
        String parameter = "";
        this.conflictOpr = "";
        while (enu.hasMoreElements()) {
            String paraName = (String) enu.nextElement();
            System.out.println(paraName + ": " + request.getParameter(paraName));
            parameter += paraName + ": " + request.getParameter(paraName) + ";";
            if (paraName.equals("oprCode")) {
                this.conflictOpr = request.getParameter(paraName);
            }
        }
        //设置visitRecord为null
        this.visitRecord.setId(null);
        this.visitRecord.setVisitName(null);
        this.visitRecord.setVisitDate(null);
        this.visitRecord.setUserName(null);
        this.visitRecord.setUserIp(null);
        this.visitRecord.setPath(null);
        this.visitRecord.setParameter(null);
        this.visitRecord.setTimeConsuming(null);
        //根据检测到的操作将访问信息存入visitRecord
        if (StringUtils.isNotBlankOrNull(getCurUser())) {
            if (StringUtils.isNotBlankOrNull(getCurUser().getDisplayName())) {
                this.visitRecord.setUserName(getCurUser().getDisplayName());
                this.visitRecord.setPath(request.getServletPath() + "");
                this.visitRecord.setUserIp(request.getRemoteAddr() + "");
                this.visitRecord.setParameter(parameter);
                this.visitRecord.setVisitDate(DateUtils.getCurDateTime());
            }
        }
    }
    @AfterReturning("webLog()")
    public void  doAfterReturning(JoinPoint joinPoint){
        // 处理完请求，返回内容
        logger.info("WebLogAspect.doAfterReturning()");
    }
    @Around("webLog()") //指定拦截器规则；也可以直接把“execution(* com.xjj.........)”写进这里
    public Object Interceptor(ProceedingJoinPoint pjp){
        long beginTime = System.currentTimeMillis();
        Object result = null;
        try {
                // 一切正常的情况下，继续执行被拦截的方法
                result = pjp.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
        }
        //时间差
        long costMs = System.currentTimeMillis() - beginTime;
        if (StringUtils.isNotBlankOrNull(this.visitRecord)) {
            this.visitRecord.setTimeConsuming(costMs + "ms");
            System.out.println("====visitRecord1111====" + this.visitRecord);
            System.out.println("====conflictOpr====" + this.conflictOpr);
            visitRecordClient
                    .saveVisitRecord(this.visitRecord, this.conflictOpr);
        }
        return result;
    }
    public static String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        System.err.print("--------"+ip);
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }



}
