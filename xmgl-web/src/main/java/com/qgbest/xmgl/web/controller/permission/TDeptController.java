package com.qgbest.xmgl.web.controller.permission;

import com.qgbest.xmgl.common.client.exception.ServiceException;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.dept.api.entity.TcDept;
import com.qgbest.xmgl.dept.client.TDeptFeignClient;
import com.qgbest.xmgl.division.client.DivisionClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/dept")
public class TDeptController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TDeptController.class);
    @Autowired
    private TDeptFeignClient tDeptFeignClient;
    @Autowired
    private DivisionClient divisionClient;
    /**
     * 初始化部门管理界面
     * @return
     */
    @RequestMapping(value = "/tsDeptTreeIndex")
    public ModelAndView tsDeptTreeIndex() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        return new ModelAndView("/permission/deptManager/deptTreeInfo", model);

    }

    /**
     * 初始化部门详情界面

     * @return
     */
    @RequestMapping(value = "/indexDeptInfo")
    public String indexDeptInfo(@RequestParam("deptId") Integer deptId,@RequestParam("parentId") Integer parentId,ModelMap modelMap) {
        List dicProviceList=divisionClient.getProvList();
        modelMap.addAttribute("dicProviceList",dicProviceList);
        modelMap.addAttribute("deptId",deptId);
        modelMap.addAttribute("parentId",parentId);
        return "/permission/deptManager/deptManageRight";
    }

    /**
     * 根据父部门id获取子部门
     * @param parentId
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getDeptTreeList")
    @ResponseBody
    public List getDeptTreeList(@RequestParam("parentId") Integer parentId) throws IOException {
        if (parentId == null){
            parentId = -1;
        }
        List deptList = tDeptFeignClient.getDeptTreeList(parentId);
        return deptList;
    }

    /**
     * 根据部门id获取部门信息
     * @param deptId
     * @param parentId
     * @param modelMap
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getDeptInfo")
    @ResponseBody
    public Map getDeptInfo(@RequestParam("deptId") Integer deptId,@RequestParam("parentId") Integer parentId,ModelMap modelMap) throws IOException {
        Map map = new HashMap();
        TcDept dept = null;
        if (deptId == null) {
            dept = new TcDept();
            dept.setParentId(parentId);
        } else {
            dept = tDeptFeignClient.getDeptInfo(deptId);
        }

        String parentDeptName="";
        if(dept.getParentId()!=null){
            TcDept parentDept = tDeptFeignClient.getDeptInfo(dept.getParentId());
            if(parentDept!=null){
                parentDeptName=parentDept.getDeptName();
            }
        }
        dept.setParentDeptName(parentDeptName);
        map.put("_model", dept);
        return map;
    }

    /**
     * 删除部门
     * @param deptId
     * @return
     */
    @RequestMapping(value = "/delDeptInfo")
    @ResponseBody
    public Map delDeptInfo(@RequestParam("deptId") Integer deptId){
       Map map=new HashMap();
        try {
           if(deptId==null){
               map.put("msgCode","false");
               map.put("msgDesc","删除失败");
           }else{
               tDeptFeignClient.delDeptInfo(deptId);
               map.put("msgCode","success");
               map.put("msgDesc","删除成功");
           }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * 保存部门
     * @param dept
     * @return
     */
    @RequestMapping(value = "/saveDeptInfo",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveDeptInfo(@ModelAttribute TcDept dept) {
        Map map=new HashMap();
        TcDept newDept=new TcDept();
        try{
            newDept=tDeptFeignClient.saveDeptInfo(dept);
            map.put("msgCode","success");
            map.put("msgDesc","保存成功");
        }catch (Exception e){
            e.printStackTrace();
            map.put("msgCode","false");
            map.put("msgDesc","保存失败");
        }
        if(newDept!=null && newDept.getParentId()!=null){
            TcDept parentDept = tDeptFeignClient.getDeptInfo(newDept.getParentId());
            if(parentDept!=null){
                String parentDeptName=parentDept.getDeptName();
                newDept.setParentDeptName(parentDeptName);
            }
        }
        map.put("_model",newDept);
        return map;
    }

    /**
     * 检测部门选择是否合理、正确
     * @param deptId
     * @param chageAfterDeptId
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/checkChangeCodeIsCorrect")
    @ResponseBody
    public Map checkChangeCodeIsCorrect(@RequestParam("deptId") Integer deptId,@RequestParam("chageAfterDeptId") Integer chageAfterDeptId) throws IOException {
        Map map = new HashMap();
        TcDept changeAfterParentDept = tDeptFeignClient.getDeptInfo(chageAfterDeptId);
        TcDept curDept = tDeptFeignClient.getDeptInfo(deptId);
        // 如果当前部门id，与改编后的父部门id一样则返回false
        Integer curDeptParentId = curDept.getParentId();
        if (curDeptParentId.intValue() == deptId.intValue()) {
            map.put("msgCode","failure");
            map.put("msgDesc", "不能选择自己部门为自己的父部门！");
        }
        // 检查当前部门设置的父部门，不能为自己的子部门，必须是自己的平级或者上级部门
        String curDeptCode = curDept.getDeptCode();
        String parentDeptCode = changeAfterParentDept.getDeptCode();
        if (curDeptCode.length() < parentDeptCode.length()) {
            map.put("msgCode","failure");
            map.put("msgDesc", "不能选择自己的子部门做父部门！");
        } else {
            map.put("msgCode", "success");
        }
        return map;
    }

    /**
     * 移动部门到别的部门下
     */
    @RequestMapping(value = "/moveDeptToOtherDept")
    @ResponseBody
    public Map moveDeptToOtherDept(@RequestParam("movedDeptId") Integer movedDeptId,@RequestParam("toDeptId") Integer toDeptId) throws IOException {
        Map map = new HashMap();
        try {
            tDeptFeignClient.moveDeptToOtherDept(movedDeptId,toDeptId);
            map.put("msgCode","success");
            map.put("msgDesc","操作成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msgCode","fail");
            map.put("msgDesc","操作失败");

        }
        return map;
    }

    /**
     * 初始化选择部门
     * @param modelMap
     * @return
     * @throws ServiceException
     */
    @RequestMapping(value = "/choseDept")
    public String choseDept(ModelMap modelMap,@RequestParam("_selDept") String _selDept) throws ServiceException {
        List deptList=tDeptFeignClient.queryDeptsTreeViewII(_selDept);
        String deptListStr=JsonUtil.toJson(deptList);
        modelMap.addAttribute("_chkStyle",httpServletRequest.getParameter("_chkStyle"));
        modelMap.addAttribute("deptListStr",deptListStr.replace("\"","'"));
        return "/permission/deptManager/choseDept";
    }

    /**
     * 获取省字典表
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getProvincesDic")
    @ResponseBody
    public Map getProvincesDic() throws IOException {
        Map map = new HashMap();
        List list=divisionClient.getProvList();
        map.put("v", list);
        return map;
    }

    /**
     * 根据省code获取市列表
     * @param provCode
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getCitiesDicByProvCode")
    @ResponseBody
    public Map getCitiesDicByProvCode(@RequestParam("provCode") String provCode) throws IOException {
        Map map = new HashMap();
        List list=divisionClient.getCityListByProv(provCode);
        map.put("v", list);
        return map;
    }

    /**
     * 根据市code获取区县列表
     * @param cityCode
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getCountiesDicByCityCode")
    @ResponseBody
    public Map getCountiesDicByCityCode(@RequestParam("cityCode") String cityCode) throws IOException {
        Map map = new HashMap();
        List list=divisionClient.getCounListByCity(cityCode);
        map.put("v", list);
        return map;
    }

    /**
     * 分别根据省code、市code,区县code获取各自的名称
     * @param provName
     * @param cityName
     * @param counName
     * @return
     */
    @RequestMapping(value = "/getProvAndCityAndCounCodeByName",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map getProvAndCityAndCounCodeByName(@RequestParam("provName") String provName,@RequestParam("cityName") String cityName,@RequestParam("counName") String counName){
        Map map = new HashMap();
        if (provName.indexOf("市") >= 0) {
            provName = provName.substring(0, provName.length() - 1);
        }
        String provCode = divisionClient.getProvCodeGetByProvName(provName);
        String cityCode = divisionClient.getCityCodeGetByCityName(cityName);
        // 不同的市可能有相同名字的区县
        String countyCode = "";
        List list = divisionClient.getCounListByCity(cityCode);
        for (int i = 0; i < list.size(); i++) {
            Map  listMap= (Map) list.get(i);
            String county_name =listMap.get("counname").toString();
            if (counName.equals(county_name)) {
                countyCode = listMap.get("councode").toString();
                break;
            }
        }
        map.put("provCode", provCode);
        map.put("cityCode", cityCode);
        map.put("countyCode", countyCode);
        return map;
    }
}
