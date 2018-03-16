package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.GlanceOverServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
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

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created by liubo on 2017/8/7.
 * description: 浏览记录接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class GlanceOverControllerTest {
  private MockMvc mockMvc;
  @Autowired
  protected WebApplicationContext wac;

  @Before
  public void setupMockMvc() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
  }

  /**
   * 保存浏览信息
   */
  @Test
  public void testSaveGlanceOverInfo() throws Exception {
    GlanceOver glanceOver = new GlanceOver();
    glanceOver.setGlance_over_type("MZJH");
    glanceOver.setGlance_over_subject_id(110);
    glanceOver.setGlance_over_id(2);
    glanceOver.setGlance_over_name("超级管理员");
    glanceOver.setGlance_over_photo("121212");
    glanceOver.setGlance_over_time("2017-08-07 15:13");
    String requestJson = JsonUtil.toJson(glanceOver);
    RequestBuilder request = put(GlanceOverServiceHTTPConstants.RequestMapping_saveGlanceOverInfo)
      .contentType(MediaType.APPLICATION_JSON).content(requestJson);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 根据id查询浏览信息
   */
  @Test
  public void testGetGlanceOverListById() throws Exception {
    Integer glanceOverId = 56;
    String type = "MZJH";
    RequestBuilder request = get(GlanceOverServiceHTTPConstants.RequestMapping_getGlanceOverListById)
      .param("id", glanceOverId.toString())
      .param("type", type);

    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 更新保存浏览信息
   */
  @Test
  public void testUpdateAndSaveGlanceOver() throws Exception {
    Integer thumbsUpId = 57;
    String type = "MZJH";
    TcUser tcUser = new TcUser();
    tcUser.setId(2);
    String user = JsonUtil.toJson(tcUser);
    RequestBuilder request = post(GlanceOverServiceHTTPConstants.RequestMapping_UpdateAndSaveGlanceOver)
      .param("id", thumbsUpId.toString())
      .contentType(MediaType.APPLICATION_JSON).content(user)
      .param("type", type);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
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
