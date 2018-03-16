package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.service.service.MessageService;
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
import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017-07-18.
 */
@Api(value = "消息管理", description = "提供消息管理增查API")
@RestController
@RequestMapping(value = "/manage/message")
public class MessageController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(MessageController.class);
    @Autowired
    private MessageService messageService;

    @ApiOperation(value = "消息查询", notes = "消息查询")
    @ApiImplicitParams({
            @ApiImplicitParam(dataType = "String", name = "queryMap", value = "查询条件", required = true, paramType = "query")
    })
    @RequestMapping(value = "/getMessageList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public List getMessageList(@RequestParam String queryMap) {
        Map query = JsonUtil.fromJsonToMap(queryMap);
        List list = messageService.getMessageList(query);
        return list;
    }

    @ApiOperation(value = "保存消息", notes = "保存消息")
    @ApiImplicitParam(dataType = "MessageBase", name = "messageBase", value = "消息model", required = true, paramType = "body")
    @RequestMapping(value = "/saveMessage", method = RequestMethod.PUT)
    public Map saveMessage(@RequestBody MessageBase messageBase) {
        logger.debug("保存消息：{}", messageBase);
        Map map = new HashMap();
        ReturnMsg msg = messageService.saveMessage(messageBase);
        map.put("MessageBase", messageBase);
        map.put("msgCode", msg.getMsgCode());
        map.put("msgDesc", msg.getMsgDesc());
        return map;
    }

    @ApiOperation(value = "更改消息查看状态", notes = "更改消息查看状态")
    @ApiImplicitParam(dataType = "String", name = "queryMap", value = "更改条件及信息", required = true, paramType = "query")
    @RequestMapping(value = "/checkMessage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public Map checkMessage(@RequestParam String queryMap) {
        Map map = new HashMap();
        Map query = JsonUtil.fromJsonToMap(queryMap);
        ReturnMsg returnMsg = messageService.checkMessage(query);
        map.put("msgCode", returnMsg.getMsgCode());
        map.put("msgDesc", returnMsg.getMsgDesc());
        return map;

    }
}
