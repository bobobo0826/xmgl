

<!DOCTYPE html>
<html lang="zh-cn">

<head>
	<title>全高项目管理系统</title>
	<meta charset="utf-8">
	<%@ include file="/res/public/loginStyle.jsp"%>
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
                        document.loginForm.action = "${root}/manage/user/login?subSys=Z1";
                        document.loginForm.submit();
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

<body class="page-login layout-full page-dark">

<div class="page height-full">
	<div class="page-content height-full">
		<div class="page-brand-info vertical-align animation-slide-left hidden-xs">
			<div class="page-brand vertical-align-middle">
				<div class="brand">
					<%--<img class="brand-img" src="logo/animated_favicon1.gif" height="20" alt="全高项目管理系统">--%>
				</div>
				<h2 class="hidden-sm">全高项目管理系统</h2>
				<ul class="list-icons hidden-sm">
					<li>
						<i class="wb-check" aria-hidden="true"></i> 项目管理系统是一个基于最新微服务，云计算开发的先进办公类项目
					</li>
					<li><i class="wb-check" aria-hidden="true"></i> 主要提供项目管理，任务管理，日常工作记录等服务</li>
					<li><i class="wb-check" aria-hidden="true"></i> 项目管理系统 紧贴业务特性，涵盖了大量的常用组件和基础功能。
					</li>
				</ul>
			</div>
		</div>
		<div class="page-login-main animation-fade">

			<div class="vertical-align">
				<div class="vertical-align-middle">
					<div class="brand visible-xs text-center">
						<%--<img class="brand-img" src="res/login/picture/logo.svg" height="50" alt="Admui">--%>
					</div>
					<h3 class="hidden-xs">登录项目管理系统</h3>
					<form class="login-form" method="post" id="loginForm" name="loginForm">
						<div class="loginform_row"><span id="login_tips"></span><span id="login_success_tips" style="color: #0bb20c"></span></div>
						<div class="form-group">
							<label class="sr-only" for="username">用户名</label>
							<input type="text" class="form-control" id="username" name="loginName" placeholder="请输入用户名">
						</div>
						<div class="form-group">
							<label class="sr-only" for="password">密码</label>
							<input type="password" class="form-control" id="password" name="password" placeholder="请输入密码">
						</div>
						<div class="form-group clearfix">
							<div class="checkbox-custom checkbox-inline checkbox-primary pull-left">
								<input type="checkbox" id="rememberName" name="rememberName">
								<label for="rememberName">自动登录</label>
							</div>
						<%--	<div class="pull-right">
								<a href="http://www.admui.com/?sendUrl=http%3A%2F%2Fdemo.admui.com%2Flogin#register" target="_blank">注册账号</a>
								·
								<a class="collapsed" data-toggle="collapse" href="#forgetPassword" aria-expanded="false" aria-controls="forgetPassword">
									找回密码
								</a>
							</div>--%>
						</div>
						<button type="button" class="btn btn-primary btn-block margin-top-30" onclick="javascript:login();">立即登录</button>
					</form>
				</div>
			</div>
			<footer class="page-copyright">
				<p>南京全高科技有限责任公司 &copy;
					<%--<a href="http://www.admui.com" target="_blank">quangao.com</a>--%>
				</p>
			</footer>
		</div>
	</div>
</div>
</body>

</html>
