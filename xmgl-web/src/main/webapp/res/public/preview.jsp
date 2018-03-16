<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/dialog/layer/layer.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/public/js/dialog/layer/skin/layer.css" /> 
<script type="text/javascript">
function printPreview(url) {
	$.layer({
        type : 2,
        title : '打印预览',
        offset : ['150px', ''],
        iframe : {
            src : url
        },	
        area : ['960px','600px']
    });
}
</script>
