package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by administror on 2017/3/24 0024.
 */
@Repository
public class LogRepositoryExtend {


    @Autowired
    private CommonDao commonDao;



    public List  getFormOperateTypeList(Integer type,String typeName)
    {
        String sql=" select * from form_operate_type where operatetypename='"+typeName+"' and formtype="+type+"";
        List list=  commonDao.getSql(sql);
        return  list;
    }
    public List  getJsonCompareFieldList(Integer id)
    {
        String sql=" SELECT  id,comparefieldid,fieldname,isjsonfiled, iskey,istitle,fielddesc from  json_compare_field where comparefieldid= "+id+"";
        List list=  commonDao.getSql(sql);
        return  list;
    }
    public List  getCompareFieldList(Integer id)
    {
        String sql="SELECT  id,formtypeid,fieldname,fieldtype, hashyperlink,fielddesc from  compare_field where formtypeid= "+id+"";
        List list=  commonDao.getSql(sql);
        return  list;
    }
    public List  getDateNameById(Integer fromTypeId,String fieldName,String parentName)
    {
        String sql = " select * from qqr_qrymetafield where table_id in(select tableid from form_type where id='"
                + fromTypeId + "') and field_name='" + fieldName + "'";
        if (parentName!=null&&!parentName.equals("")) {
            sql += " and parent_id in ( select id from qqr_qrymetafield where field_name='" + parentName + "')";
        } else {
            sql += " and parent_id=-1";
        }
        List list=  commonDao.getSql(sql);
        return  list;
    }
    public List  getDicDateNameById(String oldvalue, String dicTableName, String dicKeyField, String dicValueField,String dicBusinessType)
    {
        String sql = "";
        sql = " select " + dicValueField + " from " + dicTableName + " where " + dicKeyField + "='" + oldvalue + "' and business_type='"+dicBusinessType+"'";
        List list=  commonDao.getSql(sql);
        return  list;
    }



}
