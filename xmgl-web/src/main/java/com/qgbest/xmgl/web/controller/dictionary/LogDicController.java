package com.qgbest.xmgl.web.controller.dictionary;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.api.entity.Dictionary;
import com.qgbest.xmgl.web.controller.BaseController;
import com.qgbest.xmgl.worklog.api.entity.ReturnMsg;
import com.qgbest.xmgl.worklog.client.LogDicFeignClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * Created by ccr on 2017/8/10.
 */
@Controller
@RequestMapping(value = "/manage/dictionary")
public class LogDicController extends BaseController{
    public static final Logger logger = LoggerFactory.getLogger(LogDicController.class);
    @Autowired
    private LogDicFeignClient logDicFeignClient;
    /**
     * 初始化页面
     * @return
     */
    @RequestMapping(value = "/initLogDicList")
    public ModelAndView initLogDicList(){
        Map model = new HashMap();
        HashMap<String,String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/dictionary/worklog/LogDicList",model);
    }
    /**get
     * 获取数据库列表数据
     * @return
     */
    @RequestMapping(value = "/queryLogDictionaryList")
    @ResponseBody
    public Map queryLogDictionaryList() {
        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = logDicFeignClient.queryLogDictionaryList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }
    /**
     * 初始化项目详情页面
     * @return
     */
    @RequestMapping(value = "/initLogDictionaryInfo/{id}")
    public ModelAndView initDictionaryInfo(@PathVariable Integer id) {
        Map model = new HashMap();
        model.put("id",id);
        return new ModelAndView("/dictionary/worklog/LogDicInfo",model);
    }
    /**
     * 获取字典详情
     * @return
     */
    @RequestMapping(value = "/getLogDictionaryInfoById/{newId}")
    @ResponseBody
    public Map getLogDictionaryInfoById(@PathVariable Integer newId){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        Integer id=Integer.valueOf(String.valueOf(newId));
        Dictionary dictionary = null;
        if (id!=0){
            try{
                dictionary=logDicFeignClient.getLogDictionaryInfoById(id);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            dictionary = new Dictionary();
        }
        model.put("dictionary",dictionary);
        return model;
    }
    /**
     * 启用字典
     */
    @RequestMapping(value = "/startLogDictionaryById/{id}")
    @ResponseBody
    public ReturnMsg startLogDictionaryById(@PathVariable ("id") Integer id){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer ID = Integer.valueOf(String.valueOf(id));
        ReturnMsg returnMsg = logDicFeignClient.startLogDictionaryById(ID);
        return returnMsg;
    }
    /**
     * 禁用字典
     */
    @RequestMapping(value = "/forbiddenLogDictionaryById/{id}")
    @ResponseBody
    public ReturnMsg forbiddenLogDictionaryById(@PathVariable ("id") Integer id){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer ID = Integer.valueOf(String.valueOf(id));
        ReturnMsg returnMsg = logDicFeignClient.forbiddenLogDictionaryById(ID);
        return returnMsg;
    }

    /**
     * 删除文件信息
     * @return
     */
    @RequestMapping(value = "/delLogDictionaryInfoById/{id}")
    @ResponseBody
    public ReturnMsg delLogDictionaryInfoById(@PathVariable ("id")Integer id){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Integer ID=Integer.valueOf(String.valueOf(id));
        System.out.println("======"+ID);
        ReturnMsg returnMsg = logDicFeignClient.delLogDictionaryInfoById(ID);
        return returnMsg;
    }
    /**
     * 保存信息
     * @return
     */
    @RequestMapping(value = "/saveLogDictionary",method = RequestMethod.PUT)
    @ResponseBody
    public ReturnMsg aveDriver(@ModelAttribute Dictionary dictionary)  {
        ReturnMsg returnMsg = logDicFeignClient.saveLogDictionary(dictionary);
        //ReturnMsg  returnMsg =logDicFeignClient.saveLogDictionary(logDictionary);
        return returnMsg;
    }
    /**
     * 字典类型列表
     * @return
     *
     */
    @RequestMapping (value = "/getLogBusinessTypeList")
    @ResponseBody
    public Map getBusinessTypeList() {
        Map model =new HashMap();
        List businessTypeList= logDicFeignClient.getBusinessTypeList();
        model.put("businessTypeList", businessTypeList);
        return model;
    }


}


