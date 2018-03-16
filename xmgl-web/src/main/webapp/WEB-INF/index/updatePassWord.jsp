<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改密码</title>
<%@ include file="/res/public/hplus.jsp"%>
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/angularjs.jsp"%>
<%@ include file="/res/public/msg.jsp"%>
<%@ include file="/res/public/common.jsp"%>
<script type="text/javascript">
function doSure()
{
	
	var password = document.getElementById("oldPas").value;
	var newPassword = document.getElementById("newPas").value;
	var newPassword1 = document.getElementById("surePas").value;
	if (password=="" || password==null) {
		$.messager.alert("提示", "原密码不允许为空！", "info");
		$("#oldPas").focus();
		return;
	}
	if (newPassword=="" || newPassword==null) {
		$.messager.alert("提示", "新密码不允许为空！", "info");
		 $("#newPas").focus(); 
		return;
	} 
	if (newPassword1=="" || newPassword1==null) {
		$.messager.alert("提示", "重新输入密码框不允许为空！", "info");
		 $("#surePas").focus(); 
		return;
	}
	if (newPassword != newPassword1) {
		$.messager.alert("提示", "两次输入密码不相等，请重新输入！", "info");
		$("#newPas").val("");  
		$("#surePas").val(""); 
		$("#newPas").focus();  
		return;
	} 
	var URL='${pageContext.request.contextPath}/permission/checkPassWord.action?_newPas='+newPassword+'&_oldPas='+password; 
	URL = encodeURI(encodeURI(URL));
	$.ajax({
		  type: 'POST',
		  url: URL, 
		  success: function(result) {
					if (result.success) {
		            	clickautohide(4,'修改密码成功!');
					} else {

		            	clickautohide(4,'修改密码失败!');
					}
				},
				error:function() {
					 clickautohide(4,'修改密码失败!');
				}		  
		});

}
function closeForm()
{
	parent.closeCurTab();
}
</script>
</head>
<body>
<form name="form1" method="post">
<div class="row">
      <div class="col-sm-12">
				<div class="ibox">
				   <div class="ibox-content-noboder">
						<div class="col-sm-12">
							<div class="form-group">
							     <div class="col-sm-3">
								</div>
								<label class="col-sm-1 control-label">原始密码：</label>
								<div class="col-sm-4">
								 <input  class="form-control" id="oldPas" name="_oldPas"  type="passWord"/>
								</div>
								<div class="col-sm-1">
									<span class="text-danger">*</span>
								</div>
							</div>
						</div>
					</div>
				</div>
	</div>
</div>
<div class="row">
 <div class="col-sm-12">
				<div class="ibox">
				<div class="ibox-content-noboder">
					<div class="col-sm-12">
						<div class="form-group">
							    <div class="col-sm-3">
								</div>
								<label class="col-sm-1 control-label">新设密码：</label>
								<div class="col-sm-4">
									<input class="form-control" id="newPas" name="_newPas" type="passWord"/> 
								</div>
								<div class="col-sm-1">
									<span class="text-danger">*</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
</div>
<div class="row">
<div class="col-sm-12">
				<div class="ibox">
				<div class="ibox-content-noboder">
						<div class="col-sm-12">
							<div class="form-group">
							    <div class="col-sm-3">
								</div>
								<label class="col-sm-1 control-label">确认密码：</label>
								<div class="col-sm-4">
									<input class="form-control" id="surePas" name="_surePas" type="passWord"/>
								</div>
								<div class="col-sm-1">
									<span class="text-danger">*</span>
								</div>
							</div>
						</div>
						</div>
				</div>
			</div>
</div>
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg">
		<a class="btn btn-primary btn-sm" href="javascript:doSure();"><i class='fa fa-check'></i>确认<b></b></a>
	 	<a class="btn btn-danger btn-sm" href="###"  onclick='closeForm()'><i class='fa fa-remove'></i>关闭<b></b></a>
	</div>
</div>
</form>
</body>
</html>