<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
<title>选择 功能</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<link rel="stylesheet" type="text/css" href="${root}/res/public/css/base.css" />
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css"/>
<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
<script type="text/javascript">
 function  changeValue()
 {
	var chkArr=document.getElementsByName("moduleID");
	var param=""; 
	for(var i=0;i<chkArr.length;i++) 
	{ 
		if(chkArr[i].checked)
	  	{
			param+=chkArr[i].value+";";
  		}
	} 
	var url = "${root}/permission/calcuteOperValue.action?opr="+param;
    $.ajax({
		url: url,
		type: 'post',
		cache: false,
		async: false,
		success: function(response) { 
			var result=""+response.selectOprValue;
			parent.setSelectOperValue("<s:property value='id'/>",result);
			f_close("selectOper");
		}
	}); 
   
 }
 function closewin()
 {
	f_close("selectOper");
 }
</script> 
</head>
<body >
<form  method="post" name="myform">
<div class="box_01  box_01_840">
<div class="inner6px">
<div class="cell">
<%--<table>
			<tr> 
       		 <s:if test="list.size>0">
			 <td   >  
        	 <%
        		OgnlValueStack stack = (OgnlValueStack) request.getAttribute("struts.valueStack");
				List<TcOpr> list = (List<TcOpr>) stack.findValue("list");
				String opr=(String) stack.findValue("opr");
				for(int i=0;i<list.size();i++)
				{
					TcOpr temp=list.get(i);
					String a="";
					if(opr.contains(";"+String.valueOf(temp.getOprId())+";"))
					{
						a="checked='checked'";
					}
					out.print("<input type='checkbox' name='moduleID' class='newTd' value='"+temp.getOprId()+"'"+a+">"+temp.getOprName()+" <b></b>");
				}
        	%>
        	</td> 
			</s:if>
			<s:else>
		    	<th class="newTd" align="center">暂无添加数据</th>
			</s:else>
			</tr>
			<tr>
				 <td  align="center" >  
					<a class="btn_01"  href='javascript:changeValue();'>保   存<b></b></a>	
					<a class="btn_01"  href='javascript:closewin();'>关闭<b></b></a>
					</td>	
			</tr>
      </table>   --%>
      </div>
      </div>
      </div>
</form>
</body>
</html>