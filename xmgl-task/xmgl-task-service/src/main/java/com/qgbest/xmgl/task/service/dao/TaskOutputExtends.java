package com.qgbest.xmgl.task.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by wangchao on 2017/10/19.
 */
@Repository
public class TaskOutputExtends {
    @Autowired
    private CommonDao commonDao;

    public List getTaskOutputList(Integer taskId) {

        String sql = "";
        if (StringUtils.isNotBlankOrNull(taskId)) {
            sql += "Select a.id,a.task_id, a.doc_name, a.output_category as output_category_code, b.data_name as output_category, a.order_num, a.output_type as output_type_code, c.data_name as output_type, a.output_desc " +
                    " from task_output a " +
                    " LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'output_category') b ON a.output_category = b.data_code " +
                    " LEFT JOIN ( SELECT data_name,data_code FROM d_common_dic WHERE business_type = 'output_type') c ON a.output_type = c.data_code " +
                    " WHERE 1 = 1 AND a.task_id = '" + taskId + "'";

        }
        List list = commonDao.getSql(sql);
        System.out.println("===TaskOutputList===" + list);
        return list;
    }
}
