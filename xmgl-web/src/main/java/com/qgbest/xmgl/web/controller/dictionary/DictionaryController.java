package com.qgbest.xmgl.web.controller.dictionary;
        import com.qgbest.xmgl.common.utils.JsonUtil;
        import com.qgbest.xmgl.project.api.entity.ProjectBase;
        import com.qgbest.xmgl.project.api.entity.ReturnMsg;
        import com.qgbest.xmgl.project.api.entity.Dictionary;
        import com.qgbest.xmgl.project.client.DictionaryFeignClient;
        import com.qgbest.xmgl.web.controller.BaseController;
        import com.qgbest.xmgl.web.controller.project.ProjectController;
        import org.hibernate.loader.custom.Return;
        import org.slf4j.Logger;
        import org.slf4j.LoggerFactory;
        import org.springframework.web.servlet.ModelAndView;
        import org.springframework.beans.factory.annotation.Autowired;
        import org.springframework.web.bind.annotation.*;
        import java.util.HashMap;
        import org.springframework.stereotype.Controller;

        import java.util.List;
        import java.util.Map;
/**
 * Created by ccr on 2017/7/31.
 */
@Controller
@RequestMapping(value = "/manage/dictionary")
public class DictionaryController extends BaseController {
    public static final Logger lgger = LoggerFactory.getLogger(ProjectController.class);
    @Autowired
    private DictionaryFeignClient dictionaryFeignClient;

    /**
     * 初始化项目列表页面
     * @return
     */
    @RequestMapping(value = "/initDictionaryList")
    public ModelAndView initDictionaryList() {

        Map model = new HashMap();
        HashMap<String, String> queryMap=getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/dictionary/project/dicList", model);
    }
    /**
     * 初始化项目选择页面
     * @return
     */
    @RequestMapping(value = "/initSelectDictionaryList")
    public ModelAndView initSelectDictionaryList() {
        return new ModelAndView("/dictionary/selectDictionaryList", null);
    }

    /**get
     * 查询
     * @return
     */
    @RequestMapping(value = "/queryDictionaryList")
    @ResponseBody
    public Map queryDictionaryList() {
        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = dictionaryFeignClient.queryDictionaryList(JsonUtil.toJson(queryMap), len, cpage);
        return map;

    }
    /**
     * 启用字典
     */
    @RequestMapping(value = "/startDictionaryById/{id}")
    @ResponseBody
    public ReturnMsg startDictionaryById(@PathVariable ("id") Integer id){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer ID = Integer.valueOf(String.valueOf(id));
        ReturnMsg returnMsg = dictionaryFeignClient.startDictionaryById(ID);
        return returnMsg;
    }
    /**
     * 禁用字典
     */
    @RequestMapping(value = "/forbiddenDictionaryById/{id}")
    @ResponseBody
    public ReturnMsg forbiddenDictionaryById(@PathVariable ("id") Integer id){
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        Integer ID = Integer.valueOf(String.valueOf(id));
        ReturnMsg returnMsg = dictionaryFeignClient.forbiddenDictionaryById(ID);
        return returnMsg;
    }

    /**
     * 删除文件信息
     * @return
     */
    @RequestMapping(value = "/delDictionaryInfoById/{id}")
    @ResponseBody
    public ReturnMsg delDictionaryInfoById(@PathVariable ("id")Integer id){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Integer ID=Integer.valueOf(String.valueOf(id));
        ReturnMsg returnMsg = dictionaryFeignClient.delDictionaryInfoById(ID);
        return returnMsg;
    }

    /**
     * 初始化项目详情页面
     * @return
     */
    @RequestMapping(value = "/initDictionaryInfo/{id}")
    public ModelAndView initDictionaryInfo(@PathVariable Integer id) {

//        Map queryMap =getRequestMapStr2Str(httpServletRequest);
//        Map model =new HashMap();
//        model.put("id", queryMap.get("id"));
//        return new ModelAndView("/dictionary/dicInfo",model);
        Map model = new HashMap();
        model.put("id",id);
        return new ModelAndView("/dictionary/project/dicInfo",model);

    }

    /**
     * 获取字典详情
     * @return
     */
    @RequestMapping(value = "/getDictionaryInfoById/{newId}")
    @ResponseBody
    public Map getDictionaryInfoById(@PathVariable Integer newId){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        Integer id=Integer.valueOf(String.valueOf(newId));
        Dictionary dictionary = null;
        if (id!=0){
            try{
                dictionary=dictionaryFeignClient.getDictionaryInfoById(id);
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
     * 保存信息
     * @return
     */
    @RequestMapping(value = "/saveDictionary",method = RequestMethod.PUT)
    @ResponseBody
    public ReturnMsg saveDriver(@ModelAttribute Dictionary dictionary)  {
        /**
         * 修改情况下，更新修改人等
         */

        ReturnMsg  returnMsg =dictionaryFeignClient.saveDictionary(dictionary);
        return returnMsg;
    }
    /**
     * 字典类型列表
     * @return
     *
     */
    @RequestMapping (value = "/getBusinessTypeList")
    @ResponseBody
    public Map getBusinessTypeList() {
        Map model =new HashMap();
        List businessTypeList= dictionaryFeignClient.getBusinessTypeList();
        model.put("businessTypeList", businessTypeList);
        return model;
    }

    }



