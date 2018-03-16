package com.qgbest.xmgl.worklog.client;

/**
 * Created by quangao-Lu Tianle on 2017/7/18.
 * 评论
 */
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.constants.CommentsServiceHTTPConstants;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.Comments;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

/**
 * 获取评论和回复
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface CommentsFeignClient {
  @RequestMapping(value = CommentsServiceHTTPConstants.RequestMapping_getCommentsList, method = RequestMethod.POST)
  Map getCommentsList(
    @RequestParam("queryMap") String queryMap,
    @RequestParam("id") Integer id,
    @RequestParam("parent_id") Integer parent_id,
    @RequestParam("business_type") String business_type,
    @RequestParam("creator_id") Integer creator_id,
    @RequestBody TcUser user
  );

  /**
   * 保存评论
   */
  @RequestMapping(value = CommentsServiceHTTPConstants.RequestMapping_saveComments, method = RequestMethod.POST)
  Map saveComments(@RequestBody Comments comments);

  /**
   * 删除评论与回复
   */
  @RequestMapping(value = CommentsServiceHTTPConstants.RequestMapping_delComments, method = RequestMethod.DELETE)
  ReturnMsg delComments(@RequestParam("id") Integer id);

  /**
   * 获得评论数
   */
  @RequestMapping(value = CommentsServiceHTTPConstants.RequestMapping_getCommentsCount,method = RequestMethod.POST)
  Integer getCommentsCount(@RequestParam("queryMap") String queryMap,
                           @RequestParam("id") Integer id,
                           @RequestParam("business_type") String business_type,
                           @RequestParam("creator_id") Integer creator_id,
                           @RequestBody TcUser user);
}
