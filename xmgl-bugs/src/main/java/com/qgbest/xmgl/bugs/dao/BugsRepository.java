package com.qgbest.xmgl.bugs.dao;

import com.qgbest.xmgl.bugs.Bugs;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by quangao on 2017/8/30.
 */
@Service
@Transactional
@Repository
public interface BugsRepository extends JpaRepository<Bugs, String> {

    @Query(value = "select u from Bugs u where u.id=?1")
    Bugs getBugsInfoById(Integer id);

    @Modifying
    @Query(value = "delete from Bugs u where u.id=?1")
    void delBugs(Integer id);

}
