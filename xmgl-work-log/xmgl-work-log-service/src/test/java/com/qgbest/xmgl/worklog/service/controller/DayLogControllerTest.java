package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.DayLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
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
 * Created by quangao-Lu Tianle on 2017/8/7.
 * description: 日日志接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class DayLogControllerTest {
  private MockMvc mockMvc;
  @Autowired
  protected WebApplicationContext wac;

  @Before
  public void setupMockMvc() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
  }

  /**
   * 测试日日志列表查询
   */
  @Test
  public void testGetDayLogList() throws Exception {
    Map queryMap = new HashMap();
    TcUser tcUser = new TcUser();
    tcUser.setId(22);
    queryMap.put("_curModuleCode", "MY_MRJH");
    String queryMapStr = JsonUtil.toJson(queryMap);
    String user = JsonUtil.toJson(tcUser);
    RequestBuilder request = post(DayLogServiceHTTPConstants.RequestMapping_listDayLog)
      .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
      .param("queryMap", queryMapStr)
      .param("len", "20")
      .param("page", "1");
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("total")));
  }

  /**
   * 测试日日志详情查询,根据dayLogId
   */
  @Test
  public void testGetDayLogInfoById() throws Exception {
    Integer dayLogId = 102;
    RequestBuilder request = get(DayLogServiceHTTPConstants.RequestMapping_getDayLogInfoById, dayLogId);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 测试保存日日志
   */
  @Test
  public void testSaveDayLog() throws Exception {
    DayLog dayLog = new DayLog();
    dayLog.setWork_date("2017-07-08");
    dayLog.setCreator("陆天乐");
    dayLog.setCreator_id(22);
    dayLog.setCreate_date("2017-8");
    dayLog.setDay_summary("月总结");
    dayLog.setWork_explain("解释");
    dayLog.setStatus_code("CG");
    dayLog.setCreate_type("ZCLR");
    dayLog.setModifier("陆天乐");
    dayLog.setModifier_id(22);
    dayLog.setModify_date("2017-08-23");
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
    dayLog.setContent(content);
    String requestJson = JsonUtil.toJson(dayLog);
    RequestBuilder request = put(DayLogServiceHTTPConstants.RequestMapping_saveDayLog)
      .contentType(MediaType.APPLICATION_JSON).content(requestJson);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 测试删除,根据dayLogId
   */
  @Test
  public void testDelDayLog() throws Exception {
    Integer dayLogId = 58;

    RequestBuilder request = delete(DayLogServiceHTTPConstants.RequestMapping_delDayLog, dayLogId);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 测试获得新日志任务数量
   */
  @Test
  public void testGetNewDayLogNumbers() throws Exception {
    RequestBuilder request = get(DayLogServiceHTTPConstants.RequestMapping_getNewDayLogNumbers);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }


  /**
   * 测试获得日志下拉表,根据dayLogId
   */
  @Test
  public void testGetDayLogContentListById() throws Exception {
    Integer dayLogId = 102;

    RequestBuilder request = get(DayLogServiceHTTPConstants.RequestMapping_getDayLogContentListById, dayLogId);
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
