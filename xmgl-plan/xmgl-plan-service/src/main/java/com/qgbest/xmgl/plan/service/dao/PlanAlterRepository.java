package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.plan.api.entity.PlanAlter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface PlanAlterRepository extends JpaRepository<PlanAlter,String> {
    @Query(value = "select u from PlanAlter u where u.id=?1")
    public PlanAlter getPlanAlterInfoById(Integer id);

    @Modifying
    @Query(value = "delete from PlanAlter u where u.id=?1")
    public void deletePlanAlterById(Integer id);
}
