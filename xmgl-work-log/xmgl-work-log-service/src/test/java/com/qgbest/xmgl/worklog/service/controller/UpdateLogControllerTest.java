package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.UpdateLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.constants.WeekLogServiceHTTPConstants;

import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.service.Application;
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

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
/**
 * Created by mjq on 2017/8/8.
 * description:UpdateLogController测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class UpdateLogControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }


    /**
     * 获取列表
     */
    @Test
    public void testGetUpdateLogList() throws Exception {
        Map queryMap = new HashMap();
        queryMap.put("creator", "超级管理员");
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder request = post(UpdateLogServiceHTTPConstants.RequestMapping_getUpdateLogList)
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 根据ID获取更新日志详情
     */
    @Test
    public void testGetUpdateLogInfoById() throws Exception {
        Integer id = 1;
        RequestBuilder request = get(UpdateLogServiceHTTPConstants.RequestMapping_getUpdateLogInfo, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 保存更新日志信息
     */
    @Test
    public void testSaveUpdateLogInfo() throws Exception {
        UpdateLog updateLog = new UpdateLog();
        updateLog.setContent("更新任务相关的问题");
        updateLog.setCreate_date("2017-08-08 13:36");
        updateLog.setCreator("超级管理员");
        updateLog.setCreator_id(2);
        updateLog.setModifier("超级管理员");
        updateLog.setModify_date("2017-08-08 13:37");
        updateLog.setStatus("已发布");
        updateLog.setTitle("跟新系统问题");
        updateLog.setUpdate_date("2017-08-08");
        String requestJson = JsonUtil.toJson(updateLog);
        RequestBuilder request = put(UpdateLogServiceHTTPConstants.RequestMapping_saveUpdateLogInfo)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 删除更新日志信息
     */
    @Test
    public void testDelUpdateLogInfoById() throws Exception {
        Integer id =1;
        RequestBuilder request = delete(UpdateLogServiceHTTPConstants.RequestMapping_delUpdateLogInfo, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 获取更新日志
     */
    @Test
    public void testGetLatestUpdateLog() throws Exception {
        RequestBuilder request = post(UpdateLogServiceHTTPConstants.RequestMapping_getLatestUpdateLog);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 发布更新日志信息
     */
    @Test
    public void testPublishUpdateLogById() throws Exception {
        Integer id=1;
        RequestBuilder request = post(UpdateLogServiceHTTPConstants.RequestMapping_publishUpdateLog,id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 撤销发布更新日志信息
     */
    @Test
    public void testUnPublishUpdateLogById() throws Exception {
        Integer id=1;
        RequestBuilder request = post(UpdateLogServiceHTTPConstants.RequestMapping_unPublishUpdateLog,id);
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
