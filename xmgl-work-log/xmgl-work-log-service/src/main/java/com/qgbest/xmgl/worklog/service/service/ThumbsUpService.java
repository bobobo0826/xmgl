package com.qgbest.xmgl.worklog.service.service;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * Created by mjq on 2017/7/18.
 */
@Service
@Transactional
public class ThumbsUpService {
    @Autowired
    private ThumbsUpRepository thumbsUpRepository;
    @Autowired
    private ThumbsUpRepositoryExtends thumbsUpRepositoryExtends;


    /**
     * 保存
     *
     * @param thumbsUp 点赞信息
     * @return
     */
    public ReturnMsg saveThumbsUpInfo(ThumbsUp thumbsUp) {
        this.thumbsUpRepository.save(thumbsUp);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(thumbsUp));
    }

    public List getThumbsUpListById(Integer id,String type) {

        return this.thumbsUpRepositoryExtends.getThumbsUpListById(id,type);

    }

    /**
     * 删除点赞信息
     *
     * @param id ID
     * @return
     */
    public ReturnMsg delThumbsUpInfo(Integer id,TcUser user,String type) {
        this.thumbsUpRepositoryExtends.delThumbsUpInfo(id,user,type);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }





}
