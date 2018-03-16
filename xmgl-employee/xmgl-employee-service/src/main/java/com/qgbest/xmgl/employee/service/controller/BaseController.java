package com.qgbest.xmgl.employee.service.controller;

import com.qgbest.xmgl.common.utils.PageControl;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by xw on 2017-03-24.
 */
@RestController
public class BaseController {
    /**
     *转换查询结果
     * @param pc
     * @return
     */
    protected HashMap getQueryMap(PageControl pc)  {
        HashMap jsonData = new HashMap<String, String>();
        jsonData.put("total", pc.getTotalitem());
        jsonData.put("rows", pc.getList());
        Map pagination = new HashMap();
        pagination.put("pageSize", pc.getPagesize());
        pagination.put("pageNumber", pc.getNextpage());
        jsonData.put("pagination", pagination);
        return jsonData;
    }
}