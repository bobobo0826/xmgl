
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/dialog/msgbox/js/msgbox.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/public/js/dialog/msgbox/css/msgbox.css" /> 
<script type="text/javascript">
/**
 * 1:服务器繁忙，请稍后再试。
 * 2:保存成功！
 * 3:数据加载失败。
 * 4:正在加载中，请稍后...
 */
function clickme(i){
	ZENG.msgbox.show(tip, i);
}
function clickhide(){
	ZENG.msgbox._hide();
}
function clickautohide(i, tip){
	ZENG.msgbox.show(tip, i, 2000);
}
</script>
