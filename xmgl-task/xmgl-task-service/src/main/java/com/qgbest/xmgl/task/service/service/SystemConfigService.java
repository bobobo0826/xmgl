package com.qgbest.xmgl.task.service.service;


import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.entity.SystemConfig;
import com.qgbest.xmgl.task.service.dao.SystemConfigRepository;
import com.qgbest.xmgl.task.service.dao.SystemConfigRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Service
@Transactional
public class SystemConfigService {
    @Autowired
    private SystemConfigRepositoryExtends systemConfigRepositoryExtends;
    @Autowired
    private SystemConfigRepository sys;

    public PageControl getSystemConf(Map queryMap, int cpage, int len) {
        return this.systemConfigRepositoryExtends.getSystemConf(queryMap,cpage,len);
    }
    public String getDataValueByCode(String dateCode) {
        return this.sys.getDataValue(dateCode);
    }

    public SystemConfig findSystemById(Integer id){
        return this.sys.findSystemById(id);
    }

    public void saveSystem (SystemConfig systemConfigBase) {
        this.sys.save(systemConfigBase);
    }

    public void delSystemById(Integer  id) {
        this.sys.delSystemById(id);
    }


}
