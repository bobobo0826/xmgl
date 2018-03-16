package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.DicRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.MessageExtend;
import com.qgbest.xmgl.worklog.service.dao.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017-07-18.
 */
@Service
@Transactional
public class MessageService {
    @Autowired
    private MessageExtend messageExtend;
    @Autowired
    private MessageRepository messageRepository;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;

    /**
     * 查询消息列表
     * @param queryMap 查询条件
     * @return pc
     */
    public List getMessageList(Map queryMap) {
        return this.messageExtend.getMessageList(queryMap);
    }

    /**
     * 保存消息
     * @param messageBase
     */
    public ReturnMsg saveMessage(MessageBase messageBase) {
        this.messageRepository.save(messageBase);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(messageBase));
    }

    public ReturnMsg checkMessage(Map queryMap){
        messageExtend.checkMessage(queryMap);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }


}
