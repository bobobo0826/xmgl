package com.qgbest.xmgl.plan.service.dao;
import com.qgbest.xmgl.plan.api.entity.PlanEvaluateResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
/**
 * Created by quangao on 2017/10/16.
 */
@Repository
public interface PlanEvaluateResultRepository extends JpaRepository<PlanEvaluateResult, String>{
    @Query(value = "select u from PlanEvaluateResult u where u.id=?1")
    PlanEvaluateResult getPlanEvaluateResultInfoById(Integer id);

    @Modifying
    @Query(value = "delete from PlanEvaluateResult u where u.id=?1")
    void delPlanEvaluateResult(Integer id);
}
