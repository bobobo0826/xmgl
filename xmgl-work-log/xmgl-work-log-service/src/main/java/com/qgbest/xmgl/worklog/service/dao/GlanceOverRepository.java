package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
/**
 * Created by mjq on 2017/7/19.
 */
@Repository
public interface GlanceOverRepository extends JpaRepository<GlanceOver, String> {


    @Query(value = "select u from GlanceOver u where u.glance_over_subject_id = ?1")
    public GlanceOver getGlanceOverInfo(Integer id);


    @Modifying
    @Query(value = "delete from hd_glance_over u where u.glance_over_subject_id=?1", nativeQuery = true)
    public void delGlanceOverInfo(Integer id);

}
