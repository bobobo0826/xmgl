<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/6/6
  Time: 11:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
    <title>修改密码</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript">
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            $scope.model = {};


                controlButs($scope,$compile);
                $scope.processForm = function(funcCode) {
                    if (!validateForm()) {
                        return;
                    }
                    if($("#newPsw").val().indexOf(" ")>=0){
                        layer.msg('密码不能有空格!');
                        return;
                    }
                    if($("#newPsw").val().length>16){
                        layer.msg('密码长度不能大于16位!');
                        return;
                    }
                    if ($("#newPsw").val()==$("#oldPsw").val()){
                        layer.msg('新设密码必须和原始密码不同!');
                        return;
                    }
                    if ($("#newPsw").val()!=$("#confirm").val()){
                        layer.msg('密码两次输入不一致!');
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
                        var url="${root}/manage/user/updatePassword?_oldPsw="+$("#oldPsw").val()+"&_newPsw="+$("#newPsw").val();
                        $http({
                            method: 'POST',
                            url: encodeURI(encodeURI(url)),

                            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                        }).success(function (response) {
                            layer.close(index);

                            layer.msg(response.msg);
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
            })
        setModuleRequest(myform);
        function controlButs($scope,$compile){
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }
        function validateForm() {
            var es = $("#myform *[required='true']");
            if (es.length > 0) {
                for (var i = 0; i < es.length; i++) {
                    var e = es[i];
                    if ($.trim($(e).val()) == "") {
                        layer.tips('该字段必填', '#' + $(e).attr("id"));
                        $("html,body").animate({scrollTop:$("#"+$(e).attr("id")).offset().top- $("html,body").offset().top +  $("html,body").scrollTop()},1000);
                        return false
                    }
                }
            }
            return true;
        }
    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">
<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-6 control-label">原始密码：</label>
                            <div class="col-sm-4">
                                <input type="password" class="form-control" ng-model="model.oldPsw"
                                       id="oldPsw" name="oldPsw"  required='true'/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-6 control-label">新设密码：</label>
                            <div class="col-sm-4">
                                <input type="password"  class="form-control" ng-model="model.newPsw"
                                       id="newPsw" name="newPsw"  required='true'/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-6 control-label" >确认密码：</label>
                            <div class="col-sm-4">
                                <input  type="password" class="form-control" ng-model="model.confirm"
                                        id="confirm" name="confirm"   required='true'/>
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
<div style="clear: both;height: 35px"></div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">

    </div>
</div>
</body>
</html>

