package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.user.api.entity.ReturnMsg;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;
/**
 * Created by mjq on 2017/7/19.
 */
@Repository
public class GlanceOverRepositoryExtends {
    @Autowired
    private CommonDao commonDao;
    public List getGlanceOverListById(int id,String type){
        String sql= "";
        sql+="SELECT glance_over_type,glance_over_subject_id,glance_over_id,glance_over_name,glance_over_photo,glance_over_time FROM hd_glance_over WHERE glance_over_subject_id='"+id+"' and glance_over_type='"+type+"'";
        sql+="ORDER BY glance_over_time desc";
        List list=commonDao.getSql(sql);
        return list;
    }


    //查询该浏览记录是否已存在
    public List getGlanceOverList(Integer id, Integer userId,String type){
        String sql= "";
        sql+="SELECT glance_over_type,glance_over_subject_id,glance_over_id,glance_over_name,glance_over_photo,glance_over_time FROM hd_glance_over WHERE glance_over_subject_id='"+id+"' and glance_over_type='"+type+"' and glance_over_id='"+userId+"'";
        sql+="ORDER BY glance_over_time desc";
        List list=commonDao.getSql(sql);
        return list;
    }
    //更新浏览时间
    public void UpdateGlanceOverInfo(Integer id, TcUser user,String type){
        String time = DateUtils.getCurDateTime2Minute();
        String photo=user.getHeadPhoto();
        String sql="update hd_glance_over set glance_over_time='"+time+"',glance_over_photo='"+photo+"' where glance_over_subject_id ='"+id+"' and glance_over_id='"+user.getId()+"' and glance_over_type = '"+type+"'";
        commonDao.updateBySql(sql);


    }



}
