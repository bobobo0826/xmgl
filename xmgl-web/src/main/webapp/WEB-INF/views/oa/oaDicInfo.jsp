<%--
  Created by IntelliJ IDEA.
  User: ccr
  Date: 2017/8/23
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>详情</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript">
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            $scope.model = {};
            var url = '${root}/manage/materials/getDictionaryInfoById/'+ $("#id").val();
            $http.get(url).success(function(response) {
                $scope.model.maDictionary = response.maDictionary;
                $("#id").val($scope.model.maDictionary.id);
                $("#count").val("${count}");
                controlButs($scope,$compile);
            });
            $scope.processForm = function(funcCode) {
                if(!checkInputValueIsEmpty()){
                    return;
                }
                var msg="";
                switch(funcCode)
                {
                    case 'SAVE':
                        msg="保存"
                        break;
                    default:
                        break;
                }
                layer.confirm('确定'+msg+'吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    $scope.model.maDictionary.id=$("#id").val();
                    var url="${root}/manage/materials/saveDictionary/";
                    $http({
                        method: 'PUT',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.maDictionary,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                        if (response.msgCode == 'success') {
                            $scope.model.maDictionary= response.maDictionary;
                            $("#id").val(response.maDictionary.id);
                            $('#tt').datagrid('reload');
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
                    $('#tt').datagrid('reload');
                    parent.closeCurTab();
                    alert("curtab");
                    layer.close(index);
                }, function(index){
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

        function controlButs($scope,$compile){
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }
    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="id" value="${id}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form"  id="myform" name="myform" novalidate>
    <div class="row">
        <div class="ibox">

            <div class="ibox-content">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">物品类别：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.maDictionary.materials_type" type="text" class="form-control"
                                   id="materials_type" name="materials_type" required="true" />
                        </div>
                        <span class="text-danger">*</span>

                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">字典码：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.maDictionary.dictionary_code" type="text" class="form-control"
                                   id="dictionary_code" name="dictionary_code" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">型号：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.maDictionary.model" type="text" class="form-control"
                                   id="model" name="model" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">价格（元）：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.maDictionary.price" type="text" class="form-control"
                                   id="price" name="price" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">数量：</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="count" name="count" />
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">单位：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.maDictionary.unit" type="text" class="form-control"
                                   id="unit" name="unit" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">
    </div>
</div>
</body>
</html>


