<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/ui/css/style.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/themes/gray/tabs.css"/> 
<%@ include file="/res/public/easyui_lib.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/common.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/private/js/index/menu.index.js" charset="utf-8"></script>
<title>首页</title>
<style type="text/css"> 
.list_01 a {
display: block;
border-bottom: 1px dotted #EBEBEB;
padding: 2px 0 2px 0px;
line-height: 24px;
}
.handlerName{
text-align: -webkit-left;
}
</style>
 <script>


function Into(str2)
{ 
	var url ="${pageContext.request.contextPath}/notice/noticeDetailCk.action?_noticeId="+str2;
	parent.addTab("公告详细信息",url,"");
}
function moreInfo()
{
	var url ='${pageContext.request.contextPath}/notice/noticeManager.action';
	parent.addTab("公告管理",url,"");
}

</script>
</head> 

<body>  
<form name="form1" action="" method="post">  
<div class="main_cell">
<s:if test="!_user.isSCHOOL() && !_user.isQY()">
<table class="main_table"> 
<tr> 
<td width="50%" valign="top">
<div class="box_01" style="margin:5px 5px 5px 5px;height:400px;" id="noticePromote">
<div class="caption_01"><img src="${pageContext.request.contextPath}/res/private/images/system/arrow_01.png" width="13" height="12"  align="absmiddle"/>公告
<a href="###" class="more" onClick="moreInfo();" style="cursor:hand" >更多</a></div>
<div class="list_01"> 
<table> 
 <tr> 
 	<th width="1%"></th>
    <th width="20%" align="left">标题</th>
    <th width="10%" align="left">发布时间</th> 
  </tr>
<s:iterator value="_noticeList" status="pc">
<tr>
  	<td width="1%" class="date setc"> <s:property value="Num"/></td>
	<td width="20%" align="left" >
	<a href="###" title="<s:property value="TITLE"/>" onClick="Into(<s:property value='ID'/>)" ><s:property value="TITLE"/> </a>
	</td>
	<td width="10%"  > <s:date name="PUBLISH_TIME" format="yyyy-MM-dd HH:mm"   /> </td>
</tr> 
 </s:iterator> 
 </table>
</div>
</div>
</td>  
<td width="50%" valign="top">
<div class="box_01" style="margin:5px 5px 5px 5px ;height:400px;" >
<div class="caption_01"><img src="${pageContext.request.contextPath}/res/private/images/system/arrow_01.png" width="13" height="12"  align="absmiddle"/>Android客户端</div>
<div class="list_01" style="overflow-y:scroll;height:90%;">
<table> 
 <tr>
	 
    <th width="30%" align="left">
    <strong>扫描<span>二维码</span>下载：</strong>
	<p>打开手机上的二维码扫描软件，<br>将摄像头对准二维码图片扫描即可。</p></th>
	<th><img alt="" src="${pageContext.request.contextPath}/apkdownload.gif"></th>
  </tr>
  </table>
</div>
</div>
</td> 
</tr>
</table>
</s:if>
</div> 
</form>
</body> 
</html>