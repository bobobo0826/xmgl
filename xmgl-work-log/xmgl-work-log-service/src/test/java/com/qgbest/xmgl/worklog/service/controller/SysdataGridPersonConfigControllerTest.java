package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.SysdataGridPersonConfigServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.SysdataGridPersonConfig;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by liubo on 2017/8/8.
 * description:SysdataGridPersonConfig测试用例
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class SysdataGridPersonConfigControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }


    /**
     * 测试根据ID获取个人datagrid样式
     */
    @Test
    public void testGetConfVal() throws Exception {
        Integer id = 2;
        RequestBuilder request = get(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getConfVal, id);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试根据用户ID和modelCode获取个人datagrid样式
     */
    @Test
    public void testGetConfvalByIdAndCode() throws Exception {
        Integer id = 2;
        String modelCode="MY_MZJH";
        RequestBuilder request = get(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getconfvalByIdAndCode, id,modelCode);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 测试保存个人datagrid样式
     */
    @Test
    public void testSavePersonGridStyle() throws Exception {
        Integer userId = 2;
        String gridStyle="样式明细";
        String curModuleCode="MY_MRJH";
        String userName="超级管理员";
        SysdataGridPersonConfig sysdataGridPersonConfig = new SysdataGridPersonConfig();
        sysdataGridPersonConfig.setConf_val("1212121212");
        sysdataGridPersonConfig.setCreate_date("2017-07-25 15:26");
        sysdataGridPersonConfig.setModule_code("MY_MRJH");
        sysdataGridPersonConfig.setUser_id(2);
        sysdataGridPersonConfig.setUser_name("超级管理员");
        String requestJson = JsonUtil.toJson(sysdataGridPersonConfig);
        RequestBuilder request = put(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_savePersonGridStyle)
                .param("userId",userId.toString())
                .param("gridStyle",gridStyle)
                .param("userName",userName)
                .param("curModuleCode",curModuleCode)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
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














}
