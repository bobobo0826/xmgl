package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.UpdateLogExtend;
import com.qgbest.xmgl.worklog.service.dao.UpdateLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/7/26.
 */
@Service
@Transactional
public class UpdateLogService {
    @Autowired
    private UpdateLogExtend updateLogExtend;
    @Autowired
    private UpdateLogRepository updateLogRepository;
    /**
     * 查询日志列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */
    public PageControl queryUpdateLogList(Map queryMap, int cpage, int len) {
        return this.updateLogExtend.queryUpdateLogList(queryMap,cpage,len);
    }

    /**
     * 日志删除
     * @param id 日志ID
     * @return
     */
    public ReturnMsg deleteById(Integer  id) {
        this.updateLogRepository.delUpdateLogInfoById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }

    /**
     * 根据更新日志Id获取更新日志详情
     * @param id
     * @return
     */
    public UpdateLog getUpdateLogInfoById(Integer id){
      // System.out.println("********************** " + String.valueOf(this.updateLogRepository.getUpdateLogInfoById(id)));
        return this.updateLogRepository.getUpdateLogInfoById(id);
    }
    /**
     * 日志保存
     * @param updateLog 日志
     * @return
     */
    public ReturnMsg saveUpdateLog(UpdateLog updateLog) {

       //System.out.println("++++++++++++12 " + String.valueOf(updateLog));
        this.updateLogRepository.save(updateLog);
        ReturnMsg returnMsg =new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(updateLog));
    }



    public List getLatestUpdateLog(){
        return this.updateLogExtend.getLatestUpdateLog();
    }



    public ReturnMsg publishById(Integer  id) {
         this.updateLogExtend.publishUpdateLog(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }

    public ReturnMsg unPublishById(Integer  id) {
        this.updateLogExtend.unPublishUpdateLog(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }
}
