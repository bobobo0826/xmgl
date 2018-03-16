package com.qgbest.xmgl.employee.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.service.dao.EmployeeExtends;
import com.qgbest.xmgl.employee.service.dao.EmployeeRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmployeeExtends employeeExtends;
    @Autowired
    private EmployeeRepository employeeRepository;
    
    /**
     * 查询员工信息列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */
    
    public PageControl queryEmployeeList(Map queryMap, int cpage, int len, TcUser user) {
        return this.employeeExtends.findEmployeeList(queryMap,cpage,len,user);
    }
    public PageControl getEmployeeOperateLog(Map queryMap, int cpage, int len, TcUser user) {
        return this.employeeExtends.getEmployeeOperateLog(queryMap, cpage, len, user);
    }
    /**
     * 查询员工信息列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */

    public PageControl selectEmployeeList(Map queryMap, int cpage, int len, TcUser user) {
        return this.employeeExtends.selectEmployeeList(queryMap,cpage,len,user);
    }
    /**
     * 员工信息删除
     * @param id 员工信息ID
     * @return
     */
    public ReturnMsg deleteById(Integer  id) {
        this.employeeRepository.deleteEmployeeById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }

/*    public Map setEmployeeUserId(Integer employeeId,Integer userId){
        this.employeeRepository.setEmployeeUserId(employeeId,userId);
    }*/

    public Employee getEmployeeInfoById(Integer id) {
        if (id!=null && id!=-1){
            return this.employeeRepository.getEmployeeInfoById(id);
        }
        else{
            return new Employee();
        }

    }
    public Employee getEmployeeInfoByUserId(Integer user_id) {
        List employeeList = employeeRepository.getEmployeeInfoByUserId(user_id);
        if (employeeList!=null&&employeeList.size()>0){
             return (Employee)employeeList.get(0);
        }
        else{
            return new Employee();
        }
    }

    /**
     * 员工信息保存
     * @param employee 员工信息
     * @return
     */
    public ReturnMsg saveEmployee(Employee employee) {
        this.employeeRepository.save(employee);
        ReturnMsg returnMsg =new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(employee));
    }
    public Employee getOldEmployee(Integer id){
        return employeeExtends.getOldEmployee(id);
    }
    public List getEmployeeListByDept(String dept_name){
        return employeeExtends.getEmployeeListByDept(dept_name);
    }
}
