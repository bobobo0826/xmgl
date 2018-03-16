package com.qgbest.xmgl.web.controller.worklog;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.entity.GlanceOver;
import com.qgbest.xmgl.worklog.api.entity.ThumbsUp;
import com.qgbest.xmgl.worklog.client.GlanceOverFeignClient;
import com.qgbest.xmgl.worklog.client.ThumbsUpFeignClient;
import com.qgbest.xmgl.worklog.client.WorkLogDictionaryFeignClient;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.WeekLog;
import com.qgbest.xmgl.worklog.client.WeekLogFeignClient;

import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
/**
 * Created by mjq on 2017/7/19.
 */
@Controller
@RequestMapping(value = "/manage/glanceOver")
public class GlanceOverController extends BaseController{
    @Autowired
    public GlanceOverFeignClient glanceOverFeignClient;


    /**
     * 保存浏览信息
     *
     * @return
     */
    @RequestMapping(value = "/saveGlanceOverInfo")
    @ResponseBody
    public Map saveGlanceOverInfo(@ModelAttribute GlanceOver glanceOver) {
        glanceOver.setGlance_over_time(DateUtils.getCurDateTime2Minute());
        glanceOver.setGlance_over_name(getCurUser().getDisplayName());
        glanceOver.setGlance_over_id(getCurUser().getId());
        Map map=glanceOverFeignClient.saveGlanceOverInfo(glanceOver);
        return map;
    }





}
