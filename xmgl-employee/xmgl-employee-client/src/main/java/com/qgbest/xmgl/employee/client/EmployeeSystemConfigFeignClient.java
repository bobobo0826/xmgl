package com.qgbest.xmgl.employee.client;

import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.constants.SystemConfigServiceHTTPConstants;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by xw on 2017/6/19.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface EmployeeSystemConfigFeignClient {

    /**
     * 通过code查询value
     * @return
     */
    @RequestMapping(value = SystemConfigServiceHTTPConstants.RequestMapping_getSyetemConfDataValue,method = RequestMethod.GET)
    public String getDataValue(@RequestParam("dataCode") String dataCode) ;



}
