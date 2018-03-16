package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.MonthLogRepository;
import com.qgbest.xmgl.worklog.service.dao.MonthLogRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.qgbest.xmgl.user.api.entity.TcUser;

import java.util.List;
import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */
@Service
@Transactional
public class MonthLogService {
  @Autowired
  private MonthLogRepositoryExtends monthLogRepositoryExtends;
  @Autowired
  private MonthLogRepository monthLogRepository;

  /**
   * 月日志查询
   *
   * @param queryMap 查询条件
   * @param len      查询个数
   * @param page     查询页码
   */
  public PageControl getMonthLogList(Map queryMap, int page, int len, TcUser user) {
    return this.monthLogRepositoryExtends.getMonthLogList(queryMap, page, len, user);
  }

  /**
   * 获取月日志model
   */
  public MonthLog getMonthLogInfo(Integer id) {
    if (id != null && id != -1) {
      return this.monthLogRepository.getMonthLogInfo(id);
    } else {
      return new MonthLog();
    }
  }

  /**
   * 删除
   */
  public ReturnMsg delMonthLog(Integer id) {
    this.monthLogRepository.delMonthLog(id);
    ReturnMsg returnMsg = new ReturnMsg();
    return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
  }

  /**
   * 保存
   */
  public ReturnMsg saveMonthLog(MonthLog monthLog) {
    this.monthLogRepository.save(monthLog);
    ReturnMsg returnMsg = new ReturnMsg();
    return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(monthLog));
  }
  public MonthLog getOldMonthLog(Integer id){
    return monthLogRepositoryExtends.getOldMonthLog(id);
  }


  /**
   * 获得新增月任务数量
   */
  public Integer getMonthLogNumber() {
    return monthLogRepositoryExtends.getMonthLogNumber();
  }

  public Map getMonthLogContentListById(Integer id) {
    if (id != null && id != -1) {
      return this.monthLogRepositoryExtends.getMonthLogContentListById(id);
    } else {
      return null;
    }
  }

  public List getMonthLogIdByMonth(TcUser user, String month) {
    return this.monthLogRepositoryExtends.getMonthLogIdByMonth(user, month);
  }

}
