package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.WeekLogServiceHTTPConstants;

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
 * Created by liubo on 2017/8/7.
 * description: 周日志接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class WeekLogControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 测试周日志列表查询
     */
    @Test
    public void testGetWeekLogList() throws Exception {
        Map queryMap = new HashMap();
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        queryMap.put("_curModuleCode", "MY_MZJH");
        String queryMapStr = JsonUtil.toJson(queryMap);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(WeekLogServiceHTTPConstants.RequestMapping_getWeekLogList)
                .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 测试周日志详情查询,根据WeekLogId
     */
    @Test
    public void testGetWeekLogInfo() throws Exception {
        Integer weekLogId = 37;
        RequestBuilder request = get(WeekLogServiceHTTPConstants.RequestMapping_getWeekLogInfo, weekLogId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 测试保存周日志
     */
    @Test
    public void testSaveWeekLog() throws Exception {
        WeekLog weekLog = new WeekLog();
        weekLog.setTask_start_date("2017-07-01");
        weekLog.setTask_end_date("2017-07-22");
        weekLog.setCreator("超级管理员");
        weekLog.setCreator_id(2);
        weekLog.setCreate_date("2017-07-14 09:50");
        weekLog.setWeek_summary("周总结");
        weekLog.setWork_explain("解释");
        weekLog.setStatus_code("CG");
        weekLog.setCreate_type("ZCLR");
        weekLog.setModifier("超级管理员");
        weekLog.setModifier_id(2);
        weekLog.setModify_date("2017-07-24 09:50");
        Map contentMap = new HashMap();
        contentMap.put("record", "详细内容");
        contentMap.put("plan_id", 1);
        contentMap.put("task_id", 1);
        contentMap.put("complete", "已完成");
        contentMap.put("plan_name", "myPlan");
        contentMap.put("task_name", "myTask");
        contentMap.put("task_type", "XMRW");
        contentMap.put("period_end", "2017-07-14");
        contentMap.put("sup_module", "module");
        contentMap.put("sup_project", "project");
        contentMap.put("mission_name", "taskName");
        contentMap.put("period_start", "2017-07-03");
        contentMap.put("sup_module_id", 2);
        contentMap.put("task_end_time", "2017-08-23");
        contentMap.put("sup_project_id", 2);
        contentMap.put("task_start_time", "2017-07-30");
        contentMap.put("incomplete_explain", "incomplete_explain");
        contentMap.put("plan_actual_start_time", "plan_actual_start_time");
        String content = "[" + JsonUtil.toJson(contentMap) + "]";
        weekLog.setContent(content);
        String requestJson = JsonUtil.toJson(weekLog);
        RequestBuilder request = put(WeekLogServiceHTTPConstants.RequestMapping_saveWeekLogInfo)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(jsonPath("$.weekLog.creator").value("超级管理员"))
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 测试删除,根据weekLogId
     */
    @Test
    public void testDelWeekLogInfo() throws Exception {
        Integer weekLog =57;
        RequestBuilder request = delete(WeekLogServiceHTTPConstants.RequestMapping_delWeekLogInfo, weekLog);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 获得新增周任务数量
     */
    @Test
    public void testGetWeekLogNumber() throws Exception {
        RequestBuilder request = get(WeekLogServiceHTTPConstants.RequestMapping_getNewWeekLogNumbers);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 根据Id测试获得周日志任务列表详情
     */
    @Test
    public void testGetWeekLogContentListById() throws Exception {
        Integer weekLog = 58;
        RequestBuilder request = get(WeekLogServiceHTTPConstants.RequestMapping_getWeekLogContentListById, weekLog);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 查询monday_date为起始日期的周日志id
     */
    @Test
    public void testGetWeekLogIdByTaskStartDate() throws Exception {
        String monday_date = "2017-07-31";
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(WeekLogServiceHTTPConstants.RequestMapping_getWeekLogIdByTaskStartDate)
                .contentType(MediaType.APPLICATION_JSON).content(user)
                .param("monday_date", monday_date);
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


    /**
     * 测试超时
     */
    @Test(timeout = 1000)
    public void test_timeout() {
        Integer count = 0;
        do {
            count++;
        } while (count > 0);
    }



}
