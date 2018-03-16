package com.qgbest.xmgl.employee.service.service;



import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.employee.service.dao.SysdataGridPersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
@Service
@Transactional
public class SysdataGridPersonConfigService {

    @Autowired
    private SysdataGridPersonRepository sysdataGridPersonRepository;

    public List findConfValById(Integer id){
        return this.sysdataGridPersonRepository.findConfValById(id);
    }

    public SysdataGridPersonConfig findConfValByIdAndCode(Integer id,String modelCode){
        return this.sysdataGridPersonRepository.findConfValByIdAndCode(id, modelCode);
    }
    public ReturnMsg sysdataGridPersonConfigBase(SysdataGridPersonConfig sysdataGridPersonConfig){
        sysdataGridPersonRepository.save(sysdataGridPersonConfig);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }
}
