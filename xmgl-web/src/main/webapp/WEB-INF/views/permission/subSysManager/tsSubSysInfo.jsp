<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>子系统信息</title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<script type="text/javascript">
        var isNew=false;
        var myform  = angular.module('myBody', ['ui.bootstrap']).controller('myCtrl', function($scope, $http){
            $scope.model = {};
            var url = "${root}/manage/tsSubSys/getSubSysInfo/" + $("#_subSysId").val();
            if ($("#_subSysId").val()!=0){
				/* 详情界面*/

                document.getElementById("subSysId").setAttribute("readonly","true");
            }
            else {
				/* 新增界面*/
               isNew=true;
                document.getElementById("subSysId").style.cssText= "readonly: false;";
            }
            $http.get(url).success(function(response) {
                $scope.model._model= response._model;

            });

            $scope.processForm = function() {

                if(!checkInputValueIsEmpty()){
                    return;
                }

                layer.confirm('确定保存吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){

                    var url="${root}/manage/tsSubSys/saveSubSysInfo/"+isNew;
                    $scope.model._model.subSysId = $("#subSysId").val();//去掉空格
                    $scope.model._model.subSysName = $("#subSysName").val();
                    $scope.model._model.ssDesc = $("#ssDesc").val();
                    $http({
                        method  : 'POST',
                        url     : encodeURI(encodeURI(url)),
                        data    : $scope.model._model,
                        headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
                    }).success(function(response) {
                        layer.close(index);
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
                    //f_close("newWindow");
                    layer.close(index);
                }, function(index){
                    layer.close(index);
                });
            };
        });
        setModuleRequest(myform);

        //保存之前验证文本框是否为空
        function checkInputValueIsEmpty()
        {
            var es = $("#myform *[required='true']");
            if (es.length > 0)
            {
                for (var i = 0;i < es.length;i++)
                {
                    var e = es[i];
                    if ($.trim($(e).val()) == "")
                    {
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
	<input  type="hidden" id="_subSysId"   value="${subSysId}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-5 control-label">子系统ID：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.subSysId" type="text"
									   class="form-control"  id="subSysId"   name="subSysId" />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-5 control-label">子系统名称：</label>
							<div class="col-sm-6">
								<input ng-model="model._model.subSysName" type="text"
									   class="form-control"  id="subSysName" name="subSysName" />
							</div>
							<div class="col-sm-1">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-5 control-label">子系统描述：</label>
							<div class="col-sm-7">
							<textarea ng-model="model._model.ssDesc" type="text" rows="2"
									  class="form-control"  id="ssDesc" name="ssDesc" required='true'></textarea>
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
		<a class="btn btn-primary btn-sm" href="###" ng-disabled ='!myform.$valid' ng-click="processForm(myform.$valid)"><i class='fa fa-check'></i>保存<b></b></a>
		<a class="btn btn-danger btn-sm" href="###" ng-click="closeForm()"><i class='fa fa-remove'></i>关闭<b></b></a>
	</div>
</div>
</body>
</html>

