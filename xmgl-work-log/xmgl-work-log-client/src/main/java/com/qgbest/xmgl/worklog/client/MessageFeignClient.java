package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.worklog.api.constants.MessageServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import com.qgbest.xmgl.worklog.api.entity.MessageBase;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017-07-18.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface MessageFeignClient {
    /**
     * 查询消息列表
     *
     * @param queryMap 查询条件
     * @return
     */
    @RequestMapping(value = MessageServiceHTTPConstants.RequestMapping_getMessageList, method = RequestMethod.POST)
    List getMessageList(@RequestParam("queryMap") String queryMap);

    /**
     * 保存消息
     *
     * @param messageBase 消息model
     * @return
     */
    @RequestMapping(value = MessageServiceHTTPConstants.RequestMapping_saveMessage, method = RequestMethod.PUT)
    ReturnMsg saveMessage(@RequestBody MessageBase messageBase);

    /**
     * 更改消息查看状态
     *
     * @param queryMap 更改条件及信息
     * @return
     */
    @RequestMapping(value = MessageServiceHTTPConstants.RequestMapping_checkMessage, method = RequestMethod.POST)
    Map checkMessage(@RequestParam("queryMap") String queryMap);
}
