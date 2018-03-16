package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.Dictionary;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.service.dao.DictionaryRepository;
import com.qgbest.xmgl.task.service.dao.DictionaryRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/7/31.
 */
@Service
@Transactional
public class DictionaryService {
  @Autowired
  private DictionaryRepository dictionaryRepository;
  @Autowired
  private DictionaryRepositoryExtends dictionaryRepositoryExtends;
    /**
     * 查询项目列表
     * @param queryMap
     * @param len
     * @param cpage
     * @return
     */
    public PageControl queryDictionaryList(Map queryMap, int cpage, int len) {
        return this.dictionaryRepositoryExtends.queryDictionaryList(queryMap,cpage,len);
    }
    /**
     * 根据项目Id删除信息
     * @param id
     * @return
     */
    public ReturnMsg delDictionaryInfoById(Integer id) {
        this.dictionaryRepository.delDictionaryInfoById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
    /**
     * 查询字典类型列表
     * @return
     */
    public List getBusinessTypeList(){
        return this.dictionaryRepositoryExtends.getBusinessTypeList();
    }
    /**
     * 根据字典Id获取项目详情
     * @param id
     * @return
     */
    public Dictionary getDictionaryInfoById(Integer id){
        return this.dictionaryRepository.getDictionaryInfoById(id);
    }

    /**
     * 保存字典信息
     * @param dictionary
     * @return
     */
    public ReturnMsg saveDictionary(Dictionary dictionary) {

        this.dictionaryRepository.save(dictionary);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(dictionary));
    }
    /**
     * 启动字典
     * @param id
     * @return
     */
    public ReturnMsg startDictionaryById(Integer id) {
        this.dictionaryRepository.startDictionaryById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
    /**
     * 禁用字典
     * @param id
     * @return
     */
    public ReturnMsg forbiddenDictionaryById(Integer id) {
        this.dictionaryRepository.forbiddenDictionaryById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
}

