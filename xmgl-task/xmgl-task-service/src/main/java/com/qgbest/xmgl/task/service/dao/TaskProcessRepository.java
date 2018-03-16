package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.TaskProcess;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017/10/12.
 */
@Repository
public interface TaskProcessRepository extends JpaRepository<TaskProcess, String> {
    @Query(value = "select u from TaskProcess u where u.id=?1")
    TaskProcess getTaskProcessById(Integer id);

    @Modifying
    @Query(value = "delete  from TaskProcess u where u.id=?1")
    void delTaskProcess(Integer id);


}
