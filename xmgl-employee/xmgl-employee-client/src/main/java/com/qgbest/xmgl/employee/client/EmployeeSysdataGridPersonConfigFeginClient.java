package com.qgbest.xmgl.employee.client;


import com.qgbest.xmgl.employee.api.constants.ServiceConstants;
import com.qgbest.xmgl.employee.api.constants.SysdataGridPersonConfigServiceHTTPConstants;
import com.qgbest.xmgl.employee.api.entity.ReturnMsg;
import com.qgbest.xmgl.employee.api.entity.SysdataGridPersonConfig;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by xw on 2017/6/19.
 * 个人datagrid样式管理client
 */
@FeignClient(name = ServiceConstants.ServiceName)
public interface EmployeeSysdataGridPersonConfigFeginClient {

    /**
     * 获取个人datagrid样式
     * @param id
     * @return
     */
    @RequestMapping(value = SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getConfVal,method = RequestMethod.GET)
    public List getConfVal(@RequestParam("id") Integer id) ;

    /**
     * 获取个人datagrid样式
     * @param userId
     * @return
     */
    @RequestMapping(value = SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_getconfvalByIdAndCode,method = RequestMethod.GET)
    public SysdataGridPersonConfig getConfvalByIdAndCode(@RequestParam("userId") Integer userId, @RequestParam("modelCode") String modelCode) ;

    /**
     * 保存个人datagrid样式
     * @param gridStyle
     * @param curModuleCode
     * @param userId
     * @param userName
     * @return
     */
    @RequestMapping(value = SysdataGridPersonConfigServiceHTTPConstants.RequestMapping_savePersonGridStyle,method = RequestMethod.PUT)
    public ReturnMsg savePersonGridStyle(@RequestParam("gridStyle") String gridStyle, @RequestParam("curModuleCode") String curModuleCode, @RequestParam("userId") Integer userId, @RequestParam("userName") String userName) ;

}
