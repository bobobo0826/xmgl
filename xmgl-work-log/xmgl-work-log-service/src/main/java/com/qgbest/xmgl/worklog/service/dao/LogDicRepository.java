package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * Created by ccr on 2017/8/11.
 *
 *
 */
@Repository
public interface LogDicRepository extends JpaRepository<Dictionary,String>{
    @Query(value = "select m from Dictionary m where m.id=?1")
    public Dictionary getLogDictionaryInfoById(Integer id);

    @Query(value="delete from d_common_dic where id = ?1 ",nativeQuery = true)
    @Modifying
    public void delLogDictionaryInfoById(Integer id);

    @Query(value="UPDATE d_common_dic SET is_used='1' WHERE id=?1",nativeQuery = true)
    @Modifying
    public void startLogDictionaryById(Integer id);

    @Query(value="UPDATE d_common_dic SET is_used='0' WHERE id=?1",nativeQuery = true)
    @Modifying
    public void forbiddenLogDictionaryById(Integer id);
}
