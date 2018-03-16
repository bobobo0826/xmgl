<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/5/9
  Time: 14:48
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!doctype html>
<html>
<head>
    <title>项目详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>

    <script type="text/javascript">
        var _funcArray;
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {

            $scope.model = {};
            var url = '${root}/manage/systemconf/getSystemInfo/' + $("#id").val();

            $http.get(url).success(function (response) {
                $scope.model.systemConfBase = response.systemConfBase;
                controlButs($scope, $compile);
            });
            $scope.processForm = function (funcCode) {
                if (checkInputValueIsEmpty()) {
                    layer.confirm('确定保存吗?', {
                            btn: ['确定', '取消'], //按钮
                            shade: false //不显示遮罩
                        }, function (index) {
                            var url = "${root}/manage/systemconf/saveSystem";
                            $http({
                                method: 'POST',
                                url: encodeURI(encodeURI(url)),
                                data: $scope.model.systemConfBase,
                                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                            }).success(function (response) {
                                layer.close(index);
                                if (response.msgCode == 'success') {
                                    $scope.model.systemConfBase = response.systemConfBase;
                                    $("#supplierId").val(response.systemConfBase.id)
                                }
                                layer.msg("保存成功");

                            });
                        },
                        function (index) {

                            layer.close(index);
                        });
                }
                else {
                    return;
                    layer.msg("必填项不能为空");
                }

            };
            $scope.closeForm = function () {
                layer.confirm('确定关闭窗口吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    parent.closeCurTab();
                    layer.close(index);
                }, function (index) {
                    layer.close(index);
                });
            };
        });

        setModuleRequest(myform);

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
        function controlButs($scope, $compile) {
            var html = "";
            html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }


    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="id" value="${id}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>

    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-title">
                  <%--  <h5>信息</h5>--%>
                    <div class="ibox-tools">
                        <a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">配置代码：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.systemConfBase.data_code" type="text" class="form-control"
                                       id="data_code" name="data_code" required="true"/>
                            </div>
                            <span class="text-danger">*</span>
                        </div>
                    </div>

                </div>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">配置名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.systemConfBase.data_value" type="text" class="form-control"
                                       id="data_value" name="data_value"  required="true"/>
                            </div>
                            <span class="text-danger">*</span>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">配置阀值 ：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.systemConfBase.data_desc" type="text" class="form-control"
                                       id="data_desc" name="data_desc"  required="true"/>
                            </div>
                            <span class="text-danger">*</span>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">是否使用：</label>
                            <div class="col-sm-6">
                                <select ng-model="model.systemConfBase.is_used" class="form-control" name="is_used"
                                        id="is_used">
                                    <option value=""></option>
                                    <option value="1">是</option>
                                    <option value="0">否</option>
                                </select>
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
