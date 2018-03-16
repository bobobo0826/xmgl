package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.worklog.api.entity.DayLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by quangao on 2017/7/4.
 */
@Repository
public interface DayLogRepository extends JpaRepository<DayLog,String> {

    @Query(value = "select u from DayLog u where u.id=?1")
    public DayLog getDayLogInfoById(Integer id);

    @Modifying
    @Query(value = "delete  from DayLog u where u.id=?1")
    public void deleteDayLogById(Integer id);

}
