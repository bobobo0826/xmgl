package com.qgbest.xmgl.web.controller.project;

/**
 * Created by wch on 2017-07-04.
 */

import com.qgbest.xmgl.common.client.exception.ServiceException;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.employee.api.entity.Employee;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.log.api.constants.ServiceConstants;
import com.qgbest.xmgl.project.api.entity.ProjectBase;
import com.qgbest.xmgl.project.api.entity.ProjectParticipant;
import com.qgbest.xmgl.project.api.entity.ReturnMsg;
import com.qgbest.xmgl.project.api.entity.common.SysdataGridPersonConfig;
import com.qgbest.xmgl.project.client.ProjectFeignClient;
import com.qgbest.xmgl.project.client.common.ProjectDictionaryFeignClient;
import com.qgbest.xmgl.project.client.common.ProjectSysdataGridDefaultConfigFeginClient;
import com.qgbest.xmgl.project.client.common.ProjectSysdataGridPersonConfigFeginClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/manage/project")
public class ProjectController extends BaseController {
    public static final Logger lgger = LoggerFactory.getLogger(ProjectController.class);
    @Autowired
    private ProjectFeignClient projectFeignClient;
    @Autowired
    private ProjectSysdataGridPersonConfigFeginClient projectSysdataGridPersonConfigFeginClient;
    @Autowired
    private ProjectSysdataGridDefaultConfigFeginClient projectSysdataGridDefaultConfigFeginClient;
    @Autowired
    private EmployeeFeignClient employeeClient;
    @Autowired
    private ProjectDictionaryFeignClient projectDictionaryFeignClient;

    /**
     * 初始化项目列表页面
     *
     * @return
     */
    @RequestMapping(value = "/initProjectList")
    public ModelAndView initProjectList() {
        Map model = new HashMap();
        HashMap<String, String> queryMap = getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        return new ModelAndView("/project/projectList", model);
    }

    /**
     * 初始化项目选择页面
     *
     * @return
     */
    @RequestMapping(value = "/initSelectProjectList")
    public ModelAndView initSelectProjectList() {
        return new ModelAndView("/project/selectProjectList", null);
    }

    /**
     * 查询
     *
     * @return
     */
    @RequestMapping(value = "/queryProjectList")
    @ResponseBody
    public Map queryProjectList() {
        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = projectFeignClient.queryProjectList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }

    /**
     * 删除项目信息
     *
     * @return
     */
    @RequestMapping(value = "/delProjectInfoById")
    @ResponseBody
    public ReturnMsg delProjectInfoById() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = projectFeignClient.delProjectInfoById(id,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

    /**
     * 初始化项目详情页面
     *
     * @return
     */
    @RequestMapping(value = "/initProjectInfo")
    public ModelAndView initProjectInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("id", queryMap.get("id"));
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        return new ModelAndView("/project/projectInfo", model);
    }

    /**
     * 获取项目详情
     *
     * @return
     */
    @RequestMapping(value = "/getProjectInfoById")
    @ResponseBody
    public Map getProjectInfoById() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ProjectBase projectBase = null;
        if (id != 0) {
            try {
                projectBase = projectFeignClient.getProjectInfoById(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            projectBase = new ProjectBase();
            projectBase.setCreateDate(DateUtils.getCurDateTime2Minute());
            projectBase.setCreator(getCurUser().getDisplayName());
        }
        model.put("projectBase", projectBase);
        return model;
    }

    /**
     * 保存项目信息
     *
     * @return
     */
    @RequestMapping(value = "/saveProject")
    @ResponseBody
    public ReturnMsg saveProject() {
        ProjectBase projectBase = (ProjectBase) JsonUtil.fromJson(httpServletRequest.getParameter("projectBase"), ProjectBase.class);
        /**
         * 修改情况下，更新修改人等
         */
        System.out.println("==projectBase==="+projectBase);
        if (StringUtils.isNotBlankOrNull(projectBase.getId())) {
            projectBase.setModifier(getCurUser().getDisplayName());
            projectBase.setModifyDate(DateUtils.getCurDateTime2Minute());
        }
        ReturnMsg returnMsg = projectFeignClient.saveProject(projectBase,getCurUser().getId(),getCurUser().getDisplayName());
        ProjectBase projectBase1 = (ProjectBase) JsonUtil.fromJson(returnMsg.getMsgData(), ProjectBase.class);
        List participantList = JsonUtil.fromJsonToList(httpServletRequest.getParameter("participantList"));
        if (participantList != null && participantList.size() > 0) {
            if (returnMsg.getMsgCode() == ServiceConstants.SUCCESS) {
                for (int i = 0; i < participantList.size(); i++) {
                    ProjectParticipant projectParticipant = (ProjectParticipant) JsonUtil.fromJson(JsonUtil.toJson(participantList.get(i)), ProjectParticipant.class);
                    projectParticipant.setProject_id(projectBase1.getId());
                    ReturnMsg returnMsg2 = projectFeignClient.saveParticipant(projectParticipant,getCurUser().getId(),getCurUser().getDisplayName());
                    if (returnMsg2.getMsgCode() != ServiceConstants.SUCCESS) {
                        return returnMsg2;
                    }
                }
            }
        }
        return returnMsg;
    }

    @RequestMapping(value = "/getGridStyle")
    @ResponseBody
    public Map getGridStyle() throws IOException, ServiceException {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map = new HashMap();
        String curModuleCode = String.valueOf(queryMap.get("_curModuleCode"));
        SysdataGridPersonConfig personConfig = projectSysdataGridPersonConfigFeginClient.getConfvalByIdAndCode(getCurUser().getId(), curModuleCode);
        if (null != personConfig) {
            map.put("gridStyle", personConfig.getConf_val());
        } else {
            List defaultConfig = projectSysdataGridDefaultConfigFeginClient.getConfVal(curModuleCode);
            map.put("gridStyle", defaultConfig.get(0));
        }
        return map;
    }

    @RequestMapping(value = "/getProjectTypeList")
    @ResponseBody
    public Map getProjectTypeList() {
        Map model = new HashMap();
        List projectTypeList = projectFeignClient.getProjectTypeList();
        model.put("projectTypeList", projectTypeList);
        return model;
    }

    /**
     * 查询项目人员信息
     *
     * @return
     */
    @RequestMapping(value = "/queryParticipantList")
    @ResponseBody
    public List queryParticipantList() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        List list = projectFeignClient.queryParticipantList(JsonUtil.toJson(queryMap));
        return list;
    }

    /**
     * 删除项目信息
     *
     * @return
     */
    @RequestMapping(value = "/delParticipantById")
    @ResponseBody
    public ReturnMsg delParticipantById() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer id = Integer.valueOf(String.valueOf(queryMap.get("id")));
        ReturnMsg returnMsg = projectFeignClient.delParticipantById(id,getCurUser().getId(),getCurUser().getDisplayName());
        return returnMsg;
    }

    /**
     * 初始化参与人员详情页面
     *
     * @return
     */
    @RequestMapping(value = "/initParticipantInfo")
    public ModelAndView initParticipantInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        model.put("gridIndex", queryMap.get("_rowIndex"));
        model.put("_curModuleCode", queryMap.get("_curModuleCode"));
        model.put("imageUrl", imageUrl);
        return new ModelAndView("/project/ProjectParticipantInfo", model);
    }

    /**
     * 获取参与人员类型列表
     *
     * @return
     */
    @RequestMapping(value = "/getParticipantTypeList")
    @ResponseBody
    public Map getParticipantTypeList() {
        Map model = new HashMap();
        List participantTypeList = projectFeignClient.getParticipantTypeList();
        model.put("participantTypeList", participantTypeList);
        return model;
    }

    /**
     * 获得项目和参与人员
     *
     * @return
     */
    @RequestMapping(value = "/queryProjectListAndParticipant")
    @ResponseBody
    public List queryProjectListAndParticipant() {
        String roleCode = httpServletRequest.getParameter("roleCode");
        return projectFeignClient.queryProjectListAndParticipant(roleCode);
    }

    /**
     * 获得当前用户参与的项目和参与人员
     *
     * @return
     */
    @RequestMapping(value = "/queryProjectListAndParticipantByUser")
    @ResponseBody
    public List queryProjectListAndParticipantByUser() {
        Integer userId = Integer.valueOf(httpServletRequest.getParameter("userId"));
        Employee employee = employeeClient.getEmployeeInfoByUserId(userId);
        Integer employeeId = 0;
        if (employee != null) {
            employeeId = employee.getId();
        }
        return projectFeignClient.queryProjectListAndParticipantByUser(employeeId);
    }

    @RequestMapping (value = "/getDicListByBusinessCode")
    @ResponseBody
    public Map getDicListByBusinessCode() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        List dictionaryList = new ArrayList();
        Map model =new HashMap();
        if(StringUtils.isNotBlankOrNull(queryMap.get("businessCode"))) {
            dictionaryList = projectDictionaryFeignClient.getDicListByBusinessCode(queryMap.get("businessCode")+"");
        }
        System.out.println("==dictionaryList==="+dictionaryList);
        model.put("dictionaryList", dictionaryList);
        return model;
    }
    /**
     * datagrid样式保存
     * @return
     */
    @RequestMapping(value = "/saveGridStyle")
    @ResponseBody
    public com.qgbest.xmgl.project.api.entity.ReturnMsg saveGridStyle() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        String curModuleCode=String.valueOf(queryMap.get("_curModuleCode"));
        String gridStyle=String.valueOf(queryMap.get("_gridStyle"));
        com.qgbest.xmgl.project.api.entity.ReturnMsg returnMsg= projectSysdataGridPersonConfigFeginClient.savePersonGridStyle(gridStyle, curModuleCode,getCurUser().getId(),getCurUser().getDisplayName());
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
