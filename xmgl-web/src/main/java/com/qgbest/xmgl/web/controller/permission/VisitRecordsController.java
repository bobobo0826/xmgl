package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.client.permission.VisitRecordClient;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by quangao-Lu Tianle on 2017/8/16.
 * 访问记录Controller
 */
@Controller
@RequestMapping(value = "/manage/permission")
public class VisitRecordsController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(VisitRecordsController.class);
    @Autowired
    private VisitRecordClient visitRecordClient;

    /**
     * 初始化访问记录页面
     *
     * @return
     */
    @RequestMapping(value = "/initVisitRecordsList")
    public ModelAndView initVisitRecordsList() {
        Map model = new HashMap();
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        return new ModelAndView("/permission/visitRecords/visitRecordsList", model);
    }
    /**
     * 查询访问记录
     *
     * @return
     */
    @RequestMapping(value = "/queryVisitRecordList")
    @ResponseBody
    public Map queryVisitRecordList() {
        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        TcUser user = getCurUser();
        Map map = visitRecordClient.queryVisitRecordList(JsonUtil.toJson(queryMap), len, cpage,user );
        System.out.println("==queryVisitRecordList==="+map);
        return map;
    }

    /**
     * 删除项目信息
     *
     * @return
     */
    @RequestMapping(value = "/delVisitRecordById")
    @ResponseBody
    public ReturnMsg delVisitRecordById() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = visitRecordClient.delVisitRecordById(id,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

}
