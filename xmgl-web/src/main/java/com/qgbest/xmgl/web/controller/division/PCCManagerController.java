package com.qgbest.xmgl.web.controller.division;

import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.division.api.entity.City;
import com.qgbest.xmgl.division.api.entity.County;
import com.qgbest.xmgl.division.api.entity.Province;
import com.qgbest.xmgl.division.client.DivisionClient;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by quangao on 2017/6/19.
 */
@Controller
@RequestMapping(value = "/manage/pcc")
public class PCCManagerController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(PCCManagerController.class);
    /**
     * 行政区划
     */
    @Autowired
    private DivisionClient divisionClient;
    @RequestMapping(value = "/pccTreeIndex")
    private String pccTreeIndex(ModelMap modelMap){
        modelMap.addAttribute("_curModuleCode",httpServletRequest.getParameter("_curModuleCode"));
        return "/division/PCCManagerMain";
    }
    @RequestMapping(value = "/provinceBaseIndex")
    private String provinceBaseIndex(ModelMap modelMap){
        modelMap.addAttribute("_code",httpServletRequest.getParameter("_code"));
        return "/division/PCCManagerProvince";
    }
    @RequestMapping(value = "/cityBaseIndex")
    private String cityBaseIndex(ModelMap modelMap){
        modelMap.addAttribute("_code",httpServletRequest.getParameter("_code"));
        return "/division/PCCManagerCity";
    }
    @RequestMapping(value = "/countyBaseIndex")
    private String countyBaseIndex(ModelMap modelMap){
        modelMap.addAttribute("_code",httpServletRequest.getParameter("_code"));
        return "/division/PCCManagerCounty";
    }
    @RequestMapping(value = "/provinceBaseAddIndex")
    private String provinceBaseAddIndex(){
        return "/division/PCCManagerProvince";
    }
    @RequestMapping(value = "/cityBaseAddIndex")
    private String cityBaseAddIndex(ModelMap modelMap){
        modelMap.addAttribute("_provCode",httpServletRequest.getParameter("_provCode"));
        return "/division/PCCManagerCity";
    }
    @RequestMapping(value = "/countyBaseAddIndex")
    private String countyBaseAddIndex(ModelMap modelMap){
        modelMap.addAttribute("_cityCode",httpServletRequest.getParameter("_cityCode"));
        return "/division/PCCManagerCounty";
    }
    @RequestMapping(value = "/pccTreeList")
    @ResponseBody
    private List pccTreeList(){
        String code = httpServletRequest.getParameter("_code");
        String _nodeId = httpServletRequest.getParameter("_nodeId");
        String _levelId = httpServletRequest.getParameter("_levelId");
        if (StringUtils.isEmpty(code)){
            code="";
        }
        List list = divisionClient.pccTreeList(code,_nodeId,_levelId);
        return list;
    }
    @RequestMapping(value = "/delDivisionItem")
    @ResponseBody
    private Map delDivisionItem(){
        String code = httpServletRequest.getParameter("_a_code");
        String level = httpServletRequest.getParameter("_level");
        Map map = divisionClient.delDivisionItem(code,level);
        return map;
    }
    @RequestMapping(value = "/getProvBase")
    @ResponseBody
    private Map getProvBase(){
        String provCode = httpServletRequest.getParameter("provCode");
        Province province = null;
        Map map = new HashMap<>();
        if (StringUtils.isNotBlankOrNull(provCode)){
            province = divisionClient.getProvBase(provCode);
            map.put("is_used", province.getIsUsed());
        }else{
            province = new Province();
        }
        map.put("province",province);
        return map;
    }
    @RequestMapping(value = "/getCityBase")
    @ResponseBody
    private Map getCityBase(){
        String cityCode = httpServletRequest.getParameter("cityCode");
        City city = null;
        Map map = new HashMap<>();
        if (StringUtils.isNotBlankOrNull(cityCode)){
            city = divisionClient.getCityBase(cityCode);
            map.put("is_used", city.getIsUsed());
        }else{
            city = new City();
        }
        map.put("city",city);
        return map;
    }
    @RequestMapping(value = "/getCounBase")
    @ResponseBody
    private Map getCounBase(){
        String counCode = httpServletRequest.getParameter("counCode");
        County county = null;
        Map map = new HashMap<>();
        if (StringUtils.isNotBlankOrNull(counCode)){
            county = divisionClient.getCountyBase(counCode);
            map.put("is_used", county.getIsUsed());
        }else{
            county = new County();
        }
        map.put("county",county);

        return map;
    }
    @RequestMapping(value = "/saveProvinceBase",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    private Map saveProvinceBase(@ModelAttribute Province provinceBase){
        logger.info("保存省信息：{}", provinceBase);
        Map map = divisionClient.saveProvinceBase(provinceBase);
        return map;
    }
    @RequestMapping(value = "/saveCityBase",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    private Map saveCityBase(@ModelAttribute City cityBase){
        logger.info("保存市信息：{}", cityBase);
        Map map = divisionClient.saveCityBase(cityBase);
        return map;
    }
    @RequestMapping(value = "/saveCountyBase",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    private Map saveCountyBase(@ModelAttribute County countyBase){
        logger.info("保存县信息：{}", countyBase);
        Map map = divisionClient.saveCountyBase(countyBase);
        return map;
    }
}
