package com.qgbest.xmgl.web.controller;

import com.qgbest.xmgl.common.utils.CharsetUtil;
import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.FileUtil;
import com.qgbest.xmgl.common.utils.StringUtils;
import com.qgbest.xmgl.file.api.entity.FileBase;
import com.qgbest.xmgl.file.client.FilesClient;
import com.qgbest.xmgl.permission.api.entity.permission.TsSubSys;
import com.qgbest.xmgl.user.api.entity.TcUser;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.*;
import java.net.URLDecoder;
import java.util.*;
import java.util.List;

/**
 * Created by qianmeng on 2017-03-24.
 */
@Controller
public class BaseController {
    @Autowired
    protected HttpServletRequest httpServletRequest;
    @Autowired
    protected HttpServletResponse httpServletResponse;
    @Autowired
    private FilesClient filesClient;

    protected String filterRules;
    @Value("${imageUrl}") protected String imageUrl;

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
    protected int cpage=1;
    /**
     * 分页，每页显示条数
     */
    protected Integer len = 20;
	
	protected TcUser getCurUser() {
		TcUser curUser = (TcUser) httpServletRequest.getSession().getAttribute("curUser");
		return curUser;
	}
    protected TsSubSys getSubSys() {
        TsSubSys subSys = (TsSubSys) httpServletRequest.getSession().getAttribute("subSys");
        return subSys;
    }
    /**
     * 获取请求属性封装为Map类型
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
     * @param request
     * @return
     */
    protected HashMap<String, String> getRequestMapStr2Str(HttpServletRequest request)  {
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
     * @param request
     * @return
     */
    protected HashMap<String, String> getRequestMapStr2StrWithQuery(HttpServletRequest request)  {
        HashMap<String, String> conditions = new HashMap<String, String>();
        Map map = request.getParameterMap();
        for (Object o : map.keySet()) {
            String key = (String) o;
            conditions.put(key, ((String[]) map.get(key))[0]);
        }
        CharsetUtil.filterCharset(conditions);
        if(conditions.get("cpage")!=null){
            cpage=Integer.valueOf(String.valueOf(conditions.get("cpage")));
        }
        if(conditions.get("len")!=null){
            len=Integer.valueOf(String.valueOf(conditions.get("len")));
        }
        return conditions;
    }
    /**
     * 获取每页的长度
     * @param condtionMap
     * @return
     */
    protected Integer getLen(Map condtionMap)
    {
        Integer len=1;
        if (condtionMap.get("len")!=null){
            len=Integer.valueOf(String.valueOf(condtionMap.get("len")));
        }else {
            len=20;
        }
        return len;
    }

    /**
     * 获取页数
     * @param condtionMap
     * @return
     */
    protected Integer getCpage(Map condtionMap)
    {
        Integer len=1;
        if (condtionMap.get("cpage")!=null){
            cpage=Integer.valueOf(String.valueOf(condtionMap.get("cpage")));
            return len;
        }else {
            return 1;
        }
    }
    /**
     * 解析上传文件
     */
    public List getFile(HttpServletRequest request){
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
                request.getSession().getServletContext());
        List fileList = new ArrayList();
        if (multipartResolver.isMultipart(request)) {
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            String _moudle = multiRequest.getParameter("_module");
            Integer _id = Integer.valueOf(multiRequest.getParameter("_id"));
            TcUser curUser = getCurUser();
            Iterator<String> iter = multiRequest.getFileNames();
            while (iter.hasNext()) {
                String code = iter.next();
                MultipartFile file = multiRequest.getFile(code);
                if (!file.isEmpty()) {
                    String fileName = file.getOriginalFilename();
                    String exName = FileUtil.getExtensionName(fileName); // 扩展名
                    String uuid = UUID.randomUUID().toString();
                    String path1 = httpServletRequest.getSession().getServletContext().getRealPath("/upload")+File.separator+_moudle;
                    File filePath = new File(path1);
                    if (!filePath.exists()) {
                        filePath.mkdirs();
                    }
                    String path = filePath + "\\" + uuid + "." + exName;

                    File localFile = new File(path);
                    try {
                        file.transferTo(localFile);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    String upDownAddr="http://"+request.getRemoteHost()+":"+request.getServerPort()+"/upload/"+_moudle+ "/" + uuid + "." + exName;
                    filesClient.uploadFile2Down(upDownAddr,_moudle);
                    while (localFile.exists()){
                        localFile.delete();
                    }
                    /* try{
                        //判断是否为图片
                        Image image= ImageIO.read(localFile);
                        if (image!=null){
                            //首页头像专用
                            String pathone = filePath+File.separator+"small" + "\\" + uuid + "." + exName;
                            File localFileone = new File(filePath+File.separator+"small" );
                            if (!localFileone.exists()){
                                localFileone.mkdirs();
                            }
                            File localFileSmall = new File(pathone);
                            //指定大小进行缩放
                            Thumbnails.of(localFile).size(64,64).toFile(localFileSmall);
                            //评论，浏览，消息专用
                            String pathletter = filePath+File.separator+"letter" + "\\" + uuid + "." + exName;
                            File localFileletter = new File(filePath+File.separator+"letter" );
                            if (!localFileletter.exists()){
                                localFileletter.mkdirs();
                            }
                            File localFileLetter = new File(pathletter);
                            Thumbnails.of(localFile).size(32,32).toFile(localFileLetter);
                            //按照比例进行放大和缩小
                            //Thumbnails.of(localFile).scale(0.2f).toFile(localFileSmall);//按比例缩小
                            // Thumbnails.of(localFile).scale(2f);//按比例放大
                            //图片尺寸不变，压缩文件大小
                            //Thumbnails.of(localFile).scale(1f).outputQuality(0.25f).toFile(localFileSmall);
                        }
                    }catch(Exception e){
                        e.printStackTrace();
                    }*/

                    FileBase fileBase = new FileBase();
                    fileBase.setCreateDate(DateUtils.getCurDateTime2Minute());
                    fileBase.setCreator(curUser.getDisplayName());
                    fileBase.setCreatorId(curUser.getId());
                    fileBase.setBusinessId(_id);
                    fileBase.setBusinessName(filesClient.getBuNameByBuCode(_moudle));
                    fileBase.setBusinessTypeCode(_moudle);
                    fileBase.setFileId(uuid + "." + exName);
                    fileBase.setFileName(fileName);
                    fileBase.setFilePath("upload"+"/"+_moudle);
                    fileBase.setFileType(exName);
                    fileBase.setFileSize(String.valueOf(file.getSize()));
                    filesClient.saveFile(fileBase);
                    fileList.add(fileBase);
                }
            }
        }
        return fileList;

    }
    /**
     * 下载文件
     */
    public String downloadFileCommon(){
        httpServletResponse.setCharacterEncoding("utf-8");
        httpServletResponse.setContentType("multipart/form-data");
        try {
            httpServletResponse.setHeader("Content-Disposition", "attachment;fileName="
                    + URLDecoder.decode(httpServletRequest.getParameter("fileName"),"UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        try {
            String path = imageUrl + URLDecoder.decode(httpServletRequest.getParameter("filePath"), "UTF-8")+ "/" + httpServletRequest.getParameter("fileId");
            System.out.print("=============11111111111="+path);
            InputStream inputStream =  FileUtil.getInputStreamByUrl(path);
            OutputStream os = httpServletResponse.getOutputStream();
            byte[] b = new byte[2048];
            int length;
            if (StringUtils.isNotBlankOrNull(inputStream)){
                while ((length = inputStream.read(b)) > 0) {
                    os.write(b, 0, length);
                }
            }else{
                os.write(b, 0, 1);
            }
            // 这里主要关闭。
            os.close();
            inputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "success";
    }
}
