package com.qgbest.xmgl.web.controller.writingStandards;


import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.task.api.entity.ReturnMsg;
import com.qgbest.xmgl.task.api.entity.WritingStandards;
import com.qgbest.xmgl.task.client.StandardsFeignClient;
import com.qgbest.xmgl.user.client.UserFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by fcy on 2017/8/8.
 */
@Controller
@RequestMapping(value = "/manage/writingStandards")
public class StandardsController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(StandardsController.class);
    @Autowired
    private StandardsFeignClient standardsFeignClient;
    @Autowired
    private UserFeignClient userFeignClient;
    /**
     * 初始化规范列表
     * @return
     */

    @RequestMapping(value = "/initStandardsList")
    public String standardsQueryList() {
        logger.info("初始化规范列表界面");
        return "/writingStandards/standardsList";
    }
    @RequestMapping(value = "/initStandards")
    public String standardsShow() {
        logger.info("初始化规范展示界面");
        return "/writingStandards/standardsShow";
    }

    @RequestMapping(value = "/queryStandardsList")
    @ResponseBody
    public List queryStandardsList(HttpServletRequest request){
        logger.info("获取规范列表信息");
        //String roleCodes = userFeignClient.getRoleColesByUserId(getCurUser().getId());
        System.out.print("==========="+request.getParameter("_id"));
        List list = standardsFeignClient.getStandardsList(request.getParameter("_id"));
        return list;
    }

    @RequestMapping(value = "/queryStandardsShowList")
    @ResponseBody
    public List queryStandardsShowList(HttpServletRequest request){
        logger.info("获取规范列表展示信息");

        System.out.print("==========="+request.getParameter("_id"));
        List list = standardsFeignClient.getStandardsShowList(request.getParameter("_id"));
        return list;
    }
    /**
     * 获取规范信息在页面
     * @return
     */
    @RequestMapping (value = "/getStandardsPage")
    @ResponseBody
    public Map getStandardsPage() {
        logger.info("规范页面");
        Map model =new HashMap();
        List StandardsList= standardsFeignClient.getStandardsPage();
        model.put("StandardsList", StandardsList);
        return model;

    }
    @RequestMapping(value = "/standardsInfoIndex")
    public String standardsInfoIndex(ModelMap modelMap, HttpServletRequest request) {
        logger.info("初始化规范详细信息界面");
        modelMap.addAttribute("_id",request.getParameter("_id"));
        modelMap.addAttribute("_parentId",request.getParameter("_parentId"));
        return "/writingStandards/standardsInfo";
    }

    @RequestMapping(value="/getStandardsInfo",produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map getStandardsInfo(HttpServletRequest request){
        logger.info("获取规范详细信息");
        Map map = new HashMap();
        WritingStandards model = null;
        if (StringUtils.isNotBlankOrNull(request.getParameter("_id"))){
            try{
                model=standardsFeignClient.getStandardsInfo(Integer.valueOf(request.getParameter("_id")));
            }catch (Exception e){
                e.printStackTrace();
            }
        }else{
            model = new WritingStandards();
            model.setParent_id(Integer.valueOf(request.getParameter("_parentId")));
            model.setCreate_date(DateUtils.getCurDateTime2Minute());
            model.setCreator(getCurUser().getDisplayName());
            model.setStatus("未发布");
        }
        map.put("standards",model);
        return map;
    }

    @RequestMapping(value = "/saveStandardsInfo",method = RequestMethod.POST,produces = "application/json;charset=utf-8")
    @ResponseBody
    public Map saveStandardsInfo(@ModelAttribute WritingStandards model) {
        Map map = new HashMap();

        if (model.getId() != null) {

            model.setModify_date(DateUtils.getCurDateTime2Minute());
            model.setModifier(getCurUser().getDisplayName());
        }
        WritingStandards writingStandards=standardsFeignClient.saveStandardsInfo(model);
        map.put("standards",writingStandards);
        map.put("msgCode","success");
        map.put("msgDesc","操作成功");
        return map;

    }

    @RequestMapping(value="/delStandardsInfo")
    @ResponseBody
    public Map delStandardsInfo(HttpServletRequest request){
        String id=request.getParameter("_id");
        Map map = standardsFeignClient.delStandardsInfo(id);
        return map;
    }
    @RequestMapping (value = "/publishStandards")
    @ResponseBody
    public ReturnMsg publishStandards(HttpServletRequest request) {
        logger.info("发布规范");
        String id=request.getParameter("_id");
        Integer id1 = Integer.valueOf(id);
        ReturnMsg returnMsg = standardsFeignClient.publishStandards(id1);
        return returnMsg;

    }

    @RequestMapping (value = "/unPublishStandards")
    @ResponseBody
    public ReturnMsg unPublishStandards(HttpServletRequest request) {
        logger.info("撤销规范");
        String id=request.getParameter("_id");
        Integer id1 = Integer.valueOf(id);
        ReturnMsg returnMsg = standardsFeignClient.unPublishStandards(id1);
        return returnMsg;

    }





}
