package com.qgbest.xmgl.plan.service.controller;

import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.plan.service.dao.PlanAlterExtends;
import com.qgbest.xmgl.plan.service.dao.PlanAlterRepository;
import com.qgbest.xmgl.plan.api.entity.PlanAlter;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@Transactional
public class PlanAlterController extends BaseController{
    @Autowired
    private PlanAlterExtends planAlterExtends;
    @Autowired
    private PlanAlterRepository planAlterRepository;
    @Autowired
    private UserFeignClient userFeignClient;
    @PostMapping(value = "/getPlanAlterList")
    public PageControl getPlanAlterList(HttpServletRequest request) {
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
        TcUser user = userFeignClient.getCurUser(request.getHeader("token"));

        PageControl pc = planAlterExtends.getPlanAlterList(queryOptions,cpage,len,user);
        return pc;
    }
    @RequestMapping(value = "/getPlanAlterInfoById/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public PlanAlter getPlanAlterInfoById(@PathVariable Integer id) {
        PlanAlter planAlter = new PlanAlter();
        System.out.println("++++++++++++++++++++"+id);
        System.out.println("++++++++++++++++++++"+planAlter);
        planAlter = this.planAlterRepository.getPlanAlterInfoById(id);
        System.out.println("++++++66666666++++++"+planAlter);
        return planAlter;
    }
}
