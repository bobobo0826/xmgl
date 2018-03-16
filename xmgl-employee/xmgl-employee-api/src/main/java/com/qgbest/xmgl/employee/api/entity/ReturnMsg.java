package com.qgbest.xmgl.employee.api.entity;

import com.qgbest.xmgl.common.utils.StringUtils;
import lombok.Data;


/**
 * Created by xw on 2017/6/26 0026.
 * 通用返回消息model
 */
@Data
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
        this.msgCode= code;
        this.msgDesc= desc;
        if(StringUtils.isNotBlankOrNull(data)){
            this.msgData=data;
        }
        return this;
    }
/*

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
*/


}
