package com.qgbest.xmgl.task.service.controller;


import org.springframework.web.bind.annotation.RestController;
import com.qgbest.xmgl.common.utils.CharsetUtil;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.common.utils.PageControl;
import com.qgbest.xmgl.user.api.entity.TcUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;


import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by qianmeng on 2017-03-24.
 */
@Controller
public class BaseController {

    @Autowired
    protected HttpServletRequest httpServletRequest;



    /**
     * 列排序字段名称
     */
    protected String sortField;
    /**
     * 排序类型（DESC / ASC）
     */
    protected String sortOrder;


    /**
     * 当前页码
     */
    protected int cpage = 1;
    /**
     * 分页，每页显示条数
     */
    protected Integer len = 20;

    protected TcUser getCurUser() {
        TcUser curUser = (TcUser) httpServletRequest.getSession().getAttribute("curUser");
        return curUser;
    }

    /**
     * 获取请求属性封装为Map类型
     *
     * @param request
     * @return
     */
    protected HashMap<String, Object> getRequestMap(HttpServletRequest request) {
        HashMap<String, Object> conditions = new HashMap<String, Object>();
        Map map = request.getParameterMap();
        for (Object o : map.keySet()) {
            String key = (String) o;
            conditions.put(key, ((String[]) map.get(key))[0]);
        }
        return conditions;
    }

    /**
     * 获取请求属性封装为Map类型
     *
     * @param request
     * @return
     */
    protected HashMap<String, String> getRequestMapStr2Str(HttpServletRequest request) {
        HashMap<String, String> conditions = new HashMap<String, String>();
        Map map = request.getParameterMap();
        for (Object o : map.keySet()) {
            String key = (String) o;
            conditions.put(key, ((String[]) map.get(key))[0]);
        }
        CharsetUtil.filterCharset(conditions);

        return conditions;
    }

    /**
     * 获取请求属性封装为Map类型并赋值分页参数
     *
     * @param request
     * @return
     */
    protected HashMap<String, String> getRequestMapStr2StrWithQuery(HttpServletRequest request) {
        HashMap<String, String> conditions = new HashMap<String, String>();
        Map map = request.getParameterMap();
        for (Object o : map.keySet()) {
            String key = (String) o;
            conditions.put(key, ((String[]) map.get(key))[0]);
        }
        CharsetUtil.filterCharset(conditions);
        if (conditions.get("cpage") != null) {
            cpage = Integer.valueOf(String.valueOf(conditions.get("cpage")));
        }
        if (conditions.get("len") != null) {
            len = Integer.valueOf(String.valueOf(conditions.get("len")));
        }
        return conditions;
    }

    protected Map getRequestPayload(HttpServletRequest req) {
        StringBuilder sb = new StringBuilder();
        try(BufferedReader reader = req.getReader()) {
            char[]buff = new char[1024];
            int len;
            while((len = reader.read(buff)) != -1) {
                sb.append(buff,0, len);
            }
        }catch (IOException e) {
            e.printStackTrace();
        }
        return JsonUtil.fromJson(sb.toString(),Map.class);
    }
    /**
     * 获取每页的长度
     *
     * @param condtionMap
     * @return
     */
    protected Integer getLen(Map condtionMap) {
        Integer len = 1;
        if (condtionMap.get("len") != null) {
            len = Integer.valueOf(String.valueOf(condtionMap.get("len")));
        } else {
            len = 20;
        }
        return len;
    }

    /**
     * 获取页数
     *
     * @param condtionMap
     * @return
     */
    protected Integer getCpage(Map condtionMap) {
        Integer len = 1;
        if (condtionMap.get("cpage") != null) {
            cpage = Integer.valueOf(String.valueOf(condtionMap.get("cpage")));

            return len;
        } else {
            return 1;
        }
    }


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

