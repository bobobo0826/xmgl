<%@ page language="java" contentType="text/html; charset=GBK" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>南京全高信息科技有限公司后台权限管理发布系统</title>
</head>
<frameset rows="64,*,50" cols="*" frameborder="no" border="0" framespacing="0">
  <frame src="${root}/permission/common/top.jsp" name="topFrame" scrolling="No" noresize="noresize" id="topFrame"/>
  <frameset cols="173,10,*" frameborder="no" border="0" framespacing="0" id="mainframe">
    <frame src="${root}/permission/common/left.jsp" name="leftFrame" scrolling="yes" noresize="noresize" id="leftFrame"/>
    <frame src="${root}/permission/common/hidde.jsp" name="hiddeFrame" scrolling="No" noresize="noresize" id="hiddeFrame"/>
    <frame src="${root}/permission/common/right.jsp" name="mainFrame" id="mainFrame" scrolling="yes"/>
  </frameset>
  <frame src="${root}/permission/common/bottom.jsp"  name="downFrame" scrolling="No" noresize="noresize" id="downFrame"/>
</frameset>

</html>