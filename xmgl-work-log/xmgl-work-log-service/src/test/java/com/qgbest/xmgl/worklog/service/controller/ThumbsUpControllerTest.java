package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ThumbsUpServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
/**
 * Created by liubo on 2017/8/7.
 * description: 点赞接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class ThumbsUpControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 测试保存点赞信息
     */
    @Test
    public void testSaveThumbsUpInfo() throws Exception {
        ThumbsUp thumbsUp = new ThumbsUp();
        thumbsUp.setThumbs_up_type("MRJH");
        thumbsUp.setThumbs_up_subject_id(173);
        thumbsUp.setThumbs_up_id(2);
        thumbsUp.setThumbs_up_name("超级管理员");
        thumbsUp.setThumbs_up_photo("1111");
        thumbsUp.setThumbs_up_time("MRJH");
        String requestJson = JsonUtil.toJson(thumbsUp);
        RequestBuilder request = put(ThumbsUpServiceHTTPConstants.RequestMapping_saveThumbsUpInfo)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 测试删除点赞信息
     */
    @Test
    public void testDelThumbsUpInfo() throws Exception {
        Integer thumbsUpId = 39;
        String type="MZJH";
        TcUser tcUser = new TcUser();
        tcUser.setId(2);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = delete(ThumbsUpServiceHTTPConstants.RequestMapping_delThumbsUpInfo)
                .param("id",thumbsUpId.toString())
                .contentType(MediaType.APPLICATION_JSON).content(user)
                .param("type",type);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 根据id查询点赞信息
     */
    @Test
    public void testGetThumbsUpListById() throws Exception {
        Integer thumbsUpId = 73;
        String type="MRJH";
        RequestBuilder request = get(ThumbsUpServiceHTTPConstants.RequestMapping_getThumbsUpListById)
                .param("id",thumbsUpId.toString())
                .param("type",type);


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
