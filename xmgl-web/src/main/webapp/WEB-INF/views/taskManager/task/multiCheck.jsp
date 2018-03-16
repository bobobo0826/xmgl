<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/8/10
  Time: 9:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>批量选择</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <%@ include file="/thirdparty/ke/kindeditor.jsp" %>

    <script type="text/javascript">
        $(document).ready(function(){
            createRichText();
        });
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            controlButs($scope,$compile);
            $scope.confirm = function (funcCode){

                var msg="";
                var conditionCode = "";
                switch (funcCode){
                    case "TG":
                        conditionCode = "YSH";
                        break;
                    case "BTG":
                        conditionCode = "SHBTG";
                        if ($("#check_desc").val()==""){
                            layer.msg("请输入审核意见！");
                            return;
                        }
                        break;
                }
                console.log($("#taskIdListStr").val());
                    var url = "${root}/manage/task/saveMultiCheckDesc";
                    $http({
                        method: 'POST',
                        url: encodeURI(encodeURI(url)),
                        data: {"checkDesc":$("#check_desc").val(),"taskConditionCode":conditionCode,"taskIdListStr":$("#taskIdListStr").val()},
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        parent.layer.msg(response.msgDesc);
                        parent.doQuery();
                        f_close("new_window");
                    });

            };
            $scope.closeForm = function() {
                layer.confirm('确定关闭窗口吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                   f_close("new_window");
                    layer.close(index);
                }, function(index){
                    layer.close(index);
                });
            };
        });
        setModuleRequest(myform);
        function createRichText() {
            var elements = $('.richtext');
            var eObj1 = elements[0];
            var kindEditer1 = createY(eObj1.id);
        }
        function controlButs($scope,$compile){
            var html="";
            html += "<span id = 'tgsh'><a class='btn btn-success btn-sm' href='###' ng-click='confirm(\"TG\")'><i class='fa fa-check'></i>&nbsp;&nbsp;通过审核</a>&nbsp;&nbsp;</span>";
            html += "<span id = 'btgsh'><a class='btn btn-warning btn-sm' href='###' ng-click='confirm(\"BTG\")'><i class='fa fa-remove'></i>&nbsp;&nbsp;不通过审核</a>&nbsp;&nbsp;</span>";
            html +="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }
    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">

<input  type="hidden" id="taskIdListStr"   value="${taskIdListStr}" />

<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>
<div class = "ibox">
    <div class = "ibox-title">
        <h5>批量审核</h5>
    </div>
    <div class = "ibox-content">
        <div id="col-sm-12 check_desc_head">
            <div class=" form-group">
                <label class="col-sm-2 control-label">审核意见</label>
                <div class="col-sm-9">
                    <textarea  type="text" class="form-control richtext" id="check_desc"
                               name="check_desc"></textarea>
                </div>
                <div class="col-sm-1">
                    <span class="text-danger"></span>
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
