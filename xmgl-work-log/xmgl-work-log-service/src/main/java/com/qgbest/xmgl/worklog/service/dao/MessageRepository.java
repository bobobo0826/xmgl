package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by wangchao on 2017-07-18.
 */
@Repository
public interface MessageRepository extends JpaRepository<MessageBase,String> {


}
