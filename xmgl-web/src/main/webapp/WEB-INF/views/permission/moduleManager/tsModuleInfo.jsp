<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<title>项目失利补偿申请</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<!--hplus-->
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<%@ include file="/res/public/common.jsp"%>

	<script type="text/javascript">
		var _funcArray;
		var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {

			$scope.model = {};
			var url = '${root}/manage/module/getTsModuleInfo?moduleId='+ $("#_id").val();
			$http.get(url).success(function(response) {
				$scope.model.module = response._model;
				if(response.oprset!=null&&response.oprset!='null'){
					$("#oprSet").val(response.oprset);
				}else{
                    $("#oprSet").val();
				}
				controlButs($scope,$compile);
				if(typeof($scope.model.module.type)!="undefined"){
                    $("input[value="+$scope.model.module.type+"]").attr('checked', 'true')
				}

			});
			$scope.processForm = function(funcCode) {
				if (!validateForm()) {
					return;
				}
				$scope.model.module.moduleId = $("#moduleId").val();
				$scope.model.module.oprSet = $("#oprSet").val();
                $scope.model.module.type = $("input[name='type']:checked").val();
				layer.confirm('确定保存吗?', {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
					var url="${root}/manage/module/saveTsModuleInfo";
					$http({
						method  : 'POST',
						url     : encodeURI(encodeURI(url)),
						data    : $scope.model.module,
						headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
					}).success(function(response) {
						layer.close(index);
						if(response.msgCode=='success'){
							$scope.model.module= response._model;
							$("#_id").val(response._model.moduleId);
							$("#oprSet").val(response.oprset);
						}
						layer.msg(response.msgDesc);

					});
				}, function(index){

					layer.close(index);
				});

			};
			$scope.closeForm = function() {
				layer.confirm('确定关闭窗口吗?', {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
						parent.closeCurTab();
					layer.close(index);
				}, function(index){
					layer.close(index);
				});
			};
		});
		setModuleRequest(myform);

		function controlButs($scope,$compile){
			var html="";
			html+="<a class='btn btn-primary btn-sm' href='###' ng-click='processForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
			html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";
			var template = angular.element(html);
			var element =$compile(template)($scope);
			angular.element("#operator").empty();
			angular.element("#operator").append(element);
		}

		//对有required=required属性的表单元素，进行必填校验
		function validateForm() {
				var es = $("#myform *[required='true']");
				if (es.length > 0) {
					for (var i = 0; i < es.length; i++) {
						var e = es[i];
						if ($.trim($(e).val()) == "") {
							layer.tips('该字段必填', '#' + $(e).attr("id"));
							$("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
							return false
						}
					}
				}
			return true;
		}
		function selInsDicDataByType()
		{
			var url="${root}/manage/module/selectOperSetWithAll?opr="+$("#oprSet").val();
			width = '60%';
			height = '60%';
			f_open("selectOper", "选择操作集", width, height,encodeURI(url), true);
		}
		function setSelectOperValue(id,param)
		{
			$("#oprSet").val(param);
		}
	</script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<form collapse="isCollapsed" class="form-horizontal" role="form"
	  id="myform" name="myform" novalidate>
	<input type="hidden" id="_id" value="${moduleId}">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块编号：</label>
							<div class="col-sm-6">
								<input ng-model="model.module.moduleId" type="text" class="form-control"
									   id="moduleId" name="moduleId"  required='true'/>
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >模块名：</label>
							<div class="col-sm-6">
								<input ng-model="model.module.moduleName" type="text" class="form-control"
									   id="moduleName" name="moduleName"  required='true'  />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块描述：</label>
							<div class="col-sm-6">
								<input ng-model="model.module.moduleDesc" type="text" class="form-control"
									   id="moduleDesc" name="moduleDesc"   />
							</div>
						</div>
					</div>
					<div class="col-md-6" type="hidden">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块操作集：</label>
							<div class="col-sm-6">
								<input class="form-control" id="oprSet" name="oprSet" value="0"/>
							</div>
							<div class="col-sm-2">
								<%--<span class="text-danger">*</span>--%>
								<%--<a class="tab_td1" href="javascript:selInsDicDataByType()">操作集</a>--%>
							</div>
						</div>
					</div>
					<div class="col-sm-6" style="height:38px">
						<div class=" form-group">
							<label class="col-sm-4 control-label">类别：</label>
							<div class="col-sm-8">
								<div class="radio radio-success radio-inline">
									<input type="radio" id="ZJ" value="ZJ" name="type"  />
									<label for="ZJ"> 组件 </label>
								</div>
								<div class="radio radio-warning radio-inline">
									<input type="radio" id="LJ" value="LJ" name="type" checked=""/>
									<label for="LJ"> 链接</label>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >模块调用url/组件：</label>
							<div class="col-sm-6">
								<input ng-model="model.module.callMethod" type="text" class="form-control"
									   id="callMethod" name="callMethod"  required='true'  />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >调用参数：</label>
							<div class="col-sm-6">
								<input ng-model="model.module.moduleCallArgs" type="text" class="form-control"
									   id="moduleCallArgs" name="moduleCallArgs"  />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg" id="operator">

	</div>
</div>
</body>
</html>
