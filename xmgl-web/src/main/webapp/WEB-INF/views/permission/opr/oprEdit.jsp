
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>操作信息</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
</head>
<script type="text/javascript">
    var supModuleOld = "";
    var isNew = false;
    var myform = angular.module('myBody', ['ui.bootstrap']).controller('myCtrl', function ($scope, $http) {
        $scope.model = {};
        var url = "";
        if ($("#_oprId").val() == "") {
            isNew = true;
            url = "${root}/manage/opr/getOprInfo/" + 0
        } else {
            url = "${root}/manage/opr/getOprInfo/" + $("#_oprId").val()
        }
        $http.get(url).success(function (response) {
            $scope.model._model = response._model;
            if (!isNew) {
                $("#oprUsed").val($scope.model._model.oprUsed);
                $("#sup_module option:selected").val($scope.model._model.supModule);
                getModuleList(response._model.supModule);
                supModuleOld = $scope.model._model.supModule;
            }else{
                getModuleList();
                $("#oprUsed").val(1);
            }
        });

        $scope.processForm = function () {
            if (!checkInputValueIsEmpty()) {
                return;
            }
            layer.confirm('确定保存吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/opr/saveOprInfo/' + isNew;
                $scope.model._model.oprUsed = $("#oprUsed option:selected").val();
                $scope.model._model.supModule = $("#sup_module option:selected").val();
                $http({
                    method: 'POST',
                    url: encodeURI(encodeURI(url)),
                    data: $scope.model._model,
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                }).success(function (response) {
                    layer.close(index);
                    layer.msg(response.msgDesc);
                    parent.doQuery();
                    updateModuleOperateSetByModuleName();
                    f_close("newWindows");
                });
            }, function (index) {
                layer.close(index);
            });
        };

        $scope.closeForm = function () {
            layer.confirm('确定关闭窗口吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                f_close("newWindow");
                layer.close(index);
            }, function (index) {
                layer.close(index);
            });
        };
    });

    setModuleRequest(myform);

    function checkInputValueIsEmpty() {
        var es = $("#myform *[required='true']");
        if (es.length > 0) {
            for (var i = 0; i < es.length; i++) {
                var e = es[i];
                if ($.trim($(e).val()) == "") {
                    layer.tips('该字段必填', '#' + $(e).attr("id"));
                    return false;
                }
            }
        }
        return true;
    }

    function getModuleList(def) {
        var moduleId = document.getElementById("sup_module");
        var url = '${root}/manage/menuModule/getModuleIdList';
        $.ajax({
            type: 'post',
            cache: false,
            url: url,
            success: function (result) {
                moduleId.options.length = 0;
                var fOpt = new Option("", "");
                moduleId.options.add(fOpt);
                if (null != result) {
                    for (var i = 0; i < result.length; i++) {
                        var opt = document.createElement("option");
                        opt.value = result[i].modulename;
                        opt.text = result[i].modulename;
                        moduleId.options.add(opt);
                    }
                    moduleId.value = def;
                }
            },
            error: function () {
                alert("出错!请联系管理员!");
            }
        });
    }

    function updateModuleOperateSetByModuleName() {
        var url1 = '${root}/manage/module/updateModuleOperateSetByModuleName?moduleName=' + $("#sup_module").val();
        $.ajax({
            type: 'post',
            url: url1,
            success: function (result) {
            }
        });
        if (!isNew) {
            var url2 = '${root}/manage/module/updateModuleOperateSetByModuleName?moduleName=' + supModuleOld;
            $.ajax({
                type: 'post',
                url: url2,
                success: function (result) {
                }
            });
        }
    }

</script>
</head>
<body ng-app="myBody" ng-controller="myCtrl">
<form class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <input type="hidden" id="_oprId" value="${oprId}"/>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model._model.oprName" type="text" class="form-control" id="oprName" name="oprName"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作别名：</label>
                            <div class="col-sm-6">
                                <input ng-model="model._model.oprAlias" type="text" class="form-control" id="oprAlias" name="oprAlias" required='true'/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">是否选择：</label>
                            <div class="col-sm-6">
                                <select id="oprUsed" class="form-control">
                                    <option value=0>未选择</option>
                                    <option value=1>已选择</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">所属模块：</label>
                            <div class="col-sm-6">
                                <select name="sup_module" id="sup_module" emptyOption="true" class="form-control" required='true'></select>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">url：</label>
                            <div class="col-sm-6">
                                <input ng-model="model._model.url" type="text" class="form-control" id="url" name="url" required='true'/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">操作描述：</label>
                            <div class="col-sm-9">
                                <textarea ng-model="model._model.oprDesc" type="text" rows="2" class="form-control" id="oprDesc" name="oprDesc" required='true'></textarea>
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
        <a class="btn btn-primary btn-sm" href="###" ng-disabled='!myform.$valid' ng-click="processForm(myform.$valid)"><i class='fa fa-check'></i>保存<b></b></a>
        <a class="btn btn-danger btn-sm" href="###" ng-click="closeForm()"><i class='fa fa-remove'></i>关闭<b></b></a>
    </div>
</div>
</body>
</html>