package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.worklog.api.entity.DayLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by wch on 2017-07-13.
 */
@Repository
public interface TaskLogRepository extends JpaRepository<DayLog,String> {

    @Query(value="select u.data_code as data_code,u.data_name as data_name from d_common_dic u where business_type = 'query_period'",nativeQuery = true)
    public List getPeriodList();
}
