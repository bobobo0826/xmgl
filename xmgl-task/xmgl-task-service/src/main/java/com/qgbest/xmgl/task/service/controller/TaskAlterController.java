package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.api.entity.Task;
import com.qgbest.xmgl.task.api.entity.TaskAlter;
import com.qgbest.xmgl.task.api.entity.TaskTemp;
import com.qgbest.xmgl.task.service.dao.TaskAlterExtends;
import com.qgbest.xmgl.task.service.dao.TaskAlterRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wjy
 * Date:2017/10/18
 * Time:14:40
 * description:xmgl-serve
 */

@RestController
@Transactional
public class TaskAlterController extends BaseController{
    @Autowired
    private TaskAlterExtends taskAlterExtends;
    @Autowired
    private TaskAlterRepository taskAlterRepository;
    @PostMapping(value = "/getTaskAlterList")
    public PageControl getTaskAlterList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        System.out.println("++++++request+++++"+queryMap);
        Map queryOptions = new HashMap();

        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))){
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("page"))){
            cpage = ((Double) queryMap.get("page")).intValue();
        }
        if(StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))){
            len = ((Double) queryMap.get("pageSize")).intValue();
        }

        PageControl pc = taskAlterExtends.getTaskAlterList(queryOptions,cpage,len,getCurUser());
        return pc;
    }
    @RequestMapping(value = "/getTaskAlterInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public TaskAlter getTaskAlterInfoById(@PathVariable Integer id) {
        TaskAlter taskAlter = new TaskAlter();
        taskAlter = this.taskAlterRepository.getTaskAlterInfoById(id);
        return taskAlter;
    }


}
