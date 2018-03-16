package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/7/18.
 */
@Repository
public class CommentsRepositoryExtends {
  @Autowired
  private CommonDao commonDao;

  public PageControl getCommentsList(
    Map queryMap,
    Integer businessId,
    Integer parent_id,
    String business_type,
    Integer creator_id,
    TcUser user
  ) {
    int cpage = 1;
    int len = 1000;
    String sql =
      "SELECT id, commentator_id, comment_type, commentator_name, commentator_photo, replier_id, replier_name, replier_photo, content, comment_time, parent_id, reply_type "
      + "FROM hd_comments WHERE 1=1 "
      + "AND business_type='"
      + business_type
      + "' "
      + "AND business_id="
      + businessId
      + " AND parent_id="
      + parent_id;
    sql += " ORDER BY " + "comment_time DESC";
    String count = "select count(*) from  (" + sql + ")m ";
    PageControl pc = commonDao.getDataBySql(count, sql, cpage, len);
    List list = addChildComments(businessId, business_type, pc.getList());
    pc.setList(list);
    return pc;
  }

  /**
   * 添加子评论信息。一起连同查询过去。
   *
   * @param businessId
   * @param business_type
   * @return
   */
  public List addChildComments(Integer businessId, String business_type, List list) {
    for (Object obj : list) {
      Map map = (Map) obj;
      String sql =
        "SELECT id, commentator_id, comment_type, commentator_name, commentator_photo, replier_id, replier_name, replier_photo, content, comment_time, parent_id, reply_type "
        + "FROM hd_comments WHERE 1=1 "
        + "AND business_type='"
        + business_type
        + "' "
        + "AND business_id="
        + businessId
        + " AND parent_id="
        + map.get("id");
      sql += " ORDER BY " + "comment_time ASC";
      List childList = commonDao.getSql(sql);
      if (childList != null && childList.size() > 0) {
        map.put("children", childList);
      }
    }
    return list;
  }

  public Integer getCommentsCount(
    Map queryMap,
    Integer businessId,
    String business_type,
    Integer creator_id,
    TcUser user
  ) {
    String sql = "SELECT count(id) FROM hd_comments "
                 + "WHERE parent_id=0 "
                 + "AND business_type='" + business_type + "' "
                 + "AND business_id=" + businessId;
    if (creator_id != user.getId()) {
      sql += " AND (comment_type='GK' OR comment_type='NM' OR commentator_id=" + user.getId() + ")";
    }
    List list = commonDao.getSql(sql);
    Map map = (Map) list.get(0);
    Integer count = Integer.valueOf(String.valueOf(map.get("count")));
    return count;
  }

}