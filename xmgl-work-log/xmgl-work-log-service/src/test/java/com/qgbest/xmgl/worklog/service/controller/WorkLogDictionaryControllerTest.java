package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.worklog.api.constants.CommonDicServiceHTTPConstants;

import com.qgbest.xmgl.worklog.service.Application;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created by Lu Tianle on 2017/8/7.
 * description: 字典样式接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class WorkLogDictionaryControllerTest {
  private MockMvc mockMvc;
  @Autowired
  protected WebApplicationContext wac;

  @Before
  public void setupMockMvc() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
  }

  /**
   * 根据业务类型code获取name
   */
  @Test
  public void testGetDicListByBusinessCode() throws Exception {
    String businessCode = "mission_type";

    RequestBuilder request = get(CommonDicServiceHTTPConstants.RequestMapping_getDicListByBusinessCode, businessCode);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print());
  }

  /**
   * 根据业务类型code和数据类型code获取name
   */
  @Test
  public void testGetDataNameByDataCode() throws Exception {
    String businessCode = "mission_type";
    String dataCode = "XMRW";

    RequestBuilder request = get(
      CommonDicServiceHTTPConstants.RequestMapping_getDataNameByDataCode, businessCode, dataCode);
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
