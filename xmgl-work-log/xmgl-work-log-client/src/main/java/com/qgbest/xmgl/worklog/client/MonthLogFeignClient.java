package com.qgbest.xmgl.worklog.client;

/**
 * Created by quangao-Lu Tianle on 2017/7/4.
 */

import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.constants.MonthLogServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.MonthLog;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@FeignClient(name = ServiceConstants.ServiceName)
public interface MonthLogFeignClient {
  /**
   * 月日志列表查询
   *
   * @param queryMap 查询条件
   * @param len      查询个数
   * @param page     查询页码
   * @param user     用户
   * @return
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_getMonthLogList, method = RequestMethod.POST)
  Map getMonthLogList(
    @RequestParam("queryMap") String queryMap,
    @RequestParam("len") Integer len,
    @RequestParam("page") Integer page,
    @RequestBody TcUser user
  );

  /**
   * 获得月日志详情
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_getMonthLogInfo, method = RequestMethod.GET)
  MonthLog getMonthLogInfo(@RequestParam("id") Integer id);

  /**
   * 保存
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_saveMonthLogInfo, method = RequestMethod.PUT)
  Map saveMonthLog(@RequestBody MonthLog monthLog,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

  /**
   * 删除
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_delMonthLogInfo, method = RequestMethod.DELETE)
  ReturnMsg delMonthLog(@RequestParam("id") Integer id,@RequestParam("userId") Integer userId,@RequestParam("userName") String userName);

  /**
   * 获得新增月任务数量
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_getMonthLogNumber, method = RequestMethod.GET)
  Integer getMonthLogNumber();

  /**
   * 获得增月日志下拉表
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_getMonthLogContentListById,method = RequestMethod.GET)
  public Map getMonthLogContentListById(@RequestParam("id") Integer id);

  /**
   *查询month这个月的日志id
   */
  @RequestMapping(value = MonthLogServiceHTTPConstants.RequestMapping_getMonthLogIdByMonth,method = RequestMethod.POST)
  List getMonthLogIdByMonth(@RequestBody TcUser user, @RequestParam("month") String month);
}
