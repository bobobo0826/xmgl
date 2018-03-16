package com.qgbest.xmgl.employee.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.employee.api.constants.EmployeeServiceHTTPConstants;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.service.Application;
import com.qgbest.xmgl.user.api.entity.TcUser;
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

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created with IntelliJ IDEA.
 * User: wangchao
 * Date: 2017/8/03
 * Time: 13:46
 * description: 员工接口测试
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
@Transactional
public class EmployeeControllerTest {
    private MockMvc mockMvc;
    @Autowired
    protected WebApplicationContext wac;

    @Before
    public void setupMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();  //初始化MockMvc对象
    }

    /**
     * 测试员工列表查询
     */
    @Test
    public void testGetEmployeeList() throws Exception {
        Map queryMap = new HashMap();
        TcUser tcUser = new TcUser();
        tcUser.setId(4);
        queryMap.put("employee_name", "王超");
        queryMap.put("_curModuleCode", "YGXXGL");
        String queryMapStr = JsonUtil.toJson(queryMap);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(EmployeeServiceHTTPConstants.RequestMapping_listEmployee)
                .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("total")));
    }
    /**
     * 测试选择员工列表查询
     */
    @Test
    public void testSelectEmployeeList() throws Exception {
        Map queryMap = new HashMap();
        TcUser tcUser = new TcUser();
        tcUser.setId(4);
        queryMap.put("employee_name", "吴锦钰");
        queryMap.put("_curModuleCode", "YGXXGL");
        String queryMapStr = JsonUtil.toJson(queryMap);
        String user = JsonUtil.toJson(tcUser);
        RequestBuilder request = post(EmployeeServiceHTTPConstants.RequestMapping_listEmployee)
                .contentType(MediaType.APPLICATION_JSON).content(user)//参数名和controller中的要一致
                .param("queryMap", queryMapStr)
                .param("len", "20")
                .param("page", "1");
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andDo(print())
                .andExpect(content().string(containsString("total")));
    }
    /**
     * 测试根据员工id查询员工详情
     *
     * @throws Exception
     */
    @Test
    public void testGetEmployeeInfoById() throws Exception {
        RequestBuilder request = get(EmployeeServiceHTTPConstants.RequestMapping_getEmployeeInfoById, 4).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("王超")))
                .andDo(print()).andExpect(jsonPath("$.employee_name").value("王超"));

    }
    /**
     * 测试新增保存员工
     *
     * @throws Exception
     */
    @Test
    public void testSaveEmployee() throws Exception {
        Employee employee = new Employee();
        Map map = new HashMap();
        map.put("gender","男");
        map.put("skills","");
        map.put("hobbies","");
        map.put("birthday","");
        map.put("entry_date","");
        map.put("leave_date","");
        map.put("education_bg","");
        map.put("mobilephone_number","13245678984");
        String basic_info = JsonUtil.toJson(map);

        employee.setEmployee_name("王超");
        employee.setBasic_info(basic_info);
        employee.setEmployment_code("SX");
        employee.setCreator_id(2);
        employee.setCreator("超级管理员");
        employee.setCreate_date("2017-07-24 17:32");
        employee.setModifier_id(2);
        employee.setModifier("超级管理员");
        employee.setDept_id(3321);
        employee.setDept_name("开发一部");
        employee.setPhoto("upload\\YGZP\\0faa6a89-b732-48ea-82a9-883b2b699ee4.jpg");
        employee.setUser_id(26);
        employee.setPosition_code("KFRY");
        employee.setPosition_name("开发人员");
        String requestJson = JsonUtil.toJson(employee);

        System.out.println(requestJson);
        RequestBuilder request = put(EmployeeServiceHTTPConstants.RequestMapping_saveEmployee)
                .contentType(MediaType.APPLICATION_JSON).content(requestJson);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("王超")))
                .andDo(print())
                .andExpect(jsonPath("$.msgDesc").value("操作成功"));
    }
    /**
     * 测试删除员工
     *
     * @throws Exception
     */
    @Test
    public void testDelEmployee() throws Exception {
        RequestBuilder request = delete(EmployeeServiceHTTPConstants.RequestMapping_delEmployee, 4);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("操作成功")))
                .andExpect(jsonPath("$.msgDesc").value("操作成功"));
    }
    /**
     * 测试根据用户id查询员工详情
     *
     * @throws Exception
     */
    @Test
    public void testGetEmployeeInfoByUserId() throws Exception {
        RequestBuilder request = get(EmployeeServiceHTTPConstants.RequestMapping_getEmployeeInfoByUserId, 26).accept(MediaType.APPLICATION_JSON_UTF8);
        mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("王超")))
                .andDo(print())
                .andExpect(jsonPath("$.employee_name").value("王超"));
    }
}