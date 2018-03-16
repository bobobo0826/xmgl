<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script> <!-- 工具 -->
	<script>

		function updatePassword() {
			var oldPassword = $("#oldPassword").val();
			var newPassword = $("#newPassword").val();
			var confirmNewPassword = $("#confirmNewPassword").val();
			if (isEmpty(oldPassword)) {
				alert("请输入原密码");
				return;
			}
			if (isEmpty(oldPassword)) {
				alert("请输入新密码");
				return;
			}
			if (isEmpty(confirmNewPassword)) {
				alert("请输入确认新密码");
				return;
			}
			if (newPassword != confirmNewPassword) {
				alert("确认密码和新密码不一致，请重新填写");
				$("#confirmNewPassword").val("");
				return;
			}
			if (confirm("是否确定修改密码？")) {
				var url = "${root}/manage/user/updatePassword?newPassword="+newPassword+"&oldPassword="+oldPassword;
				$.ajax({
					type : 'post',
					cache : false,
					url : url,
					success : function(result) {
						if(result.success) {
							alert(result.msg);
							cancel();
							return;
						}
						else {
							alert(result.msg);
							return;
						}
					},
					error : function() {
						alert("出错了，请联系管理员");
						return;
					}
				});
			}
		}
		function cancel() {
			$("#oldPassword").val("");
			$("#newPassword").val("");
			$("#confirmNewPassword").val("");
		}
	</script>
	<style type="text/css">

	</style>
</head>

<body>
<form class="form-horizontal" role="form" id="myform" name="myform">
	<input type="hidden" id="departmentCode" name="departmentCode"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-2 control-label">密码：</label>
							<div class="col-sm-3">
								<input type="password"  class="form-control" id="oldPassword"
									   name="oldPassword" required='true' />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-2 control-label">确认密码：</label>
							<div class="col-sm-3">
								<input type="password"  class="form-control" id="newPassword"
									   name="newPassword" required='true' />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-2 control-label">确认密码：</label>
							<div class="col-sm-3">
								<input type="password"  class="form-control" id="confirmNewPassword"
									   name="confirmNewPassword" required='true' />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<div class="col-sm-7" align="center">
								<a class='btn btn-primary btn-sm' href="javascript:updatePassword();"><i class='fa fa-check'></i>&nbsp;&nbsp;确定</a>&nbsp;&nbsp;
								<a class='btn btn-danger btn-sm'  href="javascript:cancel();"><i class='fa fa-remove'></i>&nbsp;&nbsp;取消</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

</body>
</html>