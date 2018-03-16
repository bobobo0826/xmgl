package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.plan.api.entity.Plan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by quangao on 2017/10/12.
 */
@Service
@Transactional
@Repository
public interface PlanRepository extends JpaRepository<Plan, String> {

    @Query(value = "select u from Plan u where u.id=?1")
    Plan getPlanInfoById(Integer id);

    @Modifying
    @Query(value = "delete from Plan u where u.id=?1")
    void deletePlanById(Integer id);

    @Modifying
    @Query(value = "delete from Plan u where u.task_id=?1")
    void deletePlanByTaskId(Integer task_id);

}
