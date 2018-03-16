package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.api.entity.permission.TcStatus;
import com.qgbest.xmgl.permission.client.permission.TcStatusFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;


/**
 * Created by wjy on 2017/6/27.
 *状态Controller
 */

@Controller
@RequestMapping(value = "/manage/status")
public class TcStatusController extends BaseController {
    @Autowired
    private TcStatusFeignClient tcStatusClient;



    /**
     * 初始化状态列表
     * @return 状态列表界面
     */
    @RequestMapping(value = "/statusManage")
    public String initStatusList() {
        return "/permission/statusManager/statusList";
    }

   /**
     * 查询状态列表
     * @return
     */
    @RequestMapping(value = "/queryStatusList")
    @ResponseBody
    public Map queryStatusList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return tcStatusClient.getStatusList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

    /**
     * 初始化状态详情
     * @param id 状态id
     * @return 详情界面和状态id
     */
    @RequestMapping(value = "/initStatusInfo/{id}")
    public ModelAndView initStatusInfo(@PathVariable String id) {
        Map model =new HashMap();
        model.put("id", id);
        return new ModelAndView("/permission/statusManager/statusInfo",model);
    }

   /**
     * 获取状态详情
     * @param id 状态id
     * @return 获取的状态
     */

    @RequestMapping(value = "/getStatusById/{id}")
    @ResponseBody
    public Map getStatusById(@PathVariable String id) {
        Map map=new HashMap();
        TcStatus tcStatus = new TcStatus();
        tcStatus = tcStatusClient.getStatusById(id);
        map.put("tcStatus",tcStatus);
        System.out.println(tcStatus);
        return map;
    }

   /**
     * 删除状态
     * @param id 状态id
     * @return 操作结果success
     */

    @RequestMapping(value = "/delStatus/{id}")
    @ResponseBody
    public ReturnMsg delStatus(@PathVariable String id) {
        return tcStatusClient.delStatus(id);
    }

    /**
     *保存状态
     * @param tcStatus 状态
     * @return 存储操作状态的map
     */
    @RequestMapping(value = "/saveStatus/{isNew}")
    @ResponseBody
    public Map saveStatus(@ModelAttribute TcStatus tcStatus,@PathVariable Boolean isNew ) {
        return tcStatusClient.saveStatus(tcStatus,isNew);
    }
}

