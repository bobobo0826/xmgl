<%--
  Created by IntelliJ IDEA.
  User: ccr
  Date: 2017/8/15
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目字典详情</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript">
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            $scope.model = {};
            var url = '${root}/manage/dictionary/getDictionaryInfoById/'+ $("#id").val();
            $http.get(url).success(function(response) {
                getBusinessTypeList();
                $scope.model.dictionary = response.dictionary;
                controlButs($scope,$compile);
                /**
                 * 把下拉框中数据填到默认下拉列表
                 */
                $('#businesstype').val($scope.model.dictionary.business_type);
                controlButs($scope,$compile);

                $("#id").val($scope.model.dictionary.id);
                if(!isEmpty($("#id").val())){
                    $("#business_type").attr("readonly",true);
                }
            });
            $scope.processForm = function(funcCode) {
                if(!checkInputValueIsEmpty()){
                    return;
                }
                switch(funcCode)
                {
                    case 'SAVE':
                        break;
                    default:
                        break;
                }
                layer.confirm('确定保存吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){

                    var businessName = $('#businesstype option:selected').text();
                    $scope.model.dictionary.id=$("#id").val();
                    $scope.model.dictionary.business_name=businessName;
                    var url="${root}/manage/dictionary/saveDictionary/";
                    $http({
                        method: 'PUT',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.dictionary,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                        if (response.msgCode == 'success') {
                            $scope.model.dictionary= response.dictionary;
                            $("#id").val(response.dictionary.id);
                            $('#tt').datagrid('reload');
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
                    $('#tt').datagrid('reload');
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
        var businessTypeList;
        function getBusinessTypeList(){
            var url = "${root}/manage/dictionary/getBusinessTypeList";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url:url,
                type:'get',
                async:false,
                success:function(result){
                    addSelectOption(result.businessTypeList,"businesstype");
                    businessTypeList=result.businessTypeList;

                }
            })
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

    </script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="id" value="${id}"/>
<input type="hidden" id="businessTypeList" value="${businesstype}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form"  id="myform" name="myform" novalidate>
    <div class="row">
        <div class="ibox">
            <div class="ibox-content">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">业务类型编码：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.dictionary.business_type" type="text" class="form-control"
                                   id="business_type" name="business_type" required="true" placeholder="编码要与名称对应"/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">业务类型名称:</label>
                        <div class="col-sm-6">
                            <select  class="form-control"  name="businesstype" id="businesstype" >
                            </select>
                        </div>
                        <span class="text-danger">*</span>

                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">数据类型编码：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.dictionary.data_code" type="text" class="form-control"
                                   id="data_code" name="data_code" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">数据类型名称：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.dictionary.data_name"  type="text" class="form-control"
                                   id="data_name" name="data_name" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">数据描述：</label>
                        <div class="col-sm-6">
                            <input ng-model="model.dictionary.data_desc" type="text" class="form-control"
                                   id="data_desc" name="data_desc" required='true'/>
                        </div>
                        <span class="text-danger">*</span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">是否使用：</label>
                        <div class="col-sm-6">
                            <select ng-model="model.dictionary.is_used" type="select" class="form-control"
                                    id="is_used" name="is_used" required='true'>
                                <option value="1">是</option>
                                <option value="0">否</option>
                            </select>
                        </div>
                        <span class="text-danger">*</span>
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

