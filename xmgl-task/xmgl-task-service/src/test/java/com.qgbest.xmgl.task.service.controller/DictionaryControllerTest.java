package com.qgbest.xmgl.task.service.controller;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.DictionaryServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.Dictionary;
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
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;
import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created with IntelliJ IDEA.
 * User: ccr
 * Date: 2017/8/16.
 * Time: 10:46
 * description: 项目字典接口测试
 */
    @RunWith(SpringRunner.class)
    @SpringBootTest(classes = Application.class)
    @Transactional
    public class DictionaryControllerTest {
        private MockMvc mockMvc;
        @Autowired
        protected WebApplicationContext webApplicationContext;
        @Before
       public void setupMockMvc(){mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();}//mockmvc对象初始化
    /**
     * 测试查询字典列表
     * @throws Exception
     */
    @Test
    public void testQueryDictionaryList()throws Exception{
        Map queryMap = new HashMap();
        queryMap.put("business_name","任务状态");
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder requestBuilder = post(DictionaryServiceHTTPConstants.RequestMapping_queryDictionaryList)
                .param("queryMap",queryMapStr)
                .param("len","20")
                .param("page","1");
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("total")));

    }
    /**
     * 测试删除字典
     * @throws Exception
     */
    @Test
    public  void testDelDictionaryInfoById()throws Exception{
        RequestBuilder requestBuilder = delete(DictionaryServiceHTTPConstants.RequestMapping_delDictionaryInfoById,1);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试启用字典
     * @throws Exception
     */
    @Test
    public void  testStartDictionaryById()throws Exception{
        RequestBuilder requestBuilder = post(DictionaryServiceHTTPConstants.RequestMapping_startDictionaryById,1);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试禁用字典
     * @throws Exception
     */
    @Test
    public void testForbiddenDictionaryById()throws Exception{
        RequestBuilder requestBuilder = post(DictionaryServiceHTTPConstants.RequestMapping_forbiddenDictionaryById,1);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("操作成功")));
    }
    /**
     * 测试获取字典类型列表
     * @throws Exception
     */
    @Test
    public void testGetBusinessTypeList()throws Exception{
      RequestBuilder requestBuilder = get(DictionaryServiceHTTPConstants.RequestMapping_getBusinessTypeList).accept(MediaType.APPLICATION_JSON_UTF8);
      mockMvc.perform(requestBuilder)
              .andExpect(status().isOk())
              .andExpect(content().string(containsString("计划完成情况分类")))
              .andDo(print());
    }
    /**
     * 测试根据id获取字典详情
     * @throws Exception
     */
    @Test
    public void testGetDictionaryInfoById()throws Exception{
        RequestBuilder requestBuilder = post(DictionaryServiceHTTPConstants.RequestMapping_getDictionaryInfoById,15).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("计划完成情况")))
                .andDo(print())
                .andExpect(jsonPath("$.business_name").value("计划完成情况"));

    }
    /**
     * 测试保存字典
     * @throws Exception
     */
    @Test
    public void testSaveDictionary()throws Exception{
        Dictionary dictionary = new Dictionary();
        dictionary.setBusiness_name("任务类别");
        dictionary.setBusiness_type("task_type");
        dictionary.setData_code("CS");
        dictionary.setData_desc("测试");
        dictionary.setData_name("测试");
        dictionary.setIs_used(0);
        String requestJsonStr = JsonUtil.toJson(dictionary);
        System.out.println(requestJsonStr);
        RequestBuilder requestBuilder = put(DictionaryServiceHTTPConstants.RequestMapping_saveDictionary)
                .contentType(MediaType.APPLICATION_JSON).content(requestJsonStr);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("任务类别")))
                .andExpect(jsonPath("$.msgDesc").value("操作成功"))
                .andDo(print());
    }





}
