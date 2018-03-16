package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.LogDicServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
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
import org.springframework.web.context.WebApplicationContext;

import javax.transaction.Transactional;
import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by ccr on 2017/8/17.
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class DictionaryControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext webApplicationContext;
    @Before
    public void setupMockMvc(){mockMvc= MockMvcBuilders.webAppContextSetup(webApplicationContext).build();}
    /**
     * 测试查询字典
     * @throws Exception
     */
    @Test
    public void testQueryDictionaryList()throws Exception{
        Map queryMap = new HashMap();
        queryMap.put("business_name","录入类别");
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder requestBuilder = post(LogDicServiceHTTPConstants.RequestMapping_queryLogDictionaryList)
                .param("queryMap",queryMapStr)
                .param("len","20")
                .param("page","1");
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("total")));


    }
    /**
     * 测试删除字典
     * @throws Exception
     */
    @Test
    public void testDelDictionaryInfoById()throws Exception{
        RequestBuilder requestBuilder = delete(LogDicServiceHTTPConstants.RequestMapping_delLogDictionaryInfoById,8);
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
        RequestBuilder requestBuilder = post(LogDicServiceHTTPConstants.RequestMapping_startLogDictionaryById,1);
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
        RequestBuilder requestBuilder = post(LogDicServiceHTTPConstants.RequestMapping_forbiddenLogDictionaryById,1);
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
        RequestBuilder requestBuilder = get(LogDicServiceHTTPConstants.RequestMapping_getBusinessTypeList).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("录入类别")))
                .andDo(print());
    }
    /**
     * 测试根据id获取字典详情
     * @throws Exception
     */
    @Test
    public void testGetDictionaryInfoById()throws Exception{
        RequestBuilder requestBuilder = post(LogDicServiceHTTPConstants.RequestMapping_getLogDictionaryInfoById,1).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("任务类别")))
                .andDo(print())
                .andExpect(jsonPath("$.business_name").value("任务类别"));

    }
    /**
     * 测试保存字典
     * @throws Exception
     */
    @Test
    public void testSaveDictionary()throws Exception{
        Dictionary dictionary = new Dictionary();
        dictionary.setBusiness_name("其他业务类型");
        dictionary.setBusiness_type("other_type");
        dictionary.setData_code("ZDCS");
        dictionary.setData_desc("字典测试");
        dictionary.setData_name("字典测试");
        dictionary.setIs_used(0);
        String requestJsonStr = JsonUtil.toJson(dictionary);
        System.out.println(requestJsonStr);
        RequestBuilder requestBuilder = put(LogDicServiceHTTPConstants.RequestMapping_saveLogDictionary)
                .contentType(MediaType.APPLICATION_JSON).content(requestJsonStr);
        mockMvc.perform(requestBuilder)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("字典测试")))
                .andExpect(jsonPath("$.msgDesc").value("操作成功"))
                .andDo(print());
    }
}
