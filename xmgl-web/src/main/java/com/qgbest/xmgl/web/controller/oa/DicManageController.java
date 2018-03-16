package com.qgbest.xmgl.web.controller.oa;

import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.oa.api.entity.MaDictionary;
import com.qgbest.xmgl.oa.api.entity.ReturnMsg;
import com.qgbest.xmgl.web.controller.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import com.qgbest.xmgl.oa.client.MaterialDicFeignClient;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ccr on 2017/8/23.
 */

@Controller
@RequestMapping(value = "/manage/materials")
public class DicManageController extends BaseController {
    @Autowired
    private MaterialDicFeignClient materialDicFeignClient;
    /**
     * 初始化物品字典列表
     * @return
     */
    @RequestMapping(value = "/initDicManager")
    public ModelAndView initDicManager(){
        Map model = new HashMap();
        HashMap<String,String> queryMap = getRequestMapStr2Str(httpServletRequest);
        model.put("_curModuleCode",queryMap.get("_curModuleCode"));
        return new ModelAndView("/oa/oaDicList",model);
    }

    /**get
     * 查询
     * @return
     */
    @RequestMapping(value = "/queryDictionaryList")
    @ResponseBody
    public Map queryDictionaryList() {
        Map queryMap = getRequestMapStr2StrWithQuery(httpServletRequest);
        Map map = materialDicFeignClient.queryDictionaryList(JsonUtil.toJson(queryMap), len, cpage);
        return map;

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
        ReturnMsg returnMsg = materialDicFeignClient.delDictionaryInfoById(ID);
        return returnMsg;
    }

    /**
     * 初始化项目详情页面
     * @return
     */
    @RequestMapping(value = "/initDictionaryInfo/{id}/{count}")
    public ModelAndView initDictionaryInfo(@PathVariable ("id")Integer id ,@PathVariable("count") Integer count) {
        Map model = new HashMap();
        model.put("id",id);
        model.put("count",count);
        return new ModelAndView("/oa/oaDicInfo",model);

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
        MaDictionary maDictionary = null;
        if (id!=0){
            try{
                maDictionary=materialDicFeignClient.getDictionaryInfoById(id);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            maDictionary = new MaDictionary();
        }
        model.put("maDictionary",maDictionary);
        return model;


    }
    /**
     * 保存信息
     * @return
     */
    @RequestMapping(value = "/saveDictionary",method = RequestMethod.PUT)
    @ResponseBody
    public ReturnMsg saveDictionary(@ModelAttribute MaDictionary maDictionary)  {
        ReturnMsg  returnMsg =materialDicFeignClient.saveDictionary(maDictionary);
        return returnMsg;
    }


}