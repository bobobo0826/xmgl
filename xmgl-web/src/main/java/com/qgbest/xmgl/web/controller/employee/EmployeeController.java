package com.qgbest.xmgl.web.controller.employee;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.api.entity.SysdataGridPersonConfig;
import com.qgbest.xmgl.employee.client.*;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wjy on 2017/7/18.
 */
@Controller
@RequestMapping(value="/manage/employee")
public class EmployeeController extends BaseController {
    @Autowired
    private EmployeeFeignClient employeeClient;
    @Autowired
    private EmployeeSysdataGridPersonConfigFeginClient employeeSysdataGridPersonConfigFeginClient;
    @Autowired
    private EmployeeSysdataGridDefaultConfigFeginClient employeeSysdataGridDefaultConfigFeginClient;
    @Autowired
    private EmployeeSystemConfigFeignClient employeeSystemConfigFeignClient;
    @Autowired
    private EmployeeDictionaryFeignClient employeeDictionaryFeignClient;
    /**
     * 初始化员工信息列表
     * @return
     */
    @RequestMapping(value = "/initEmployeeList")
    public ModelAndView initEmployeeList() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        model.put("user_id",getCurUser().getId());
        return new ModelAndView( "/employee/employeeList",model);
    }

    @RequestMapping(value = "/queryEmployeeList")
    @ResponseBody

    public Map queryEmployeeList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return employeeClient.getEmployeeList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

    /**
     * 获取选择员工界面的员工LIST列表
     * @return
     */
    @RequestMapping(value = "/selectEmployeeList")
    @ResponseBody

    public Map selectEmployeeList(){
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        return employeeClient.selectEmployeeList(JsonUtil.toJson(queryMap), len, cpage, getCurUser());
    }

    @RequestMapping(value = "/connectAccount")

    public ModelAndView connectAccount(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/employee/selectConnectAccount",queryMap );
    }

    @RequestMapping(value = "/selectEmployee")

    public ModelAndView selectEmployee(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/employee/selectEmployee",queryMap );
    }
/*    @RequestMapping(value = "/selectChecker")

    public ModelAndView selectChecker(){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        return new ModelAndView("/employee/selectChecker",queryMap );
    }*/



    @RequestMapping(value = "/initEmployeeInfo")
    public ModelAndView initEmployeeInfo() {
        Map model= getRequestMapStr2Str(httpServletRequest);
        Integer user_id = getCurUser().getId();
        model.put("user_id",user_id);
        model.put("imageUrl",this.imageUrl);
        return new ModelAndView("/employee/employeeInfo",model);
    }

    @RequestMapping(value = "/initMyEmployeeInfo")
    public ModelAndView initMyEmployeeInfo() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        Integer user_id = getCurUser().getId();
        model.put("user_id",user_id);
        Employee employee = employeeClient.getEmployeeInfoByUserId(getCurUser().getId());
        model.put("imageUrl",this.imageUrl);
        if (employee!=null){
            model.put("id",employee.getId());
            return new ModelAndView("/employee/employeeInfo",model);
        }
        else{
            return new ModelAndView("/employee/noEmployeeInfo",null);
        }
    }


    @RequestMapping(value = "/getEmployeeInfoById/{id}")
    @ResponseBody
    public Employee getEmployeeInfoById(@PathVariable Integer id) {
        Employee employee = new Employee();
        employee = employeeClient.getEmployeeInfoById(id);
        if (id==-1){
            employee.setCreate_date(DateUtils.getCurDateTime2Minute());
            employee.setCreator(getCurUser().getDisplayName());
            employee.setCreator_id(getCurUser().getId());
        }
        return employee;
    }

    @RequestMapping(value = "/delEmployee/{id}")
    @ResponseBody
    public ReturnMsg delEmployee(@PathVariable Integer id) {
        return employeeClient.delEmployee(id,getCurUser().getId(),getCurUser().getDisplayName());
    }
    @RequestMapping(value = "/saveEmployee")
    @ResponseBody
    public Map saveEmployee(@ModelAttribute Employee employee) {
        if (employee.getId()!=null){
            employee.setModify_date(DateUtils.getCurDateTime2Minute());
            employee.setModifier(getCurUser().getDisplayName());
            employee.setModifier_id(getCurUser().getId());
        }
        
        Map map=employeeClient.saveEmployee(employee,getCurUser().getId(),getCurUser().getDisplayName());
        
        return map;
    }

    @RequestMapping(value = "/getGridStyle")
    @ResponseBody
    public Map getGridStyle()  {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map map =new HashMap();
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        SysdataGridPersonConfig personConfig= employeeSysdataGridPersonConfigFeginClient.getConfvalByIdAndCode(getCurUser().getId(), curModuleCode);
        List defaultConfig = employeeSysdataGridDefaultConfigFeginClient.getConfVal(curModuleCode);
        if (null != personConfig) {
            map.put("gridStyle", personConfig.getConf_val());
        } else {

            map.put("gridStyle",defaultConfig.get(0));
        }

        return map;
    }

    @RequestMapping(value = "/getEmploymentStatusDic")
    @ResponseBody
    public Map getEmploymentStatusDic(){
        Map model =new HashMap();
        List employmentStatusDic= employeeDictionaryFeignClient.getDicListByBusinessCode("employment_status");
        model.put("employmentStatusDic", employmentStatusDic);
        return model;
    }
    @RequestMapping(value = "/getEducationBgDic")
    @ResponseBody
    public Map getEducationBgDic(){
        Map model =new HashMap();
        List educationBgDic= employeeDictionaryFeignClient.getDicListByBusinessCode("education_bg");
        model.put("educationBgDic", educationBgDic);
        return model;
    }

    @RequestMapping(value = "/uploadEmployeePic")
    public String uploadEmployeePic(@RequestParam("id") Integer id, @RequestParam("_module") String _module, ModelMap modelMap){
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("_module",_module);
        return "employee/uploadEmployeePic";
    }

    @RequestMapping (value = "/setEmployeeUserId")
    @ResponseBody
    public Map setEmployeeUserId(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Integer employeeId=Integer.valueOf(String.valueOf(queryMap.get("employeeId")));
        Integer userId=Integer.valueOf(String.valueOf(queryMap.get("userId")));
        Employee employee =getEmployeeInfoById(employeeId);
        Map retMap=new HashMap();
        if (employeeClient.getEmployeeInfoByUserId(userId)==null){
            employee.setUser_id(userId);
            employeeClient.saveEmployee(employee,getCurUser().getId(),getCurUser().getDisplayName());
            retMap.put("msg","操作成功");
            retMap.put("success",true);

        }else {
            retMap.put("msg", "操作失败,该账户已经关联了其他员工！");
            retMap.put("success", false);
        }

        return retMap;
    }

    @RequestMapping (value = "/getNoEmployeeInfo")
    @ResponseBody
    public Map getNoEmployeeInfo(){
        Map map =new HashMap();
        String noEmployeeInfo = employeeSystemConfigFeignClient.getDataValue("MYYGXX");
        map.put("noEmployeeInfo",noEmployeeInfo);
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
        ReturnMsg returnMsg= employeeSysdataGridPersonConfigFeginClient.savePersonGridStyle(gridStyle, curModuleCode,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

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


}
