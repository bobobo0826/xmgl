package com.qgbest.xmgl.plan.service.dao;
import com.qgbest.xmgl.plan.api.entity.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
/**
 * Created by quangao on 2017/9/28.
 */
@Repository
public interface EvaluateRepository extends JpaRepository<Evaluation, String>{
    @Query(value = "select u from Evaluation u where u.id=?1")
    Evaluation getEvaluationInfoById(Integer id);

    @Modifying
    @Query(value = "delete from Evaluation u where u.id=?1")
    void delEvaluation(Integer id);
}