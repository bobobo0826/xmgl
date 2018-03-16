package com.qgbest.xmgl.bugs.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by quangao-Lu Tianle on 2017/9/1.
 */
@Repository
public class CommonDicRepositoryExtends {
    @Autowired
    private CommonDao commonDao;

    public List getDicByBusinessType(String BusinessType){
        String sql = "SELECT data_code,data_name FROM d_common_dic WHERE is_used='1' AND business_type='" + BusinessType + "'";
        List list = commonDao.getSql(sql);
        return list;
    }
}
