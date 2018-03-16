<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/common.jsp"%>
<jsp:include page="/res/public/float_div.jsp"></jsp:include>
<!--会占据form头一定高度-->
<%@ include file="/res/public/lodop.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
  $("#checkTitle").height($(window).height()-50); //浏览器当前窗口可视区域高度
  var columnFiled =$("#_columnFiled").val();
  var columnTitle =$("#_columnTitle").val();
	var columnsHidden =$("#_columnsHidden").val();
  var titleArray=columnTitle.split(',');
  var fieldArray =columnFiled.split(',');
  var hiddenArray =columnsHidden.split(',');  
  var str = '';
  var tableStr=new Array(); 
  tableStr.push("<table  align=\"center\" border=\"0\" class=\"tab1\" style=\"margin:0px 0px 0px 20px;\">");
  tableStr.push("<tr>"); 
  tableStr.push("<td class=\"tab_td2\" colspan=2><input type=\"checkbox\" id=\"selectAll\" checked onchange=\"selectAllCheckBox();\">全选(清空)</input></td>"); 
  tableStr.push("<tr>"); 
  for(var i = 1;i < titleArray.length;i=i+2)
  { 
	  if(titleArray[i] != null || titleArray[i]!='')
	  {  
			if(i==titleArray.length-1)
			{

				 
				tableStr.push("<tr>"); 
				if(hiddenArray[i] =="false" || hiddenArray[i] =="undefined")
				{ 
			 		 tableStr.push("<td class=\"tab_td2\" colspan=2><input type=\"checkbox\" id=\""+fieldArray[i] +"\" checked >" + titleArray[i]+ "</input></td>"); 
				}
				else
				{ 
					tableStr.push("<td class=\"tab_td2\" colspan=2><input type=\"checkbox\" id=\""+fieldArray[i] +"\"   >" + titleArray[i]+ "</input></td>");
				}
				tableStr.push("</tr>");
			}
			else
			{ 
				j=i+1; 
				tableStr.push("<tr>");   
				if(hiddenArray[i]=="false" || hiddenArray[i] =="undefined")
				{ 
					tableStr.push("<td class=\"tab_td2\" width=\"250px\" ><input type=\"checkbox\" id=\""+fieldArray[i]+"\"  checked>" + titleArray[i]  + "</input></td>");
				}
				else
				{
					tableStr.push("<td class=\"tab_td2\" width=\"250px\" ><input type=\"checkbox\" id=\""+fieldArray[i]+"\"   >" + titleArray[i]  + "</input></td>");
					
				}  
				if(hiddenArray[j]=="false" || hiddenArray[j] =="undefined")
				{ 
					tableStr.push("<td class=\"tab_td2\" width=\"250px\" ><input type=\"checkbox\" id=\""+fieldArray[j]+"\"  checked>" + titleArray[j]  + "</input></td>");
				}
				else
				{ 
					tableStr.push("<td class=\"tab_td2\" width=\"250px\" ><input type=\"checkbox\" id=\""+fieldArray[j]+"\" >" + titleArray[j]  + "</input></td>");
					
				}
				tableStr.push("</tr>");
			} 
	  }
	}
	//最后加两行空白行     因为竖直滑动条是相对于整个浏览器的，如果不加下面代码，会有部分字段被  最下面的按钮覆盖(有待优化)
	  /* tableStr.push("<tr>");
	  tableStr.push("<td class=\"tab_td2\"  colspan=2 ></td>");
	  tableStr.push("</tr>");  */
	tableStr.push("</table>");
	document.getElementById("checkTitle").innerHTML = tableStr.join("");
	 
});

function doShowColumns()
{
	var columnFiled =$("#_columnFiled").val();
	var columnTitle =$("#_columnTitle").val();
	  var titleArray=columnTitle.split(',');
	  var fieldArray =columnFiled.split(',');
	  var showColums=""; 
	  var a =1;
	  //判断所有单选框不可全部为空
	  for(var i=0;i<fieldArray.length;i++)
	  { 
		  if(fieldArray[i] !='' && fieldArray[i] !=null)
		  {
		  var checkId=fieldArray[i];  
		  var check=document.getElementById(checkId).checked; 
		  if(!check)
		  {
			  a++;
		   }
		  }
	 } 
     if(a==fieldArray.length)
     {
         alert("不可以隐藏所有列,请至少显示一列");
         return;
     } 
	  for(var i=0;i<fieldArray.length;i++)
	  {
		  if(fieldArray[i] !='' && fieldArray[i] !=null)
		  {
			  var checkId=fieldArray[i]; 
			  var check=document.getElementById(checkId).checked; 
			  if(check)
			  {
				  parent.$('#tt').datagrid('showColumn', fieldArray[i]);
				  var opts =  parent.$('#tt').datagrid('getColumnOption', fieldArray[i]);
				  opts.hidden=false; 
			  }else
			  {
				  parent.$('#tt').datagrid('hideColumn', fieldArray[i]);
				  var opts =  parent.$('#tt').datagrid('getColumnOption', fieldArray[i]);
				  opts.hidden=true; 
			  }
		  }
	  }
	  
	  parent.$("#tt").datagrid("resize");
	  f_close("列表显示");
} 
var checked = false;
function selectAllCheckBox()
{ 
	var flag = document.getElementById("selectAll").checked;
	$("input[type=checkbox]").each(function(){
		$(this).attr("checked", flag);
	});  
}
function doClose()
{
	 
		f_close("列表字段显示与隐藏"); 
	 
}
</script>
</head>
<body>
<input type="hidden" id="_columnFiled" value="${_columnFiled}"/>
<input type="hidden" id="_columnTitle" value="${_columnTitle}"/>
<input type="hidden" id="_columnsHidden" value="${_columnsHidden}"/>
<form name="myform"  method="post"> 
<div class="box_01">
<div class="inner3px"> 
<div class="cell" id ="checkTitle" style="overflow-y:scroll;">
<table> 

</table>
</div>
 <div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg">  
			<a class="btn btn-primary btn-sm ng-scope" href="javascript:doShowColumns();"  ><i class='fa fa-check'></i>&nbsp;&nbsp;确定<b></b></a>
		 
		<a class="btn btn-danger btn-sm ng-scope" href="javascript:doClose();"><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭<b></b></a>  
	</div>
</div>

</div>
</div>
</form>
</body>
</html>