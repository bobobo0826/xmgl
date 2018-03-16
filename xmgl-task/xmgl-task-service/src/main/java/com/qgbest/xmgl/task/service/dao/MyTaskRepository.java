package com.qgbest.xmgl.task.service.dao;
import com.qgbest.xmgl.task.api.entity.Plan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
/**
 * Created by mjq on 2017/7/26.
 */
@Repository
public interface MyTaskRepository extends JpaRepository<Plan, String> {
    @Query(value = "select u from Plan u where u.id = ?1")
    public Plan getMyTaskInfoById(int id);




}
