package com.qgbest.xmgl.employee.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.service.dao.EmployeeExtends;
import com.qgbest.xmgl.employee.service.dao.EmployeeRepository;
import com.qgbest.xmgl.employee.service.service.EmployeeService;
import com.qgbest.xmgl.employee.service.service.LogService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

/**
 * Created by wjy on 2017/7/18.
 */
@Api(value = "员工信息管理",description="提供员工信息管理增删改查API")
@RestController
@RequestMapping(value = "/manage/employee")
public class EmployeeController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(EmployeeController.class);
    @Autowired
    private EmployeeService employeeService;
    @Autowired
    private LogService logService;
    @Autowired
    private EmployeeExtends employeeExtends;


    @RequestMapping(value = "/selectEmployeeLists")
    @ResponseBody
    public List selectEmployeeLists(HttpServletRequest request)  {
        Map query =new HashMap<>();
        List list =employeeExtends.getEmployeeListName(query);
        return list;
    }


    @ApiOperation(value = "员工信息分页查询", notes = "员工信息分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/getEmployeeList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map getEmployeeList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.employeeService.queryEmployeeList(query, page, len, user);
        jsonData = getQueryMap(pc);
        return jsonData;
    }
    @ApiOperation(value="操作日志查询", notes="操作日志查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/getEmployeeOperateLog", produces= MediaType.APPLICATION_JSON_VALUE)
    public Map getEmployeeOperateLog(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map jsonData = new HashMap();
        Map query= JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.employeeService.getEmployeeOperateLog(query, page, len,user);
        jsonData=getQueryMap(pc);
        return jsonData;
    }

    @ApiOperation(value = "查询员工界面的员工列表", notes = "查询员工界面的员工列表")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "len", value = "查询个数", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "int", name = "page", value = "查询页码", required = true, paramType = "query"),
            @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
    })
    @PostMapping(value = "/selectEmployeeList", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map selectEmployeeList(@RequestParam String queryMap, @RequestParam Integer len, @RequestParam Integer page, @RequestBody TcUser user) {
        Map query = JsonUtil.fromJsonToMap(queryMap);
        PageControl pc = this.employeeService.selectEmployeeList(query, page, len, user);
        return getQueryMap(pc);
    }

    @ApiOperation(value = "获取员工信息model", notes = "根据员工信息ID获取员工信息model")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/getEmployeeInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Employee getEmployeeInfoById(@PathVariable Integer id) {
        Employee employee;
        employee = employeeService.getEmployeeInfoById(id);
        return employee;
    }


    @RequestMapping(value = "/getEmployeeInfoByUserId/{user_id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Employee getEmployeeInfoByUserId(@PathVariable Integer user_id) {
        return employeeService.getEmployeeInfoByUserId(user_id);
    }


    @ApiOperation(value = "员工信息保存", notes = "员工信息保存")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "Employee", name = "employee", value = "员工信息model", required = true, paramType = "body"),
    })
    @RequestMapping(value = "/saveEmployee", method = RequestMethod.PUT)
    public Map saveEmployee(@RequestBody Employee employee,@RequestParam Integer userId,@RequestParam String userName) {
        logger.debug("保存员工信息信息：{}", employee);
        Map map = new HashMap();
        String operate= ServiceConstants.modify_operate;
        Employee oldEmployee=null;
        if(employee.getId()==null||employee.getId()==-1){
            operate= ServiceConstants.add_operate;
        }else{
            oldEmployee=employeeService.getOldEmployee(employee.getId());
        }
        ReturnMsg msg = employeeService.saveEmployee(employee);
        logService.addLog(operate, employee.getId() + "", JsonUtil.toJson(oldEmployee), JsonUtil.toJson(employee), "employees",userName,userId , "",
                employee.getEmployee_name());
        map.put("employee", employee);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }

    @ApiOperation(value = "员工信息删除", notes = "根据员工信息ID获取员工信息model")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "integer", name = "id", value = "id", required = true, paramType = "path"),
    })
    @RequestMapping(value = "/delEmployee/{id}/{userId}/{userName}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ReturnMsg delEmployee(@PathVariable("id") Integer id,@PathVariable("userId") Integer userId,@PathVariable("userName") String userName) {
        Employee employee=getEmployeeInfoById(id);
        logService.addLog(ServiceConstants.delete_operate, employee.getId() + "", JsonUtil.toJson(employee), null, "employees",userName,userId , "",
                employee.getEmployee_name());
        return employeeService.deleteById(id);
    }



    @RequestMapping(value = "/getEmployeeListByDept/{dept_name}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public List getEmployeeListByDept(@PathVariable String dept_name) {
        return employeeService.getEmployeeListByDept(dept_name);
    }



/*    @RequestMapping(value = "/setEmployeeUserId", method = RequestMethod.PUT)
    public Map setEmployeeUserId(@RequestParam Integer employeeId, @RequestParam Integer userId) {
        return employeeService.setEmployeeUserId(employeeId, userId);
    }*/
}
