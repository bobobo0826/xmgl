package com.qgbest.xmgl.web.controller.oa;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.division.api.contants.ServiceConstants;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.oa.api.entity.Materials;
import com.qgbest.xmgl.oa.api.entity.ReturnMsg;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.oa.client.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by fcy on 2017/8/22.
 */
@Controller
@RequestMapping(value = "/manage/materials")
public class GoodsController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(GoodsController.class);

    @Autowired
    private MaterialsFeignClient materialsFeignClient;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;
    /**
     * 初始化物品列表
     * @return
     */

    @RequestMapping(value = "/initMaterialsManagement")
    public ModelAndView initMaterialsManagement(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        System.out.println("================="+queryMap.get("_curModuleCode"));
        Integer UserId=getCurUser().getId();
        model.put("UserId", UserId);
        return new ModelAndView( "/goodsManage/goodsList",model);
    }

    @RequestMapping(value = "/queryGoodsList")
    @ResponseBody
    public Map queryGoodsList(){

        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        Integer employee_id;
        if (queryMap.get("_curModuleCode")=="WDWPGL"){
        Integer UserId=getCurUser().getId();
        Employee employee = employeeFeignClient.getEmployeeInfoByUserId(UserId);
       employee_id = employee.getId();
        }
       else{
            employee_id=0;
        }
        return materialsFeignClient.getGoodsList(JsonUtil.toJson(queryMap), len, cpage,employee_id);
    }

    @RequestMapping(value = "/initGoodsInfo")
    public ModelAndView initGoodsInfo() {
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        model.put("id", queryMap.get("id"));
        return new ModelAndView("/goodsManage/goodsInfo",model);
    }
    @RequestMapping(value = "/getGoodsInfoById")
    @ResponseBody
    public Map getGoodsInfoById(){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        Integer id=Integer.valueOf(String.valueOf(queryMap.get("id")));
        Materials materials = null;
        if (id!=0){
            try{
                materials=materialsFeignClient.getGoodsInfo(id);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            materials = new Materials();
            materials.setEntry_date(DateUtils.getCurDateTime2Minute());
            materials.setEntry_person(getCurUser().getDisplayName());



        }
        model.put("materials",materials);

        return model;
    }

    /**
     * 保存物品信息
     * @return
     */
    @RequestMapping(value = "/saveGoodsInfo",method = RequestMethod.PUT)
    @ResponseBody
    public ReturnMsg saveDriver(@ModelAttribute Materials materials)  {
        if (materials.getId() != null) {

            materials.setModify_date(DateUtils.getCurDateTime2Minute());
            materials.setModifier(getCurUser().getDisplayName());
        }


        ReturnMsg returnMsg =materialsFeignClient.saveGoodsInfo(materials);

        return returnMsg;
    }


    @RequestMapping(value = "/delGoodsInfo")
    @ResponseBody
    public ReturnMsg delGoodsInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        // System.out.println("================="+id);
        ReturnMsg returnMsg = materialsFeignClient.delGoodsInfo(id);
        return returnMsg;


    }

    @RequestMapping(value = "/getGoodsStateList")
    @ResponseBody
    public Map getGoodsStateList() {
        Map model = new HashMap();
        List goodsStateList = materialsFeignClient.getGoodsStateList();
        model.put("goodsStateList", goodsStateList);
        return model;

    }

    @RequestMapping(value = "/getGoodsTypeList")
    @ResponseBody
    public Map getGoodsTypeList() {
        Map model = new HashMap();
        List goodsTypeList = materialsFeignClient.getGoodsTypeList();
        model.put("goodsTypeList", goodsTypeList);
        return model;

    }
    @RequestMapping(value = "/recoveryGoods/{idsStr}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ReturnMsg recoveryGoods(@PathVariable("idsStr") String idsStr) {
        try {
            if (StringUtils.isEmpty(idsStr)) {
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.FAILE,ServiceConstants.FAILE_DESC,"");
            } else {
                materialsFeignClient.recoveryGoods(idsStr);
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    @RequestMapping(value = "/scrapGoods/{idsStr}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ReturnMsg scrapGoods(@PathVariable("idsStr") String idsStr) {
        try {
            if (StringUtils.isEmpty(idsStr)) {
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.FAILE,ServiceConstants.FAILE_DESC,"");
            } else {
                materialsFeignClient.scrapGoods(idsStr);
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
    @RequestMapping(value = "/allotGoods", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public ReturnMsg allotGoods() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        String idsStr = queryMap.get("idsStr")+"";
        Integer employee_id = Integer.valueOf(String.valueOf(queryMap.get("employee_id")));
        String employee_name = queryMap.get("employee_name")+"";
        System.out.println("===idsStr==="+idsStr);
        System.out.println("===employee_id==="+employee_id);
        System.out.println("===employee_name==="+employee_name);
        try {
            if (StringUtils.isEmpty(idsStr)) {
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.FAILE,ServiceConstants.FAILE_DESC,"");
            } else {
                materialsFeignClient.allotGoods(idsStr,employee_id,employee_name);
                ReturnMsg returnMsg = new ReturnMsg();
                return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
    @RequestMapping(value = "/selectEmployee")

    public ModelAndView selectEmployee(){
        logger.info("进入选择员工页面");
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/goodsManage/selectEmployee",queryMap );
    }


    @RequestMapping(value = "/getModelByType")
    @ResponseBody
    public Map getModelByType(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map=new HashMap();
        String type = String.valueOf(queryMap.get("type"));
        if(StringUtils.isNotBlankOrNull(type)){
            List list= materialsFeignClient.getModelByType(type);
            map.put("list",list);
        }

        return map;
    }






}
