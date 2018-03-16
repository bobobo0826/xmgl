package com.qgbest.xmgl.worklog.service.controller;

/**
 * Created by quangao-Lu Tianle on 2017/7/18.
 */

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.entity.Comments;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.CommentsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Api(value = "评论管理", description = "提供评论管理增删改查API")
@RestController
@RequestMapping(value = "/manage/comments")
public class CommentsController extends BaseController {
  public static final Logger logger = LoggerFactory.getLogger(CommentsController.class);
  @Autowired
  private CommentsService commentsService;

  @ApiOperation(value = "查询评论", notes = "查询评论")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "Integer", name = "parent_id", value = "parent_id", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "String", name = "business_type", value = "评论业务类型", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "Integer", name = "creator_id", value = "creator_id", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
  })
  @PostMapping(value = "/getCommentsList", produces = MediaType.APPLICATION_JSON_VALUE)
  public Map getCommentsList(
    @RequestParam String queryMap,
    @RequestParam("id") Integer id,
    @RequestParam("parent_id") Integer parent_id,
    @RequestParam String business_type,
    @RequestParam("creator_id") Integer creator_id,
    @RequestBody TcUser user
  ) {
    Map jsonData = new HashMap();
    Map query = JsonUtil.fromJsonToMap(queryMap);
    PageControl pc = this.commentsService.getCommentsList(query, id, parent_id, business_type,creator_id, user);
    jsonData = getQueryMap(pc);
    return jsonData;
  }

  @ApiOperation(value = "保存评论", notes = "保存评论")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "Comments", name = "comments", value = "评论model", required = true, paramType = "body"),
  })
  @RequestMapping(value = "/saveComments", method = RequestMethod.POST)
  public Map saveComments(@RequestBody Comments comments) {
    logger.debug("保存评论：{}", comments);
    Map map = new HashMap();
    ReturnMsg msg = commentsService.saveComments(comments);
    map.put("comments", comments);
    map.put("msgCode", msg.getMsgCode());
    map.put("msgDesc", msg.getMsgDesc());
    return map;
  }

  @ApiOperation(value = "删除评论", notes = "删除评论")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
  })
  @RequestMapping(value = "/delComments/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
  public ReturnMsg delComments(@PathVariable("id") Integer id) {
    ReturnMsg returnMsg = commentsService.delComments(id);
    return returnMsg;
  }

  @ApiOperation(value="查询的评论数", notes="查询的评论数")
  @ApiImplicitParams({
    @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query"),
    @ApiImplicitParam(dataType = "Integer", name = "id", value = "id", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "String", name = "business_type", value = "评论业务类型", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "Integer", name = "creator_id", value = "creator_id", required = true, paramType = "path"),
    @ApiImplicitParam(dataType = "TcUser", name = "user", value = "用户信息", required = false, paramType = "body")
  })
  @RequestMapping(value = "/getCommentsCount",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
  public Integer getCommentsCount(
    @RequestParam String queryMap,
    @RequestParam("id") Integer id,
    @RequestParam("business_type") String business_type,
    @RequestParam("creator_id") Integer creator_id,
    @RequestBody TcUser user
  ) {
    Map query = JsonUtil.fromJsonToMap(queryMap);
    return commentsService.getCommentsCount(query, id, business_type,creator_id, user);
  }


}
