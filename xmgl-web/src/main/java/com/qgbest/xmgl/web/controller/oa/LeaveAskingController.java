package com.qgbest.xmgl.web.controller.oa;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.oa.api.entity.LeaveAsking;
import com.qgbest.xmgl.oa.api.entity.ReturnMsg;
import com.qgbest.xmgl.oa.client.*;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author: LiuFuMing
 * Created by xw on 2017/8/23 0023.
 * Description:
 */
@Controller
@RequestMapping(value="/manage/leaveAsking")
public class LeaveAskingController extends BaseController {
         @Autowired
         private OaDictionaryFeignClient oaDictionaryFeignClient;
        @Autowired
        private LeaveAskingFeignClient leaveAskingClient;
        @Autowired
        private LeaveAskingDictionaryFeignClient leaveAskingDictionaryFeignClient;
/*        @Autowired
        private LeaveAskingSysdataGridPersonConfigFeginClient leaveAskingSysdataGridPersonConfigFeginClient;
        @Autowired
        private LeaveAskingSysdataGridDefaultConfigFeginClient leaveAskingSysdataGridDefaultConfigFeginClient;*/
        @Autowired
        private LeaveAskingSystemConfigFeignClient leaveAskingSystemConfigFeignClient;
        /**
         * 初始化员工信息列表
         * @return
         */
        @RequestMapping(value = "/initLeaveAskingList")
        public ModelAndView initLeaveAskingList() {

            Map queryMap= getRequestMapStr2Str(httpServletRequest);
            System.out.print("----------"+queryMap);

            Map model =new HashMap();
            model.put("_curModuleCode",queryMap.get("_curModuleCode"));
            model.put("creator_id",getCurUser().getId());
            return new ModelAndView( "/oa/leaveAsking/leaveAskingList",model);
        }
         //查询
        @RequestMapping(value = "/queryLeaveAskingList")
        @ResponseBody

        public Map queryLeaveAskingList(){
            HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
            return leaveAskingClient.getLeaveAskingList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
        }

    //跳转详情界面
        @RequestMapping(value = "/initLeaveAskingInfo")
        public ModelAndView initLeaveAskingInfo() {
            Map model= getRequestMapStr2Str(httpServletRequest);
            if (!StringUtils.isNotBlankOrNull(model.get("id"))){
                model.put("id", -1);
            }
            if (model.get("id").equals(-1)){
                model.put("creator_id",getCurUser().getId());
            }

            model.put("imageUrl",this.imageUrl);
            model.put("cur_user_id",getCurUser().getId());
            return new ModelAndView("/oa/leaveAsking/leaveAskingInfo",model);
        }

        //获取详情
        @RequestMapping(value = "/getLeaveAskingInfoById/{id}")
        @ResponseBody
        public LeaveAsking getLeaveAskingInfoById(@PathVariable Integer id) {
            LeaveAsking leaveAsking = new LeaveAsking();
            leaveAsking = leaveAskingClient.getLeaveAskingInfoById(id);
            if (id == -1){
                leaveAsking.setCreate_time(DateUtils.getCurDateTime2Minute());
                leaveAsking.setCreator(getCurUser().getDisplayName());
                leaveAsking.setCreator_id(getCurUser().getId());
                leaveAsking.setStatus("CG");
            }
            return leaveAsking;
        }
        @RequestMapping(value = "/saveLeaveAsking")
        @ResponseBody
        public Map saveLeaveAsking() {
            LeaveAsking leaveAsking = JsonUtil.fromJson(httpServletRequest.getParameter("leaveAsking"), LeaveAsking.class);
            System.out.print(leaveAsking);
            String oprCode = String.valueOf(httpServletRequest.getParameter("oprCode"));
            if (oprCode.equals("PASS") || oprCode.equals("NOTPASS")){
                leaveAsking.setChecker(getCurUser().getDisplayName());
                leaveAsking.setChecker_id(getCurUser().getId());
                leaveAsking.setCheck_time(DateUtils.getCurDateTime2Minute());
            }
            else if(oprCode.equals("ENDLEAVE")) {
                System.out.println("aaaaa");
                leaveAsking.setActual_resump_time(DateUtils.getCurDateTime2Minute());
            }
            Map map=leaveAskingClient.saveLeaveAsking(leaveAsking, getCurUser().getId(), getCurUser().getDisplayName());

            return map;
        }
        //删除，参数如果在url后面，获取参数要用@PathVariable
        @RequestMapping(value = "/delLeaveAsking/{id}")
        @ResponseBody
        public ReturnMsg delLeaveAsking(@PathVariable Integer id) {
            return leaveAskingClient.delLeaveAsking(id, getCurUser().getId(), getCurUser().getDisplayName());
        }

        @RequestMapping(value = "/getLeaveAskingDic")
        @ResponseBody
        public Map getLeaveAskingDic(){
            Map model =new HashMap();
            List leaveAskingStatusList= oaDictionaryFeignClient.getDicListByBusinessCode("leave_asking_status");
            model.put("leaveAskingStatusList",leaveAskingStatusList);
            List leaveAskingResStatusList= oaDictionaryFeignClient.getDicListByBusinessCode("resumption_status");
            model.put("leaveAskingResStatusList",leaveAskingResStatusList);
            return model;
        }

        @RequestMapping(value = "/getLeaveAskingStatusDic")
        @ResponseBody
        public Map getLeaveAskingStatusDic(){
            Map model =new HashMap();
            List leaveAskingStatusDic= leaveAskingDictionaryFeignClient.getDicListByBusinessCode("status");
            model.put("leaveAskingStatusDic", leaveAskingStatusDic);
            return model;
        }





}

