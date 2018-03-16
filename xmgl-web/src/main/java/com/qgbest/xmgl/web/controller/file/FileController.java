package com.qgbest.xmgl.web.controller.file;

import com.qgbest.xmgl.common.utils.FileUtil;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.file.api.entity.FileBase;
import com.qgbest.xmgl.file.api.entity.ReturnMsg;
import com.qgbest.xmgl.file.client.FileBaseClient;
import com.qgbest.xmgl.file.client.FilesClient;
import com.qgbest.xmgl.web.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wch on 2017/6/26
 */

@Controller
@RequestMapping(value = "/manage/file")
public class FileController extends BaseController {
    public static final Logger logger = LoggerFactory.getLogger(FileController.class);
    @Autowired
    private FileBaseClient fileClient;
    @Autowired
    private FilesClient filesClient;

    /**
     * 初始化文件列表页面
     * @return
     */
    @RequestMapping(value = "/initFileList")
    public ModelAndView initFileList() {
        return new ModelAndView("/file/fileList", null);
    }
    /**
     * 初始化文件列表页面
     * @return
     */
    @RequestMapping(value = "/initFileListCs")
    public ModelAndView initFileListCs() {
        return new ModelAndView("/file/fileListCs", null);
    }
    /**
     * 查询
     * @return
     */
    @RequestMapping(value = "/queryFileList")
    @ResponseBody
    public Map queryFileList() {
        HashMap<String, String> queryMap = getRequestMapStr2Str(httpServletRequest);
        Map map = fileClient.queryFileList(JsonUtil.toJson(queryMap), len, cpage);
        return map;
    }

    /**
     * 初始化文件详情页面
     * @return
     */
    @RequestMapping(value = "/initFileInfo")
    public ModelAndView initFileInfo() {
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        model.put("id", queryMap.get("_id"));
        return new ModelAndView("/file/fileInfo",model);
    }

    /**
     * 获取文件详情
     * @return
     */
    @RequestMapping(value="/getFileInfoById")
    @ResponseBody
    public Map getFileInfoById(){
        Map queryMap =getRequestMapStr2Str(httpServletRequest);
        Map model =new HashMap();
        Integer id=Integer.valueOf(String.valueOf(queryMap.get("id")));
        FileBase fileBase=new FileBase();
        if(id==null||id==0){
            //do nothing
        }else{
            fileBase=fileClient.getFileInfoById(id);
        }
        model.put("fileBase",fileBase);
        return model;
    }

    /**
     * 删除文件信息
     * @return
     */
    @RequestMapping(value="/delFileInfoById")
    @ResponseBody
    public ReturnMsg delFileInfoById(){
        Integer id=Integer.valueOf(httpServletRequest.getParameter("_id"));
        ReturnMsg returnMsg = fileClient.delFileInfo(id);
        return returnMsg;
    }
    /**
     * 删除文件信息
     * @return
     */
    @RequestMapping(value="/delFileInfoByIds")
    @ResponseBody
    public ReturnMsg delFileInfoByIds(){
        String idsa = httpServletRequest.getParameter("_id");
        idsa = idsa.substring(0,idsa.length()-1);
        String[] ids = idsa.split(",");
        ReturnMsg returnMsg = null;
        for (int i=0;i<ids.length;i++){
            Integer id=Integer.valueOf(ids[i]);
            returnMsg = fileClient.delFileInfo(id);
        }
        return returnMsg;
    }
    @RequestMapping(value="/uploadInfo")
    public String uploadInfo(@RequestParam("id") Integer id,@RequestParam("_module") String _module,ModelMap modelMap){
        modelMap.addAttribute("id", id);
        modelMap.addAttribute("_module",_module);
        httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
        httpServletResponse.setHeader("Access-Control-Allow-Methods", "*");
        return "file/uploadFileInfo";
    }
    @RequestMapping(value = "/uploadFileInfo")
    @ResponseBody
    public Map uploadFileInfo(HttpServletRequest request){
        List fileList = getFile(request);
        Map map = new HashMap();
        map.put("success",true);
        map.put("fileInfoList",fileList);
        return map;
    }
    @RequestMapping(value = "/downloadFile")
    public void downloadFile(){
        downloadFileCommon();
    }
    /**
     * 展示文件
     */
    @RequestMapping(value = "/initFileShow")
    public String initFileShow(ModelMap modelMap) {
        try {
            String filePath = imageUrl + URLDecoder.decode(httpServletRequest.getParameter("filePath"), "UTF-8")+ "/" + httpServletRequest.getParameter("fileId");
            modelMap.addAttribute("filePath",filePath);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "/file/pdfShow";
    }
    @RequestMapping(value = "/convertFileIo")
    public void convertFileIo(HttpServletRequest request,HttpServletResponse response){
        String path = request.getParameter("path");
        try {
            path = URLDecoder.decode(path,"utf-8");
            System.out.println("path="+path);
            InputStream bis =FileUtil.getInputStreamByUrl(path); //得到网络返回的输入流
            byte[] data = FileUtil.readInputStream(bis);//返回的实际可读字节数
            response.getOutputStream().write(data);
            bis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}