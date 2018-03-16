package com.qgbest.xmgl.task.service.controller;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.service.dao.EmailRepositoryExtends;

import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


/**
 * Created by wangchao on 2017/9/26.
 */
@RestController
@Transactional
public class EmailController extends BaseController {
    @Autowired
    private EmailRepositoryExtends emailRepositoryExtends;
    @Autowired
    private UserFeignClient userFeignClient;
    /**
     *根据templet_code选择模板，
     * 传入模板所需参数，
     * 组装邮件内容发送
     * */
    @RequestMapping(value = "/sendBusinessEmail")
    @ResponseBody
    public Map sendBusinessEmail(HttpServletRequest request,TcUser user) {
        Map map = new HashMap();
        Map queryMap = getRequestPayload(request);
        user = userFeignClient.getCurUser(request.getHeader("token"));
//        Map query = JsonUtil.fromJsonToMap(queryMap);
        System.out.println(queryMap);
        try {
            String result = emailRepositoryExtends.sendEmailByTemplet(queryMap,user);
            if(StringUtils.isNotBlankOrNull(result)){
                map=JsonUtil.fromJsonToMap(result);
            }
        }catch(UnsupportedEncodingException e){
            e.printStackTrace();
        }
        return map;
    }
    /**
     *邮件提醒按钮调用
     * 也可将该逻辑写于前台js，然后直接调用sendBusinessEmail（）方法
     * */
   /* @RequestMapping(value = "/taskRemind")
    @ResponseBody
    public String taskRemind(@RequestParam String queryMap) {
        Map query = JsonUtil.fromJsonToMap(queryMap);
        String result = "";
        if (StringUtils.isNotBlankOrNull(query.get("task_status"))) {
            if (query.get("task_status").equals("DTJ")) {
                //待承接时，调用承接任务通知模板
                query.put("templet_code","CJRWTZ");
                result = emailRepositoryExtends.sendEmailByTemplet(query);
            } else if (query.get("task_status").equals("JXZ")) {
                String curTime = DateUtils.getCurDateTime2Minute();
                SimpleDateFormat DateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                String taskEndTime = DateFormat.format(query.get("task_end_time"));
                if (curTime.compareTo(taskEndTime) <= 0) {
                    //期限内，调用任务到期提醒模板
                    query.put("templet_code","RWDQTX");
                } else {
                    //期限外，调用任务超时报警模板
                    query.put("templet_code","RWCSBJ_R");
                }
                result = emailRepositoryExtends.sendEmailByTemplet(query);
            }
        }
        return result;
    }
*/

}
