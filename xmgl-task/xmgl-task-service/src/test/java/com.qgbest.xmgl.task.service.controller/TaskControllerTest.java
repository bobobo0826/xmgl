package com.qgbest.xmgl.task.service.controller;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.EmailServiceHTTPConstants;
import com.qgbest.xmgl.task.api.constants.TaskServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.service.Application;
import com.qgbest.xmgl.user.api.entity.TcUser;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
/**
 * Created by liubo on 2017/8/7.
 * description:任务管理测试用例
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class TaskControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }


    /**
     * 测试任务信息分页查询
     */
    @Test
    public void testGetTaskList() throws Exception {
        Map queryMap = new HashMap();
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        tcUser.setRoleCode("KFRY");
        queryMap.put("_curModuleCode", "RWGL");
        String queryMapStr = JsonUtil.toJson(queryMap);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(TaskServiceHTTPConstants.RequestMapping_listTask)
                .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试获取计划列表
     */
    @Test
    public void testGetPlanList() throws Exception {
        Map queryMap = new HashMap();
        queryMap.put("task_id", 87);
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder request = post(TaskServiceHTTPConstants.RequestMapping_listPlan)
                .param("queryMap", queryMapStr);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试根据任务信息ID获取任务信息
     */
    @Test
    public void testGetTaskInfoById() throws Exception {
        Integer taskId = 63;
        RequestBuilder request = get(TaskServiceHTTPConstants.RequestMapping_getTaskInfoById, taskId);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试根据计划信息ID获取任务信息
     */
    @Test
    public void testGetPlanInfoById() throws Exception {
        Integer planId = 125;
        RequestBuilder request = get(TaskServiceHTTPConstants.RequestMapping_getPlanInfoById, planId);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试保存任务
     */
    @Test
    public void testSaveTask() throws Exception {
        Task task = new Task();
        task.setTask_name("任务名称");
        task.setTask_type_code("XMRW");
        task.setTask_condition_code("YXF");
        task.setComplete("50%");
        task.setSup_project_id(1);
        task.setSup_project_name("P1");
        task.setSup_module_id(1);
        task.setSup_module_name("M");
        task.setTask_desc("1111111111");
        task.setCreator("超级管理员");
        task.setCreate_time("2017-08-07 14:30");
        task.setModifier("超级管理员");
        task.setModify_time("2017-08-27 14:30");
        task.setCreator_id(2);
        task.setModifier_id(2);
        task.setReport_cycle("DAY");
        task.setImportance("不重要");
        task.setUrgency("不紧急");
        Map participantsMap = new HashMap();
        participantsMap.put("id", "1");
        participantsMap.put("name", "毛毛");
        participantsMap.put("mobilephone_number", "1234656");
        String participants = "[" + JsonUtil.toJson(participantsMap) + "]";
        task.setParticipants(participants);
        String requestJson = JsonUtil.toJson(task);
        RequestBuilder request = put(TaskServiceHTTPConstants.RequestMapping_saveTask)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 测试保存计划
     */
    @Test
    public void testSavePlan() throws Exception {
        Plan plan = new Plan();
        plan.setTask_id(199);
        plan.setPlan_name("计划名称");
        plan.setPlan_desc("12121212121");
        plan.setStart_date("2017-07-24 ");
        plan.setEnd_date("2017-07-30 ");
        plan.setActual_start_time("2017-08-24 ");
        plan.setActual_end_time("2017-08-30 ");
        plan.setIs_cancel("未注销");
        plan.setCreate_time("2017-08-04 8:44");
        plan.setModify_time("2017-08-04 8:44");
        plan.setModified_flag("0");
        Map participantsMap = new HashMap();
        participantsMap.put("employee_id", "1");
        participantsMap.put("name", "毛毛");
        participantsMap.put("photo", "1111111");
        participantsMap.put("mobilephone_number", "1234656");
        String participants = "[" + JsonUtil.toJson(participantsMap) + "]";
        plan.setParticipants(participants);
        String requestJson = JsonUtil.toJson(plan);
        RequestBuilder request = put(TaskServiceHTTPConstants.RequestMapping_savePlan)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试删除任务
     */
    @Test
    public void testDelTaskInfo() throws Exception {
        Integer taskId =63;
        RequestBuilder request = delete(TaskServiceHTTPConstants.RequestMapping_delTask, taskId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试根据id删除计划
     */
    @Test
    public void testDelPlan() throws Exception {
        Integer planId =125;
        RequestBuilder request = delete(TaskServiceHTTPConstants.RequestMapping_delPlan, planId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试根据taskId删除计划
     */
    @Test
    public void testDelPlanByTaskId() throws Exception {
        Integer taskId =87;
        RequestBuilder request = delete(TaskServiceHTTPConstants.RequestMapping_deletePlanByTaskId, taskId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 测试根据TaskId获取任务完成进度
     */
    @Test
    public void testGetTaskSchedulePercent() throws Exception {
        Integer taskId =84;
        RequestBuilder request = post(TaskServiceHTTPConstants.RequestMapping_getTaskSchedulePercent)
                .param("taskId", taskId.toString());
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 重置计划修改标志
     */
    @Test
    public void testResetModifiedFlag() throws Exception {
        Integer taskId =87;
        RequestBuilder request = put(TaskServiceHTTPConstants.RequestMapping_resetModifiedFlag)
                .param("taskId", taskId.toString());
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
     * 测试根据指定审核人id获取待审核任务
     */
    @Test
    public void testGetUncheckedTaskList() throws Exception {
        Integer assigned_checker_id = 17;
        RequestBuilder request = get(TaskServiceHTTPConstants.RequestMapping_getUncheckedTaskList, assigned_checker_id);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

}
