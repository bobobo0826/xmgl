package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.plan.api.entity.PlanOutput;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017/10/12.
 */
@Repository
public interface PlanOutputRepository extends JpaRepository<PlanOutput,String>{
    @Query(value = "select u from PlanOutput u where u.id=?1")
    PlanOutput getPlanOutputById(Integer id);

    @Modifying
    @Query(value = "delete from PlanOutput u where u.id=?1")
    void delPlanOutput(Integer id);

}
