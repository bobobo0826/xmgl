package com.qgbest.xmgl.employee.client;

import com.qgbest.xmgl.employee.api.constants.EmployeeServiceHTTPConstants;
import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;
import java.util.List;

/**
 * Created by wjy on 2017/7/18.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface EmployeeFeignClient {
    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_listEmployee,method = RequestMethod.POST)
    public Map getEmployeeList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;

    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_getEmployeeOperateLog,method = RequestMethod.POST)
    public Map getEmployeeOperateLog(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;


    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_selectEmployeeList,method = RequestMethod.POST)
    public Map selectEmployeeList(@RequestParam("queryMap") String queryMap, @RequestParam("len") Integer len, @RequestParam("page") Integer page, @RequestBody TcUser user) ;

    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_getEmployeeInfoById,method = RequestMethod.GET)
    public Employee getEmployeeInfoById(@RequestParam("id") Integer id);
    
    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_saveEmployee,method = RequestMethod.PUT)
    public Map saveEmployee(@RequestBody Employee employee,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName) ;
    
    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_delEmployee,method = RequestMethod.DELETE)
    public ReturnMsg delEmployee(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_getEmployeeInfoByUserId,method = RequestMethod.GET)
    public Employee getEmployeeInfoByUserId(@RequestParam("user_id") Integer user_id);

    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_getEmployeeListByDept,method = RequestMethod.POST)
    public List getEmployeeListByDept(@RequestParam("dept_name") String dept_name);

/*    @RequestMapping(value = EmployeeServiceHTTPConstants.RequestMapping_setEmployeeUserId,method = RequestMethod.DELETE)
    public Map setEmployeeUserId(@RequestParam("id") Integer id);*/

}
