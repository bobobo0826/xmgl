<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>角色信息</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<%@ include file="/res/public/msg.jsp"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/ui/css/style.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/common.js"  charset="UTF-8"></script>
</head>
<body>
<form name="myform" method="post">
<%--<input type="hidden" id="oldName" value="<s:property value='module.roleName'/>">--%>
<div class="box_01" style="margin-bottom:35px;" >
	<div class="inner6px" > 
		<div class="cell" > 
		<%--	<table>
	      <tr>
	        <th width="20%" >角色ID：</th>
	        <td width="80%">
	        <s:if test="null!=module.roleID||module.roleID!=''">
	        	<input class="form_text" required="true" name="module.roleID" id="id" size="21" value="<s:property value='module.roleID'/>" style="width:220px;height:20px" readonly="true"/>
	        	<font color="red">*</font>
	        </s:if>
	        <s:else>
	        	<input class="form_text"  required="true" name="module.roleID" id="id"  size="21" value="<s:property value='module.roleID'/>" style="width:220px;height:20px" />
	        	<font color="red">*</font>
	        </s:else>
	        </td>  	 
	      </tr>
	      <tr>
	        <th>角色名：</th>
	        <td>
	        	<input class="form_text" required="true"  name="module.roleName" id="name" size="21" value="<s:property value='module.roleName'/>" style="width:220px;height:20px" />
	        	<font color="red">*</font>
	        </td>  	 
	      </tr>
	      <tr>
	        <th >角色描述：</th>
	        <td>
	        	<input class="form_text" required="true" name="module.roleDesc" id="id" size="21" value="<s:property value='module.roleDesc'/>" style="width:220px;height:20px" />
	       </td>
	      </tr>
	      <tr>
	      	<td colspan="2" align="center">
	      		<a class="btn_01"  href='javascript:saveModule();'>保   存<b></b></a>
				<a class="btn_01"  onclick="closeWin();"  href="###">关   闭<b></b></a>
	      	</td>
	      </tr>
	    </table>--%>
	    </div>
</div>
</div>
</form>
</body>

<script>
$(document).ready(function() {
	var retInfo = "<s:property value='_retInfo' />";
	if(retInfo=='操作成功')
	{
		clickautohide(4,"保存成功");
		parent.$('#tt').datagrid('load');
	}
});
function closeWin() {
	f_close('editRoleInfo');
	parent.$('#tt').datagrid('reload');
}
   function saveModule()
   {
	   if(document.getElementById("id").value==null || document.getElementById("id").value=="")
	    {
		    $.messager.alert('提示','角色编号不能为空！'); 
	    	document.getElementById("id").focus();
	    	return ;
	    }
	    if(document.getElementById("name").value==null || document.getElementById("name").value=="")
	    {
	    	$.messager.alert('提示','角色名称不能为空！');
	    	$("#name").focus();
	    	return ;
	    }
		if(document.getElementById("id").readOnly!=true)
		{
			var roleId = document.getElementById("id").value;
			var url= "${pageContext.request.contextPath}/permission/checkRoleId.action?roleId="+roleId;
			var flag = checkData(url);
			if(flag ==false){
			  	alert("角色ID已存在，请重新输入！");
			   	document.getElementById("id").focus();
			   	return ;
			}
		}
 
		if(document.getElementById("oldName").value!=document.getElementById("name").value)
		{
			var roleName = document.getElementById("name").value;
			var url= "${pageContext.request.contextPath}/permission/checkRoleName.action?roleName="+roleName;
			url=encodeURI(encodeURI(url));
			
			var flag = checkData(url);
			
			if(flag ==false)
			{
			  	alert("角色名称已存在，请重新输入！");
			   	document.getElementById("name").focus();
			   	return ;
			}
		}
		 
				document.myform.action="${pageContext.request.contextPath}/permission/tsSaveRole.action";
			    document.myform.submit();
			}
	

   /***检查数据重复*****/
   function checkData(url){
	   var flag = false;
	   $.ajax({
			  url: url,
			  type : 'post',
			  cache : false,
			  async:false,
			  success:function(result){
			if(null != result.flags && result.flags==false)
			{
				  flag =  false;
			}
			else if(result.flags==true)
				flag= true;
			}
		
			});
		return flag;
		
   }
</script>
</html>