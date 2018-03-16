package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.CommentsServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.Comments;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created by quangao-Lu Tianle on 2017/8/3.
 * description: 评论接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class CommentsControllerTest {
  private MockMvc mockMvc;
  @Autowired
  protected WebApplicationContext wac;

  @Before
  public void setupMockMvc() {
    mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
  }

  /**
   * 测试查询评论
   */
  @Test
  public void testGetCommentsList() throws Exception {
    String businessId = "78";
    String parentId = "0";
    String businessType = "MRJH";

    Map queryMap = new HashMap();
    TcUser tcUser = new TcUser();
    String queryMapStr = JsonUtil.toJson(queryMap);
    String user = JsonUtil.toJson(tcUser);
    RequestBuilder request = post(CommentsServiceHTTPConstants.RequestMapping_getCommentsList)
      .contentType(MediaType.APPLICATION_JSON).content(user)
      .param("queryMap", queryMapStr)
      .param("id", businessId)
      .param("parent_id", parentId)
      .param("business_type", businessType)
      .param("creator_id", "0");
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("total")));
  }

  /**
   * 测试保存评论
   */
  @Test
  public void testSaveComments() throws Exception {
    Comments comments = new Comments();
    comments.setComment_type("GK");
    comments.setCommentator_id(22);
    comments.setCommentator_photo("");
    comments.setCommentator_name("陆天乐");
    comments.setReplier_name("陆天乐");
    comments.setReplier_id(22);
    comments.setReplier_photo("");
    comments.setBusiness_id(78);
    comments.setContent("评论");
    comments.setComment_time("2017-08-09");
    comments.setParent_id(0);
    comments.setReply_type("NM");

    String requestJson = JsonUtil.toJson(comments);
    RequestBuilder request = post(CommentsServiceHTTPConstants.RequestMapping_saveComments)
      .contentType(MediaType.APPLICATION_JSON).content(requestJson);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  /**
   * 测试删除评论
   */
  @Test
  public void testDelComments() throws Exception {
    Integer commentId = 100;
    RequestBuilder request = delete(CommentsServiceHTTPConstants.RequestMapping_delComments, commentId);
    mockMvc.perform(request)
           .andExpect(status().isOk())
           .andDo(print())
           .andExpect(content().string(containsString("操作成功")));
  }

  @Test
  /**
   * 测试查询评论数
   */

  public void testGetCommentsCount() throws Exception {
    String businessId = "78";
    String businessType = "MRJH";
    String creatorId = "22";
    TcUser tcUser = new TcUser();
    tcUser.setId(22);

    String user = JsonUtil.toJson(tcUser);
    Map queryMap = new HashMap();
    String queryMapStr = JsonUtil.toJson(queryMap);
    RequestBuilder request = post(CommentsServiceHTTPConstants.RequestMapping_getCommentsCount)
      .contentType(MediaType.APPLICATION_JSON).content(user)
      .param("queryMap",queryMapStr)
      .param("id",businessId)
      .param("business_type",businessType)
      .param("creator_id",creatorId);
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
