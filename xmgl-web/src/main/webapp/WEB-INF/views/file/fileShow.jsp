<%--
  Created by IntelliJ IDEA.
  User: QG-YKM
  Date: 2017-05-24
  Time: 10:23 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>文件列表</title>
    <!--hplus-->
    <%@ include file="/res/public/loginStyle.jsp"%>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript">
        var type='';
        $(document).ready(function(){
            getFileData();
        });
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                getFileData();
            }
        });

        function getUrl() {
            var url;
            url="${root}/manage/file/queryFileList"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function getQueryCondition(){
            var url="?file_name="+$('#file_name').val()
            +"&business_type_code="+type;
            return url;
        }
        function getFileData() {
            $(".pageBox").pageFun({  /*在本地服务器上才能访问哦*/
                interFace:getUrl(),  /*接口*/
                displayCount:8,  /*每页显示总条数*/
                maxPage:5,/*每次最多加载多少页*/
                dataFun:function(data){
                    showFile(data);
                },
                pageFun:function(i){
                    var pageHtml = '<li class="pageNum">'+i+'</li>';
                    return pageHtml;
                }

            })
        }
        function showFile(data) {
            var html = '';
            var result = data;
            for(var i=0;i<result.length;i++){
                var path ='http://localhost:8084/';
                path+=result[i].file_path+'/'+result[i].file_id;
                var checkValue=result[i].id+','+result[i].file_name+','+result[i].file_path+','+result[i].file_id;
                var type = result[i].file_type;
                if(type=="gif"||type=="jpg"||type=="jepg"||type=="png"||type=="JPG"||type=="GIF"||type=="PNG"){
                    html+='<div class="file-box"> ' +
                        '<div class="file" style="width: 310px;height: 260px">  <a href="##"> ' +
                        '<input type="checkbox" class="selectable-item" name="media" value="'+checkValue+'">' +
                        '<span class="corner"></span> ' +
                        '<div class="image"> ' +
                        '<img alt="image" class="img-responsive" style="height: 220px;width: 310px;" src="'+path+'"> ' +
                        '</div> ' +
                        '<div class="file-name">' +
                        result[i].file_name +
                        '<br> ' +
                        '<small>添加时间：' +
                        result[i].create_date +
                        '</small> ' +
                        '</div> </a> </div></div>';
                }else{
                    html+='<div class="file-box"> ' +
                        '<div class="file" style="width: 310px;height: 260px">  <a href="##"> ' +
                        '<input type="checkbox" class="selectable-item" name="media" value="'+checkValue+'">' +
                        '<span class="corner"></span> ' +
                        '<div class="icon"> ' +
                        '<i class="fa fa-file" style="height: 220px;width: 310px;"></i>' +
                        '<embed src="'+path+'" style="height: 220px;width: 310px;">'+
                        '</div> ' +
                        '<div class="file-name">' +
                        result[i].file_name +
                        '<br> ' +
                        '<small>添加时间：' +
                        result[i].create_date +
                        '</small> ' +
                        '</div> </a> </div></div>';
                }
            }
            $("#tt").html(html);
        }
        function doQuery() {
            getFileData();
        }
        function doQueryType(data) {
            if(data!=undefined){
                type=data;
            }else{
                type='';
            }
            getFileData();
        }
        function downloadFile(){
            var id_array=new Array();
            $('input[name="media"]:checked').each(function(){
                id_array.push($(this).val());//向数组中添加元素
            });
            for(var i=0;i<id_array.length;i++){
                var values = id_array[i].split(',');
                var url = "${root}/manage/file/downloadFile?id="+values[0]+"&fileId="+values[3]+"&filePath="+values[2]+"&fileName="+values[1];
                window.location.href=encodeURI(encodeURI(url));
            }
        }
        function deleteFile(){
            var id_array=new Array();
            $('input[name="media"]:checked').each(function(){
                id_array.push($(this).val());//向数组中添加元素
            });
            var idstr='';
            for(var i=0;i<id_array.length;i++){
                var ids = id_array[i].split(',');
                idstr += ids[0]+',';
            }
            var url="${root}/manage/file/delFileInfoByIds?_id="+idstr;
            layer.confirm(_DELETE_ONE_MSG, {
                btn : [ '确定', '取消' ], //按钮
                shade : false
                //不显示遮罩
            }, function(index) {
                $.ajax({
                    url : encodeURI(encodeURI(url)),
                    type : 'post',
                    cache : false,
                    async : false,
                    success : function(result) {
                        doQuery();
                        layer.close(index);
                        layer.msg(result.msgDesc);
                    }
                });
            }, function(index) {
                layer.close(index);
            });
        }
    </script>
</head>
<body>

<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="input-search input-search-dark" style="width: 380px;">
                        <i class="input-search-icon wb-search"  id="search"></i>
                        <input type="text" class="form-control" name="file_name" id="file_name" placeholder="查找..." onchange="doQuery()">
                    </div>

                </form>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <div class="file-manager">
                    <h5>显示：</h5>
                    <a href="javascript:doQueryType()" class="file-control active">所有</a>
                    <a href="javascript:doQueryType('file')" class="file-control">文档</a>
                    <a href="javascript:doQueryType('avi')" class="file-control">视频</a>
                    <a href="javascript:doQueryType('YGZP')" class="file-control">图片</a>
                    <div class="hr-line-dashed"></div>
                    <button class="btn btn-primary btn-block">上传文件</button>
                    <div class="hr-line-dashed"></div>
                    <h5>分类</h5>
                    <ul class="folder-list" style="padding: 0">
                        <li><a href="javascript:doQueryType('file')"><i class="fa fa-folder"></i> 文档</a>
                        </li>
                        <li><a href="javascript:doQueryType('YGZP')"><i class="fa fa-folder"></i> 图片</a>
                        </li>
                        <li><a href="javascript:doQueryType('file')"><i class="fa fa-folder"></i> 视频</a>
                        </li>
                        <li><a href="javascript:doQueryType('avi')"><i class="fa fa-folder"></i> 书籍</a>
                        </li>
                    </ul>
                    <h5 class="tag-title">标签</h5>
                    <ul class="tag-list" style="padding: 0">
                        <li><a href="javascript:doQueryType()">头像</a>
                        </li>
                        <li><a href="javascript:doQueryType()">前端</a>
                        </li>
                        <li><a href="javascript:doQueryType()">后端</a>
                        </li>
                        <li><a href="javascript:doQueryType()">服务器</a>
                        </li>
                        <li><a href="javascript:doQueryType()">业务文档</a>
                        </li>
                        <li><a href="javascript:doQueryType()">视频</a>
                        </li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-9 animated fadeInRight">
        <div class="row">
            <div class="col-sm-12" id="tt">

            </div>
        </div>
    </div>
</div>
<div class="site-action active">
        <button type="button" data-action="download" onclick="downloadFile()" class="btn-raised btn btn-primary btn-floating animation-slide-bottom">
            <i class="icon wb-download" aria-hidden="true"></i>
        </button>
        <button type="button" data-action="trash" onclick="deleteFile()" class="btn-raised btn btn-primary btn-floating animation-slide-bottom">
            <i class="icon wb-trash" aria-hidden="true"></i>
        </button>
</div>
<div align="center" id="operator"></div>
<div class="main_btnarea">
    <div class="pageBox">
        <ul class="pageDiv clearfix">

        </ul>
        <div class="notContent hide">
            无数据
        </div>
        <div class="page">
            <ul class="pageMenu clearfix">
                <li class="firstPage">首页</li>
                <li class="prevPage"> < 上一页 </li>
                <div class="pageObj ">

                </div>
                <li class="nextPage"> 下一页 > </li>
                <li class="lastPage">尾页</li>
                <li class="last" style="font-size: 14px;">
                    共<span class="totalPage"></span>页，跳转至 <input type="number" class="keuInput" value="1">
                    <button type="button" class="btnSure">确定</button>
                </li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>