package com.qgbest.xmgl.worklog.service.dao;



import com.qgbest.xmgl.worklog.api.entity.SysdataGridPersonConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
public interface SysdataGridPersonRepository extends JpaRepository<SysdataGridPersonConfig, String>{

    @Query(value = "select u.conf_val from SysdataGridPersonConfig u where u.user_id=?1 ")
    public List findConfValById(Integer id);

    @Query(value = "select u from SysdataGridPersonConfig u where u.user_id=?1 and u.module_code=?2")
    public SysdataGridPersonConfig findConfValByIdAndCode(Integer id, String modelCode);
}
