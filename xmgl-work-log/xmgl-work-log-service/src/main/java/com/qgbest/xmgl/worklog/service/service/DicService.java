package com.qgbest.xmgl.worklog.service.service;


import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import com.qgbest.xmgl.worklog.service.dao.DicRepository;
import com.qgbest.xmgl.worklog.service.dao.DicRepositoryExtends;
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
public class DicService {
    @Autowired
    private DicRepository dicRepository;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;

    /**
     * 获取业务类型列表
     * @return
     */
    public List getBusinessTypeList() {return this.dicRepository.getBusinessTypeList();}

    /**
     * 获取字典列表
     * @param queryMap
     * @param cpage
     * @param len
     * @return
     */
    public PageControl findDicList(Map queryMap, int cpage, int len) {return this.dicRepositoryExtends.findDicList(queryMap,cpage,len);}

    /**
     * 根据id获取字典信息
     * @param id
     * @return
     */
    public Dictionary findById(Integer id) {return this.dicRepository.findById(id); }

    /**
     * 根据id删除字典信息
     * @param id
     */
    public void deleteById(Integer  id) {this.dicRepository.deleteById(id);}

    /**
     * 保存字典信息
     * @param dictionary
     */
    public void save(Dictionary dictionary) {this.dicRepository.save(dictionary);}

    /**
     * 根据业务类型code获取字典列表
     * @param businessCode
     * @return
     */
    public List getDicListByBusinessCode(String businessCode){return this.dicRepositoryExtends.getDicListByBusinessCode(businessCode);}

    /**
     * 根据code获取name
     * @param dataCode
     * @return
     */
    public String getDataNameByDataCode(String businessTypeCode,String dataCode){return this.dicRepositoryExtends.getDataNameByDataCode(businessTypeCode,dataCode); }
}
