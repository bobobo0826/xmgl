package com.qgbest.xmgl.web;

import com.qgbest.xmgl.common.utils.MailUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.filter.CharacterEncodingFilter;

import javax.servlet.Filter;

/**
 * Created by qianmeng on 2017-03-07
 */
@ComponentScan(basePackages={
        "com.qgbest.xmgl.user.client",
        "com.qgbest.xmgl.permission.client",
        "com.qgbest.xmgl.log.client",
        "com.qgbest.xmgl.division.client",
        "com.qgbest.xmgl.worklog.client",
        "com.qgbest.xmgl.file.client",
        "com.qgbest.xmgl.project.client",
        "com.qgbest.xmgl.dept.client",
        "com.qgbest.xmgl.employee.client",
        "com.qgbest.xmgl.task.client",
        "com.qgbest.xmgl.plan.client",
        "com.qgbest.xmgl.oa.client",
        "com.qgbest.xmgl.web"})
@EnableFeignClients(basePackages={
        "com.qgbest.xmgl.user.client",
        "com.qgbest.xmgl.permission.client",
        "com.qgbest.xmgl.log.client",
        "com.qgbest.xmgl.plan.client",
        "com.qgbest.xmgl.worklog.client",
        "com.qgbest.xmgl.division.client",
        "com.qgbest.xmgl.project.client",
        "com.qgbest.xmgl.dept.client",
        "com.qgbest.xmgl.employee.client",
        "com.qgbest.xmgl.task.client",
        "com.qgbest.xmgl.oa.client",
        "com.qgbest.xmgl.file.client"})
@EntityScan
@SpringBootApplication(exclude={DataSourceAutoConfiguration.class,HibernateJpaAutoConfiguration.class})
@EnableEurekaClient
@RestController
@EnableDiscoveryClient
@EnableCircuitBreaker
@EnableHystrix
@EnableHystrixDashboard
@EnableRedisHttpSession(maxInactiveIntervalInSeconds= 1800)
public class Application extends SpringBootServletInitializer {
    public static final Logger logger = LoggerFactory.getLogger(Application.class);
    /**
     * 编码过滤器
     * @return
     */
    @Bean
    Filter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        return filter;
    }
  /**
     * 设置session 过期时间
     * @return
     */
    @Bean
    public EmbeddedServletContainerCustomizer containerCustomizer(){
        return new EmbeddedServletContainerCustomizer() {
            @Override
            public void customize(ConfigurableEmbeddedServletContainer container) {
                container.setSessionTimeout(1800);//单位为S
            }
        };
    }
    @Bean
    JedisConnectionFactory jedisConnectionFactory(){
        JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory();
        return jedisConnectionFactory;
    }
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        logger.info("Springboot Application [springboot-web] started!");
    }
}
