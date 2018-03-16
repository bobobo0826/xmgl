<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>全高项目管理系统</title>

<link rel="shortcut icon" href="/logo/favicon.ico"> 
<link rel="icon" type="image/gif" href="/logo/animated_favicon1.gif" >

<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>
<link
	href="${root}/res/hplus/css/login.css"
	rel="stylesheet"> 
<script>
if (window.top !== window.self) { 
	window.top.location = window.location;
}

$(document).ready(function(){ 
  	 var username=getCookie('username');
  	 var password=getCookie('password');  
  	 if (!isEmpty(username))
  		$("#username").val(username);
  	 if (!isEmpty(password)) {
  		$("#password").val(password);
  		$("#rememberName").attr("checked",true); 
  	 } 
  });
$(document).keydown(function(event) { 
	if(event.keyCode == 13) { 
		login();
	}
});            

function login() {  
	var username =$("#username").val();
    var password =$("#password").val();  
    
    if(isEmpty(username)) {
        $('#login_tips').html('请输入用户名');
        $("#username").focus();
        return;
    }
    if(isEmpty(password)) {
    	$('#login_tips').html('请输入密码'); 
        $("#password").focus();
        return;
    }     

  	var ck = $("input[type='checkbox'][name='rememberName']").is(':checked'); 
  	if (ck) {
  		setCookie('username', username, 365);
  		setCookie('password', password, 365);
  	}
  	else {
  		setCookie('username', '', 365);
  		setCookie('password', '', 365);
  	}
	$.ajax({
			url:"${root}/manage/user/checkUser",
			type: "post",
			async:false,
			data:{username:$("#username").val(),password:$("#password").val()},
			success: function(result) {
				data=JSON.parse(result);
				if (data.result == "OK") {
                    $('#login_tips').html('');
					$('#login_success_tips').html('登录成功正在跳转中...请稍后');
					document.myform.action = "${root}/manage/user/login?subSys=Z1";
		 			document.myform.submit();
				}
				else {
					$('#login_tips').html('用户名或者密码不正确，请重新输入');
					$("#password").focus();
		 			return;
				}
	 		},
	 		error: function() {
	 			$.messager.alert("提示","登录出现异常，请联系系统管理员","error");
				return;
		    }	
		}); 
}
function setCookie(key, value, expiredays) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + expiredays);
	document.cookie = key
			+ "="
			+ escape(value)
			+ ((expiredays == null) ? "" : ";expires="
					+ exdate.toGMTString());
}
function getCookie(key) {
	if (document.cookie.length > 0) {
		c_start = document.cookie.indexOf(key + "=");
		if (c_start != -1) {
			c_start = c_start + key.length + 1;
			c_end = document.cookie.indexOf(";", c_start);
			if (c_end == -1)
				c_end = document.cookie.length;
			return unescape(document.cookie.substring(c_start, c_end));
		}
	}
	return "";
}
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
};
function isEmpty(s) {
	return (s == null || s.trim().length == 0);
}
</script>

</head>

<body class="signin">
	<div class="signinpanel">
		<div class="row">
			<div class="col-sm-7">
				<div class="signin-info">
					<div class="logopanel m-b">
						<h1>[ 全高项目管理系统 ]</h1>
					</div>
					<div class="m-b"></div>
					<h4>
						欢迎使用 <strong> 全高项目管理系统</strong>
					</h4>
					<ul class="m-b">

						<li><i class="fa fa-arrow-circle-o-right m-r-xs"></i> <span class="label label-warning">工作日志记录</span></li>
						<br />

						<li><i class="fa fa-arrow-circle-o-right m-r-xs"></i> <span class="label label-info">...</span></li>
					</ul>
				</div>
			</div>
			<div class="col-sm-5">
				<form method="post" id="myform" name="myform">
					<h4 class="no-margins">登录：</h4>
					<input name="_subSys" type="hidden" id="_subSys" value="Z1"/> 
					<div class="loginform_row"><span id="login_tips"></span><span id="login_success_tips" style="color: #0bb20c"></span></div>
					<input type="text" name="username" id="username" class="form-control uname" placeholder="用户名">
					<input type="password" name="password" id="password" class="form-control pword m-b"	placeholder="密码">
					<input type="checkbox" name="rememberName" id="rememberName" /> 记住密码
					<input type="button" class="btn btn-success btn-block" onclick="javascript:login();" value="立即登录"/>
				</form>
			</div>
		</div>
		
		
		<div class="signup-footer">
			<div class="pull-left">&copy; 2017 All Rights Reserved.</div>
		</div>
	</div>
</body>

</html>