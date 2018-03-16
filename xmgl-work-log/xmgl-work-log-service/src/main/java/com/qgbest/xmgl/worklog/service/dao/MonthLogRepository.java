package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */
public interface MonthLogRepository extends JpaRepository<MonthLog, String> {
  @Query("select u from MonthLog u where u.id = ?1")
  MonthLog getMonthLogInfo(Integer id);

  @Modifying
  @Query(value = "delete from MonthLog u where u.id=?1")
  void delMonthLog(Integer oprId);

}
