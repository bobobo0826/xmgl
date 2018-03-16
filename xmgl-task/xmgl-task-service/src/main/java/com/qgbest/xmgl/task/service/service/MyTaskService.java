package com.qgbest.xmgl.task.service.service;
import com.qgbest.xmgl.task.api.entity.Plan;
import com.qgbest.xmgl.task.service.dao.MyTaskExtends;
import com.qgbest.xmgl.task.service.dao.MyTaskRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by mjq on 2017/7/26.
 */
@Service
@Transactional
public class MyTaskService {
    @Autowired
    private MyTaskRepository myTaskRepository;
    @Autowired
    private MyTaskExtends myTaskExtends;

    /**
     * 查询我的任务列表
     * @param queryMap 查询条件
     * @param cpage 页码
     * @param len 长度
     * @return pc
     */
    public PageControl getMyTaskQueryList(Map queryMap, int cpage, int len,TcUser user,String taskType,String contractor) {
        return this.myTaskExtends.getMyTaskQueryList(queryMap, cpage, len,user,taskType,contractor);
    }


    public Plan getMyTaskInfoById(Integer id) {
        if (id!=null && id!=-1){
            return this.myTaskRepository.getMyTaskInfoById(id);

        }
        else{
            return new Plan();
        }

    }


    public Map getParticipantsListById(Integer id) {
        if (id!=null && id!=-1) {
            return this.myTaskExtends.getParticipantsListById(id);
        }
        else{
            return null;
        }
    }
    public Map getUnCompletePlan(TcUser user) {
        return this.myTaskExtends.getUnCompletePlan(user);

    }





}
