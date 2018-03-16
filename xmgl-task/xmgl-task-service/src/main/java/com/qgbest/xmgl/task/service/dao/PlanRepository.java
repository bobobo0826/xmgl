package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.Plan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by wjy on 2017/7/18.
 */
public interface PlanRepository extends JpaRepository<Plan,String> {
    @Query(value = "select u from Plan u where u.id=?1")
    public Plan getPlanInfoById(Integer id);

    @Modifying
    @Query(value = "delete  from Plan u where u.id=?1")
    public void deletePlanById(Integer id);
    @Modifying
    @Query(value = "delete  from Plan u where u.task_id=?1")
    public void deletePlanByTaskId(Integer taskId);
}
