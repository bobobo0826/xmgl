package com.qgbest.xmgl.worklog.service.dao;

/**
 * Created by quangao-Lu Tianle on 2017/7/19.
 */

import com.qgbest.xmgl.worklog.api.entity.Comments;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentsRepository extends JpaRepository<Comments, String> {

  @Modifying
  @Query(value = "delete from hd_comments u where u.id=?1", nativeQuery = true)
  void delComments(Integer id);
}
