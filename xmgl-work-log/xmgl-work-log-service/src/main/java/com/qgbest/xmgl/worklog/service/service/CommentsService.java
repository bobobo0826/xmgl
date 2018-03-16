package com.qgbest.xmgl.worklog.service.service;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.Comments;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.dao.CommentsRepositoryExtends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.qgbest.xmgl.worklog.service.dao.CommentsRepository;

import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/7/18.
 */
@Service
@Transactional
public class CommentsService {
  @Autowired
  private CommentsRepositoryExtends commentsRepositoryExtends;
  @Autowired
  private CommentsRepository commentsRepository;

  /**
   * 获得评论
   */
  public PageControl getCommentsList(
    Map queryMap,
    Integer id,
    Integer parent_id,
    String business_type,
    Integer creator_id,
    TcUser user
  ) {
    return this.commentsRepositoryExtends.getCommentsList(queryMap, id, parent_id, business_type, creator_id, user);
  }

  /**
   * 保存评论
   */
  public ReturnMsg saveComments(Comments comments) {
    Comments comments1 = this.commentsRepository.save(comments);
    ReturnMsg returnMsg = new ReturnMsg();
    return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, JsonUtil.toJson(comments1));
  }

  /**
   * 删除评论与回复
   */
  public ReturnMsg delComments(Integer id) {
    commentsRepository.delComments(id);
    ReturnMsg returnMsg = new ReturnMsg();
    return returnMsg.getReturnMsg(ServiceConstants.SUCCESS, ServiceConstants.SUCCESS_DESC, "");
  }

  /**
   * 获得评论数
   */
  public Integer getCommentsCount(
    Map queryMap,
    Integer id,
    String business_type,
    Integer creator_id,
    TcUser user
  ) {
    return this.commentsRepositoryExtends.getCommentsCount(queryMap, id, business_type, creator_id, user);
  }




}
