package com.qgbest.xmgl.task.service.controller;
import com.qgbest.xmgl.task.api.constants.SysdataGridPersonConfigServiceHTTPConstants;
import com.qgbest.xmgl.task.api.constants.SystemConfigServiceHTTPConstants;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.MyTaskServiceHTTPConstants;
import com.qgbest.xmgl.task.api.constants.TaskServiceHTTPConstants;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.task.service.Application;
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
import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
/**
 * Created by liubo on 2017/8/8.
 * description:SystemConfigController测试用例
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class SystemConfigControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 通过code查询value
     */
    @Test
    public void testGetDataValueByCode() throws Exception {
        String dataCode = "MYYGXX";
        RequestBuilder request = get(SystemConfigServiceHTTPConstants.RequestMapping_getSyetemConfDataValue, dataCode);
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
