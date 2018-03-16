<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<%--<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/common.js"  charset="UTF-8"></script>--%>
	<%--<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/libs/css/form.css" />--%>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/ui/css/style.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/thirdparty/My97DatePicker/WdatePicker.js"  charset="UTF-8"></script>
	<!--hplus-->
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<script>
		$(document).ready(function() {
		});
		var myform  = angular.module('body', ['ui.bootstrap']).controller('roleCtrl', function($scope, $http){
			$scope.model = {};
			var url = '${root}/manage/permission/getRoleInfo?_id='+$("#_id").val()+'&_parentId='+$("#_parentId").val();
			//获取数据
			$http.get(url).success(function(response) {
				$scope.model._model = response._model;
				$scope.model._model.parentRoleName = response.parentRoleName;
			});
			$scope.processForm = function() {
				if(isEmpty($scope.model._model.roleCode))
				{
					$.messager.alert("提示", "角色编号不可为空！", "info");
					return;
				}
				if(isEmpty($scope.model._model.roleName))
				{
					$.messager.alert("提示", "角色名称不可为空！", "info");
					return;
				}
				$scope.model._model.id = $("#_id").val();
				$http({
					method  : 'POST',
					url     : encodeURI(encodeURI('${root}/manage/permission/saveRoleInfo')),
					data    : $scope.model._model,
					headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
				}).success(function(response) {
					if (response.msgCode=="success") {
						var roleInfo=response._model;
						$scope.model._model=roleInfo;
						$("#_id").val($scope.model._model.id);
						$("#_parentId").val($scope.model._model.parentId);
						//刷新tree节点
						window.parent.reloadTreeNodeById(roleInfo.parentId);
						layer.msg(response.msgDesc);
					} else {
						layer.msg(response.msgDesc);
					}
				});
			};
			$scope.status = {
				isFirstOpen: true,
				isFirstDisabled: false
			};
		});
		setModuleRequest(myform);
	</script>
</head>

<body ng-app="body" ng-controller="roleCtrl"  >
<form class="form-horizontal"  role="form" id="myform" name="myform"  novalidate   >
	<input type="hidden" name='_parentId' id="_parentId" value="${_parentId}"/>
	<input type="hidden" name="_id" id="_id" value="${_id}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色编号：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.roleCode"  class="form-control"   id="roleCode" name="roleCode"  />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色名称：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.roleName"  class="form-control"   id="roleName" name="roleName"  />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">上级角色名称：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.parentRoleName" readOnly class="form-control"   id="parentRoleName" name="parentRoleName"  />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色描述：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.roleDesc"  class="form-control"   id="roleDesc" name="roleDesc"  />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">排序号：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.orderNo"  class="form-control"   id="orderNo" name="orderNo"  />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg" id="operator">
		<a class="btn btn-success btn-sm" href="###" ng-disabled ='!myform.$valid' ng-click="processForm(myform.$valid)">保 存<b></b></a>
	</div>
</div>
</body>
</html>