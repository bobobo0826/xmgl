package com.qgbest.xmgl.plan.service.dao;

import com.qgbest.xmgl.plan.api.entity.PlanProcess;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017/10/10.
 */
@Repository
public interface PlanProcessRepository extends JpaRepository<PlanProcess, String> {

}
