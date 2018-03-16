package com.qgbest.xmgl.worklog.service.dao;

import com.qgbest.xmgl.common.service.utils.CommonDao;
import com.qgbest.xmgl.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by wangchao on 2017-07-18.
 */
@Repository
public class MessageExtend {
    @Autowired
    private CommonDao commonDao;

    public List getMessageList(Map queryMap) {
        String sql = "";
        sql += "select a.id, a.business_type, b.data_name as business_name, a.message_type, a.business_id, a.is_checked, a.remind_time, a.check_time, a.remind_title, a.remind_content, a.sender_id, a.receiver_id, a.comment_id, a.sender, a.receiver, a.sender_head_photo, a.log_date " +
                "from hd_message_base a " +
                "left join d_common_dic b on a.business_type = b.data_code where 1 = 1 ";
        if (StringUtils.isNotBlankOrNull(queryMap.get("is_checked"))) {
            sql += " and a.is_checked = '" + queryMap.get("is_checked") + "'";
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("receiver_id"))) {
            sql += " and a.receiver_id = " + queryMap.get("receiver_id");
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("sender_id"))) {
            sql += " and a.sender_id = " + queryMap.get("sender_id");
        }
        if (StringUtils.isNotBlankOrNull(queryMap.get("messageType"))) {
            sql += " and a.message_type = '" + queryMap.get("messageType") + "'";
        }

        sql += " ORDER BY a.remind_time DESC";
        List list = commonDao.getSql(sql);
        return list;
    }

    /**
     * 更改消息查看状态
     *
     * @param queryMap
     * @return
     */
    public void checkMessage(Map queryMap) {
        String sql = "";
        if (StringUtils.isNotBlankOrNull(queryMap.get("checkType")) && queryMap.get("checkType").equals("markAllMessage")) {
            //全部标为已读
            sql = String.format("update hd_message_base set is_checked = '1', check_time = '%s' where receiver_id = %s and is_checked = '0'", queryMap.get("check_time"), queryMap.get("receiver_id"));

        } else {
            //单个点击后标为已读
            sql = String.format("update hd_message_base set is_checked = '1', check_time = '%s' where id = %s", queryMap.get("check_time"), queryMap.get("id"));
        }
        commonDao.updateBySql(sql);
    }

}
