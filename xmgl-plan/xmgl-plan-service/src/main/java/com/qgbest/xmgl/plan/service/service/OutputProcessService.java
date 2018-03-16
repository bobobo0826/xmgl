package com.qgbest.xmgl.plan.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.plan.service.dao.OutputProcessRepository;
import com.qgbest.xmgl.plan.api.entity.OutputProcess;
import com.qgbest.xmgl.plan.api.entity.PlanOutput;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by wangchao on 2017/10/12.
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
     * 计划输出过程的change_info字段暂闲置不用
     */
    public void saveOutputProcess(PlanOutput planOutput, String process_status, Operate process_opr, TcUser curUser) {

        if (planOutput != null) {
            OutputProcess outputProcess = setOutputProcess(planOutput, process_status, process_opr, curUser);
            outputProcessRepository.save(outputProcess);
        }

    }


    public OutputProcess setOutputProcess(PlanOutput planOutput, String process_status, Operate process_opr, TcUser curUser) {
        OutputProcess outputProcess = new OutputProcess();
        if (planOutput != null) {
            //PlanOutput中有的字段
            outputProcess.setOutput_id(planOutput.getId());
            outputProcess.setPlan_id(planOutput.getPlan_id());
            outputProcess.setOutput_category(planOutput.getOutput_category());
            outputProcess.setOrder_num(planOutput.getOrder_num());
            outputProcess.setOutput_type(planOutput.getOutput_type());
            outputProcess.setDoc_name(planOutput.getDoc_name());
            outputProcess.setOutput_desc(planOutput.getOutput_desc());
            //OutputProcess独有字段
            outputProcess.setOperator_id(curUser.getId());
            outputProcess.setOperator(curUser.getDisplayName());
            outputProcess.setRecord_time(DateUtils.getCurDateTime2Minute());
            outputProcess.setProcess_status(process_status);
            outputProcess.setProcess_opr(process_opr+"");

        }
        return outputProcess;
    }


}
