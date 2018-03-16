package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.TaskAlter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wjy
 * Date:2017/10/18
 * Time:14:41
 * description:xmgl-serve
 */
@Repository
public interface TaskAlterRepository extends JpaRepository<TaskAlter,String> {
    @Query(value = "select u from TaskAlter u where u.id=?1")
    public TaskAlter getTaskAlterInfoById(Integer id);

    @Modifying
    @Query(value = "delete from TaskAlter u where u.id=?1")
    public void deleteTaskAlterById(Integer id);
}
