package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.task.api.entity.OutputProcess;
import com.qgbest.xmgl.task.api.entity.TaskOutput;
import com.qgbest.xmgl.task.service.dao.OutputProcessRepository;
import com.qgbest.xmgl.task.service.dao.TaskOutputRepository;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;


/**
 * Created by wangchao on 2017/10/13.
 */
@Service
@Transactional
public class OutputProcessService {
    @Autowired
    private OutputProcessRepository outputProcessRepository;

    public enum Operate{
        add,
        update,
        delete
    }


    /**
     * 在保存之后调用
     * 任务输出过程的change_info字段暂闲置不用
     */
    public void saveOutputProcess(TaskOutput taskOutput, String process_status, Operate process_opr, TcUser curUser) {

        if (taskOutput != null) {
            OutputProcess outputProcess = setOutputProcess(taskOutput, process_status, process_opr, curUser);
            outputProcessRepository.save(outputProcess);
        }

    }


    public OutputProcess setOutputProcess(TaskOutput taskOutput, String process_status, Operate process_opr, TcUser curUser) {
        OutputProcess outputProcess = new OutputProcess();
        if (taskOutput != null) {
            //taskOutput中有的字段
            outputProcess.setOutput_id(taskOutput.getId());
            outputProcess.setTask_id(taskOutput.getTask_id());
            outputProcess.setOutput_category(taskOutput.getOutput_category());
            outputProcess.setOrder_num(taskOutput.getOrder_num());
            outputProcess.setOutput_type(taskOutput.getOutput_type());
            outputProcess.setDoc_name(taskOutput.getDoc_name());
            outputProcess.setOutput_desc(taskOutput.getOutput_desc());
            //outputProcess独有字段
            outputProcess.setOperator_id(curUser.getId());
            outputProcess.setOperator(curUser.getDisplayName());
            outputProcess.setRecord_time(DateUtils.getCurDateTime2Minute());
            outputProcess.setProcess_status(process_status);
            outputProcess.setProcess_opr(process_opr+"");

        }
        return outputProcess;
    }

    public void removeItemById(List list, Integer id) {
        if (list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                Map map = (Map) list.get(i);
                if (map.get("id").equals(id)) {
                    list.remove(i);
                }
            }
        }
    }
}
