<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/7/24
  Time: 14:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
    <title>更新日志详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <%@ include file="/thirdparty/ke/kindeditor.jsp"%>

    <script type="text/javascript">

        $(document).ready(function(){
            createRichText();
        });
        function createRichText(){
            var elements=$('.richtext');
            var eObj1 = elements[0];

            kindEditer1=createImg(eObj1.id);

        }
        var _funcArray;
        var _curModuleCode = '${_curModuleCode}';



        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);

            $scope.model = {};
            var url = '${root}/manage/updateLogManage/getUpdateLogInfoById?id='+ $("#_id").val();

            $http.get(url).success(function(response) {

                if($("#_id").val()!=0){



                kindEditer1.html(response.updateLog.content);}

                $scope.model.updateLog = response.updateLog;

                controlButs($scope,$compile);

            });
            $scope.processForm = function(funcCode) {
                if (!validateForm()) {
                    return;
                }
                var msg="";
                switch(funcCode)
                {
                    case 'SAVE':
                        msg="保存";
                        break;
                    case 'FB':
                        msg="发布";
                        break;
                    case 'CXFB':
                        msg="撤销发布";
                        break;
                    default:
                        break;
                }

                layer.confirm('确定'+msg+'吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                   // $scope.model.updateLog.id=$("#id").val();
                    var url="${root}/manage/updateLogManage/saveUpdateLogInfo/";
                   // $scope.model.updateLog.crea
                   // alert(JSON.stringify($scope.model.updateLog));
                   // alert("操作成功");
                    $scope.model.updateLog.content=$('#content').val();
                    if (funcCode === 'FB'){
                        $scope.model.updateLog.status="已发布";}

                    if (funcCode === 'CXFB'){
                        $scope.model.updateLog.status="草稿";}


                    $http({
                        method: 'PUT',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.updateLog,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                    if (response.msgCode == 1) {
                      $scope.model.updateLog= JSON.parse(response.msgData);
                         $("#id").val( $scope.model.updateLog.id)

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
                    parent.closeCurTab();
                    layer.close(index);
                }, function(index){
                    layer.close(index);
                });
            };
        });
        setModuleRequest(myform);



        function controlButs($scope,$compile){
            var html="";
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'saveUpdateLog':
                        html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                           break;
                        case'publishUpdateLog':
                            if ($scope.model.updateLog.status != "已发布") {
                                html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"FB\")'><i class='fa fa-check'></i>&nbsp;&nbsp;发布</a>&nbsp;&nbsp;";
                            } else {
                                html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"CXFB\")'><i class='fa fa-check'></i>&nbsp;&nbsp;撤销发布</a>&nbsp;&nbsp;";

                            }
                            break;
                        default:
                            break;

                    }
                }
            }
            html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";
            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }

        //对有required=required属性的表单元素，进行必填校验
        function validateForm() {
                    var es = $("#myform *[required='true']");
                    if (es.length > 0) {
                        for (var i = 0; i < es.length; i++) {
                            var e = es[i];
                            if ($.trim($(e).val()) == "") {
                                layer.tips('该字段必填', '#' + $(e).attr("id"));
                                $("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
                                return false
                            }
                        }
            }
            return true;
        }
    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="_id" value="${id}">

<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >标题：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.title" type="text" class="form-control"
                                       id="title" name="title"  required='true'  />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >更新日期：</label>
                            <div class="col-sm-6">
                                <input  ng-model="model.updateLog.update_date"  class="form-control"
                                       id="update_date" name="update_date"  required='true'  />
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

    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">


                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.creator" type="text" class="form-control"
                                       id="creator" name="creator"  required='true' readonly = "true" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.create_date" type="text" class="form-control"
                                       id="create_date" name="create_date" readonly = "true" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.status" type="text" class="form-control"
                                       id="status" name="status"  required='true' readonly = "true" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.modifier" type="text" class="form-control"
                                       id="modifier" name="modifier"   readonly = "true" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.updateLog.modify_date" type="text" class="form-control"
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
                            <label class="col-sm-2 control-label">内容：</label>
                            <div class="col-sm-9">
                                <textarea type="text" ng-model="model.updateLog.content" class="form-control richtext"
                                          id="content" name="content"   rows ='5'></textarea>
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
