package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.TaskOutput;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017/10/12.
 */
@Repository
public interface TaskOutputRepository extends JpaRepository<TaskOutput, String> {
    @Query(value = "select u from TaskOutput u where u.id=?1")
    TaskOutput getTaskOutputById(Integer id);

    @Modifying
    @Query(value = "delete  from TaskOutput u where u.id=?1")
    void delTaskOutput(Integer id);

    @Modifying
    @Query(value = "delete  from TaskOutput u where u.task_id=?1",nativeQuery = true)
    void delTaskOutputByTaskId(Integer taskId);
}
