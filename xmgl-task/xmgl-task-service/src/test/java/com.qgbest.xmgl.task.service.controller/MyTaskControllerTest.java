package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.MyTaskServiceHTTPConstants;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.task.service.Application;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import java.util.HashMap;
import java.util.Map;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
/**
 * Created by liubo on 2017/8/7.
 * description:我的任务管理测试用例
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class MyTaskControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 测试获取我的任务列表
     */
    @Test
    public void testGetMyTaskQueryList() throws Exception {
        Map queryMap = new HashMap();
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        tcUser.setDisplayName("超级管理员");
        queryMap.put("_curModuleCode", "MY_RWGL");
        String queryMapStr = JsonUtil.toJson(queryMap);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(MyTaskServiceHTTPConstants.RequestMapping_getMyTaskQueryList)
                .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 测试根据ID获取计划
     */
    @Test
    public void testGetMyTaskInfoById() throws Exception {
        Integer planId = 125;
        RequestBuilder request = get(MyTaskServiceHTTPConstants.RequestMapping_getMyTaskInfoById, planId);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试获取我的待完成计划列表
     */
    @Test
    public void testGetUnCompletePlan() throws Exception {
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        tcUser.setDisplayName("超级管理员");
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(MyTaskServiceHTTPConstants.RequestMapping_getUnCompletePlan)
                .contentType(MediaType.APPLICATION_JSON).content(user);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }


    /**
     * 测试废弃方法
     */
    @Ignore("废弃方法")
    @Test
    public void test_ignore() {
        System.out.println("ignore.......");
    }






}
