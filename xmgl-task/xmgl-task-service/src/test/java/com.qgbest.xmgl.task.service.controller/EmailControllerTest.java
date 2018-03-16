package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.EmailServiceHTTPConstants;
import com.qgbest.xmgl.task.service.Application;
import org.junit.Before;
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

import java.util.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by wangchao on 2017/9/30.
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class EmailControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    @Test
    public void testSendBusinessEmail() throws Exception {
        Map queryMap = new HashMap();
        List recvs = new ArrayList();
        recvs.add("1428554573@qq.com");
        queryMap.put("templet_code", "CJRWTZ");
        queryMap.put("receivers", recvs);
        queryMap.put("task_name", "全高项目管理系统");
        queryMap.put("creator", "王超");
        queryMap.put("task_start_time", "2017-9-20 11:10");
        queryMap.put("task_end_time", "2017-9-30 11:10");
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder request = post(EmailServiceHTTPConstants.RequestMapping_sendBusinessEmail)
                .param("queryMap", queryMapStr);

        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
}
