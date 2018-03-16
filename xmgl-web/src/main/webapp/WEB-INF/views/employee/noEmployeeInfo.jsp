<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/7/24
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的个人信息</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script>
    var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
        $scope.model = {};
        var url = '${root}/manage/employee/getNoEmployeeInfo';
        $http.get(url).success(function(response) {
            $scope.noEmployeeInfo=response.noEmployeeInfo;
        });

    });
    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">
<div>
    <div class="col-md-4">
        <input type="hidden"/>
    </div>
    <div class="col-md-4">
        <div class=" form-group">
            <label class="col-sm-4 control-label"></label>
                <h1>{{ noEmployeeInfo}}</h1>
        </div>
    </div>
    <div class="col-md-4">
        <input type="hidden"/>
    </div>
</div>
</body>
</html>
