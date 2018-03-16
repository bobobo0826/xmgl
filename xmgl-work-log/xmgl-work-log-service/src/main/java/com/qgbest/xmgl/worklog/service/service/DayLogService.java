package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.DayLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.DayLogExtend;
import com.qgbest.xmgl.worklog.service.dao.DayLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * Created by quangao on 2017/7/4.
 */
@Service
@Transactional
public class DayLogService {
    @Autowired
    private DayLogExtend dayLogExtend;
    @Autowired
    private DayLogRepository dayLogRepository;

    /**
     * 查询日志列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */
    public PageControl queryDayLogList(Map queryMap, int cpage, int len,TcUser user) {
        return this.dayLogExtend.findDayLogList(queryMap,cpage,len,user);
    }
    public PageControl getWorkOperateLog(Map queryMap, int cpage, int len, TcUser user) {
        return this.dayLogExtend.getWorkOperateLog(queryMap, cpage, len, user);
    }
    /**
     * 日志删除
     * @param id 日志ID
     * @return
     */
    public ReturnMsg deleteById(Integer  id) {
        this.dayLogRepository.deleteDayLogById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }

    public Integer getNewDayLogNumbers() {
       return this.dayLogExtend.getNewDayLogNumbers();
    }

    /**
     * 获取日志model
     * @param id 日志ID
     * @return
     */
    public DayLog getDayLogInfoById(Integer id) {
        if (id!=null && id!=-1){
            return this.dayLogRepository.getDayLogInfoById(id);
        }
        else{
            return new DayLog();
        }

    }

    public Map getDayLogContentListById(Integer id) {
        if (id!=null && id!=-1) {
            return this.dayLogExtend.getDayLogContentListById(id);
        }
        else{
            return null;
        }
    }

    /**
     * 日志保存
     * @param dayLog 日志
     * @return
     */
    public ReturnMsg saveDayLog(DayLog dayLog) {
        this.dayLogRepository.save(dayLog);
        ReturnMsg returnMsg =new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(dayLog));
    }

    public Integer checkWorkLogRepeat(String workDate,Integer userId){
        return this.dayLogExtend.checkWorkLogRepeat(workDate,userId);
    }
    public DayLog getOldDayLog(Integer id){
        return dayLogExtend.getOldDayLog(id);
    }

}
