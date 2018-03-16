package com.qgbest.xmgl.task.client;

import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.constants.SysDatagridDefaultConfigServiceHTTPConstants;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by quangao on 2017/5/18.
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface TaskSysdataGridDefaultConfigFeginClient {

    /**
     * 获取datagrid样式
     * @param modelCode
     * @return
     */
    @RequestMapping(value = SysDatagridDefaultConfigServiceHTTPConstants.RequestMapping_getSysdataDefaultConfVal,method = RequestMethod.GET)
    public List getConfVal(@RequestParam("modelCode") String modelCode) ;






}
