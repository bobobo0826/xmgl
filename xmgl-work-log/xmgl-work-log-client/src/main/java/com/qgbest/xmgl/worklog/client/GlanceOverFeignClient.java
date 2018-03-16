package com.qgbest.xmgl.worklog.client;

import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.worklog.api.constants.GlanceOverServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.constants.ThumbsUpServiceHTTPConstants;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.*;
import com.qgbest.xmgl.worklog.api.constants.ServiceConstants;
import java.util.Map;
import java.util.List;
/**
 * Created by mjq on 2017/7/19.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface GlanceOverFeignClient {
    /**
     * 保存浏览信息
     *
     * @param glanceOver model
     * @return
     */
    @RequestMapping(value = GlanceOverServiceHTTPConstants.RequestMapping_saveGlanceOverInfo, method = RequestMethod.PUT)
    public Map saveGlanceOverInfo(@RequestBody GlanceOver glanceOver);




    /**
     * 根据id查询浏览信息
     *
     * @param id ID
     * @return
     */
    @RequestMapping(value = GlanceOverServiceHTTPConstants.RequestMapping_getGlanceOverListById,method = RequestMethod.GET)
    public List getGlanceOverListById(@RequestParam("id") Integer id,@RequestParam("type") String type);




    @RequestMapping(value = GlanceOverServiceHTTPConstants.RequestMapping_UpdateAndSaveGlanceOver, method = RequestMethod.POST)
    public ReturnMsg UpdateAndSaveGlanceOver(@RequestParam("id") Integer id, @RequestBody TcUser user,@RequestParam("type") String type);



}
