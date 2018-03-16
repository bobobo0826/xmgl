package com.qgbest.xmgl.employee.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.employee.api.constants.SysdataGridPersonConfigServiceHTTPConstants;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Created with IntelliJ IDEA.
 * User: wangchao
 * Date: 2017/8/04
 * Time: 10:16
 * description: 个人dataGrid样式接口测试
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
     * 测试根据用户id获取个人dataGrid样式
     */
    @Test
    public void testGetConfVal() throws Exception {
        RequestBuilder request = get(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getConfVal, 22).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("员工姓名")))
                .andDo(print());
    }
    /**
     * 测试根据用户id和模块code获取个人dataGrid样式
     */
    @Test
    public void testGetConfvalByIdAndCode() throws Exception {
        RequestBuilder request = get(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getconfvalByIdAndCode, 22,"YGXXGL").accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("员工姓名")))
                .andDo(print());
    }
    /**
     * 测试新增保存个人dataGrid样式
     *
     * @throws Exception
     */
    @Test
    public void testSavePersonGridStyle() throws Exception {
        Map map = new HashMap();
        List list = new ArrayList();
        map.put("field","员工姓名");
        map.put("resizable",true);
        map.put("width",100);
        map.put("headalign","center");
        map.put("align","center");
        map.put("sortable",true);
        map.put("order","asc");
        String  one_column = JsonUtil.toJson(map);//转json
        list.add(one_column);//转json数组
        String gridStyle = JsonUtil.toJson(list);

        System.out.println(list);
        RequestBuilder request = put(SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_savePersonGridStyle)
                .param("gridStyle", gridStyle)
                .param("curModuleCode", "YGXXGL")
                .param("userId", "22")
                .param("userName", "陆天乐");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }

}