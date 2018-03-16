package com.qgbest.xmgl.web.controller.project;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.project.api.entity.ProjectModule;
import com.qgbest.xmgl.project.client.ProjModuleFeignClient;
import com.qgbest.xmgl.task.client.TaskFeignClient;
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

/**
 * Created by wch on 2017-07-07.
 */
@Controller
@RequestMapping(value = "/manage/projectModule")
public class ProjectModuleController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(ProjectModuleController.class);
    @Autowired
    private ProjModuleFeignClient projModuleFeignClient;
    @Autowired
    private TaskFeignClient taskFeignClient;

    /**
     * 初始化项目模块详情界面
     *
     * @return
     */
    @RequestMapping(value = "/initProjModuleInfo")
    public ModelAndView initProjModuleInfo() {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Map modelMap = new HashMap();
        modelMap.put("moduleId", queryMap.get("moduleId"));
        modelMap.put("projectName", queryMap.get("projectName"));
        modelMap.put("projectId", queryMap.get("projectId"));
        modelMap.put("parentId", queryMap.get("parentId"));
        modelMap.put("level", queryMap.get("level"));
        modelMap.put("_curModuleCode", queryMap.get("_curModuleCode"));
        return new ModelAndView("/project/projModuleManageRight", modelMap);
    }

    /**
     * 根据父模块id获取子模块
     *
     * @param parentId
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getProjModuleTreeList")
    @ResponseBody
    public List getProjModuleTreeList(@RequestParam("parentId") Integer parentId, @RequestParam("level") Integer level) throws IOException {
        if (parentId == null) {
            parentId = -1;
        }
        if (level == null) {
            level = 0;
        }
        List projModuleList = projModuleFeignClient.getProjModuleTreeList(parentId, level);
        return projModuleList;
    }

    /**
     * 删除项目模块
     *
     * @param moduleId
     * @return
     */
    @RequestMapping(value = "/delProjModuleInfo")
    @ResponseBody
    public Map delProjModuletInfo(@RequestParam("moduleId") Integer moduleId) {
        Map map = new HashMap();
        try {
            if (moduleId == null) {
                map.put("msgCode", "false");
                map.put("msgDesc", "删除失败");
            } else {
                projModuleFeignClient.delProjModuleInfo(moduleId, getCurUser().getId(), getCurUser().getDisplayName());
                map.put("msgCode", "success");
                map.put("msgDesc", "删除成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * 移动部门到别的部门下
     */
    @RequestMapping(value = "/moveProjModule")
    @ResponseBody
    public Map moveDeptToOtherDept(@RequestParam("fromModuleId") Integer fromModuleId, @RequestParam("toModuleId") Integer toModuleId, @RequestParam("targetLevel") Integer targetLevel) throws IOException {
        Map map = new HashMap();
        if (targetLevel > 1) {
            try {
                projModuleFeignClient.moveProjModule(fromModuleId, toModuleId, targetLevel);
                map.put("msgCode", "success");
                map.put("msgDesc", "操作成功");
            } catch (Exception e) {
                e.printStackTrace();
                map.put("msgCode", "fail");
                map.put("msgDesc", "操作失败");

            }
        } else {
            map.put("msgCode", "fail");
            map.put("msgDesc", "操作不允许");
        }
        return map;
    }

    /**
     * 根据模块id获取模块信息
     *
     * @param moduleId
     * @param parentId
     * @return
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/getProjModuleInfo")
    @ResponseBody
    public Map getProjModuleInfo(@RequestParam("moduleId") Integer moduleId, @RequestParam("parentId") Integer parentId) throws IOException {
        Map map = new HashMap();
        ProjectModule projectModule = null;
        if (moduleId == null) {
            projectModule = new ProjectModule();
            projectModule.setParentId(parentId);//新建模块时，设置父模块id
        } else {
            projectModule = projModuleFeignClient.getProjModuleInfo(moduleId);
        }

        map.put("_model", projectModule);
        return map;
    }

    /**
     * 保存项目模块信息
     *
     * @param projectModule
     * @return
     */
    @RequestMapping(value = "/saveProjModuleInfo", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveProjModuleInfo(@ModelAttribute ProjectModule projectModule) {
        Map map = new HashMap();
        if(StringUtils.isNotBlankOrNull(projectModule.getId())) {
            Integer moduleId = Integer.valueOf(String.valueOf(projectModule.getId()));
            String oldModuleName = projModuleFeignClient.getProjModuleInfo(moduleId).getModuleName();
            if(!oldModuleName.equals(projectModule.getModuleName())){
                System.out.println("==oldModuleName=="+oldModuleName);
                System.out.println("==newModuleName=="+projectModule.getModuleName());
                taskFeignClient.updateTaskModuleName(projectModule.getId(),projectModule.getModuleName());
            }
        }
        ProjectModule newProjectModule = new ProjectModule();
        try {
            newProjectModule = projModuleFeignClient.saveProjModuleInfo(projectModule, getCurUser().getId(), getCurUser().getDisplayName());
            map.put("msgCode", "success");
            map.put("msgDesc", "保存成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msgCode", "false");
            map.put("msgDesc", "保存失败");
        }
        if(newProjectModule.getModuleStatusCode().equals("ZZ")){
            taskFeignClient.resetTaskAndPlanCondition(projectModule.getId());
        }
        map.put("_model", newProjectModule);
        return map;
    }

    @RequestMapping(value = "/choseProjModule")
    public String choseProjModule(@RequestParam("_chkStyle") String chkStyle, @RequestParam("projectId") Integer projectId, ModelMap modelMap) {
        List moduleList = projModuleFeignClient.choseProjModule(projectId);
        String moduleListStr = JsonUtil.toJson(moduleList);
        modelMap.addAttribute("moduleListStr", moduleListStr.replace("\"", "'"));
        modelMap.addAttribute("_chkStyle", chkStyle);
        return "/project/selectProjModuleTree";
    }


}