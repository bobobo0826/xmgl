package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.service.dao.TaskLogExtend;
import com.qgbest.xmgl.worklog.service.dao.TaskLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by wch on 2017-07-13.
 */
@Service
@Transactional
public class TaskLogService {
    @Autowired
    private TaskLogExtend taskLogExtend;
    @Autowired
    private TaskLogRepository taskLogRepository;

    /**
     * 查询项目任务日志列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     */
    public PageControl queryTaskLogList(Map queryMap, int cpage, int len) {
        return this.taskLogExtend.queryTaskLogList(queryMap,cpage,len);
    }
    /**
     * 获取周期列表
     */
    public List getPeriodList(){
        return this.taskLogRepository.getPeriodList();
    }






}

