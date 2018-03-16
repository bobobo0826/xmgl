package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.ThumbsUpServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import java.util.Map;
import java.util.List;
/**
 * Created by mjq on 2017/7/18.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface ThumbsUpFeignClient {
    /**
     * 保存点赞信息
     *
     * @param thumbsUp model
     * @return
     */
    @RequestMapping(value = ThumbsUpServiceHTTPConstants.RequestMapping_saveThumbsUpInfo, method = RequestMethod.PUT)
    public Map saveThumbsUpInfo(@RequestBody ThumbsUp thumbsUp);


    /**
     * 删除周点赞信息
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = ThumbsUpServiceHTTPConstants.RequestMapping_delThumbsUpInfo, method = RequestMethod.DELETE)
    public ReturnMsg delThumbsUpInfo(@RequestParam("id") Integer id,@RequestBody TcUser user,@RequestParam("type") String type);


    /**
     * 根据id查询点赞信息
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = ThumbsUpServiceHTTPConstants.RequestMapping_getThumbsUpListById,method = RequestMethod.GET)
    public List getThumbsUpListById(@RequestParam("id") Integer id,@RequestParam("type") String type);







}
