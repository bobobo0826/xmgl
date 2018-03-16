package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.TaskLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.service.Application;
import org.junit.Before;
import org.junit.Ignore;
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
import java.util.HashMap;
import java.util.Map;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
/**
 * Created by liubo on 2017/8/8.
 * description:
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class TaskLogControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 项目任务日志列表查询
     */
    @Test
    public void testQueryTaskLogList() throws Exception {
        Map queryMap = new HashMap();
        queryMap.put("period", "DAY");
        String queryMapStr = JsonUtil.toJson(queryMap);
        RequestBuilder request = post(TaskLogServiceHTTPConstants.RequestMapping_queryTaskLogList)
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print());
    }
    /**
     * 获取周期列表
     */
    @Test
    public void testGetPeriodList() throws Exception {

        RequestBuilder request = get(TaskLogServiceHTTPConstants.RequestMapping_getPeriodList);

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
