package com.qgbest.xmgl.employee.service.dao;

import com.qgbest.xmgl.employee.api.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Created by wjy on 2017/7/18.
 */
public interface EmployeeRepository extends JpaRepository<Employee,String> {
    @Query(value = "select u from Employee u where u.id=?1")
    public Employee getEmployeeInfoById(Integer id);

    @Query(value = "select u from Employee u where u.user_id=?1")
    public List getEmployeeInfoByUserId(Integer user_id);

    @Modifying
    @Query(value = "delete  from Employee u where u.id=?1")
    public void deleteEmployeeById(Integer id);
}
