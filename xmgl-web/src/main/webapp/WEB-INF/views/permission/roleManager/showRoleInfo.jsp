<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%--<%@page import="com.quangao.model.permission.TsRole"%>
<%@page import="com.opensymphony.xwork2.ognl.OgnlValueStack"%>--%>
<head>
<title>选择角色</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<link rel="stylesheet" type="text/css" href="${root}/res/public/css/base.css" />
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css"/>
<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
<script type="text/javascript">
 function  confirmSelect()
 {
	  var rdButtons = document.getElementsByName("roles");
	  var seleRoleCode="";
	  for(var i = 0;i< rdButtons.length;i++)
	  {
	      if(rdButtons[i].checked  == true) 
	      {
	    	  seleRoleCode=rdButtons[i].value;
	    	  break;
	      }
	  }  
	  if(seleRoleCode=="") 
	  {
		  alert("请选择该功能对应的角色！"+seleRoleCode);
		  return;
	  }
	  //parent.window.returnValue =seleRoleCode;
	 // window.close();
	 parent.$("#selectRoleCode").val(seleRoleCode);
	 parent.$("#selectRoleCode").trigger('change');
	 f_close("RoleSelectWindow");
 } 
</script> 
</head>
<body >
<form  method="post" name="myform">
<div class="box_01  box_01_840">
<div class="inner6px">
<div class="cell">
<%--
<table>
			<tr> 
       		 <s:if test="rolesList.size>0">
			 <td   >  
        	 <%
        		OgnlValueStack stack = (OgnlValueStack) request.getAttribute("struts.valueStack");
				List<TsRole> list = (List<TsRole>) stack.findValue("rolesList");
				for(int i=0;i<list.size();i++)
				{
					TsRole temp=list.get(i);
					out.print("<input type='radio' name='roles' class='newTd' value='"+temp.getRoleCode()+"'>"+temp.getRoleName()+" <b></b>");
				}
        	%>
        	</td> 
			</s:if>
			<s:else>
		    	<th class="newTd" align="center">暂无数据</th>
			</s:else>
			</tr>
			<tr>
				 <td  align="center" >  
					<a class="btn_01"  href='javascript:confirmSelect();'>确认<b></b></a>	 
				 </td>	
			</tr>
      </table>   
--%>
      </div>
      </div>
      </div>
</form>
</body>
</html>