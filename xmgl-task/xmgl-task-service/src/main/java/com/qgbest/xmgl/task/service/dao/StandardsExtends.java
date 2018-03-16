package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by fcy on 2017/8/8.
 */
@Repository
public class StandardsExtends {
    @Autowired
    private CommonDao commonDao;

    public List queryStandardsList(Integer parentId) {


        List list = null;
        String sql = "SELECT id,standards_name as name, parent_id as pId,standards_content as content from writing_standards where 1=1   ";

        sql += " and parent_id='" + parentId + "'   ";

        sql += "  order by order_no ";
        list = commonDao.getSql(sql);
        return list;
    }
    public List queryStandardsShowList(Integer parentId) {


        List list = null;
        String sql = "SELECT id,standards_name as name, parent_id as pId,standards_content as content from writing_standards where status='已发布'  ";

        sql += " and parent_id='" + parentId + "'   ";

        sql += "  order by order_no ";
        list = commonDao.getSql(sql);
        return list;
    }
      public  void  delStandards(Integer id){
        String sql="delete from writing_standards where parent_id="+id+"";
        commonDao.updateBySql(sql);
      }
    public  void   publishStandards(Integer id){
        String sql="UPDATE writing_standards SET status='已发布' where id="+id+"";
        commonDao.updateBySql(sql);
    }
    public  void   UnPublishStandards(Integer id){
        String sql="UPDATE writing_standards SET status='未发布' where id="+id+"";
        commonDao.updateBySql(sql);
    }


    public List getStandardsPage()  {
        String sql="SELECT id,standards_name as name, parent_id as pId,standards_content as content from writing_standards where status='已发布'";
        List list = commonDao.getSql(sql);
        return list;

    }
}
