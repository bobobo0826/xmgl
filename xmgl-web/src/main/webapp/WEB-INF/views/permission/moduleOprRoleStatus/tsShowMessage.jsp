<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<html>
<head>
<title>选择</title>
<link href="${root}/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
 function  changeValue()
 {
	var chkArr=document.myform.moduleID;
	var param=""; 
	var value=""; 
	for(var i=0;i<chkArr.length;i++) 
	{ 
		if(chkArr[i].checked)
	  	{
	  		param+=chkArr[i].value.substring(0,chkArr[i].value.lastIndexOf(":")-1)+",";
	  		value+=chkArr[i].value.substring(chkArr[i].value.lastIndexOf(":")+1)+",";
  		}
	}
	window.returnValue =param+";"+value;
	window.close();
 }
</script>
<style type="text/css">
<!--
body {
	background-color: #FFFFFF;
}
li
{
  white-space:nowrap;
} 
-->
</style>
</head>
<body>
<form  method="post" name="myform">
<%--<table width="100%" border="0">
  <tr><td class="ling_style" width="100%" colspan="2"></td></tr>
  <tr><td height="10" colspan="2"></td></tr>
  <tr>
    <td colspan="2" class="newTd">
      <fieldset style="fieldset_style"><LEGEND><font class="fieldset_font">选择<s:property value="title"/>的功能</font></LEGEND>
      <table width="95%" border="0">
      	<s:checkboxlist list="map" id="roleId" name="moduleID"></s:checkboxlist>
      </table>
      </fieldset>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <table>
        <tr>
         <td><a href="javascript:void(null);" onclick="changeValue();"><img src="${root}/images/button_r.gif" width="71" height="20" border="0"/></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>--%>
</form>
</body>
</html>