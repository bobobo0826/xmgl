package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.service.dao.TaskProcessExtends;
import com.qgbest.xmgl.task.service.dao.TaskProcessRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by lfm on 2017/10/25.
 */
@RestController
@Transactional
public class TaskProcessController extends BaseController{

    @Autowired
    private UserFeignClient userFeignClient;
    @Autowired
    private TaskProcessRepository taskProcessRepository;
    @Autowired
    private TaskProcessExtends taskProcessExtends;

    @PostMapping(value = "/getTaskProcessList")
    public PageControl getTaskProcessList(HttpServletRequest request) {
        Map queryMap = getRequestPayload(request);
        System.out.println("queryMap");
        System.out.println(queryMap);
        Map queryOptions = new HashMap();
        if (StringUtils.isNotBlankOrNull(queryMap.get("queryOptions"))) {
            queryOptions = (Map) queryMap.get("queryOptions");
        }
        Integer cpage = 1;
        Integer len = 1000;
        if (StringUtils.isNotBlankOrNull(queryMap.get("page"))) {
            cpage = ((Double) queryMap.get("page")).intValue();
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("pageSize"))) {
            len = ((Double) queryMap.get("pageSize")).intValue();
        }
        TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
        PageControl pc = taskProcessExtends.findTaskProcessList(queryOptions,cpage,len,curUser);
        System.out.println(pc);
        return pc;
    }

    @PostMapping(value = "/deleteTaskProcessList")
    public Map deleteTaskProcessList(HttpServletRequest request){
        Map dataMap = getRequestPayload(request);
        Map map = new HashMap();
        if(StringUtils.isNotBlankOrNull(dataMap.get("id"))) {
            Integer id  = ((Double)dataMap.get("id")).intValue();
            taskProcessRepository.delTaskProcess(id);
            map.put("success",true);
        }
        else
        {
            map.put("success",false);
        }
        return map;
    }


}
