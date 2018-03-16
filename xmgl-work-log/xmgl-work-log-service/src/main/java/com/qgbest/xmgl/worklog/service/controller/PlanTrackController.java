package com.qgbest.xmgl.worklog.service.controller;

import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.worklog.service.dao.DicRepositoryExtends;
import com.qgbest.xmgl.worklog.service.dao.PlanTrackExtends;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017/9/28.
 */
@RestController
public class PlanTrackController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(PlanTrackController.class);
    @Autowired
    private PlanTrackExtends planTrackExtends;
    @Autowired
    private DicRepositoryExtends dicRepositoryExtends;


    @RequestMapping(value = "/getPlanLogList")
    @ResponseBody
    public PageControl getPlanLogList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        System.out.println("====1111111====="+queryMap);
        PageControl pc = planTrackExtends.getPlanLogList(queryMap);
        return pc;
    }
    @RequestMapping(value = "/getPeriodDic")
    @ResponseBody
    public List getPeriodDic(){
        return dicRepositoryExtends.getDicListByBusinessCode("query_period");
    }
}
