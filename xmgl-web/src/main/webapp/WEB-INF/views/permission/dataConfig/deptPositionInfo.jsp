<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/angularjs.jsp"%>
<%@ include file="/res/public/msg.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script>
<script type="text/javascript" src="${root}/thirdparty/My97DatePicker/WdatePicker.js" scharset="UTF-8"></script>
<script type="text/javascript" src="${root}/res/public/js/constant.js" charset="UTF-8" scharset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/thirdparty/layer/skin/layer.css" />
<script type="text/javascript" src="${root}/thirdparty/layer/layer.js" charset="UTF-8"></script>
<script type="text/javascript" src="${root}/res/public/js/biz/form.js" charset="UTF-8"></script>
<script type="text/javascript">
   //获取数据
   var myform  = angular.module('mybody', ['ui.bootstrap']).controller('myCtrl', function($scope,$compile, $http){
   $scope.model = {};
   var id=$("#_id").val();
   getInfo(id);
   function getInfo(id)
   {
	   var url='${root}/dataConfig/queryInfo.action?_id='+id+"&_deptId="+$('#_deptId').val();
       $http.get(url).success(function(response) {
           $scope.model._positionDept=response._positionDept;
           $('#deptName').val(response.deptName);
           $('#deptId').val(response._positionDept.deptId);
       });
   }
   //保存    
   $scope.processForm = function(v,funcCode) {
       if(!checkInputValueIsEmpty())
       {
           return;
       }   
       $.messager.confirm("提示","确定保存吗?",function (f){
           if(f){
        	   $scope.model._positionDept.deptId = $('#deptId').val();
               var url="${root}/dataConfig/saveInfo.action";
	           $http({
	               method  : 'POST',
	               url     : encodeURI(encodeURI(url)),
	               data    : $scope.model,  
	               headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
	           }).success(function(data) {
                   if (data.success) {
                       $('#_id').val(data._positionDept.id);    //重新获取界面上的id
                       $scope.model._positionDept=data._positionDept;
                       layer.alert(data.msg);
                   } else {
                	   layer.alert(data.msg);
                   }
               });
           }});
       };
       //关闭当前按钮
       $scope.closeForm=function(){
                   f_close('editUserInfo');
           };
});
setModuleRequest(myform);

//保存之前验证文本框是否为空
function checkInputValueIsEmpty()
{
   var es = $("#myform *[required]");
   if (es.length > 0) 
   {
       for (var i = 0;i < es.length;i++) 
       {
           var e = es[i];
           if ($.trim($(e).val()) == "")
           {
               layer.tips('该字段必填', '#' + $(e).attr("id"));
               return false;
           }
       }
   }
   return true;
} 
</script>
</head>
<body ng-app="mybody" ng-controller="myCtrl">
<form  collapse="isCollapsed" class="form-horizontal"  role="form" id="myform" name="myform"  novalidate>
<%--<s:hidden  name="_id" id="_id"></s:hidden>
<s:hidden  name="_deptId" id="_deptId"></s:hidden>--%>
<div class="box_01">
<div class="inner6px">
<div class="cell">
		<%--<table>
			<tr>
				<th width="20%">部门:</th>
				<td>
					<input  class="form_text" id="deptName" name="deptName" readonly/>
					<input ng-hide="true"  class="form_text" id="deptId" name="deptId" />
				</td>
				<th width="20%">岗位:</th>
				<td>
				    <s:select list="_position" listKey="id" listValue="data_name" emptyOption="true" id="position" name="position"  ng-model="model._positionDept.positionId"  cssClass="form_list" required='true'/>
					<sapn class='red'>*</sapn>
				</td>
			</tr>
			<tr>
				<th>岗位等级:</th>
				<td>
				   <input style="width:202px" ng-model="model._positionDept.positionLevel"  class="form_list" id="positionLevel" name="positionLevel" required='true'/>
				   <sapn class='red'>*</sapn>
				</td>
				<th width="25%">是否启用</th>
				<td>
			        <s:select list="#{'1':'是','0':'否'}"  ng-model="model._positionDept.isUsed" id="isUsed" name="isUsed" emptyOption="false"  class="form_list" required='true'/>
 					<sapn class='red'>*</sapn>
 				</td>
			</tr>
		</table>--%>
</div>
</div>
<div class="inner6px">
<div class="cell">
</div>
</div>
</div>
   </form> 
   <!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
   <div style="margin-top:100px;">
   <div class="main_btnarea">
       <div class="btn_area_setc btn_area_bg">
           <a class="btn_01" href="javascript:void(0);" ng-disabled="!myform.$valid" ng-click="processForm(myform.$valid)" id="save">保存<b></b></a>
           <a class="btn_01" href="javascript:void(0);" ng-click="closeForm()">关闭<b></b></a>
       </div>
   </div>
   </div>
</body>
</html>
