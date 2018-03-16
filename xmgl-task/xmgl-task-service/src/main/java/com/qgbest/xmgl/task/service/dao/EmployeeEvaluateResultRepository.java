package com.qgbest.xmgl.task.service.dao;
import com.qgbest.xmgl.task.api.entity.EmployeeEvaluateResult;
import com.qgbest.xmgl.task.api.entity.TaskEvaluateResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by quangao on 2017/10/10.
 */
@Repository
public interface EmployeeEvaluateResultRepository extends JpaRepository<EmployeeEvaluateResult, String>{
    @Query(value = "select u from EmployeeEvaluateResult u where u.id=?1")
    EmployeeEvaluateResult getEmployeeEvaluateResultInfoById(Integer id);

    @Modifying
    @Query(value = "delete from EmployeeEvaluateResult u where u.id=?1")
    void delEmployeeEvaluateResult(Integer id);
}
