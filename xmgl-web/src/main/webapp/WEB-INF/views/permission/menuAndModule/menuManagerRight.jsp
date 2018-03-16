<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
			var url="";
			if($("#_parentId").val()!=""){
				url='${root}/manage/menuModule/getMenuModuleAddInfo?_parentId='+$("#_parentId").val()+"&_pid="+$("#_pid").val();
			}else{
				url = '${root}/manage/menuModule/getMenuModuleInfo?_id='+$("#_id").val();
			}
			//获取数据
			$http.get(url).success(function(response) {
				$scope.model._model = response._model;
				if(response._model.subSysId!=""&&response._model.subSysId!=null){
					$("#subSysId").val(response._model.subSysId);
				}
				$("#level").val(response._model.level);
				$("#menuModuleId").val(response._model.menuModuleId);
				$("#menuItemId").val(response._model.menuItemId);
				$("#_id").val(response._model.menuFlag);
				$("#isLeaf").val(response._model.isLeaf);
				$("#menuItemIndex").val(response._model.menuItemIndex);
				$("#_modelIdOld").val(response._model.moduleId);
				getModuleList(response._model.moduleId);
			});
			$scope.processForm = function() {
				layer.confirm('确定保存吗?', {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
				$scope.model._model.menuFlag = $("#_id").val();
				$scope.model._model.menuModuleId = $("#menuModuleId").val();
				$scope.model._model.subSysId = $("#subSysId").val();
				$scope.model._model.menuItemId = $("#menuItemId").val();
				$scope.model._model.level = $("#level").val();
				$scope.model._model.isLeaf = $("#isLeaf").val();
				$scope.model._model.menuItemIndex = $("#menuItemIndex").val();
				$scope.model._model.moduleId =$("#moduleId").val();
				var url= '${root}/manage/menuModule/saveMenuModuleInfo';
				$http({
					method  : 'POST',
					url     : encodeURI(encodeURI(url)),
					data    : $scope.model._model,
					headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
				}).success(function(response) {
					if (response.msgCode=="success") {
						var roleInfo=response._model;
						$scope.model._model=roleInfo;
						//$("#_id").val($scope.model._model.id);
						//$("#_parentId").val($scope.model._model.parentId);
						//刷新tree节点
						//window.parent.reloadTreeNodeById(roleInfo.parentId);
						layer.msg(response.msgDesc);
					} else {
						layer.msg(response.msgDesc);
					}
				});
				}, function(index){

					layer.close(index);
				});

			};
			$scope.status = {
				isFirstOpen: true,
				isFirstDisabled: false
			};
		});
		setModuleRequest(myform);

		function getModuleList(def){
				var moduleId = document.getElementById("moduleId");
				var url = '${root}/manage/menuModule/getModuleIdList';
				$.ajax({
					type : 'post',
					cache : false,
					url : url,
					async : false,
					success : function(result) {
						//var data = result.v;
						moduleId.options.length = 0;
						var fOpt = new Option("", "");
						moduleId.options.add(fOpt);
						if (null != result) {
							for (var i=0; i < result.length; i++){
								var opt = document.createElement("option");
								opt.value = result[i].id;
								opt.text = result[i].name;
								moduleId.options.add(opt);
							}
							moduleId.value = def;
						}
					},
					error : function() {
						alert("出错!请联系管理员!");
					}
				});
		}
	</script>
</head>

<body ng-app="body" ng-controller="roleCtrl"  >
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg" id="operator">
		<a class="btn btn-success btn-sm" href="###" ng-disabled ='!myform.$valid' ng-click="processForm(myform.$valid)">保 存<b></b></a>
	</div>
</div>
<form class="form-horizontal"  role="form" id="myform" name="myform"  novalidate>
	<input type="hidden" name="_id" id="_id" value="${_id}">
	<input type="hidden" name="_parentId" id="_parentId" value="${_parentId}">
	<input type="hidden" name="_pid" id="_pid" value="${_pid}">
	<input type="hidden" name="menuModuleId" id="menuModuleId" value="${menuModuleId}" />
	<input type="hidden" name="subSysId" id="subSysId" value="${subSysId}" />
	<input type="hidden" name="menuItemId" id="menuItemId" value="${menuItemId}"  />
	<input type="hidden" name="level" id="level" value="${level}" />
	<input type="hidden" name="isLeaf" id="isLeaf" value="${isLeaf}" />
	<input type="hidden" name="menuItemIndex" id="menuItemIndex" value="${menuItemIndex}"/>
	<input type="hidden" name="_modelIdOld" id="_modelIdOld" value="${_modelIdOld}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">菜单ID：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.menuFlag"  class="form-control"   id="menuFlag" name="menuFlag" readonly />
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">菜单名称：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.menuItemName"  class="form-control"   id="menuItemName" name="menuItemName"  />
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">菜单顺序：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.menuOrder"  class="form-control"   id="menuOrder" name="menuOrder"  />
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">上级菜单ID：</label>
							<div class="col-sm-6">
								<input  ng-model="model._model.parentItemId"  class="form-control"   id="parentItemId" name="parentItemId"  readonly/>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="form-group">
							<label class="col-sm-4 control-label">菜单对应模块：</label>
							<div class="col-sm-6">
								<select name="moduleId" id="moduleId" emptyOption="true"  class="form-control"></select>
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