<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>状态信息</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<%@ include file="/res/public/msg.jsp"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/ui/css/style.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/common.js"  charset="UTF-8"></script>
</head>
<body>
<form action="" name="myform" method="post">
<%--<s:hidden name="id"  id="id"/>
<input type="hidden" id="oldName" value="<s:property value='module.retValue'/>">--%>
<div class="box_01" style="margin-bottom:35px;" >
<div class="inner6px" > 
<div class="cell" > 
<%--<table>
	       <tr>
	        <th width="20%">返回值ID：</th>
	        <td width="80%">
	       		<s:if test="null!=module.retValueId||module.retValueId!=''">
        			<s:textfield cssClass="form_text" name="module.retValueId" id="_id" size="30" readonly="true" style="width:220px;"/>
       		 	</s:if>
       			 <s:else>
        			<s:textfield cssClass="form_text" name="module.retValueId" id="_id"  maxlength="10" size="30" style="width:220px;"/>
        		</s:else>	 
            </td>  	 
	      </tr>
	      <tr>
	        <th>返回值名称：</th>
	        <td>
	        	<s:textfield cssClass="form_text" name="module.retValue" id="name" size="30" style="width:220px;"/>
	        </td>  	 
	      </tr>
	      <tr>
	        <th>返回值描述：</th>
	        <td>
	        	<s:textfield cssClass="form_text" name="module.retValueDesc"  size="30" style="width:220px;"/>
	        </td>
	      </tr>
              <tr>
				<td colspan="2" align="center" >
				<a class="btn_01"  href='javascript:saveModule();'>保   存<b></b></a>	
				<a class="btn_01"  href="javascript:close();" >关闭<b></b></a>	
			</tr>
</table>--%>
</div>
</div>
</div>
</form>
</body>
<script>
$(document).ready(function(){
	init();
});
function init()
{ 
	var resultFlag = "<s:property value='_retInfo' />";
	if(resultFlag == 'success')
	{
		clickautohide(4,"保存成功");
		parent.$('#tt').datagrid('load');
	} 
}
function saveModule()
{

    if(document.getElementById("_id").value =="" || document.getElementById("_id").value==null)
    {
    	$.messager.alert("提示","返回值编码不能为空！");
    	document.getElementById("_id").focus();
    	return ;
    }
    if(document.getElementById("name").value=="" || document.getElementById("name").value==null)
    {
    	$.messager.alert("提示","返回值名称不能为空！");
    	document.getElementById("name").focus();
    	return ;
    }
    var retValueId = document.getElementById("_id").value;
    var retValue = document.getElementById("name").value;
	if(document.getElementById("_id").readOnly!=true)
	{
		//var list = jsonrpc.rpc("genericManager.getHql")(" from TcMapRetValue where retValueId='"+document.getElementById("id").value+"'").list;
		var url = "${pageContext.request.contextPath}/permission/checkRetId.action?retValueId="+retValueId;
		
		var list = getList(url);
		if(list.length>0)
		{
			$.messager.alert("提示","返回值编码已存在，请重新输入！");
		   	document.getElementById("_id").focus();
		   	return ;
		}
	}

	if(document.getElementById("oldName").value!=document.getElementById("name").value)
	{
		//var list = jsonrpc.rpc("genericManager.getHql")(" from TcMapRetValue where retValue='"+document.getElementById("name").value+"'").list;
		var url = "${pageContext.request.contextPath}/permission/checkRetName.action?retValue="+retValue;
		url=encodeURI(encodeURI(url));
		var list = getList(url);
		if(list.length>0)
		{
			$.messager.alert("提示","返回值名称已存在，请重新输入！");
		   	document.getElementById("name").focus();
		   	return ;
		}
	}
	$.messager.confirm('保存', '确认保存吗?', function(r){
		if (r){
			document.myform.action="${pageContext.request.contextPath}/permission/tcMapRetValuesave.action";
		    document.myform.submit();
		}
	});
}


   /****
   *
   * 获取list
   ****/
   function getList(url){
 	   var list = new Array();
 	   $.ajax({
 			  url: url,
 			  type : 'post',
 			  cache : false,
 			  async:false,
 			  success:function(result){
 			  
 			if(null != result.flags )
 			{
 				list=  result.flags;
 			}
 			
 			}
 		
 			});
 		return list;
   }
   function close() {
		f_close('editInfo');
		parent.$('#tt').datagrid('reload');
	}
</script>
</html>