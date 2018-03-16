package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.permission.api.entity.permission.TsModule;
import com.qgbest.xmgl.permission.client.permission.TSModuleFeignClient;
import com.qgbest.xmgl.permission.client.permission.TcOprFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/module")
public class TSModuleController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TSModuleController.class);
    @Autowired
    private TSModuleFeignClient tsModuleFeignClient;
    @Autowired
    private TcOprFeignClient tcOprFeignClient;

    @RequestMapping(value = "/tsQueryModule")
    public String tsQueryModule() {
        return "/permission/moduleManager/tsModuleList";
    }

    @RequestMapping(value = "/tsUpdModule")
    public String tsUpdModule(ModelMap modelMap, HttpServletRequest request) {
        modelMap.addAttribute("moduleId", request.getParameter("moduleId"));
        return "/permission/moduleManager/tsModuleInfo";
    }

    @RequestMapping(value = "/tsQueryModuleList")
    @ResponseBody
    public Map tsQueryModuleList() throws IOException {
        HashMap queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = new HashMap();
        try {
            map = tsModuleFeignClient.getTsModuleList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    @RequestMapping(value = "/getTsModuleInfo")
    @ResponseBody
    public Map getTsModuleInfo(HttpServletRequest request) {
        Map map = new HashMap();
        TsModule model = null;
        if (StringUtils.isNotBlankOrNull(request.getParameter("moduleId"))) {
            try {
                model = tsModuleFeignClient.getTsModuleInfo(request.getParameter("moduleId"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            model = new TsModule();
        }
        map.put("_model", model);
        map.put("oprset", "" + model.getOprSet() + "");
        return map;
    }

    @RequestMapping(value = "/saveTsModuleInfo", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveTsModuleInfo(@ModelAttribute TsModule model) {
        Map map = new HashMap();
        TsModule tsModule = tsModuleFeignClient.saveTsModuleInfo(model);
        map.put("oprset", "" + tsModule.getOprSet() + "");
        map.put("_model", tsModule);
        map.put("msgCode", "success");
        map.put("msgDesc", "操作成功");
        return map;
    }

    @RequestMapping(value = "/delTsModuleInfo")
    @ResponseBody
    public Map delTsModuleInfo(HttpServletRequest request) {
        //保存用户信息
        String id = request.getParameter("moduleid");
        Map map = tsModuleFeignClient.delTsModuleInfo(id);
        return map;
    }

    /**
     * 选择操作，展示所有操作集合
     *
     * @return
     */
    @RequestMapping(value = "/selectOperSetWithAll")
    public String selectOperSetWithAll(HttpServletRequest request, ModelMap modelMap) {
        String opr = null;
        String operValue = null;
        String moduleName = null;
        try {
            operValue = URLEncoder.encode(request.getParameter("opr"), "utf-8");
            moduleName = URLDecoder.decode(request.getParameter("moduleName"), "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        System.out.println("operValue11111111111111aaaaaaaaaaaa"+operValue);
        String id = request.getParameter("id");
        operValue = StringUtils.isNotBlankOrNull(operValue) ? operValue : "0";
        BigInteger bigInteger = new BigInteger(new BigDecimal(operValue).toPlainString());
        System.out.println("bigInteger"+bigInteger);
        String str2 = bigInteger.toString(2);
        StringBuilder sb = new StringBuilder();
        for (int j = 0; j < str2.length(); j++)
            if (str2.charAt(j) == '1') {
                sb.append(";");
                sb.append(str2.length() - j - 1);
                sb.append(";");
            }
        opr = sb.toString();
        System.out.println("oprrrrrrrrrrrr"+opr);
        modelMap.addAttribute("operValue", operValue);
        modelMap.addAttribute("opr", opr);
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("moduleName", moduleName);
        return "/permission/moduleManager/selectOper";
    }

    /**
     * 计算选择后的操作的值的总和
     *
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/calcuteOperValue")
    @ResponseBody
    public Map calcuteOperValue(HttpServletRequest request) throws IOException {
        Map map = new HashMap();
        String opr = request.getParameter("opr");
        opr = opr.substring(0, opr.length() - 1);
        String[] opersArray = opr.split(";");
        BigInteger sumBig = new BigInteger("0");
        for (int i = 0; i < opersArray.length; i++) {
            String operStr = opersArray[i];
            BigInteger bigInteger = new BigInteger("2");
            bigInteger = bigInteger.pow(Integer.parseInt(operStr));
            sumBig = sumBig.add(bigInteger);
        }
        map.put("selectOprValue", "" + sumBig + "");
        return map;
    }

    /**
     * 根据模块名查找操作，更新操作集
     */
    @RequestMapping(value = "/updateModuleOperateSetByModuleName")
    @ResponseBody
    public void updateModuleOperateSetByModuleName(HttpServletRequest request) {
        String moduleName = "";
        try {
            moduleName = URLDecoder.decode(request.getParameter("moduleName"), "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        BigInteger sumBig = new BigInteger("0");
        String opr = tcOprFeignClient.getOprIdByModuleName(moduleName);
        if (opr != null && opr.length() > 0) {
            opr = opr.substring(0, opr.length() - 1);
            String[] opersArray = opr.split(";");
            for (int i = 0; i < opersArray.length; i++) {
                String operStr = opersArray[i];
                BigInteger bigInteger = new BigInteger("2");
                bigInteger = bigInteger.pow(Integer.parseInt(operStr));
                sumBig = sumBig.add(bigInteger);
            }
        }
        tsModuleFeignClient.updateModuleOperate(moduleName, sumBig);
    }

    /**
     * 选择操作，展示所有操作集合
     *
     * @return
     */
    @RequestMapping(value = "/getOperList")
    @ResponseBody
    public Map getOperList(HttpServletRequest request) {
        String moduleName = null;
        try {
            moduleName = URLDecoder.decode(request.getParameter("moduleName"), "utf-8");
        } catch (UnsupportedEncodingException exception) {
            exception.printStackTrace();
        }
        List moduleNameList = tsModuleFeignClient.getTsModuleOprList(moduleName);
        Map map = new HashMap();
        map.put("moduleNameList", moduleNameList);
        return map;
    }

    /**
     * 选择操作，展示模块中的操作集合
     *
     * @return
     * @throws Exception
     */
    //    public List getOperValueList(String operValue) {
    //        BigDecimal bigDecimal = new BigDecimal(operValue);
    //        BigInteger bigInt = new BigInteger(bigDecimal.toPlainString());
    //        String str = bigInt.toString(2);
    //        String str2 = bigInt.toString(2);
    //        StringBuilder sb = new StringBuilder();
    //        for (int j = 0; j < str2.length(); j++) {
    //            if (str2.charAt(j) == '1') {
    //                sb.append(";");
    //                sb.append(str2.length() - j - 1);
    //                sb.append(";");
    //            }
    //        }
    //        String operIds = "";
    //        for (int j = 0; j < str.length(); j++) {
    //            if (str.charAt(j) == '1') {
    //                if (StringUtils.isNotBlankOrNull(operIds))
    //                    operIds = (str.length() - j - 1) + "";
    //                else
    //                    operIds = operIds + "," + (str.length() - j - 1);
    //            }
    //        }
    //        List list = tsModuleFeignClient.getOperValueList(operIds);
    //        System.out.println("111111111111111"+list);
    //        return list;
    //    }
}

