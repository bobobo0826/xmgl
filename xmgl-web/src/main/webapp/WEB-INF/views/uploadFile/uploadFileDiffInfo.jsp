<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>导入上传的文档</title>
  <%@ include file="/res/public/hplus.jsp"%>
  <%@ include file="/res/public/easyui_lib.jsp"%>
  <%@ include file="/res/public/angularjs.jsp"%>
  <%@ include file="/res/public/common.jsp"%>
  <%@ include file="/res/public/msg.jsp"%>
  <%@ include file="/thirdparty/uploadifive-v1.2.2/upload.jsp"%>
  <script type="text/javascript">
    var message="";
    var msg = "";
    function setUpload(){
      $("#filename").uploadifive({
        'uploadScript' : '${root}/manage/pretrial/saveUploadAfterDiffInfo',//请求响应的Action
        'cancelImg'    : '${root}/thirdparty/uploadify/img/cancel.png',//设置  取消按钮图片的路径
        'buttonText'   : '选择文件', //浏览按钮的文本，默认值：BROWSE 。
        'buttonImg'    : '${root}/thirdparty/uploadify/img/selectFile.jpg',
        'width'		   : 80, //width ： 设置浏览按钮的宽度 ，默认值：110。 
        'height'	   : 30, //设置浏览按钮的高度 ，默认值：30。
        'queueID'      : 'some_file_queue',  // 文件队列的ID，该ID与存放文件队列的div的ID一致。 
        'folder'       : '',//设置上传文件后保存的路径
        'fileExt'      : '*.jpg;*.png;*.gif;*.bmp;*.jpeg;*.mp3;*.ogg;*.wav;*.mp4;*.webm;*.doc;*.txt;*.pdf;*.iso,*.xls,*.xlsx;*.ppt;*.html;*.pptx;*.zip;*.rar',
        'fileDesc'     : '附件格式:*.jpg;*.png;*.gif;*.bmp;*.jpeg;*.mp3;*.ogg;*.wav;*.mp4;*.webm;*.doc;*.txt;*.pdf;*.iso,*.xls,*.xlsx;*.ppt;*.html;*.pptx;*.zip;*.rar',
        'fileObjName' : '_fileData',//设置一个名字，在服务器处理程序中根据该名字来取上传文件的数据。默认为Filedata  
        'auto'         : false,//设置是否自动上传  
        'sizeLimit'	   : 1024*1024*10, //设置文件大小
        'multi'        : true,//设置是否多文件上传  ,
        'simUploadLimit':1 ,
        onError: function(event, queueID, fileObj) {
          //$.messager.confirm('提示',"文件:" + fileObj.name + "上传失败");
        },
        onCancel: function(event, queueID, fileObj){
        },
        onUploadComplete: function(event,data)
        {
          var data = eval("(" + data + ")");
          msg = data.msg;
          if(data.success)
          {
            parent.$("#tt").datagrid('load');
            f_close('newWindow');
          }
          else
          {
            if(!isEmpty(msg)){
              alert("处理完毕,详细信息:\n"+msg);
            }
          }
          f_close('newWindow');
        },
        'onComplete': function(event,queueID,file,serverData,reponseData){

          var data = eval("(" + serverData + ")");
          msg += data.msg;

        },
        'onSelect': function(event, queueID, fileObj){
        },
        onSelectOnce: function(event,data){
          if(!isEmpty(message))
            layer.alert( message);
          message="";
        }
      });
    }
    function cancleSeq(){
      $('#filename').uploadifive('clearQueue');
      parent.$('#attstt').datagrid('reload');
      f_close('newWindow');
    }
    function uploadAll(){
      $('#filename').data('uploadifive').settings.formData = {'_id':$('#id').val(),'_moudle':$('#_moudle').val(),'_mark':$("#mark").val(),'_diffFileId':$("#_diffFileId").val()};   //动态更改formData的值
      $('#filename').uploadifive('upload');
    }
  </script>
</head>
<body  onload="setUpload()">
<form name="myform" method="post"  onsubmit="return false;">
  <input type="hidden" id="id" name="id" value="${pretrial_file_id}">
  <input type="hidden" id="_moudle" name="moudle" value="${module}">
  <input type="hidden" id="_diffFileId" name="moudle" value="${id}">
  <div class="row">
    <div class="col-sm-12">
      <div class="ibox">
        <div class="ibox-content">
          <div class="col-sm-12">
            <div align="center">
              <input id="filename" name="_fileData" type="file"/>
            </div>
          </div>
          <div class="col-sm-12">
            <label>待上传文件列表</label>
            <fieldset style="height:130px; overflow-y:auto;border:1px solid #bbb">
              <div id="some_file_queue" > </div>
            </fieldset>
          </div>
          <div class="col-sm-12">
            <label>备注</label>
            <textarea id = "mark" style="height:100px;width: 650px; overflow-y:auto;border:1px solid #bbb"></textarea>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg">
      <a href="javascript:uploadAll();" class="btn btn-primary btn-sm" ><i class='fa fa-check'></i>确定<b></b></a>
      <a href="javascript:cancleSeq();" class="btn btn-danger btn-sm" ><i class='fa fa-remove'></i>关闭<b></b></a>
    </div>
  </div>
</form>
</body>
</html>