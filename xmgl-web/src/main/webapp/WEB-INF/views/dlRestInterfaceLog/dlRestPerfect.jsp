<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html>
<head>
    <title>项目详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>

    <script type="text/javascript">
        var _funcArray;
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {

            $scope.model = {};
            var url = '${root}/manage/DlRestInterfaceLog/getDlRestInfo/' + $("#id").val();
/*            alert(url);*/
            $http.get(url).success(function (response) {
                $("#create_date").val($("#date").val());
                $scope.model.dlRestInterfaceLogBase = response.dlRestInterfaceLogBase;
                controlButs($scope, $compile);
               /* alert(JSON.stringify($scope.model.dlRestInterfaceLogBase ));*/
            });

            $scope.closeForm = function (index) {
                parent.closeCurTab();
                layer.close(index);
            };
        });


        setModuleRequest(myform);

        function controlButs($scope, $compile) {
            var html = "";
            /* html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";*/
            html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }


    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="id" value="${id}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>

    <div class="row">
        <div class="ibox">
            <div class="ibox-content">
               <%-- <div class="ibox-title">
                    &lt;%&ndash;  <h5>信息</h5>&ndash;%&gt;
                    <div class="ibox-tools">
                        <a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
                    </div>
                </div>--%>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">物流公司：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.logistics_company_name" type="text"
                                       class="form-control"
                                       id="logistics_company_name" name="logistics_company_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.interface_name" type="text"
                                       class="form-control"
                                       id="interface_name" name="interface_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口类型：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.interface_type_code" type="text"
                                       class="form-control"
                                       id="interface_type_code" name="interface_type_code" required="true" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口类型名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.interface_type_name" type="text"
                                       class="form-control"
                                       id="interface_type_name" name="interface_type_name" required="true" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口描述：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.interface_mark" type="text"
                                       class="form-control"
                                       id="interface_mark" name="interface_mark" required="true" readonly/>
                            </div>
                        </div>
                    </div>
                   <div class="col-md-4">
                       <div class="form-group">
                           <label class="col-sm-4 control-label">创建时间 ：</label>
                           <div class="col-sm-6">
                               <input ng-model="model.dlRestInterfaceLogBase.request_time" class="form-control"
                                      type="text"
                                      id="request_time" name="request_time" readonly/>
                           </div>
                       </div>
                   </div>
                   <%-- <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">调用状态：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.request_status_code" type="text"
                                       class="form-control"
                                       id="request_status_code" name="request_status_code" required="true" readonly/>
                            </div>
                        </div>
                    </div>--%>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">调用状态：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.request_status_name" type="text"
                                       class="form-control"
                                       id="request_status_name" name="request_status_name" required="true" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">调用状态名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.request_status_mark" type="text"
                                       class="form-control"
                                       id="request_status_mark" name="request_status_mark" required="true" readonly/>
                            </div>
                        </div>
                    </div>
                   <div class="col-md-4">
                       <div class="form-group">
                           <label class="col-sm-4 control-label">接口地址：</label>
                           <div class="col-sm-6">
                                <textarea ng-model="model.dlRestInterfaceLogBase.interface_url" type="text"
                                          class="form-control"
                                          rows="2" id="interface_url" name="interface_url" required="true"
                                          readonly></textarea>
                           </div>
                       </div>
                   </div>
<%--
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">company_id：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.logistics_company_id" type="text"
                                       class="form-control"
                                       id="logistics_company_id" name="logistics_company_id" required="true" readonly/>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">business_id：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.dlRestInterfaceLogBase.business_id" type="text"
                                       class="form-control"
                                       id="business_id" name="business_id" required="true" readonly/>
                            </div>
                        </div>
                    </div>--%>

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
