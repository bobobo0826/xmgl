package com.qgbest.xmgl.employee.client;


import com.qgbest.xmgl.employee.api.constants.CommonDicServiceHTTPConstants;
import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface EmployeeDictionaryFeignClient {

    /**
     * 根据业务类型code和类型code获取name
     * @param businessCode
     * @return
     */
    @RequestMapping(value = CommonDicServiceHTTPConstants.RequestMapping_getDicListByBusinessCode,method = RequestMethod.GET)
    public List getDicListByBusinessCode(@RequestParam("businessCode") String businessCode) ;

    /**
     * 根据业务类型code和类型code获取name
     * @param businessCode
     * @return
     */
    @RequestMapping(value = CommonDicServiceHTTPConstants.RequestMapping_getDataNameByDataCode,method = RequestMethod.GET)
    public String getDataNameByDataCode(@RequestParam("businessCode") String businessCode, @RequestParam("dataCode") String dataCode) ;

}
