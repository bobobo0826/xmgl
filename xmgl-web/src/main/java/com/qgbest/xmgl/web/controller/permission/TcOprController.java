package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.division.api.contants.ServiceConstants;
import com.qgbest.xmgl.permission.api.entity.ReturnMsg;
import com.qgbest.xmgl.permission.api.entity.permission.TcOpr;
import com.qgbest.xmgl.permission.client.permission.TcOprFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/opr")
public class TcOprController extends BaseController {
  public static final Logger logger = LoggerFactory.getLogger(TcOprController.class);
  @Autowired
  public TcOprFeignClient oprClient;

  /**
   * 初始化操作管理界面
   *
   * @return
   */
  @RequestMapping(value = "/tcOprQueryIndex")
  public String tcOprQueryIndex() {
    return "/permission/opr/oprList";
  }

  /**
   * 初始化操作详情界面
   *
   * @param oprId
   * @param modelMap
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/tcOprInfoIndex")
  public String tcOprInfoIndex(@RequestParam("oprId") Integer oprId, ModelMap modelMap) throws Exception {
    modelMap.addAttribute("oprId", oprId);
    return "/permission/opr/oprEdit";
  }

  /**
   * 获取操作列表
   *
   * @return
   */
  @RequestMapping(value = "/tcOprQueryList", method = RequestMethod.POST)
  @ResponseBody
  public Map tcOprQueryList() {
    HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
    Map map = oprClient.getOprList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    return map;
  }

  /**
   * 获取操作详情
   *
   * @return
   */
  @RequestMapping(value = "/getOprInfo/{oprId}", produces = MediaType.APPLICATION_JSON_VALUE)
  @ResponseBody
  public Map getOprInfo(@PathVariable Integer oprId) {
    Map map = new HashMap();
    TcOpr model = null;
    if (StringUtils.isNotBlankOrNull(oprId)) {
      try {
        model = oprClient.getOprInfo(oprId);
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else {
      model = new TcOpr();
    }
    map.put("_model", model);
    return map;
  }

  /**
   * 删除操作信息
   *
   * @param oprId
   * @return
   */
  @RequestMapping(value = "/delOprInfo/{oprId}")
  @ResponseBody
  public ReturnMsg delOprInfo(@PathVariable Integer oprId) {
    return oprClient.delOprInfo(oprId);
  }

  /**
   * 批量选择操作(状态更改为已选择)
   *
   * @param idsStr
   * @return
   */
  @RequestMapping(value = "/mutiSelectOpr/{idsStr}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
  @ResponseBody
  public ReturnMsg mutiSelectOpr(@PathVariable("idsStr") String idsStr) {
    try {
      if (StringUtils.isEmpty(idsStr)) {
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
      } else {
        oprClient.mutiSelectOpr(idsStr);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  /**
   * 批量不选择操作(状态更改为未选择)
   *
   * @param idsStr
   * @return
   */
  @RequestMapping(value = "/mutiUnSelectOpr/{idsStr}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
  @ResponseBody
  public ReturnMsg mutiUnSelectOpr(@PathVariable("idsStr") String idsStr) {
    Map map = new HashMap();

    try {
      if (StringUtils.isEmpty(idsStr)) {
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.FAILE,ServiceConstants.FAILE_DESC,"");
      } else {
        oprClient.mutiUnSelectOpr(idsStr);
        ReturnMsg returnMsg = new ReturnMsg();
        return returnMsg.getReturnMsg(ServiceConstants.SUCCESS,ServiceConstants.SUCCESS_DESC,"");
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  /**
   * 保存操作
   *
   * @return
   */
  @RequestMapping(value = "/saveOprInfo/{isNew}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
  @ResponseBody
  public Map saveOprInfo(@ModelAttribute TcOpr opr, @PathVariable Boolean isNew) {
    return oprClient.saveOprInfo(opr, isNew);
  }
}
