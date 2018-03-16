package com.qgbest.xmgl.bugs.controller;

import com.qgbest.xmgl.bugs.Bugs;
import com.qgbest.xmgl.bugs.dao.BugsRepository;
import com.qgbest.xmgl.bugs.dao.BugsRepositoryExtends;
import com.qgbest.xmgl.bugs.dao.CommonDicRepositoryExtends;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.employee.client.EmployeeFeignClient;
import com.qgbest.xmgl.project.client.ProjModuleFeignClient;
import com.qgbest.xmgl.project.client.ProjectFeignClient;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA 2017.
 * User:lbb
 * Date:2017/8/29
 * Time:9:38
 * description:xmgl-new
 */
@RestController
@Controller
public class BugsController extends BaseController {
    @Autowired
    private BugsRepositoryExtends bugsRepositoryExtends;
    @Autowired
    private BugsRepository bugsRepository;
    @Autowired
    private CommonDicRepositoryExtends commonDicRepositoryExtends;
    @Autowired
    private EmployeeFeignClient employeeFeignClient;
    @Autowired
    private ProjectFeignClient projectFeignClient;
    @Autowired
    private ProjModuleFeignClient projModuleFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;


    @RequestMapping(value = "/queryBugsList")
    @ResponseBody
    public PageControl queryDayLogList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        //        queryMap.put("user", getCurUser().getDisplayName());
        return bugsRepositoryExtends.queryBugsList(queryMap);
    }

    @RequestMapping(value = "/delBugs/{id}")
    @ResponseBody
    public void delBugs(@PathVariable Integer id) {
        bugsRepository.delBugs(id);
    }

    @RequestMapping(value = "/getBugsInfoById/{id}")
    @ResponseBody
    public Map getBugsInfoById(@PathVariable Integer id) {
        Map map = new HashMap();
        map.put("Bugs", bugsRepository.getBugsInfoById(id));
        return map;
    }

    @RequestMapping(value = "/saveBugsInfo/{status}")
    @ResponseBody
    public void saveBugsInfo(HttpServletRequest request, @PathVariable String status) {
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        Integer id;
        Map data = getRequestPayload(request);
        Bugs bugs;
        try {
            id = ((Double) data.get("id")).intValue();
            if (status.equals("Save") || status.equals("Submit")) {
                bugs = new Bugs();
                bugs.setId(id);
                switch (status) {
                    case ("Save"):
                        bugs.setStatus("草稿");
                        break;
                    case ("Submit"):
                        bugs.setStatus("待解决");
                        break;
                }
                bugs.setCreator(curUser.getDisplayName());
                bugs.setCreateDate(DateUtils.getCurDateTime2Minute());
                bugs.setResponsible_person((String) data.get("responsible_person"));
                bugs.setProject((String) data.get("project"));
                bugs.setDescription((String) data.get("description"));
                try {
                    bugs.setModule((String) data.get("module"));
                } catch (NullPointerException e2) {
                    e2.printStackTrace();
                }
            } else {
                bugs = bugsRepository.getBugsInfoById(id);
                List<HashMap<String, Object>> recordList;
                if(JsonUtil.fromJsonToList(bugs.getRecord())!=null){
                recordList = JsonUtil.fromJsonToList(bugs.getRecord());
                }else{
                    recordList = new ArrayList<>();
                }
                Map<String, Object> lastRecord;
                if (recordList != null && recordList.size() > 0) {
                    lastRecord = recordList.get(recordList.size() - 1);
                } else {
                    lastRecord = new HashMap<>();
                }
                switch (status) {
                    case ("Test"):
                        bugs.setStatus("待回测");
                        HashMap<String, Object> recordMap = new HashMap<>();
                        recordMap.put("operator", curUser.getDisplayName());
                        recordMap.put("operate_time", DateUtils.getCurDateTime2Minute());
                        recordMap.put("status_code", "待回测");
                        recordMap.put("remarks", data.get("remarks"));
                        recordList.add(recordMap);
                        break;
                    case ("Confirm"):
                        bugs.setStatus("已解决");
                        lastRecord.put("status_code", "已解决");
                        break;
                    case ("notConfirm"):
                        bugs.setStatus("待解决");
                        lastRecord.put("status_code", "未解决");
                        break;
                }
                bugs.setRecord(JsonUtil.toJson(recordList));
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            bugs = new Bugs();
            if (status.equals("Save")) {
                bugs.setStatus("草稿");
            } else {
                bugs.setStatus("待解决");
            }
            bugs.setCreator(curUser.getDisplayName());
            bugs.setCreateDate(DateUtils.getCurDateTime2Minute());
            bugs.setResponsible_person((String) data.get("responsible_person"));
            bugs.setProject((String) data.get("project"));
            bugs.setDescription((String) data.get("description"));
            try {
                bugs.setModule(((List) data.get("module")).get(0).toString());
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        bugsRepository.save(bugs);
    }

    @RequestMapping(value = "/getDicByBusinessType")
    @ResponseBody
    public List getDicByBusinessType() {
        return commonDicRepositoryExtends.getDicByBusinessType("bug_status");
    }


    @RequestMapping(value = "/getBugsOprInfoById/{id}")
    @ResponseBody
    public List getBugsOprInfoById(@PathVariable Integer id) {
        return bugsRepositoryExtends.getBugsOprInfoById(id);
    }

    @RequestMapping(value = "/getDeptAndEmployee")
    @ResponseBody
    public Map getDeptAndEmployee() {
        Map employee = employeeFeignClient.getEmployeeList((new HashMap()).toString(), 10000, 1, new TcUser());
        return employee;
    }

    @RequestMapping(value = "/getProject")
    @ResponseBody
    public Map getProject() {
        Map project = projectFeignClient.queryProjectList((new HashMap()).toString(), 10000, 1);
        return project;
    }

    @RequestMapping(value = "/getModuleByProjectId/{projectId}")
    @ResponseBody
    public List getModuleByProjectId(@PathVariable Integer projectId) {
        List list = projModuleFeignClient.choseProjModule(projectId);
        return list;
    }
    @RequestMapping(value = "/getEmployeeIdListByPid/{projectId}")
    @ResponseBody
    public List getEmployeeIdListByPid(@PathVariable Integer projectId) {
        List list = projectFeignClient.getEmployeeIdListByPid(projectId);
        return list;
    }


}
