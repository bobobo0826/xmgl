package com.qgbest.xmgl.worklog.api.entity;

import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;

import java.util.HashMap;
import java.util.Map;


/**
 * Created by xw on 2017/6/26 0026.
 * 通用返回消息model
 */
public class ReturnMsg {
    private Integer msgCode;
    private String msgDesc;
    private String msgData;


    /**
     * 获取通用返回消息
     * @param data
     * @return
     */
    public ReturnMsg getReturnMsg(Integer code,String desc,String data){
        if(!StringUtils.isNotBlankOrNull(code)||!StringUtils.isNotBlankOrNull(desc)){
            return null;
        }
        this.msgCode= ServiceConstants.SUCCESS;
        this.msgDesc= ServiceConstants.SUCCESS_DESC;
        if(StringUtils.isNotBlankOrNull(data)){
            this.msgData=data;
        }
        return this;
    }

    public Integer getMsgCode() {
        return msgCode;
    }

    public void setMsgCode(Integer msgCode) {
        this.msgCode = msgCode;
    }

    public String getMsgDesc() {
        return msgDesc;
    }

    public void setMsgDesc(String msgDesc) {
        this.msgDesc = msgDesc;
    }

    public String getMsgData() {
        return msgData;
    }

    public void setMsgData(String msgData) {
        this.msgData = msgData;
    }


}
