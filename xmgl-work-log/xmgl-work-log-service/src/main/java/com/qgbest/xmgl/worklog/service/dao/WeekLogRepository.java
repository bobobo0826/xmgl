package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by mjq on 2017/7/4.
 */
@Repository
public interface WeekLogRepository extends JpaRepository<WeekLog, String> {
    @Query(value = "select u from WeekLog u where u.id = ?1")
    public WeekLog getWeekLogInfo(Integer id);

    @Modifying
    @Query(value = "delete from log_week u where u.id=?1", nativeQuery = true)
    public void delWeekLogInfo(Integer id);






}
