package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.LogDicRepository;
import com.qgbest.xmgl.worklog.service.dao.LogDicRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.util.List;
import java.util.Map;

/**
 * Created by ccr on 2017/8/11.
 */
@Service
@Transactional
public class LogDicService {
    @Autowired
    private LogDicRepository logDicRepository;
    @Autowired
    private LogDicRepositoryExtends logDicRepositoryExtends;
    /**
     * 查询项目列表
     * @param queryMap
     * @param len
     * @param cpage
     * @return
     */
    public PageControl queryLogDictionaryList(Map queryMap, int cpage, int len) {

        return this.logDicRepositoryExtends.queryLogDictionaryList(queryMap,cpage,len);
    }
    /**
     * 根据字典Id获取项目详情
     * @param id
     * @return
     */
    public Dictionary getLogDictionaryInfoById(Integer id){
        return this.logDicRepository.getLogDictionaryInfoById(id);
    }
    /**
     * 保存字典信息
     * @param dictionary
     * @return
     */
    public ReturnMsg saveLogDictionary(Dictionary dictionary) {

        this.logDicRepository.save(dictionary);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(dictionary));
    }
    /**
     * 启动字典
     * @param id
     * @return
     */
    public ReturnMsg startLogDictionaryById(Integer id) {
        this.logDicRepository.startLogDictionaryById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
    /**
     * 禁用字典
     * @param id
     * @return
     */
    public ReturnMsg forbiddenLogDictionaryById(Integer id) {
        this.logDicRepository.forbiddenLogDictionaryById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
    /**
     * 根据项目Id删除信息
     * @param id
     * @return
     */
    public ReturnMsg delLogDictionaryInfoById(Integer id) {
        this.logDicRepository.delLogDictionaryInfoById(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC,"");
    }
    /**
     * 查询字典类型列表
     * @return
     */
    public List getBusinessTypeList(){
        return this.logDicRepositoryExtends.getBusinessTypeList();
    }

}
