package com.qgbest.xmgl.bugs;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
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
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.filter.CharacterEncodingFilter;

import javax.servlet.Filter;

/**
 * Created by lbb on 2017/03/03.
 */
@Configuration
@ComponentScan(basePackages = {"com.qgbest.xmgl.bugs", "com.qgbest.xmgl.common.service.utils", "com.qgbest.xmgl.employee.client", "com.qgbest.xmgl.project.client", "com.qgbest.xmgl.user.client"})
@EnableFeignClients(basePackages = {"com.qgbest.xmgl.project.client", "com.qgbest.xmgl.employee.client", "com.qgbest.xmgl.user.client"})
@EntityScan(basePackages = {"com.qgbest.xmgl.bugs"})
@EnableAutoConfiguration
@EnableJpaRepositories
@EnableDiscoveryClient
@EnableEurekaClient
@EnableCircuitBreaker     //增加的断路器注解
@EnableHystrix
@EnableHystrixDashboard
@RestController
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class, HibernateJpaAutoConfiguration.class})
public class Application extends SpringBootServletInitializer {
    public static final Logger logger = LoggerFactory.getLogger(Application.class);

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }


    //    @Bean
    //    public EmbeddedServletContainerCustomizer containerCustomizer(){
    //        return new EmbeddedServletContainerCustomizer() {
    //            @Override
    //            public void customize(ConfigurableEmbeddedServletContainer container) {
    //                container.setSessionTimeout(1800);//单位为S
    //            }
    //        };
    //    }
    //    @Bean
    //    JedisConnectionFactory jedisConnectionFactory(){
    //        JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory();
    //        return jedisConnectionFactory;
    //    }

    // 编码过滤器
    @Bean
    Filter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        return filter;
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        logger.info("Springboot Application [springboot-bugs-area] started!");
    }


}
