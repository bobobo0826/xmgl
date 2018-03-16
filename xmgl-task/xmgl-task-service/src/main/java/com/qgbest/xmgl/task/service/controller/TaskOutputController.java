package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.api.entity.OutputProcess;
import com.qgbest.xmgl.task.api.entity.TaskOutput;
import com.qgbest.xmgl.task.service.dao.OutputProcessRepository;
import com.qgbest.xmgl.task.service.dao.TaskOutputExtends;
import com.qgbest.xmgl.task.service.dao.TaskOutputRepository;
import com.qgbest.xmgl.task.service.service.OutputProcessService;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017/10/19.
 */
@RestController
@Transactional
public class TaskOutputController extends BaseController {
    @Autowired
    private TaskOutputExtends taskOutputExtends;
    @Autowired
    private TaskOutputRepository taskOutputRepository;
    @Autowired
    private OutputProcessService outputProcessService;
    @Autowired
    private UserFeignClient userFeignClient;

    @RequestMapping(value = "/getTaskOutputList/{taskId}", method = RequestMethod.GET)
    public List getTaskOutputList(@PathVariable("taskId") Integer taskId) {
        return taskOutputExtends.getTaskOutputList(taskId);
    }

    @RequestMapping(value = "/getTaskOutputById/{id}", method = RequestMethod.GET)
    public TaskOutput getTaskOutputById(@PathVariable("id") Integer id) {
        return taskOutputRepository.getTaskOutputById(id);
    }

    @RequestMapping(value = "/delOutputById", method = RequestMethod.DELETE)
    public Map delOutputById(HttpServletRequest request) {
        Map msgMap = new HashMap();
        Map reqMap = getRequestPayload(request);
        if (reqMap != null && StringUtils.isNotBlankOrNull(reqMap.get("id"))) {
            Integer id = ((Double) reqMap.get("id")).intValue();
            String process_status = reqMap.get("taskStatus") + "";
            TaskOutput taskOutput = taskOutputRepository.getTaskOutputById(id);
            TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
            outputProcessService.saveOutputProcess(taskOutput, process_status, OutputProcessService.Operate.delete, curUser);
            try {
                taskOutputRepository.delTaskOutput(id);
                msgMap.put("success", true);
            } catch (Exception e) {
                msgMap.put("success", false);
                e.printStackTrace();
            }
        }
        return msgMap;
    }

    @RequestMapping(value = "/saveTaskOutput", method = RequestMethod.POST)
    @ResponseBody
    public Map saveTaskOutput(HttpServletRequest request) {
        Map reqMap = getRequestPayload(request);
        if (reqMap!=null&&StringUtils.isNotBlankOrNull(reqMap.get("dataToSave"))) {
            TcUser curUser = userFeignClient.getCurUser(request.getHeader("token"));
            String process_status = reqMap.get("taskStatus")+"";
            TaskOutput taskOutput = JsonUtil.fromJson(JsonUtil.toJson(reqMap.get("dataToSave")), TaskOutput.class);
            if(taskOutput.getId()!=null){
                TaskOutput oldTaskOutput = taskOutputRepository.getTaskOutputById(taskOutput.getId());
                //更新（修改） 此处equals()已重写，比较表中字段值
                if (!taskOutput.equals(oldTaskOutput)) {
                    taskOutputRepository.save(taskOutput);
                    outputProcessService.saveOutputProcess(taskOutput, process_status, OutputProcessService.Operate.update, curUser);
                }
            }else{
                //新增时，必须先保存taskOutput，使其id不为null
                taskOutputRepository.save(taskOutput);
                outputProcessService.saveOutputProcess(taskOutput, process_status, OutputProcessService.Operate.add, curUser);
            }

        }
        Map retMap = new HashMap();
        retMap.put("success", true);
        return retMap;
    }
}
