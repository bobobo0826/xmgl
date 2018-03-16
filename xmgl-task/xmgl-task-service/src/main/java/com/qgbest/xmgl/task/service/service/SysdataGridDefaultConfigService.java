package com.qgbest.xmgl.task.service.service;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.SysdataGridDefaultConfig;
import com.qgbest.xmgl.task.service.dao.SysdataGridDefaultExtends;
import com.qgbest.xmgl.task.service.dao.SysdataGridDefaultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Service
@Transactional
public class SysdataGridDefaultConfigService {

    @Autowired
    private SysdataGridDefaultRepository sysdataGridDefaultRepository;

    @Autowired
    private SysdataGridDefaultExtends sysdataGridDefaultExtends;

    public PageControl getSysdataGridDefaultConfig(Map queryMap, int cpage, int len) {
        return this.sysdataGridDefaultExtends.getSysdataGridDefaultConfig(queryMap,cpage,len);
    }
    public SysdataGridDefaultConfig findSystemById(Integer id){
        return this.sysdataGridDefaultRepository.findSysdataById(id);
    }
    public ReturnMsg delSysdataById(Integer  id) {
        sysdataGridDefaultRepository.delSysdataById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }
    public ReturnMsg saveSysdata(SysdataGridDefaultConfig sysdataGridDefaultConfig) {
        this.sysdataGridDefaultRepository.save(sysdataGridDefaultConfig);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(sysdataGridDefaultConfig));
    }
    public List getBaseJsonByCode(String dateCode) {
        return this.sysdataGridDefaultRepository.getBaseJson(dateCode);
    }

}
