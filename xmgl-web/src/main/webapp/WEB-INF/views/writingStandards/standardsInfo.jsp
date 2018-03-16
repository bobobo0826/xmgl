<%--
  Created by fcy.
  User: quangao
  Date: 2017/8/8
  Time: 10:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/res/ui/css/style.css" />
    <script type="text/javascript" src="${pageContext.request.contextPath}/thirdparty/My97DatePicker/WdatePicker.js"  charset="UTF-8"></script>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <%@ include file="/thirdparty/ke/kindeditor.jsp"%>
    <script>
        $(document).ready(function() {
            createRichText();
            $("#order_no").keyup(function(e) {
                var c=$(this);
                if(/[^\d]/.test(c.val())){//替换非数字字符
                    var new_value=c.val().replace(/[^\d]/g,'');
                    $(this).val(new_value);
                }
            });
        });
        function createRichText(){
            var elements=$('.richtext');
            var eObj1 = elements[0];

            kindEditer1=createImg(eObj1.id);

        }
        var myform  = angular.module('body', ['ui.bootstrap']).controller('roleCtrl', function($scope, $http){
            $scope.model = {};
            var url = '${root}/manage/writingStandards/getStandardsInfo?_id='+$("#_id").val()+'&_parentId='+$("#_parentId").val();
            //获取数据
            $http.get(url).success(function(response) {


                if($("#_id").val()!=0){



                    kindEditer1.html(response.standards.standards_content);}

                $scope.model.standards = response.standards;

                if ($scope.model.standards.status=="已发布"){
                    $("#fb").hide();
                }else{
                    $("#cxfb").hide();
                }


                if($scope.model.standards.modifier==""||$scope.model.standards.modify_date==""
                    ||$scope.model.standards.modifier==null||$scope.model.standards.modify_date==null)
                {
                    $("#modifier_hide").hide();
                    $("#modify_date_hide").hide();

                }
                else{
                    $("#modifier_hide").show();
                    $("#modify_date_hide").show();
                }


                // $scope.model.standards.parentRoleName = response.parentRoleName;
            });

            $scope.publish =function () {
                $scope.model.standards.id = $("#_id").val();
                data = {'_id':$("#_id").val()};
                $http({
                    method  : 'POST',
                    url     : encodeURI(encodeURI('${root}/manage/writingStandards/publishStandards')),
                    data    : data,
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded'
                    }

                }).success(function(response) {

                    if (response.msgCode==1) {
//                        $scope.model.standards.status="已发布";
                        window.location.reload();
                        layer.msg(response.msgDesc);

                    } else {
                        layer.msg("发布失败");
                    }

                });
            };
            $scope.unPublish =function () {
                $scope.model.standards.id = $("#_id").val();
                data = {'_id':$("#_id").val()};
                $http({
                    method  : 'POST',
                    url     : encodeURI(encodeURI('${root}/manage/writingStandards/unPublishStandards')),
                    data    : data,
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded'
                    }

                }).success(function(response) {

                    if (response.msgCode==1) {
//                        $scope.model.standards.status="未发布";
                        window.location.reload();
                        layer.msg(response.msgDesc);
                    } else {
                        layer.msg("撤销失败");
                    }
                });
            };
            $scope.processForm = function() {
                if(isEmpty($scope.model.standards.standards_name))
                {
                    $.messager.alert("提示", "规范名称不可为空！", "info");
                    return;
                }

                $scope.model.standards.id = $("#_id").val();
                var newString = $('#standards_content').val().replace("<br />",""  );
                $scope.model.standards.standards_content=newString;

                $http({
                    method  : 'POST',
                    url     : encodeURI(encodeURI('${root}/manage/writingStandards/saveStandardsInfo')),
                    data    : $scope.model.standards,
                    headers : { 'Content-Type': 'application/x-www-form-urlencoded'
                    }

                }).success(function(response) {

                    if (response.msgCode=="success") {
                        var standardsInfo=response.standards;
                        $scope.model.standards=standardsInfo;
                        $("#_id").val($scope.model.standards.id);
                        $("#_parentId").val($scope.model.standards.parent_id);
                        //刷新tree节点
                        parent.reloadTreeNodeById(standardsInfo.parent_id);
                        alert(JSON.stringify(response))
                        layer.msg(response.msgDesc);

                    } else {
                        layer.msg(response.msgDesc);
                    }
                });
            };

            $scope.status = {
                isFirstOpen: true,
                isFirstDisabled: false
            };
        });
        setModuleRequest(myform);
    </script>
</head>

<body ng-app="body" ng-controller="roleCtrl">
<input type="hidden" name="_id" id="_id" value="${_id}">
<input type="hidden" name='_parentId' id="_parentId" value="${_parentId}"/>
<form  class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >规范名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.standards_name" type="text" class="form-control"
                                       id="standards_name" name="standards_name"  required='true'  />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >排序号：</label>
                            <div class="col-sm-6">
                                <input  ng-model="model.standards.order_no"  class="form-control"
                                        id="order_no" name="order_no"  required='true'  />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.status" type="text" class="form-control"
                                       id="status" name="status"  required='true' readonly = "true" />
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">


                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.creator" type="text" class="form-control"
                                       id="creator" name="creator"  required='true' readonly = "true" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.create_date" type="text" class="form-control"
                                       id="create_date" name="create_date" readonly = "true" />
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4" id="modifier_hide">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.modifier" type="text" class="form-control"
                                       id="modifier" name="modifier"   readonly = "true" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4" id="modify_date_hide">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.standards.modify_date" type="text" class="form-control"
                                       id="modify_date" name="modify_date"  readonly = "true" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">规范描述：</label>
                            <div class="col-sm-9">
                                <textarea type="text" ng-model="model.standards.standards_content" class="form-control richtext"
                                          id="standards_content" name="standards_content"   rows ='5' data-ng-trim=“false”></textarea>
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
        <a id="save" class="btn btn-primary btn-sm" href="###"  ng-click='processForm(myform.$valid)'><i class='fa fa-check'></i>&nbsp;&nbsp;保 存<b></b></a>&nbsp;&nbsp;
        <a id="fb"class="btn btn-success btn-sm " href="###"  ng-click='publish(myform.$valid)'><i class='fa fa-check'></i>&nbsp;&nbsp;发 布<b></b></a>
        <a id="cxfb" class="btn btn-danger btn-sm " href="###"  ng-click='unPublish(myform.$valid)'><i class='fa fa-remove'></i>&nbsp;&nbsp;撤销发布<b></b></a>&nbsp;&nbsp;
    </div>
</div>



</body>
</html>
