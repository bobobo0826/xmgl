package com.qgbest.xmgl.worklog.service.dao;



import com.qgbest.xmgl.worklog.api.entity.FormType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by qince on 2015/7/3.
 */
@Repository
public interface LogRepository extends JpaRepository<FormType,String> {

    @Query(value="select u.* from form_type u where u.formtype = ?1 ",nativeQuery = true)
    public FormType getFormType(String type);

    @Query(value="select u.* from form_type u where u.id = ?1 ",nativeQuery = true)
    public FormType getFormOperateTypeById(int id);




}

