<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>用户详细信息</title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/dialog.js"  charset="UTF-8"></script>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<script type="text/javascript">
		var myform  = angular.module('myBody', ['ui.bootstrap']).controller('myCtrl', function($scope, $http){
			$scope.model = {};
			console.log("555555555"+$("#userId").val());
			console.log("111111"+$("#isFromEmployee").val());

			var url = "${root}/manage/user/getUserDetail?id="+$("#userId").val();
			$http.get(url).success(function(response) {
                $scope.model._model= response._model;
				$("#userId").val($scope.model._model.id);
				$("#userStatus").val($scope.model._model.userStatus);
				$("#deptId").val($scope.model._model.deptId);
				$("#roleCode").val($scope.model._model.roleCode);
				$("#deptName").val($scope.model._model.deptName);
				$("#displayName").val($scope.model._model.displayName);
				console.log(JSON.stringify($scope.model._model));
                if ($('#isFromEmployee').val()){
                    $scope.model._model.displayName=$("#_displayName").val();
                    $scope.model._model.roleCode=$("#_roleCode").val();
                    $scope.model._model.roleName=$("#_roleName").val();
                    $scope.model._model.deptId=$("#_deptId").val();
                    $scope.model._model.deptName=$("#_deptName").val();
                    $scope.model._model.headPhoto=$("#head_photo").val();
                    $("#roleCode").val($scope.model._model.roleCode);
                    $("#roleName").val($scope.model._model.roleName);
                    $("#deptId").val($scope.model._model.deptId);
                    $("#deptName").val($scope.model._model.deptName);
                } //是否为开户
			});


			$scope.processForm = function() {
				if(!checkInputValueIsEmpty()){
					return;
				}
				$scope.model._model.id=$("#userId").val();

				$scope.model._model.roleName=$("#roleName").val();
				$scope.model._model.roleCode=$("#roleCode").val();
				$scope.model._model.deptId=$("#deptId").val();
				$scope.model._model.deptName=$("#deptName").val();

                $scope.model._model.userStatus=$("#userStatus").val();

				var postUrl = '${root}/manage/user/saveUserInfo';
				$.blockUI();
				$http({
					method  : 'POST',
					url     : encodeURI(encodeURI(postUrl)),
					data    : $scope.model._model,
					headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
				}).success(function(data) {
					$.unblockUI();
					if (data.success) {
						layer.msg(data.msg);
						if ($("#isFromEmployee").val()){
						    console.log(data._model.id);
						    setEmployeeUserId(data._model.id);

                        }
					} else {
						layer.msg(data.msg);
					}
				});
			};
			$scope.closeForm = function() {
				parent.reloadUserList();
				f_close("editUserInfo");
			};
		});
		setModuleRequest(myform);

		//选择主要部门
		function choseDept()
		{
			var url = '${root}/manage/dept/choseDept?_chkStyle=checkbox'+"&_selDept="+$("#deptId").val();
			url=encodeURI(encodeURI(url));
			windowName="deptWindow";
			windowTitle="选择部门";
			width = "20%";
			height = "80%";
			f_open(windowName, windowTitle, width,height, url, true);
		}
		function setDept(deptInfo){
			if(deptInfo==null || deptInfo=="")
				return;
			var dept_name='';
			var dept_id = '';
			for (var i=0;i<deptInfo.length;i++){
                dept_name += deptInfo[i].dept_name+',';
                dept_id += deptInfo[i].id+',';
			}
            dept_name = dept_name.substring(0,dept_name.length-1);
            dept_id = dept_id.substring(0,dept_id.length-1);
            $("#deptName").val(dept_name);
            $("#deptId").val(dept_id);

		}
		function choseRole(){
			var url = '${root}/manage/permission/choseRoleWithId?_chkStyle=checkbox&_selCodes=' + $('#roleCode').val();
			windowName="roleWindow";
			windowTitle="选择角色";
			width = "20%";
			height = "80%";
			f_open(windowName, windowTitle, width,height, url, true);
		}

		function setRole(roleList){
			if(roleList==null || roleList=="")
				return;
            var roleName='';
            var roleCode= '';
            for (var i=0;i<roleList.length;i++){
                roleName += roleList[i].roleName+',';
                roleCode += roleList[i].roleCode+',';
            }
            roleName = roleName.substring(0,roleName.length-1);
            roleCode = roleCode.substring(0,roleCode.length-1);
			$("#roleName").val(roleName);
			$("#roleCode").val(roleCode);
		}

        function setEmployeeUserId(userId){
            var url = "${root}/manage/employee/setEmployeeUserId?employeeId="+$("#employeeId").val()+"&userId="+userId;
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                async : false,
                success: function(result) {
                }
            });
        }

		//保存之前验证文本框是否为空
		function checkInputValueIsEmpty(){
			var es = $("#myform *[required='true']");
			if (es.length > 0) {
				for (var i = 0;i < es.length;i++) {
					var e = es[i];
					if ($.trim($(e).val()) == "") {
						layer.tips('该字段必填', '#' + $(e).attr("id"));
						return false;
					}
				}
			}
			return true;
		}
	</script>
</head>
<body ng-app="myBody" ng-controller="myCtrl">
<form class="form-horizontal"  role="form" id="myform" name="myform"  novalidate>
	<input  type="hidden" id="_displayName"   value="${displayName}"/>
	<input  type="hidden" id="_deptId"   value="${deptId}"/>
	<input  type="hidden" id="_roleCode"   value="${roleCode}"/>
	<input  type="hidden" id="_deptName"   value="${deptName}"/>
	<input  type="hidden" id="_roleName"   value="${roleName}"/>
	<input  type="hidden" id="userId"   value="${id}"/>
	<input  type="hidden" id="employeeId"   value="${employeeId}"/>
	<input  type="hidden" id="isFromEmployee"   value="${isFromEmployee}"/>
	<input  type="hidden" id="head_photo"   value="${head_photo}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">用户名：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.userName" type="text"
									   class="form-control"  id="userName" placeholder="请输入用户名"
									   name="userName" required='true'/>
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">用户名2(手机号)：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.userName2" type="text"
									   class="form-control"  id="userName2" placeholder="请输入手机号"
									   name="userName2" />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">姓名：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.displayName" type="text"
									   class="form-control"  id="displayName" placeholder="请输入姓名"
									   name="displayName" required='true' />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.roleName" type="text"
									   class="form-control" placeholder="请选择角色" id="roleName"
									   name="roleName" disabled="true" required='true' />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
								<input type="hidden"    type="text"
									   id="roleCode" name="roleCode" />
								<a class="btn btn-warning btn-sm" href="javascript:choseRole();">
									<i class='fa fa-search'></i>&nbsp;&nbsp;选择
								</a>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">部门：</label>
							<div class="col-sm-6">
								<input type="text"  ng-model="model._model.deptName"  class="form-control" placeholder="请选择部门" id="deptName"
									   name="deptName" disabled="true" />
							</div>
							<div class="col-sm-2">
								<input   type="hidden" type="text" 	id="deptId" name="deptId" />
								<a class="btn btn-warning btn-sm" href="javascript:choseDept();">
									<i class='fa fa-search'></i>&nbsp;&nbsp;选择
								</a>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">是否启用：</label>
							<div class="col-sm-6">
									<select id="userStatus" class="form-control">
										<option value=""></option>
										<option value='是'>是</option>
										<option value='否'>'否'</option>
									</select>
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-12">
						<div class="form-group">
							<label class="col-sm-2 control-label">用户描述：</label>
							<div class="col-sm-5">
								<textarea ng-model="model._model.userDesc" type="text" class="form-control"  rows="3" id="userDesc" name="userDesc"></textarea>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg">
		<a class="btn btn-primary btn-sm" href="###"  ng-click="processForm(myform.$valid)"><i class='fa fa-check'></i>保存<b></b></a>
		<a class="btn btn-danger btn-sm" href="###" ng-click="closeForm()"><i class='fa fa-remove'></i>关闭<b></b></a>
	</div>
</div>
</body>
</html>