package com.qgbest.xmgl.task.service.dao;
import com.qgbest.xmgl.task.api.entity.TaskEvaluateResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by quangao on 2017/10/9.
 */
@Repository
public interface TaskEvaluateResultRepository extends JpaRepository<TaskEvaluateResult, String>{
    @Query(value = "select u from TaskEvaluateResult u where u.id=?1")
    TaskEvaluateResult getTaskEvaluateResultInfoById(Integer id);

    @Modifying
    @Query(value = "delete from TaskEvaluateResult u where u.id=?1")
    void delTaskEvaluateResult(Integer id);
}
