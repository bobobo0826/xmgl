package com.qgbest.xmgl.web.controller.worklog;

import com.qgbest.xmgl.web.controller.BaseController;

import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.worklog.client.WorkLogSysdataGridDefaultConfigFeginClient;
import com.qgbest.xmgl.worklog.client.WorkLogSysdataGridPersonConfigFeginClient;
import com.qgbest.xmgl.worklog.client.WorkLogSystemConfigFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: xw
 * Date: 2017/7/14
 * Time: 11:55
 * description: 类描述
 */
@Controller
@RequestMapping(value = "/manage/commonWorkLog")
public class WorkLogCommonController extends BaseController {
    @Autowired
    private WorkLogSysdataGridDefaultConfigFeginClient workLogSysdataGridDefaultConfigFeginClient;

    @Autowired
    private WorkLogSysdataGridPersonConfigFeginClient workLogSysdataGridPersonConfigFeginClient;
    @Autowired
    private WorkLogSystemConfigFeignClient workLogSystemConfigFeignClient;

    /**
     * datagrid样式查询
     * @return
     */
    @RequestMapping(value = "/getGridStyle")
    @ResponseBody
    public Map getGridStyle()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map map =new HashMap();
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        SysdataGridPersonConfig personConfig= workLogSysdataGridPersonConfigFeginClient.getConfvalByIdAndCode(getCurUser().getId(), curModuleCode);
        if (null != personConfig) {
            map.put("gridStyle", personConfig.getConf_val());
        } else {
            List defaultConfig = workLogSysdataGridDefaultConfigFeginClient.getConfVal(curModuleCode);
            map.put("gridStyle",defaultConfig.get(0));
        }
        return map;
    }
    /**
     * datagrid样式保存
     * @return
     */
    @RequestMapping(value = "/saveGridStyle")
    @ResponseBody
    public ReturnMsg saveGridStyle() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        String gridStyle=String.valueOf(queryMap.get("_gridStyle"));
        ReturnMsg returnMsg= workLogSysdataGridPersonConfigFeginClient.savePersonGridStyle(gridStyle, curModuleCode,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }
    /**
     *初始化datagrid显示隐藏列界面
     * @return
     */
    @RequestMapping(value = "/showGridColumn")
    public ModelAndView showGridColumn()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String columnFiled=String.valueOf(queryMap.get("_columnFiled"));
        String columnTitle=String.valueOf(queryMap.get("_columnTitle"));
        String columnsHidden=String.valueOf(queryMap.get("_columnsHidden"));
        Map model =new HashMap();
        model.put("_columnFiled",columnFiled);
        model.put("_columnTitle",columnTitle);
        model.put("_columnsHidden",columnsHidden);
        return new ModelAndView("/sysdataGridDefaultConfig/showDataGridColumn",model);
    }

    @RequestMapping(value = "/getSysConfDataValue")
    @ResponseBody
    public String getSysConfDataValue() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String dataCode=String.valueOf(queryMap.get("dataCode"));
        String value= workLogSystemConfigFeignClient.getDataValue(dataCode);
        return value;
    }

}
