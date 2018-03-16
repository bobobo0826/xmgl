package com.qgbest.xmgl.worklog.service.service;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.service.dao.GlanceOverRepository;
import com.qgbest.xmgl.worklog.service.dao.GlanceOverRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.ThumbsUpRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
/**
 * Created by mjq on 2017/7/19.
 */
@Service
@Transactional
public class GlanceOverService {
    @Autowired
    private GlanceOverRepository glanceOverRepository;
    @Autowired
    private GlanceOverRepositoryExtends glanceOverRepositoryExtends;

    /**
     * 保存
     *
     * @param glanceOver 点赞信息
     * @return
     */
    public ReturnMsg saveGlanceOverInfo(GlanceOver glanceOver) {
        this.glanceOverRepository.save(glanceOver);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(glanceOver));
    }

    public List getGlanceOverListById(Integer id,String type) {

        return this.glanceOverRepositoryExtends.getGlanceOverListById(id,type);

    }




    public ReturnMsg UpdateAndSaveGlanceOver(Integer id, TcUser user,String type){
        List GlanceOverUserList=glanceOverRepositoryExtends.getGlanceOverList(id,user.getId(),type);
        if(GlanceOverUserList.size()!=0){
            this.glanceOverRepositoryExtends.UpdateGlanceOverInfo(id,user,type);
        }else{
            GlanceOver glanceOver=new GlanceOver();
            glanceOver.setGlance_over_time(DateUtils.getCurDateTime2Minute());
            glanceOver.setGlance_over_name(user.getDisplayName());
            glanceOver.setGlance_over_id(user.getId());
            glanceOver.setGlance_over_type(type);
            glanceOver.setGlance_over_photo(user.getHeadPhoto());
            glanceOver.setGlance_over_subject_id(id);
            this.glanceOverRepository.save(glanceOver);
        }
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
    }







}
