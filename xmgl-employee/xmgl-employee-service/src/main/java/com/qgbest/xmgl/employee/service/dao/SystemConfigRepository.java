package com.qgbest.xmgl.employee.service.dao;


import com.qgbest.xmgl.employee.api.entity.SystemConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by xw on 2017/6/19.
 */
public interface SystemConfigRepository extends JpaRepository<SystemConfig, String> {
    @Modifying
    @Query(value = "delete  from SystemConfig u where u.id=?1")
    public void delSystemById(Integer id);

    @Query(value = "select u from SystemConfig u where u.id=?1")
    public SystemConfig findSystemById(Integer id);

    @Query(value = "select u.data_value from SystemConfig u where u.data_code=?1")
    public String getDataValue(String data_code);
}
