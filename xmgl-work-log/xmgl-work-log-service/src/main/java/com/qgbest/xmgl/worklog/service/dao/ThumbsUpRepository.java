package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
/**
 * Created by mjq on 2017/7/18.
 */
@Repository
public interface ThumbsUpRepository extends JpaRepository<ThumbsUp, String> {

    @Query(value = "select u from ThumbsUp u where u.id = ?1")
    public ThumbsUp getThumbsUpInfo(Integer id);


    @Modifying
    @Query(value = "delete from hd_thumbs_up u where u.thumbs_up_subject_id=?1", nativeQuery = true)
    public void delThumbsUpInfo(Integer id);
}
