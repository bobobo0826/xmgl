<%--
  Created by fcy.
  User: quangao
  Date: 2017/8/23
  Time: 15:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
    <title>物品管理详情</title>
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
            getGoodsStateList();

            $scope.model = {};
            var url = '${root}/manage/materials/getGoodsInfoById?id='+ $("#_id").val();

            $http.get(url).success(function(response) {


                if($("#_id").val()!=0){




                    kindEditer1.html(response.materials.goods_info);}


                $scope.model.materials = response.materials;


                controlButs($scope,$compile);
                var dictionary_code = "";
                if ($scope.model.materials.dictionary_code != null) {
                    dictionary_code = $scope.model.materials.dictionary_code;
                }
                getGoodsTypeList(dictionary_code);
                selectModel(dictionary_code);

                $("#materials_status").val(response.materials.materials_status);
//                $("#employee_name").val(response.materials.employee_name);


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
                    case 'BF':
                        msg="报废";
                        break;
                    case 'HS':
                        msg="回收";
                        break;
                    default:
                        break;
                }

                layer.confirm('确定'+msg+'吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    $scope.model.materials.materials_status = $("#materials_status").val();
                    $scope.model.materials.dictionary_code = $("#materials_type").val();


                    var url="${root}/manage/materials/saveGoodsInfo/";

                    $scope.model.materials.goods_info=$('#goods_info').val();
                    $scope.model.materials.employee_name=$('#employee_name').val();
                    $scope.model.materials.buy_date=$('#buy_date').val();

                    if (funcCode === 'HS'){
                        $scope.model.materials.materials_status="闲置";
                        $scope.model.materials.employee_id="";
                        $scope.model.materials.employee_name="";
                        window.location.reload();
                    }

                    if (funcCode === 'BF'){
                        $scope.model.materials.materials_status="报废";
                        $scope.model.materials.employee_id="";
                        $scope.model.materials.employee_name="";
                        window.location.reload();
                    }


                    $http({
                        method: 'PUT',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.materials,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                        if (response.msgCode == 1) {
                            $scope.model.materials= JSON.parse(response.msgData);
                            $("#id").val( $scope.model.materials.id)

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

        function getGoodsStateList() {

            var url = "${root}/manage/materials/getGoodsStateList";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: false,
                success: function (result) {
                    addSelectOption(result.goodsStateList, "materials_status");

                }
            });
        }
        function getGoodsTypeList(value) {

            var url = "${root}/manage/materials/getGoodsTypeList";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: false,
                success: function (result) {

                    addSelectOption1(result.goodsTypeList, "materials_type");

                    $("#materials_type").val(value);


                }
            });
        }
        function addSelectOption(selectListValue,selectKey){
            $("#"+selectKey).append("<option ></option>");
            for(var i=0;i<selectListValue.length;i++){
                $("#"+selectKey).append("<option  value="+selectListValue[i].data_name+">"+selectListValue[i].data_name+"</option>");
            }

        }
        function addSelectOption1(selectListValue,selectKey){
            $("#"+selectKey).append("<option ></option>");
            for(var i=0;i<selectListValue.length;i++){
                $("#"+selectKey).append("<option  value="+selectListValue[i].dictionary_code+">"+selectListValue[i].materials_type+"</option>");
            }

        }
        function addSelectOption2(selectListValue,selectKey){
            $("#"+selectKey).append("<option ></option>");
            for(var i=0;i<selectListValue.length;i++){
                $("#"+selectKey).append("<option  value="+selectListValue[i].dictionary_code+">"+selectListValue[i].model+"</option>");
            }

        }

        function selectEmployee(){
            var url="${root}/manage/materials/selectEmployee?_curModuleCode=XMCYRY";
            var width="80%";
            var height="80%";
            f_open("newWindow","选择员工",width,height,url,true);
        }
        function setEmployeeInfo(object){
            $("#employee_id").val(object.employee_id);
            $("#employee_name").val(object.employee_name);

        }

        function selectModel(value) {

            var type=$("#materials_type").val();
            var url = "${root}/manage/materials/getModelByType?type="+type ;
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'get',
                cache : false,
                async : false,
                success:function(result)
                {

                    $("#model").empty();
                    addSelectOption2(result.list, "model");

                    $("#model").val(value);

                }
            });
        }

        function controlButs($scope,$compile){
            var html="";
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'saveGoods':
                            html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                            break;
                        case'scrapGoods':

                                html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"BF\")'><i class='fa fa-check'></i>&nbsp;&nbsp;报废</a>&nbsp;&nbsp;";
                          break;
                        case 'recoveryGoods':
                                html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"HS\")'><i class='fa fa-check'></i>&nbsp;&nbsp;回收</a>&nbsp;&nbsp;";
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
<input type="hidden" id="goodsStateList" value="${goodsStateList}"/>

<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >编号：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.materials.materials_code" type="text" class="form-control"
                                       id="materials_code" name="materials_code"  required='true'  />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >物品类别：</label>
                            <div class="col-sm-6">
                                <select  class="form-control" id="materials_type" name="materials_type"
                                         required='true' onchange="selectModel()"></select>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >型号：</label>
                            <div class="col-sm-6">
                                <select   class="form-control" id="model" name="model"  required='false'></select>
                            </div>
                        </div>
                    </div>



                    <div class="col-md-4" style="display:none;">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >当前员工id：</label>
                            <div class="col-sm-6">
                                <input  ng-model="model.materials.employee_id"  class="form-control"
                                        id="employee_id" name="employee_id"  required='false'  />
                            </div>
                            <%--<div class="col-sm-2">--%>
                                <%--<span class="text-danger">*</span>--%>
                            <%--</div>--%>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >员工姓名：</label>
                            <div class="col-sm-6">
                                <input  ng-model="model.materials.employee_name"  class="form-control"
                                        id="employee_name" name="employee_name"  required='false'  />
                            </div>
                            <div class="col-sm-2">
                                <%--<span class="text-danger">*</span>--%>
                                <a class="btn btn-warning btn-sm" id="oprToolBar" href="javascript:selectEmployee();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >状态：</label>
                            <div class="col-sm-6">
                                <select  class="form-control" id="materials_status" name="materials_status"></select>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" >位置：</label>
                            <div class="col-sm-6">
                                <input  ng-model="model.materials.materials_location"  class="form-control"
                                        id="materials_location" name="materials_location"  required='false'  />
                            </div>
                            <%--<div class="col-sm-2">--%>
                            <%--<span class="text-danger">*</span>--%>
                            <%--</div>--%>
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
                            <label class="col-sm-4 control-label">录入人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.materials.entry_person" type="text" class="form-control"
                                       id="entry_person" name="entry_person"  required='true' readonly = "true" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.materials.entry_date" type="text" class="form-control"
                                       id="entry_date" name="entry_date" readonly = "true" />
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="form-group">
                            <label   class="col-sm-4 control-label" >买入日期：</label>
                            <div class="col-sm-6">
                                <input    onclick="laydate()" ng-model="model.materials.buy_date"  class="form-control"
                                        id="buy_date" name="buy_date"  required='false'  />
                            </div>
                            <%--<div class="col-sm-2">--%>
                            <%--<span class="text-danger">*</span>--%>
                            <%--</div>--%>
                        </div>
                    </div>

                    <%--<div class="col-md-4">--%>
                        <%--<div class="form-group">--%>
                            <%--<label class="col-sm-4 control-label">状态：</label>--%>
                            <%--<div class="col-sm-6">--%>
                                <%--<input ng-model="model.materials.status" type="text" class="form-control"--%>
                                       <%--id="status" name="status"  required='true' readonly = "true" />--%>
                            <%--</div>--%>
                        <%--</div>--%>
                    <%--</div>--%>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.materials.modifier" type="text" class="form-control"
                                       id="modifier" name="modifier"   readonly = "true" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.materials.modify_date" type="text" class="form-control"
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
                            <label class="col-sm-2 control-label">详细信息：</label>
                            <div class="col-sm-9">
                                <textarea type="text" ng-model="model.materials.goods_info" class="form-control richtext"
                                          id="goods_info" name="goods_info"   rows ='5'></textarea>
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
