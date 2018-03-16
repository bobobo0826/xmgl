package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.MonthLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
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
 * Created by quangao-Lu Tianle on 2017/8/3.
 * description: 月日志接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class MonthLogControllerTest {
  private MockMvc mockMvc;
  @Autowired
  protected WebApplicationContext wac;

  @Before
  public void setupMockMvc() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
  }

  /**
   * 测试月日志列表查询
   */
  @Test
  public void testGetMonthLogList() throws Exception {
    Map queryMap = new HashMap();
    TcUser tcUser = new TcUser();
    tcUser.setId(22);
    queryMap.put("_curModuleCode", "MY_MYJH");
    String queryMapStr = JsonUtil.toJson(queryMap);
    String user = JsonUtil.toJson(tcUser);
    RequestBuilder request = post(MonthLogServiceHTTPConstants.RequestMapping_getMonthLogList)
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
   * 测试月日志详情查询,根据monthLogId
   */
  @Test
  public void testGetMonthLogInfo() throws Exception {
    Integer monthLogId = 102;
    RequestBuilder request = get(MonthLogServiceHTTPConstants.RequestMapping_getMonthLogInfo, monthLogId);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 测试保存月日志
   */
  @Test
  public void testSaveMonthLog() throws Exception {
    MonthLog monthLog = new MonthLog();
    monthLog.setWork_date("2017-7");
    monthLog.setCreator("陆天乐");
    monthLog.setCreator_id(22);
    monthLog.setCreate_date("2017-8");
    monthLog.setMonth_summary("月总结");
    monthLog.setWork_explain("解释");
    monthLog.setStatus_code("CG");
    monthLog.setCreate_type("ZCLR");
    monthLog.setModifier("陆天乐");
    monthLog.setModifier_id(22);
    monthLog.setModify_date("2017-08-23");
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
    monthLog.setContent(content);
    String requestJson = JsonUtil.toJson(monthLog);
    RequestBuilder request = put(MonthLogServiceHTTPConstants.RequestMapping_saveMonthLogInfo)
      .contentType(MediaType.APPLICATION_JSON).content(requestJson);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(jsonPath("$.monthLog.creator").value("陆天乐"))
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 测试删除,根据monthLogId
   */
  @Test
  public void testDelMonthLogInfo() throws Exception {
    Integer monthLogId = 58;

    RequestBuilder request = delete(MonthLogServiceHTTPConstants.RequestMapping_delMonthLogInfo, monthLogId);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 测试获得新增月任务数量
   */
  @Test
  public void testGetMonthLogNumber() throws Exception {
    RequestBuilder request = get(MonthLogServiceHTTPConstants.RequestMapping_getMonthLogNumber);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 测试获得增月日志下拉表,根据monthLogId
   */
  @Test
  public void testGetMonthLogContentListById() throws Exception {
    Integer monthLogId = 102;
    RequestBuilder request = get(MonthLogServiceHTTPConstants.RequestMapping_getMonthLogContentListById, monthLogId);

    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 查询month这个月的月日志id
   */
  @Test
  public void testGetMonthLogIdByMonth() throws Exception {
    String month = "2017-07";
    TcUser tcUser = new TcUser();
    tcUser.setId(22);
    String user = JsonUtil.toJson(tcUser);
    RequestBuilder request = post(MonthLogServiceHTTPConstants.RequestMapping_getMonthLogIdByMonth)
      .contentType(MediaType.APPLICATION_JSON).content(user)
      .param("month", month);
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
