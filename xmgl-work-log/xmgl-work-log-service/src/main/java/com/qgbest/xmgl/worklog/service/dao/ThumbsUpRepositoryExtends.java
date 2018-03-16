package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;


/**
 * Created by mjq on 2017/7/18.
 */
@Repository
public class ThumbsUpRepositoryExtends {
    @Autowired
    private CommonDao commonDao;
    public List getThumbsUpListById(int id,String type){
        String sql= "";
        sql+="SELECT thumbs_up_type,thumbs_up_subject_id,thumbs_up_id,thumbs_up_name,thumbs_up_photo,thumbs_up_time FROM hd_thumbs_up WHERE thumbs_up_subject_id='"+id+"' and thumbs_up_type='"+type+"'";
        sql+="ORDER BY thumbs_up_time desc";
        List list=commonDao.getSql(sql);
        return list;
    }

    //取消赞
    public void delThumbsUpInfo(Integer id, TcUser user,String type){
        String sql="delete from hd_thumbs_up where thumbs_up_subject_id ='"+id+"' and thumbs_up_id='"+user.getId()+"' and thumbs_up_type = '"+type+"'";
        commonDao.updateBySql(sql);


    }





}
