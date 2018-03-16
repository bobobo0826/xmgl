package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.task.api.entity.WritingStandards;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

/**
 * Created by fcy on 2017/8/9.
 */
public interface StandardsRepository extends JpaRepository<WritingStandards, String> {
    @Query(value = "select m from WritingStandards m where m.id=?1")
    public WritingStandards getStandardsInfo(Integer id);
    @Query(value="delete from writing_standards u where u.id = ?1 ",nativeQuery = true)
    @Modifying
    public void delStandardsInfo(Integer id);

}
