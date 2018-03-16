package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.WritingStandards;
import com.qgbest.xmgl.task.service.dao.StandardsExtends;
import com.qgbest.xmgl.task.service.dao.StandardsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by fcy on 2017/8/8.
 */
@Service
@Transactional
public class StandardsService {
    @Autowired
    private StandardsExtends standardsExtends;
    @Autowired
    private StandardsRepository standardsRepository;

    /**
     * 查询日志列表

     * @return pc
     */
    public List queryStandardsList(Integer parentId) {
        return this.standardsExtends.queryStandardsList(parentId);
    }
    public List queryStandardsShowList(Integer parentId) {
        return this.standardsExtends.queryStandardsShowList(parentId);
    }
    public WritingStandards getStandardsInfo(Integer id){
        return this.standardsRepository.getStandardsInfo(id);
    }


    public WritingStandards save(WritingStandards writingStandards) {
        return this.standardsRepository.save(writingStandards);
    }

    public void delStandardsInfo(Integer id) {
        this.standardsExtends.delStandards(id);
        this.standardsRepository.delStandardsInfo(id);

    }

    public ReturnMsg publishById(Integer  id) {
        this.standardsExtends.publishStandards(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }
    public ReturnMsg unPublishById(Integer  id) {
        this.standardsExtends.UnPublishStandards(id);
        ReturnMsg returnMsg=new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
    }
    public List getStandardsPage(){
        return this.standardsExtends.getStandardsPage();
    }
}
