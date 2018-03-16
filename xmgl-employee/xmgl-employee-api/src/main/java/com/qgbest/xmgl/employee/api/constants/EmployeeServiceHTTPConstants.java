package com.qgbest.xmgl.employee.api.constants;

/**
 * Created by wjy on 2017/7/18.
 */
public interface EmployeeServiceHTTPConstants {
    /**
     * 获取员工列表
     */
    public final static String RequestMapping_listEmployee = "/manage/employee/getEmployeeList";
    public final static String RequestMapping_getEmployeeOperateLog = "/manage/employee/getEmployeeOperateLog";

    /**
     * 获取员工列表
     */
    public final static String RequestMapping_selectEmployeeList = "/manage/employee/selectEmployeeList";
    /**
     * 获取员工详情
     */
    public final static String RequestMapping_getEmployeeInfoById = "/manage/employee/getEmployeeInfoById/{id}";

    /**
     * 保存员工
     */
    public final static String RequestMapping_saveEmployee = "/manage/employee/saveEmployee";
    /**
     * 删除员工
     */
    public final static String RequestMapping_delEmployee = "/manage/employee/delEmployee/{id}/{userId}/{userName}";
    /**
     * 根据userId获取Employee
     */
    public final static String RequestMapping_getEmployeeInfoByUserId = "/manage/employee/getEmployeeInfoByUserId/{user_id}";

    public final static String RequestMapping_getEmployeeListByDept = "/manage/employee/getEmployeeListByDept/{dept_name}";


/*    public final static String RequestMapping_setEmployeeUserId = "/manage/employee/setEmployeeUserId";*/
}
