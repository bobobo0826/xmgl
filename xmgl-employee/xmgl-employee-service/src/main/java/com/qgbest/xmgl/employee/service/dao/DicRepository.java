package com.qgbest.xmgl.employee.service.dao;


import com.qgbest.xmgl.employee.api.entity.Dictionary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
@Repository
public interface DicRepository extends JpaRepository<Dictionary,String> {
    @Query("select distinct  u.business_type,u.business_name from Dictionary u ")
    public List getBusinessTypeList();

    @Modifying
    @Query(value = "delete  from Dictionary u where u.id=?1")
    public void deleteById(Integer id);

    @Query(value = "select u from Dictionary u where u.id=?1")
    public Dictionary findById(Integer id);

    @Query("select u.data_code,u.data_name from Dictionary u where u.business_type=?1")
    public List getDicListByBusinessCode(String businessCode);
}
