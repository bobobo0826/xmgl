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
        var _funcArray;

        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            $("#role_name").val($("#roleName").val());
            $scope.model = {};
            var url = '${root}/manage/query/getQueryById/'+ $("#id").val();
            $http.get(url).success(function(response) {
                $scope.model.query = response.query;
                controlButs($scope,$compile);
            });
            $scope.processForm = function(funcCode) {
                if(checkInputValueIsEmpty())
                {
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
                        $scope.model.query.role_code = $("#role_code").val();

                        var url="${root}/manage/query/save";
                        $http({
                            method: 'POST',
                            url: encodeURI(encodeURI(url)),
                            data: $scope.model.query,
                            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                        }).success(function (response) {
                            layer.close(index);
                            if (response.msgCode == 'success') {
                                $scope.model.query = response.query;
                                $("#id").val(response.query.id)
                            }
                            layer.msg(response.msgDesc);
                        });

                    }, function(index){
                        layer.close(index);
                    });
                }
                else
                {
                    return;
                }

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

        function selectRole(){
                var url='${root}/manage/query/initRole';
                url=encodeURI(encodeURI(url));
                f_open("selectRole","选择角色", '720px', '480px', url ,true);
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

        function setRoles(codes,names)
        {
             $("#role_code").val(codes);
            $("#role_name").val(names);

        }
    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">

<input type="hidden" id="id" value="${id}"/>
<input  type="hidden" id="roleName" value="${roleName}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>
    <div class="row">
        <div class="ibox">
            <div class="ibox-title">
                <h5>配置详情</h5>
                <div class="ibox-tools">
                    <a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                </div>
            </div>
            <div class="ibox-content">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">模块名称：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.query.bizdata_code"  type="text" class="form-control"
                                   id="bizdata_code" name="bizdata_code" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">查询名称：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.query.query_name" type="text" class="form-control"
                                   id="query_name" name="query_name" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">查询代码：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.query.query_code" type="text" class="form-control"
                                   id="query_code" name="query_code" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">查询表达式：</label>
                        <div class="col-sm-6">
                            <textArea ng-model="model.query.query_expression"  type="text" class="form-control"  style="height:100px;" id="query_expression" name="query_expression" required='true'></textArea>

                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">角色：</label>
                        <div class="col-sm-6">
                            <textArea   type="text" class="form-control"  style="height:100px;" id="role_name" name="role_name" required='true'></textArea>
                                <a class='btn btn-success btn-sm' href='javascript:selectRole();'><i class='fa fa-plus'></i>&nbsp;&nbsp;选择角色</a>
                        </div>
                        <span class="text-danger">*</span>
                        <input ng-model="model.query.role_code" type="hidden" name="role_code" id="role_code" />
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