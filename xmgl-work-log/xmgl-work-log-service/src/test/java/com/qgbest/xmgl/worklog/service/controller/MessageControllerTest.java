package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.MessageServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.service.Application;
import org.junit.Before;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created with IntelliJ IDEA.
 * User: wangchao
 * Date: 2017/8/04
 * Time: 8:46
 * description: 消息接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class MessageControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }


    /**
     * 测试查询消息列表
     *
     * @throws Exception
     */
    @Test
    public void testGetMessageList() throws Exception {
        Map queryMap = new HashMap();
        queryMap.put("messageType", "PL");
        String queryMapStr = JsonUtil.toJson(queryMap);

        RequestBuilder request = post(MessageServiceHTTPConstants.RequestMapping_getMessageList)
                .param("queryMap", queryMapStr);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("PL")));
    }

    /**
     * 测试保存消息
     *
     * @throws Exception
     */
    @Test
    public void testSaveMessage() throws Exception {

        MessageBase messageBase = new MessageBase();
        messageBase.setMessageType("PL");
        messageBase.setIsChecked("0");
        messageBase.setBusinessId(20);
        messageBase.setBusinessType("MRJH");
        messageBase.setCheckTime("2017-08-04 9:30");
        messageBase.setRemindTime("2017-08-04 8:30");
        messageBase.setRemindTitle("来自： 【日日志】 ：陆天乐");
        messageBase.setRemindContent("您的 【日日志】 { 2017-08-01 }收到陆天乐的评论");
        messageBase.setCommentId(50);
        messageBase.setReceiver("超级管理员");
        messageBase.setReceiverId(2);
        messageBase.setSender("陆天乐");
        messageBase.setSenderId(22);
        messageBase.setSenderHeadPhoto("upload\\YGZP\\ef871749-9682-4154-ab53-2a3c41bd73cc.jpg");
        messageBase.setLogDate("2017-08-01");
        String requestJson = JsonUtil.toJson(messageBase);

        System.out.println(requestJson);
        RequestBuilder request = put(MessageServiceHTTPConstants.RequestMapping_saveMessage)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("MRJH")))
                .andDo(print())
                .andExpect(jsonPath("$.msgDesc").value("操作成功"));
    }
     /**
      * 测试更改消息查看状态
     *
      * @throws Exception
     */
    @Test
    public void testCheckMessage() throws Exception {
        Map queryMap = new HashMap();
        queryMap.put("id", "57");
        queryMap.put("checkTime", "2017-08-02 13:31");

        String queryMapStr = JsonUtil.toJson(queryMap);

        RequestBuilder request = post(MessageServiceHTTPConstants.RequestMapping_checkMessage)
                .param("queryMap", queryMapStr);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")))
                .andExpect(jsonPath("$.msgDesc").value("操作成功"));
    }
}