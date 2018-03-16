package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.plan.api.entity.OutputProcess;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017/10/10.
 */
@Repository
public interface OutputProcessRepository extends JpaRepository<OutputProcess,String>{
    @Query(value = "select u from OutputProcess u where u.id=?1")
    OutputProcess getOutputProcessById(Integer id);

    @Modifying
    @Query(value = "delete  from OutputProcess u where u.id=?1")
    void delOutputProcess(Integer id);
}
