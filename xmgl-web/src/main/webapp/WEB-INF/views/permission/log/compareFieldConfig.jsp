<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>比较字段配置</title>
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<%@ include file="/res/public/easyui_lib.jsp" %>
<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/faxibox/style/jquery-foxibox-0.2.css" />
<script type="text/javascript" src="${root}/thirdparty/My97DatePicker/WdatePicker.js"  charset="UTF-8"></script>
<script type="text/javascript" src="${root}/res/public/js/faxibox/script/jquery-foxibox-0.2.js"  charset="UTF-8"></script>
<script type="text/javascript"> 
function fileSelectChange( fileInputId,  fileNameInputId)
{
	var arr=$("#"+fileInputId).val().split('\\');//注split可以用字符或字符串分割 
	$("#"+fileNameInputId).val(arr[arr.length-1]);  
}

function upload(){
	if(isEmpty($('#_fileName').val())){
		alert("请选择上传的文件!");
		return;
	}
	
	var filename = $('#_fileName').val();
	var dot = filename.lastIndexOf('.');   
    if ((dot >-1) && (dot < (filename.length - 1))) {   
        var exName = filename.substring(dot + 1);
        if(exName!='xml'){
        	alert("只能上传xml文件!");
        	return;
        }
    }
    if(confirm("是否确定上传?")){
    	document.myform.action="${root}/log/saveConfigFile.action";
        document.myform.submit();
    }
}
</script>
</head>

<body>
<form name="myform" method="post" enctype="multipart/form-data">
<div class="box_01">
<div class="inner6px">
<div class="cell">
<table id="queryTable">
 	<tr>		 
		<th class="label">操作模块:</th><td>
		<select  list="_formList" listKey="ID" listValue="TEXT" id="_formType" name="_formType" cssStyle="width:150px;"/>
		</td>
	</tr>
	<tr>	
		<th width="10%">选择文件：</th>
		<td  width="20%">
		<input type="file"  name="_file" id="_file" onchange="fileSelectChange('_file','_fileName');" />
		<input type="hidden" name="_fileName" id="_fileName"/>
		
		 <a href="javascript:upload();" class="btn_01" >上传<b></b></a>
		</td>
	</tr>
</table>
</div><!-- end cell -->
</div><!-- end inner6px -->
</div><!-- end box_01 -->
</form>
</body>
</html>