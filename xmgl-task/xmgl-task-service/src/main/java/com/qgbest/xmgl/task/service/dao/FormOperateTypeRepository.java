package com.qgbest.xmgl.task.service.dao;



import com.qgbest.xmgl.task.api.entity.FormOperateType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by qince on 2015/7/3.
 */
@Repository
public interface FormOperateTypeRepository extends JpaRepository<FormOperateType,String> {



    @Query(value="select u.* from form_operate_type u where u.operatetypeid = ?1 ",nativeQuery = true)
    public FormOperateType getFormOperateTypeListById(int id);

    @Query(value = "select u.operatetypeid,u.operatetypename  from form_operate_type u where u.formtype=?1", nativeQuery = true)
    public List getOperateTypes(Integer id);



}

