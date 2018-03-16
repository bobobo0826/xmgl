package com.qgbest.xmgl.web.controller.user;

import com.qgbest.xmgl.common.utils.*;
import com.qgbest.xmgl.dept.api.entity.TcDept;
import com.qgbest.xmgl.dept.client.TDeptFeignClient;
import com.qgbest.xmgl.permission.api.entity.permission.*;
import com.qgbest.xmgl.permission.client.permission.IndexPageFeignClient;
import com.qgbest.xmgl.permission.client.permission.LoginRecordFeignClient;
import com.qgbest.xmgl.permission.client.permission.TSRoleFeignClient;
import com.qgbest.xmgl.user.api.entity.TcUser;
import com.qgbest.xmgl.user.client.UserFeignClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.net.*;

/**
 * Created by qm on 2017/03/03.
 */
@Controller
@RequestMapping(value = "/manage/user")
public class TUserController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(TUserController.class);
    @Autowired
    private UserFeignClient userFeignClient;
    @Autowired
    private LoginRecordFeignClient loginRecordFeignClient;
    @Autowired
    private TDeptFeignClient tDeptFeignClient;
    @Autowired
    private IndexPageFeignClient indexPageFeignClient;
    @Autowired
    private TSRoleFeignClient tsRoleFeignClient;
    @RequestMapping(value = "/registUser")
    public String registUser() {
        logger.info("进入注册用户信息页面");
        return "../../registUser";
    }
    @RequestMapping(value="/checkUser",method = RequestMethod.POST)
    @ResponseBody
    public String checkUser(@RequestParam("username") String username,@RequestParam("password") String password) throws IOException {
        logger.info("检查用户名和密码是否正确");
        Map map=new HashMap();
        try {
            password= MD5Util.MD5Encode(password);
            TcUser user=userFeignClient.checkUser(username, password);
            if (user==null) {
                map.put("result", "NO");
            }
            else{
				HttpSession session = httpServletRequest.getSession(true);
				session.setAttribute("curUser", user);
                map.put("result", "OK");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  JsonUtil.getJsonStrByObject(map);
    }

    @RequestMapping(value="/login")
    public String login(ModelMap modelMap,@RequestParam("subSys") String subSys) throws Exception {
        logger.info("用户登录");
        TcUser user = getCurUser();
        List<TsSysRoleMenuTree> roleMenus = new ArrayList<TsSysRoleMenuTree>();
        while(user.getId()==null){
            Thread.sleep(10);
        }
        String roleCodes = userFeignClient.getRoleColesByUserId(user.getId());
        List<Menu> menuList = indexPageFeignClient.showMenu(subSys,user.getId(),roleCodes);
        Map map = new HashMap();
        map.put("menus", menuList);
        modelMap.addAttribute("imageUrl",this.imageUrl);
        modelMap.addAttribute("menu", JsonUtil.getJsonStrByObject(map));
        modelMap.addAttribute("photo", getCurUser().getHeadPhoto());
        LoginRecord loginRecord = new LoginRecord();
        loginRecord.setUserId(user.getId());
        loginRecord.setUserName(user.getDisplayName());
        loginRecord.setRoleCode(user.getRoleCode());
        loginRecord.setRoleName(user.getRoleName());
        loginRecord.setDeptId(user.getDeptId());
        loginRecord.setDeptName(user.getDeptName());
        loginRecord.setLogin_time(DateUtils.getCurDateTime());
        String clientIP="";
        String ip = httpServletRequest.getHeader("X-Forwarded-For");
        if(StringUtils.isEmpty(ip)==false && !"unKnown".equalsIgnoreCase(ip)){
            //多次反向代理后会有多个ip值，第一个ip才是真实ip
            int index = ip.indexOf(",");
            if(index != -1){
                clientIP=ip.substring(0,index);
            }else{
                clientIP=ip;
            }
        }else{
            ip = httpServletRequest.getHeader("X-Real-IP");
            if(StringUtils.isEmpty(ip)==false && !"unKnown".equalsIgnoreCase(ip)){
                clientIP=ip;
            }else{
                clientIP=httpServletRequest.getRemoteAddr();
            }
        }
        loginRecord.setIp(clientIP);
        loginRecordFeignClient.saveLoginRecord(loginRecord);
        return "../index_new/index";
    }

    @RequestMapping(value="/initRegistInfo")
    public String initRegistInfo(ModelMap modelMap){
        logger.info("初始化用户注册页面");
        return "/user/registInfo";
    }

    @RequestMapping(value="/updatePassword")
    @ResponseBody
    public Map updatePassword() throws IOException {
        Map condition=httpServletRequest.getParameterMap();
        Map queryMap= JsonUtil.fromJsonToMap(JsonUtil.getJsonStrByObject(condition));
        queryMap = CharsetUtil.filterCharset(queryMap);
        logger.info("修改密码");
        String newPassword=String.valueOf(queryMap.get("_newPsw"));
        String inputPassword=String.valueOf(queryMap.get("_oldPsw"));
        Map map = new HashMap();
        TcUser user=getCurUser();
        String realPassword=user.getPsw();
        inputPassword=MD5Util.MD5Encode(inputPassword);
        if (realPassword.equals(inputPassword))
        {
            newPassword= MD5Util.MD5Encode(newPassword);
            user.setPsw(newPassword);
            try{
                TcUser newUser =  userFeignClient.saveUser(user);
                map.put("success",true);
                map.put("msg",newUser.getDisplayName()+"修改成功");
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        else {
            map.put("msg","原始密码错误，修改失败");
            map.put("success",false);
        }
       return map;
    }
    @RequestMapping(value="/doNext")
    public String doNext(){
        String userName=httpServletRequest.getParameter("userName");
        String password=httpServletRequest.getParameter("password");
        String userType=httpServletRequest.getParameter("userType");
        TcUser user=new TcUser();
        user.setUserName(userName);
        user.setPsw(password);
        if(userType.equals("user_gys"))
        {
            return "";
        }else if(userType.equals("user_nbzj"))
        {
            return "/expert/expertRegistInfo";
        }
        return "../index_new/index";
    }
    @RequestMapping(value="/doReturn")
    public String doReturn(){
        return "../index_new/index";
    }

    @RequestMapping(value="/initUserListUser")
    public String initUserListUser(){ return "/permission/userManager/userInfoTree";

    }

    @RequestMapping(value="/queryDeptListForTree",method = RequestMethod.POST)
    @ResponseBody
    public Map queryDeptListForTree() throws IOException {
        Map responseMap=new HashMap();
        List deptList=tDeptFeignClient.queryDeptListForTree(httpServletRequest.getParameter("_id"));
        for (int i = 0; i < deptList.size(); i++) {
            Map map = (Map) deptList.get(i);
            map.put("data_type", "dept");
        }
        responseMap.put("deptList",deptList);
        return responseMap;
    }

    @RequestMapping(value="/indexUserInforList")
    public String indexUserInforList(@RequestParam("_deptId") String deptId,ModelMap modelMap){
        modelMap.addAttribute("_deptId",deptId);
        return "/permission/userManager/userList";
    }

    @RequestMapping(value = "/queryUserList",method=RequestMethod.POST)
    @ResponseBody
    public Map queryUserList() throws IOException {
        HashMap queryMap=getRequestMapStr2StrWithQuery(httpServletRequest);
        if (!"-1".equals(queryMap.get("deptId"))){
            String userId = userFeignClient.getUserIdByDeptId(queryMap.get("deptId").toString());
            queryMap.put("userIds",userId);
        }
        Map map = userFeignClient.queryUserList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }

    @RequestMapping(value = "/resetPsw",method=RequestMethod.POST)
    @ResponseBody
    public Map resetPsw(){
        Map map = new HashMap();
        if(userFeignClient.resetPsw(Integer.valueOf(httpServletRequest.getParameter("id")))){
            map.put("success", true);
            map.put("msg", "重置成功");
        }else{
            map.put("success", false);
            map.put("msg", "重置失败");
        }
        return map;
    }

    @RequestMapping(value = "/delUserInfo",method=RequestMethod.POST)
    @ResponseBody
    public Map delUserInfo(@RequestParam("id") Integer id){
        Map map = new HashMap();
        if(userFeignClient.delUserInfo(id)){
            map.put("success", true);
            map.put("msg", "删除成功");
        }else{
            map.put("success", false);
            map.put("msg", "删除失败");
        }
        return map;
    }

    @RequestMapping(value = "/initaddUserInfo")
    public ModelAndView initaddUserInfo(ModelMap modelMap) {
        Map queryMap = getRequestMapStr2Str(httpServletRequest);
        System.out.print(queryMap);
        return new ModelAndView("/permission/userManager/userInfo", queryMap);
    }

    @RequestMapping(value = "/getUserDetail")
    @ResponseBody
    public Map getUserDetail(@RequestParam("id") Integer userId)throws Exception {
        Map map = new HashMap();
        TcUser user=null;
        if(userId==null){
            user=new TcUser();
        }else
        {
            user=userFeignClient.getUserById(userId);
        }
        //map = getRoleAndDeptByUserId(userId);
        map.put("_model",user);
        return map;
    }

    @RequestMapping(value = "/saveUserInfo",method = RequestMethod.POST,produces="application/json;charset=UTF-8")
    @ResponseBody
    public Map saveUserInfo(@ModelAttribute TcUser user) throws Exception {
        Map map = new HashMap();
        TcUser userNew=null;
        if(user==null){
            userNew=new TcUser();
            map.put("success", false);
            map.put("msg", "操作失败");
            map.put("_model",userNew);
            return map;
        }else{
            Map resultMap = userFeignClient.checkUserNameValid(user);
            String success = resultMap.get("success").toString();
            if ("false".equals(success)) {
                map.put("success", false);
                map.put("msg", resultMap.get("errorMsg"));
                return map;
            }
            if(user.getId()==null){
                user.setCreatorId(getCurUser().getId());
                user.setCreateDate(DateUtils.getCurDateTime2Minute());
                user.setCreatorName(getCurUser().getUserName());
                user.setPsw("1");
                user.setSubSys("Z1");
            }
            userNew = userFeignClient.saveUser(user);
            if(StringUtils.isNotBlankOrNull(user.getDeptId())){
                String[] users = user.getDeptId().split(",");
                for (int i=0;i<users.length;i++){
                    userFeignClient.saveUserDeptInfo(userNew.getId(),Integer.valueOf(users[i]));
                }
            }
            if(StringUtils.isNotBlankOrNull(user.getRoleCode())){
                String[] codes = user.getRoleCode().split(",");
                for (int i=0;i<codes.length;i++){
                    userFeignClient.saveUserRoleInfo(userNew.getId(), codes[i]);
                }

            }
        }
       // map = getRoleAndDeptByUserId(userNew.getId());
        map.put("success", true);
        map.put("msg", "操作成功");
        map.put("_model",userNew);
        return map;
    }
    public Map getRoleAndDeptByUserId(Integer userId){
        Map map = new HashMap();
        String deptName="";
        Integer deptId=null;
        String deptIds = userFeignClient.getDeptIdByUserId(userId);
        if(StringUtils.isNotBlankOrNull(deptIds)){
            String[] deptid = deptIds.split(",");
            for (int i=0;i<deptid.length;i++){
                TcDept dept=tDeptFeignClient.getDeptInfo(Integer.valueOf(deptid[i]));
                if(dept!=null){
                    deptId=dept.getId();
                    if(StringUtils.isNotBlankOrNull(dept.getDeptName())) {
                        deptName = dept.getDeptName()+",";
                    }
                }
            }
        }
        if (StringUtils.isNotBlankOrNull(deptName)){
            deptName = deptName.substring(0,deptName.length()-1);
        }
        String roleName="";
        String roleCode="";
        String roleCodes=userFeignClient.getRoleColesByUserId(userId);
        if(roleCodes!=null){
            String[] rolecode = roleCodes.split(",");
            for (int i=0;i<rolecode.length;i++) {
                TsRole tsRole = tsRoleFeignClient.getRoleInfo(Integer.valueOf(rolecode[i]));
                if (tsRole != null) {
                    roleCode += tsRole.getRoleCode()+",";
                    if (StringUtils.isNotBlankOrNull(tsRole.getRoleName())) {
                        roleName += tsRole.getRoleName()+",";
                    }
                }
            }
        }
        if (StringUtils.isNotBlankOrNull(roleName)){
            roleName = roleName.substring(0,roleName.length()-1);
        }
        map.put("deptId",deptId);
        map.put("deptName",deptName);
        map.put("roleCode",roleCode);
        map.put("roleName",roleName);
        return map;
    }
    @RequestMapping(value="/updatePasswordIndex")
    public ModelAndView updatePasswordIndex() {
        System.out.println("\nsuccess");
        return new ModelAndView("/permission/pswManager/updatePassword",null);
    }

    @RequestMapping(value="/setUserHeadPhotoById")
    @ResponseBody
    public Map setUserHeadPhotoById(){
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Integer id=Integer.valueOf(String.valueOf(queryMap.get("userId")));
        System.out.print("userId is "+id);
        String headPhoto=String.valueOf(queryMap.get("headPhoto"));
        System.out.print("headPhoto is "+headPhoto);
        TcUser user = userFeignClient.getUserById(id);
        user.setHeadPhoto(headPhoto);
        userFeignClient.saveUser(user);
        Map map=new HashMap();
        map.put("success",true);
        return map;
    }
    @RequestMapping(value="/personalCenter")
    public ModelAndView personalCenter() {
        Map queryMap= getRequestMapStr2Str(httpServletRequest);
        Map model = new HashMap();
        if(StringUtils.isNotBlankOrNull(queryMap.get("displayPage"))) {
            String displayPage = String.valueOf(queryMap.get("displayPage"));
            model.put("displayPage", displayPage);
        }
        return new ModelAndView("/permission/personalCenter/personalCenter",model);
    }
}
