package com.qgbest.xmgl.worklog.service.dao;
import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
/**
 * Created by quangao on 2017/7/26.
 */
@Repository
public interface UpdateLogRepository extends JpaRepository<UpdateLog,String> {
    @Query(value = "select m from UpdateLog m where m.id=?1")
    public UpdateLog getUpdateLogInfoById(Integer id);

    @Query(value="delete from update_log u where u.id = ?1 ",nativeQuery = true)
    @Modifying
    public void delUpdateLogInfoById(Integer id);


//    @Query(value="update update_log set status="已发布" where id = ?1 ",nativeQuery = true)
//    @Modifying
//    public void delUpdateLogInfoById(Integer id);

}
