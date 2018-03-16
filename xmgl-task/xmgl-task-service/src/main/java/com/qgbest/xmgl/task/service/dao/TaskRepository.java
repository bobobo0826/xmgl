package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by wjy on 2017/7/18.
 */
public interface TaskRepository extends JpaRepository<Task,String> {
    @Query(value = "select u from Task u where u.id=?1")
    public Task getTaskInfoById(Integer id);

    @Modifying
    @Query(value = "delete from Task u where u.id=?1")
    public void deleteTaskById(Integer id);


}
