package com.qgbest.xmgl.task.service.dao;


import com.qgbest.xmgl.task.api.entity.SysdataGridDefaultConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
public interface SysdataGridDefaultRepository extends JpaRepository<SysdataGridDefaultConfig, String> {
    @Query(value = "select u from SysdataGridDefaultConfig u where u.id=?1")
    public SysdataGridDefaultConfig findSysdataById(Integer id);

    @Modifying
    @Query(value = "delete  from SysdataGridDefaultConfig u where u.id=?1")
    public void delSysdataById(Integer id);


    @Query(value = "select u.conf_val from SysdataGridDefaultConfig u where u.module_code=?1")
    public List getBaseJson(String module_code);
}
