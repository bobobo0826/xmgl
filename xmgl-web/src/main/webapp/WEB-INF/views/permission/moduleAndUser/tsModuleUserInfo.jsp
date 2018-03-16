<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>模块用户管理</title>
<%@ include file="/res/public/hplus.jsp"%>
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/angularjs.jsp"%>
<%@ include file="/res/public/common.jsp"%>
<%@ include file="/res/public/msg.jsp"%>
</head>
<body>
<form action="" name="myform" method="post">
<input type="hidden" value="${userId}" id="userId">
<div class="box_01" style="margin-bottom:40px;">
	<div class="inner6px">
		<div class="cell">
			<table>
     <tr>
        <th width="20%">用户：</th>
        <td width="80%">
			  <select cssStyle="width:150px" name="userIdS" id="userIds" />
        </td>  	
      </tr>
      <tr>
        <th>模块：</th>
        <td id="moduleList">
      	</td>
      </tr>
</table>
</div>
</div>
</div>
<div class="main_btnarea">
		<div class="btn_area_setc btn_area_bg">
		<a class="btn_01"  href='javascript:saveModule();'>保   存<b></b></a>	
		</div>
	</div>
</form>
</body>
<script>

	/**
	保存角色菜单配置信息
	**/
	function saveModule()
	{
		var chkArr=document.myform.moduleIds;

		var param=""; 
		for(var i=0;i<chkArr.length;i++) 
		{
			if(chkArr[i].checked)
		  	{
				var oprValue=document.getElementById(i).value;
			  	if(oprValue==null || oprValue=="")
			  	{
			  		param+="0,";
			  	}
			  	else
			  	{
					param+=oprValue+",";
			  	}
	  		}
		}
		var userIdS=$("#userIds").val();
		if(isEmpty(userIdS))
		{
			 $.messager.alert('错误', '请选择用户！', "error");
			return;
		}
		if(isEmpty(param))
		{
			$.messager.alert('错误', '请选择用户！', "error");
			return;
		}
	    document.myform.action="${root}/manage/moduleUser/tsMUSave?opr="+param;
		document.myform.submit();
	}
	/***
	*配置功能-操作如新增。。。
	***/
  	function selInsDicDataByType(str,operValue,moduleId,id)
	{
 		var windowName = "selectOper";
 		var windowTitle = "选择操作";
 		var width =650;
		var height =400;
 		var url="${root}/manage/module/selectOperSetWithAll?id="+id+"&operValue="+operValue+"&opr="+document.getElementById(id).value ;
		f_open(windowName, windowTitle, width, height, url, true);
	  	document.getElementById(moduleId).checked=true;
	}
    function setSelectOperValue(elementId,operValue)
    {
	  	document.getElementById(elementId).value=operValue+"";
    }
	$(document).ready(function(){
				getModuleAndUserList($("#userId").val());
				var url = "${root}/manage/moduleUser/getModuleUserList?userId="+$("#userId").val();
				$.ajax({
					url: url,
					type: 'post',
					cache: false,
					async: false,
					success: function(response) {
						var data = response.mlist;
						var opr = response.operSet;
						var moduleIds = response.moduleIds;
						var html = "";
						for(var i=0;i<data.length;i++)
						{
							var temp=data[i];
							console.log(temp)
							if(null!=moduleIds&&moduleIds.length>0)
							{
								for(var c=0;c<moduleIds.length;c++)
								{
									if(moduleIds[c]==temp.moduleid)
										break;
								}
								if(c==moduleIds.length)
									c=-1;
								if(c>=0)
								{
									html+="<input type='checkbox' nowrap='true' id='"+temp.moduleid+"' checked='checked' name='moduleIds' value='"+temp.moduleid+"'><a href=\"javascript:selInsDicDataByType('"+temp.modulename+"','"+temp.oprset+"','"+temp.moduleid+"','"+i+"')\">"+temp.modulename+"("+temp.moduledesc+")</a><input type='hidden' id='"+i+"' value='"+opr[c]+"'><br/>";
								}
								else
								{
									html+="<input type='checkbox' nowrap='true' id='"+temp.moduleid+"' name='moduleIds' value='"+temp.moduleid+"'><a href=\"javascript:selInsDicDataByType('"+temp.modulename+"','"+temp.oprset+"','"+temp.moduleid+"','"+i+"')\">"+temp.modulename+"("+temp.moduledesc+")</a><input type='hidden' id='"+i+"'><br/>";
								}
							}
							else
							{
								html+="<input type='checkbox' nowrap='true' id='"+temp.moduleid+"' name='moduleIds' value='"+temp.moduleid+"'><a href=\"javascript:selInsDicDataByType('"+temp.modulename+"','"+temp.oprset+"','"+temp.moduleid+"','"+i+"')\">"+temp.modulename+"("+temp.moduledesc+")</a><input type='hidden' id='"+i+"'><br/>";
							}
						}
						$("#moduleList").html(html);
					}
				});
				var msgDesc = "${msgDesc}";
				if(msgDesc=="操作成功"){
					layer.msg(msgDesc);
					parent.$('#mt').datagrid('load');
				}
			}
	);
	function getModuleAndUserList(def){
		var userIds = document.getElementById("userIds");
		var url = '${root}/manage/moduleUser/getUserIdsList?userId='+$("#userId").val();
		$.ajax({
			type : 'get',
			cache : false,
			url : url,
			async : false,
			success : function(result) {
				//var data = result.v;
				userIds.options.length = 0;
				var fOpt = new Option("", "");
				userIds.options.add(fOpt);
				if (null != result) {
					for (var i=0; i < result.length; i++){
						var opt = document.createElement("option");
						opt.value = result[i].id;
						opt.text = result[i].display_name;
						userIds.options.add(opt);
					}
					userIds.value = def;
				}
			},
			error : function() {
				alert("出错!请联系管理员!");
			}
		});
	}
</script> 