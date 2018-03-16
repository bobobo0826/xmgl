package com.qgbest.xmgl.employee.service.controller;

import com.qgbest.xmgl.employee.api.constants.CommonDicServiceHTTPConstants;
import com.qgbest.xmgl.employee.service.Application;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created with IntelliJ IDEA.
 * User: wangchao
 * Date: 2017/8/04
 * Time: 10:16
 * description: 字典表接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class DicControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 测试根据业务类型code获取name
     */
    @Test
    public void testGetDicListByBusinessCode() throws Exception {
        RequestBuilder request = get(CommonDicServiceHTTPConstants.RequestMapping_getDicListByBusinessCode, "education_bg").accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("初中")))
                .andDo(print());
    }
    /**
     * 测试根据业务类型code和数据类型code获取name
     */
    @Test
    public void testGetDataNameByDataCode() throws Exception {
        RequestBuilder request = get(CommonDicServiceHTTPConstants.RequestMapping_getDataNameByDataCode, "education_bg","CZ").accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("初中")))
                .andDo(print());
    }
}