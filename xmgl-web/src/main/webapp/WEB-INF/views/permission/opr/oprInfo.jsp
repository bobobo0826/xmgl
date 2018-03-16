<%--<%@ page language="java" contentType="text/html; charset=UTF-8"%>--%>
<%--<html>--%>
<%--&lt;%&ndash;<head>&ndash;%&gt;--%>
<%--&lt;%&ndash;<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />&ndash;%&gt;--%>
<%--&lt;%&ndash;<title>操作信息</title>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/res/public/hplus.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;s<%@ include file="/res/public/easyui_lib.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/res/public/common.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/res/public/angularjs.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/res/public/msg.jsp"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<script>&ndash;%&gt;--%>
	<%--&lt;%&ndash;$(document).ready(function(){&ndash;%&gt;--%>
		<%--&lt;%&ndash;$("#checkBoxList").html();&ndash;%&gt;--%>
		<%--&lt;%&ndash;if(!isEmpty($("#_checkBoxListStr").val())){&ndash;%&gt;--%>
			<%--&lt;%&ndash;var checkBoxList=JSON.parse($("#_checkBoxListStr").val());&ndash;%&gt;--%>
			<%--&lt;%&ndash;var html="";&ndash;%&gt;--%>
			<%--&lt;%&ndash;for(var i=0;i<checkBoxList.length;i++){&ndash;%&gt;--%>

			<%--&lt;%&ndash;}&ndash;%&gt;--%>
		<%--&lt;%&ndash;}&ndash;%&gt;--%>
	<%--&lt;%&ndash;});&ndash;%&gt;--%>

	<%--&lt;%&ndash;var myform  = angular.module('myBody', ['ui.bootstrap']).controller('myCtrl', function($scope, $http){&ndash;%&gt;--%>
		<%--&lt;%&ndash;$scope.processForm = function() {&ndash;%&gt;--%>
			<%--&lt;%&ndash;layer.confirm('确定保存吗?', {&ndash;%&gt;--%>
				<%--&lt;%&ndash;btn: ['确定','取消'], //按钮&ndash;%&gt;--%>
				<%--&lt;%&ndash;shade: false //不显示遮罩&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;var url='${root}/manage/opr/tcOprEdit';&ndash;%&gt;--%>
				<%--&lt;%&ndash;$http({&ndash;%&gt;--%>
					<%--&lt;%&ndash;method  : 'POST',&ndash;%&gt;--%>
					<%--&lt;%&ndash;url     : encodeURI(encodeURI(url)),&ndash;%&gt;--%>
					<%--&lt;%&ndash;data    : $scope.model._model,&ndash;%&gt;--%>
					<%--&lt;%&ndash;headers : { 'Content-Type': 'application/x-www-form-urlencoded' }&ndash;%&gt;--%>
				<%--&lt;%&ndash;}).success(function(response) {&ndash;%&gt;--%>
					<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
					<%--&lt;%&ndash;if(response.msgCode=='success'){&ndash;%&gt;--%>
						<%--&lt;%&ndash;parent.$('#tt').datagrid('load');&ndash;%&gt;--%>
					<%--&lt;%&ndash;}&ndash;%&gt;--%>
					<%--&lt;%&ndash;layer.msg(response.msgDesc);&ndash;%&gt;--%>
				<%--&lt;%&ndash;});&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
			<%--&lt;%&ndash;});&ndash;%&gt;--%>
		<%--&lt;%&ndash;};&ndash;%&gt;--%>

		<%--&lt;%&ndash;$scope.initOpr = function() {&ndash;%&gt;--%>
			<%--&lt;%&ndash;layer.confirm('确定初始化操作吗?', {&ndash;%&gt;--%>
				<%--&lt;%&ndash;btn: ['确定','取消'], //按钮&ndash;%&gt;--%>
				<%--&lt;%&ndash;shade: false //不显示遮罩&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;var url='${root}/manage/opr/tcOprEmpty';&ndash;%&gt;--%>
				<%--&lt;%&ndash;$http({&ndash;%&gt;--%>
					<%--&lt;%&ndash;method  : 'POST',&ndash;%&gt;--%>
					<%--&lt;%&ndash;url     : encodeURI(encodeURI(url)),&ndash;%&gt;--%>
					<%--&lt;%&ndash;headers : { 'Content-Type': 'application/x-www-form-urlencoded' }&ndash;%&gt;--%>
				<%--&lt;%&ndash;}).success(function(response) {&ndash;%&gt;--%>
					<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
					<%--&lt;%&ndash;if(response.msgCode=='success'){&ndash;%&gt;--%>
						<%--&lt;%&ndash;parent.$('#tt').datagrid('load');&ndash;%&gt;--%>
					<%--&lt;%&ndash;}&ndash;%&gt;--%>
					<%--&lt;%&ndash;layer.msg(response.msgDesc);&ndash;%&gt;--%>
				<%--&lt;%&ndash;});&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
			<%--&lt;%&ndash;});&ndash;%&gt;--%>
		<%--&lt;%&ndash;};&ndash;%&gt;--%>

		<%--&lt;%&ndash;$scope.closeForm = function() {&ndash;%&gt;--%>
			<%--&lt;%&ndash;layer.confirm('确定关闭窗口吗?', {&ndash;%&gt;--%>
				<%--&lt;%&ndash;btn: ['确定','取消'], //按钮&ndash;%&gt;--%>
				<%--&lt;%&ndash;shade: false //不显示遮罩&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;f_close("newWindow");&ndash;%&gt;--%>
				<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
			<%--&lt;%&ndash;}, function(index){&ndash;%&gt;--%>
				<%--&lt;%&ndash;layer.close(index);&ndash;%&gt;--%>
			<%--&lt;%&ndash;});&ndash;%&gt;--%>
		<%--&lt;%&ndash;};&ndash;%&gt;--%>
	<%--&lt;%&ndash;});&ndash;%&gt;--%>
	<%--&lt;%&ndash;setModuleRequest(myform);&ndash;%&gt;--%>
<%--&lt;%&ndash;</script>&ndash;%&gt;--%>
<%--&lt;%&ndash;</head>&ndash;%&gt;--%>
<%--&lt;%&ndash;<body ng-app="myBody" ng-controller="myCtrl">&ndash;%&gt;--%>
<%--&lt;%&ndash;<form class="form-horizontal"  role="form" id="myform" name="myform"  novalidate>&ndash;%&gt;--%>
	<%--&lt;%&ndash;<input  type="hidden" id="_checkBoxListStr"   value="${checkBoxListStr}"/>&ndash;%&gt;--%>
	<%--&lt;%&ndash;<div class="row">&ndash;%&gt;--%>
		<%--&lt;%&ndash;<div class="col-sm-12">&ndash;%&gt;--%>
			<%--&lt;%&ndash;<div class="ibox">&ndash;%&gt;--%>
				<%--&lt;%&ndash;<div class="ibox-content">&ndash;%&gt;--%>
					<%--&lt;%&ndash;<div class="col-md-4">&ndash;%&gt;--%>
						<%--&lt;%&ndash;<div class="form-group">&ndash;%&gt;--%>
							<%--&lt;%&ndash;<label class="col-sm-4 control-label">操作功能：</label>&ndash;%&gt;--%>
							<%--&lt;%&ndash;<div class="col-sm-6" id="checkBoxList">&ndash;%&gt;--%>

							<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
						<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
					<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
				<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
			<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
		<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
	<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;</form>&ndash;%&gt;--%>
<%--&lt;%&ndash;<div class="main_btnarea">&ndash;%&gt;--%>
	<%--&lt;%&ndash;<div class="btn_area_setc btn_area_bg">&ndash;%&gt;--%>
		<%--&lt;%&ndash;<a class="btn btn-primary btn-sm" href="###" ng-disabled ='!myform.$valid' ng-click="processForm(myform.$valid)"><i class='fa fa-check'></i>保存<b></b></a>&ndash;%&gt;--%>
		<%--&lt;%&ndash;<a class="btn btn-primary btn-sm" href="###" ng-click="initOpr()"><i class='fa fa-check'></i>操作功能初始化<b></b></a>&ndash;%&gt;--%>
		<%--&lt;%&ndash;<a class="btn btn-danger btn-sm" href="###" ng-click="closeForm()"><i class='fa fa-remove'></i>关闭<b></b></a>&ndash;%&gt;--%>
	<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;</div>&ndash;%&gt;--%>
<%--//</body>--%>
<%--</html>--%>