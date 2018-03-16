package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.StandardsServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.WritingStandards;
import com.qgbest.xmgl.task.service.Application;
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

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by fcy on 2017/8/16.
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class StandardsControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }


    /**
     * 测试获取规范列表
     */
    @Test
    public void getStandardsList() throws Exception {
        String parentId = "-1";

        RequestBuilder request = post(StandardsServiceHTTPConstants.RequestMapping_getStandardsList)
                .param("parentId", parentId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试获取已发布规范列表
     */
    @Test
    public void getStandardsShowList() throws Exception {
        String parentId = "21";

        RequestBuilder request = post(StandardsServiceHTTPConstants.RequestMapping_getStandardsShowList)
                .param("parentId", parentId);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试规范详情
     */
    @Test
    public void testGetStandardsInfo() throws Exception {
        String id = "19";

        RequestBuilder request = get(StandardsServiceHTTPConstants.RequestMapping_getStandardsInfo, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

    /**
     * 测试保存规范
     */
    @Test
    public void testSaveStandardsInfo() throws Exception {
       WritingStandards writingStandards = new WritingStandards();

        writingStandards.setStatus("未发布");
        writingStandards.setStandards_name("房贷首付");
        writingStandards.setStandards_content("发射点发生");
        writingStandards.setCreator("超级管理员");
        writingStandards.setCreate_date("2017-08-04 8:44");
        writingStandards.setModifier("超级管理员");
        writingStandards.setModify_date("2017-08-27 14:30");
        writingStandards.setOrder_no(2);
        writingStandards.setParent_id(21);

        String writingStandardsJson = JsonUtil.toJson(writingStandards);
        RequestBuilder request = put(StandardsServiceHTTPConstants.RequestMapping_saveStandardsInfo)
                .contentType(MediaType.APPLICATION_JSON).content(writingStandardsJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试删除规范
     */
    @Test
    public void testDelStandardsInfo() throws Exception {
        Integer id = 23;
        RequestBuilder request = delete(StandardsServiceHTTPConstants.RequestMapping_delStandardsInfo, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试发布规范
     */
    @Test
    public void testPublishStandardsById() throws Exception {
        Integer id = 23;
        RequestBuilder request = post(StandardsServiceHTTPConstants.RequestMapping_publishStandards, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }

    /**
     * 测试撤销发布规范
     */
    @Test
    public void testUnpublishStandardsById() throws Exception {
        Integer id = 22;
        RequestBuilder request = post(StandardsServiceHTTPConstants.RequestMapping_unPublishStandards, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试获取规范页面列表
     */
    @Test
    public void getStandardsPage() throws Exception {

        RequestBuilder request = post(StandardsServiceHTTPConstants.RequestMapping_getStandardsPage);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }






}
