package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepository;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.WeekLogRepository;
import com.qgbest.xmgl.worklog.service.dao.WeekLogRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by mjq on 2017/7/4.
 */
@Service
@Transactional
public class WeekLogService {
    @Autowired
    private ThumbsUpRepository thumbsUpRepository;
    @Autowired
    private WeekLogRepository weekLogRepository;
    @Autowired
    private WeekLogRepositoryExtends weekLogRepositoryExtends;
    @Autowired
    private ThumbsUpRepositoryExtends thumbsUpRepositoryExtends;


    /**
     * 查询日志列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */
    public PageControl getWeekLogList(Map queryMap, int cpage, int len,TcUser user) {
        return this.weekLogRepositoryExtends.getWeekLogList(queryMap, cpage, len,user);
    }







    public WeekLog getWeekLogInfo(Integer id) {
        if (id!=null && id!=-1){
            return this.weekLogRepository.getWeekLogInfo(id);
        }
        else{
            return new WeekLog();
        }

    }



    /**
     * 保存
     *
     * @param weekLog 每周计划
     * @return
     */
    public ReturnMsg saveWeekLogInfo(WeekLog weekLog) {
        this.weekLogRepository.save(weekLog);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(weekLog));
    }


    /**
     * 删除
     *
     * @param id ID
     * @return
     */
    public ReturnMsg delWeekLogInfo(Integer id) {
        weekLogRepository.delWeekLogInfo(id);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }


    public Integer getNewWeekLogNumbers() {
        return this.weekLogRepositoryExtends.getNewWeekLogNumbers();
    }

    public Map getWeekLogContentListById(Integer id) {
        if (id!=null && id!=-1) {
            return this.weekLogRepositoryExtends.getWeekLogContentListById(id);
        }
        else{
            return null;
        }
    }


    public List getWeekLogIdByTaskStartDate(TcUser user, String monday_date) {
        return this.weekLogRepositoryExtends.getWeekLogIdByTaskStartDate(user, monday_date);
    }

    public WeekLog getOldWeekLog(Integer id){
        return weekLogRepositoryExtends.getOldWeekLog(id);
    }


}
