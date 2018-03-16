package com.qgbest.xmgl.web.controller.updateLogManage;
import com.qgbest.xmgl.common.client.exception.ServiceException;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.project.api.entity.common.SysdataGridPersonConfig;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.UpdateLog;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.client.UpdateLogFeignClient;
import org.hibernate.annotations.SourceType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by quangao on 2017/7/24.
 */
@Controller
@RequestMapping(value = "/manage/updateLogManage")
public class UpdateLogController extends BaseController{

    @Autowired
    private UpdateLogFeignClient updateLogFeignClient;
    /**
     * 初始化日志列表
     * @return
     */

    @RequestMapping(value = "/initUpdateLogList")
    public ModelAndView initUpdateLogList(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        Integer UserId=getCurUser().getId();
        model.put("UserId", UserId);
        return new ModelAndView( "/updateLogManage/updateLogList",model);
    }
    @RequestMapping(value = "/queryUpdateLogList")
    @ResponseBody
    public Map queryUpdateLogList(){

        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return updateLogFeignClient.getUpdateLogList(JsonUtil.toJson(queryMap), len, cpage);
    }

    @RequestMapping(value = "/initUpdateLogInfo")
    public ModelAndView initUpdateLogInfo() {
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        model.put("id", queryMap.get("id"));
        return new ModelAndView("/updateLogManage/updateLogInfo",model);
    }
    @RequestMapping(value = "/getUpdateLogInfoById")
    @ResponseBody
    public Map getUpdateLogInfoById(){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        Integer id=Integer.valueOf(String.valueOf(queryMap.get("id")));
        UpdateLog updateLog = null;
        if (id!=0){
            try{
                updateLog=updateLogFeignClient.getUpdateLogInfo(id);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            updateLog = new UpdateLog();
            updateLog.setCreate_date(DateUtils.getCurDateTime2Minute());
            updateLog.setCreator(getCurUser().getDisplayName());
            updateLog.setCreator_id(getCurUser().getId());
            updateLog.setStatus("草稿");

        }
        model.put("updateLog",updateLog);

        return model;
    }

    /**
     * 保存更新信息
     * @return
     */
    @RequestMapping(value = "/saveUpdateLogInfo",method = RequestMethod.PUT)
    @ResponseBody
    public ReturnMsg saveDriver(@ModelAttribute UpdateLog updateLog)  {
        if (updateLog.getId() != null) {

            updateLog.setModify_date(DateUtils.getCurDateTime2Minute());
            updateLog.setModifier(getCurUser().getDisplayName());
        }


        ReturnMsg returnMsg =updateLogFeignClient.saveUpdateLogInfo(updateLog);

        return returnMsg;
    }

    /**
     * 删除
     *
     * @return
     */
    @RequestMapping(value = "/delUpdateLogInfo")
    @ResponseBody
    public ReturnMsg delUpdateLogInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
       // System.out.println("================="+id);
        ReturnMsg  returnMsg = updateLogFeignClient.delUpdateLogInfo(id);
        return returnMsg;
    }
    @RequestMapping(value = "/getNewUpdateLogNumbers")
    @ResponseBody
    public Map getNewUpdateLogNumbers(){
        Integer newUpdateLogNumbers;
        newUpdateLogNumbers= updateLogFeignClient.getNewUpdateLogNumbers();
        Map map = new HashMap();
        map.put("count",String.valueOf(newUpdateLogNumbers));
        return map;
    }
    /**
     * 获取更新信息在首页
     * @return
     */
    @RequestMapping (value = "/getLatestUpdateLog")
    @ResponseBody
    public Map getLatestUpdateLog() {
        Map model =new HashMap();
        List updateLogList= updateLogFeignClient.getLatestUpdateLog();
        model.put("updateLogList", updateLogList);
        return model;

    }

    @RequestMapping (value = "/publishUpdateLog")
    @ResponseBody
    public ReturnMsg publishUpdateLog() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg  returnMsg = updateLogFeignClient.publishUpdateLog(id);
        return returnMsg;

    }

    @RequestMapping (value = "/unPublishUpdateLog")
    @ResponseBody
    public ReturnMsg unPublishUpdateLog() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg  returnMsg = updateLogFeignClient.unPublishUpdateLog(id);
        return returnMsg;

    }






}
