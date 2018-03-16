package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.TaskTemp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wjy
 * Date:2017/10/18
 * Time:15:54
 * description:xmgl-serve
 */
public interface TaskTempRepository extends JpaRepository<TaskTemp,String> {

    @Query(value = "select u from TaskTemp u where u.id=?1")
    public TaskTemp getTaskTempInfoById(Integer id);

    @Query(value = "select u from TaskTemp u where u.task_id=?1")
    public TaskTemp getTaskTempInfoByTaskId(Integer id);

    @Modifying
    @Query(value = "delete from TaskTemp u where u.id=?1")
    public void deleteTaskTempById(Integer id);

}
