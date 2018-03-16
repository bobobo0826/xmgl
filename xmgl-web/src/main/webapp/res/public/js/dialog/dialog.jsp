<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/public/js/dialog/artDialog4.1.7/skins/blue.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/dialog/artDialog4.1.7/jquery.artDialog.source.js?skin=blue"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/dialog/artDialog4.1.7/plugins/iframeTools.source.js"></script>
<script type="text/javascript">
function ShowArtDlg(title, url, width, height, lock) {  
    if (width == null || width == "") {  
        width = '90%';  
    }  
    if (!width.indexOf('px') && !width.indexOf('%')) {  
        width = width + 'px';  
    }  
    if (width.indexOf('px') < 0 && width.indexOf('%') < 0) {  
        width = width + 'px';  
    }  
    if (height == null || height == "") {  
        height = '90%';
    }  
    if (height.indexOf('px') < 0 && height.indexOf('%') < 0) {  
        height = height + 'px';  
    }  
    if (lock == null || lock == "") {  
        lock = false;  
    }  
    art.dialog.open(url, { height: height, width: width, title: title, lock: lock }, false); //打开子窗体  
}
/**
 * 覆写window.alert方法
 */
function alert(msg) {
	return $.dialog.alert(msg);
}

</script>
</head>
</html>