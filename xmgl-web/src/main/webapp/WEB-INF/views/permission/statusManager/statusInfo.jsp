<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/5/23
  Time: 14:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
    <title>状态字典详情</title>
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

        var isNew=false;
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {

            $scope.model = {};
            var url = '${root}/manage/status/getStatusById/'+ $("#status_id").val();
            if ($("#status_id").val()!=-1){
                /* 详情界面*/

                document.getElementById("statusId").setAttribute("readonly","true");
            }
            else {
                /* 新增界面*/
                isNew=true;
               document.getElementById("statusId").style.cssText= "readonly: false;";
            }
                $http.get(url).success(function(response) {
                $scope.model.tcStatus = response.tcStatus;
                console.log(response.tcStatus);
                controlButs($scope,$compile);
            })
            $scope.processForm = function(funcCode) {
                if (!validateForm()) {
                    return;
                }
                var msg="";
                switch(funcCode)
                {
                    case 'SAVE':
                        msg="保存"
                        break;
                    case 'TJ':
                        msg="提交"
                        break;
                    default:
                        break;
                }
                layer.confirm('确定'+msg+'吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    /*修改状态界面或者新增输入状态不重名,且输入不为空*/
                    var url="${root}/manage/status/saveStatus/"+isNew;
                    $scope.model.tcStatus.statusId = trim($("#statusId").val());//去掉空格
                    $scope.model.tcStatus.statusName = $("#statusName").val();
                    $scope.model.tcStatus.stalias = $("#stalias").val();
                    if (!isEmpty($('#stdesc').val())) {
                        $scope.model.tcStatus.stdesc = $("#stdesc").val();
                    }
                    $http({
                        method: 'POST',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.tcStatus,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
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
                    layer.close(index);
                }, function(index){
                    layer.close(index);
                });
            };
            })
        setModuleRequest(myform);
        function trim(str)
        {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }
        //对有required=required属性的表单元素，进行必填校验
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

        function controlButs($scope,$compile){
            var html="";

            html+="<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
            /*html+="<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"TJ\")'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;";*/
            html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }
    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input  type="hidden" id="status_id"   value="${id}" />
<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>

    <div class="row">
        <div class="col-sm-12">
        <div class="ibox">
            <div class="ibox-title">
                <h5>状态基本信息</h5>
                <div class="ibox-tools">
                    <a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                </div>
            </div>
            <div class="ibox-content">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">状态ID：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.tcStatus.statusId" type="text" class="form-control"
                                   id="statusId" name="statusId"  required='true'/>
                        </div>
                        <div class="col-sm-2">
                            <span class="text-danger">*</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">状态名称：</label>
                        <div class="col-sm-6">
                            <input type="text" ng-model="model.tcStatus.statusName" class="form-control"
                                   id="statusName" name="statusName"  required='true'/>
                        </div>
                        <div class="col-sm-2">
                            <span class="text-danger">*</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="col-sm-4 control-label" >状态别名：</label>
                        <div class="col-sm-6">
                            <input  type="text" ng-model="model.tcStatus.stalias"  class="form-control"
                                   id="stalias" name="stalias"   required='true'/>
                        </div>
                        <div class="col-sm-2">
                            <span class="text-danger">*</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="col-sm-4 control-label" >描述：</label>
                        <div class="col-sm-6">
                            <input  type="text"  ng-model="model.tcStatus.stdesc" class="form-control"
                                   id="stdesc" name="stdesc"   />
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

