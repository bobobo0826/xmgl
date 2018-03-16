<%--
  Created by IntelliJ IDEA.
  User: wch
  Date: 2017-07-07
  Time: 17:00 下午
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目模块信息</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <script type="text/javascript"
            src="http://api.map.baidu.com/api?v=2.0&ak=HH0Ze3kk1ZuopsMXfMP8bbzqQDxaGSMg"></script>
</head>
<body>
<body ng-app="body" ng-controller="moduleCtrl">
<input type="hidden" id="moduleId" value="${moduleId}"/>
<input type="hidden" id="project_name" value="${projectName}"/>
<input type="hidden" id="project_id" value="${projectId}"/>
<input type="hidden" id="parent_id" value="${parentId}"/>
<input type="hidden" id="level" value="${level}"/>
<form method="post" class="form-horizontal" name="myform" id="myform">
    <div class="ibox-content">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">项目名称：</label>
                            <div class="col-sm-7">
                                <input type="hidden" name="parentId" id="parentId">
                                <%--<input type="hidden" ng-model="model._model.projectId" name="projectId" id="projectId">--%>
                                <input ng-model="model._model.projectName" readOnly type="text" class="form-control"
                                       id="projectName" name="projectName" required='true'>
                            </div>
                        </div>
                    </div>
                    <%--     <div class="col-sm-7">
                             <div class="form-group">
                                 <label class="col-sm-2 control-label">父模块名称：</label>
                                 <div class="col-sm-7">
                                     <input type="hidden" ng-model="model._model.parentId"
                                            name="parentId" id="parentId">
                                     <input	ng-model="model._model.parentModuleName" readOnly type="text" 	class="form-control" id="parentModuleName" name="parentModuleName" required='true'>
                                 </div>
                             </div>
                         </div>--%>
                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">模块名称：</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="moduleName"
                                       ng-model="model._model.moduleName" name="moduleName" required='true'/>
                            </div>
                            <div class="col-sm-3">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">模块编码：</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control"
                                       ng-model="model._model.moduleCode" name="moduleCode" id="moduleCode"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-7">
                        <div class=" form-group">
                            <label class="col-sm-2 control-label">模块状态：</label>
                            <div class="col-sm-7">
                                <div class="radio radio-info radio-inline">
                                    <input class="rdlActive" type="radio" id="working" value="ZX" name="moduleStatus"
                                           checked="">
                                    <label for="working"> 在行 </label>
                                </div>
                                <div class="radio radio-danger radio-inline">
                                    <input class="rdlActive" type="radio" id="stop" value="ZZ" name="moduleStatus">
                                    <label for="stop">终止</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">模块描述：</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control"
                                       ng-model="model._model.moduleDesc" name="moduleDesc" id="moduleDesc"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-7">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">排序：</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control"
                                       ng-model="model._model.orderNum" name="orderNum" id="orderNum"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<div class="row">
    <div class="col-sm-7">
        <div class="col-sm-12">
            <div class="btn_area_setc btn_area_bg" id="oprToolBar" style="display: none">
                <a class="btn btn-sm btn-success" href="###" ng-click="processForm(myform.$valid)"><i
                        class='fa fa-check'></i>&nbsp;&nbsp;保存模块<b></b></a>&nbsp;&nbsp;
            </div>
        </div>
    </div>
</div>

</body>
<script>
    var _funcArray;
    var _curModuleCode = "${_curModuleCode}";
    var myform = angular.module('body', ['ui.bootstrap']).controller('moduleCtrl', function ($scope, $http) {
        //配置保存模块权限
        _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);
        if (_funcArray != null && _funcArray != undefined) {
            for (var i = 0; i < _funcArray.length; i++) {
                var funcObj = _funcArray[i];
                switch (funcObj) {
                    case 'saveModule':
                        $("#oprToolBar").show();
                        break;
                    default:
                        break;
                }
            }
        }
        $scope.model = {};
        //获取数据
        var url = '${root}/manage/projectModule/getProjModuleInfo?moduleId=' + $("#moduleId").val() + '&parentId=' + $("#parent_id").val();
        $http.get(url).success(function (response) {
            $scope.model._model = response._model;
            $("#projectName").val($("#project_name").val());
            $("#parentId").val($scope.model._model.parentId);
            $("input[name='moduleStatus'][value='" + $scope.model._model.moduleStatusCode + "']").attr("checked", 'true');
        });
        $scope.processForm = function () {
            $scope.model._model.parentId = $("#parentId").val();
            $scope.model._model.projectId = $("#project_id").val();
            $scope.model._model.level = $("#level").val();
            $scope.model._model.id = $("#moduleId").val();
            $scope.model._model.moduleName = $("#moduleName").val();
            $scope.model._model.ModuleCode = $("#ModuleCode").val();
            $scope.model._model.ModuleDesc = $("#ModuleDesc").val();
            $scope.model._model.orderNum = $("#orderNum").val();
            $scope.model._model.moduleStatusCode = $("input[name='moduleStatus']:checked").val();
            $http({
                method: 'POST',
                url: encodeURI(encodeURI('${root}/manage/projectModule/saveProjModuleInfo')),
                data: $scope.model._model,
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            }).success(function (response) {
                if (response.msgCode == "success") {
                }
                layer.msg(response.msgDesc);
            }, function (index) {
                layer.close(index);
            });
        };
    });
    setModuleRequest(myform);

</script>
</body>
</html>