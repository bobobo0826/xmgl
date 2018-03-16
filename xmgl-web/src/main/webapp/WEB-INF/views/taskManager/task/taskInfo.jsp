<%--
  Created by wjy
  Date: 2017/7/26
  Time: 15:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <title>任务详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/thirdparty/ke/kindeditor.jsp" %>


</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="task_id" value="${id}"/>
<input type="hidden" id="cur_user_id" value="${user_id}"/>
<input type="hidden" id="imageUrl" value="${imageUrl}"/>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="photo_path"/>
<input type="hidden" id="user_id"/>

<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>基本信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">任务名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.task_name" type="text" name="task_name"
                                       class="form-control rdlActive" required="true" id="task_name"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">父级任务：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.sup_task_name" type="text" name="sup_task_name"
                                       class="form-control" readonly="true" id="sup_task_name"/>
                                <input type="text" ng-model="model.task.sup_task_id" id="sup_task_id" hidden="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger"></span>
                                <a class="btn btn-warning btn-sm rdlActive search_icon"
                                   href="javascript:selectSupTask();">
                                    <i class='fa fa-search'></i>
                                </a>
                                <a class="btn btn-danger btn-sm rdlActive search_icon"
                                   href="javascript:removeSuptask();">
                                    <i class='fa fa-remove'></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">任务类型：</label>
                            <div class=" col-sm-6">
                                <select onchange="projectHide()" type="text" class="form-control rdlActive"
                                        id="task_type" name="task_type" required='true'>
                                </select>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div id="status_name_head" class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">任务状态：</label>
                            <div class="col-sm-6">
                                <select type="text" class="form-control" id="task_condition" name="task_condition"
                                        disabled="disabled">
                                </select>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4 proj_head_hide">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">项目名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control id_name" id="sup_project_name"
                                       name="sup_project_name" required="true" readonly="true"/>
                                <input type="text" class="id_name" ng-model="model.task.sup_project_id"
                                       id="sup_project_id" hidden="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger proj_required_icon">*</span>
                                <a class="btn btn-warning btn-sm rdlActive search_icon" id="sup_project_a"
                                   href="javascript:selectProject();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 proj_head_hide">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">任务项目类别：</label>
                            <div class="col-sm-6">
                                <select type="text" class="form-control rdlActive id_name" id="task_proj_type"
                                        name="task_proj_type" required="true">
                                </select>
                            </div>
                            <div class="col-sm-2 proj_required_icon">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 proj_head_hide">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">模块名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control id_name" id="sup_module_name"
                                       name="sup_module_name"
                                       required="true" readonly/>
                                <input type="text" class="id_name" ng-model="model.task.sup_module_id"
                                       id="sup_module_id" hidden="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger proj_required_icon">*</span>
                                <a class="btn btn-warning btn-sm rdlActive search_icon" id="sup_module_a"
                                   href="javascript:selectModule();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4" style="height: 38px">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">汇报周期：</label>
                            <div class="col-sm-8">
                                <div class="radio radio-info radio-inline ">
                                    <input class="rdlActive" type="radio" id="DAY" value="DAY" name="report_cycle"
                                           checked="">
                                    <label for="DAY"> 每天 </label>
                                </div>
                                <div class="radio radio-info radio-inline ">
                                    <input class="rdlActive" type="radio" id="WEEK" value="WEEK" name="report_cycle">
                                    <label for="WEEK"> 每周</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4" style="height: 38px">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">是否重要：</label>
                            <div class="col-sm-8">
                                <div class="radio radio-danger radio-inline">
                                    <input class="rdlActive" type="radio" id="important" value="重要" name="importance">
                                    <label for="important"> 重要 </label>
                                </div>
                                <div class="radio radio-info radio-inline">
                                    <input class="rdlActive" type="radio" id="unimportant" value="不重要" name="importance"
                                           checked="">
                                    <label for="unimportant">不重要</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4" style="height: 38px">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">是否紧急：</label>
                            <div class="col-sm-4">
                                <div class="radio radio-danger radio-inline">
                                    <input class="rdlActive" type="radio" id="urgent" value="紧急" name="urgency">
                                    <label for="urgent"> 紧急 </label>
                                </div>
                                <div class="radio radio-info radio-inline">
                                    <input class="rdlActive" type="radio" id="not_urgent" value="不紧急" name="urgency"
                                           checked="">
                                    <label for="not_urgent"> 不紧急</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">完成情况：</label>
                            <div class="col-sm-6">
                                <div class="progress progress-striped active m-b-sm"
                                     style="margin-bottom:0px;height:28px">
                                    <div style="width: 0%;" class="progress-bar"></div>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span id="task_complete"></span>
                            </div>
                        </div>
                    </div>

                    <div id="creator_head" class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.creator" type="text" class="form-control" id="creator"
                                       name="creator" readonly="true"/>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.create_time" type="text" class="form-control"
                                       id="create_time"
                                       name="create_time" readonly="true"/>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.modifier" type="text" class="form-control" id="modifier"
                                       name="modifier" readonly="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.modify_time" type="text" class="form-control"
                                       id="modify_time"
                                       name="modify_time" readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 check_info">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">审核人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.checker" type="text" class="form-control" id="checker"
                                       name="checker" readonly="true"/>

                            </div>
                            <div class="col-sm-2">
                                <span></span>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-4 check_info">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">审核时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.task.check_time" type="text" class="form-control"
                                       id="check_time"
                                       name="check_time" readonly="true"/>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4" id="assigned_checker_head">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">指定审核人：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="assigned_checker" name="assigned_checker"
                                       readonly="true"/>
                                <input type="text" ng-model="model.task.assigned_checker_id" id="assigned_checker_id"
                                       hidden="true"/>

                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger"></span>
                                <a class="btn btn-warning btn-sm " id="selectChecker"
                                   href="javascript:selectChecker();">
                                    <i id="assigned_checker_icon" class='fa fa-search'></i>
                                </a>
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
                        <div class=" form-group">
                            <label class="col-sm-2 control-label">任务描述：</label>
                            <div class="col-sm-9" id="task_desc_div">
                            <textarea ng-model="model.task.task_desc" type="text" class="form-control richtext"
                                      id="task_desc"
                                      name="richtext" required="true"></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                        <div class=" form-group check_info">
                            <label class="col-sm-2 control-label">审核意见</label>
                            <div class="col-sm-9" id="check_desc_div">
                                <textarea ng-model="model.task.check_desc" type="text" class="form-control richtext"
                                          id="check_desc"
                                          name="check_desc"></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger"></span>
                            </div>
                        </div>
                    </div>
                    <div class = "col-md-4">
                        <div class = "ibox">
                            <a class="collapse-link">
                                <div class="ibox-title">
                                    <h5>任务成果上传</h5>
                                    <div class="ibox-tools">
                                        <i class="fa fa-chevron-up"></i>
                                    </div>
                                </div>
                            </a>
                            <div class = "ibox-content">
                                <div class="toolbardiv">
                                    <a id="uploadFile" class="btn btn-success btn-sm" href="javascript:addResultFile();">
                                        <i class='fa fa-plus'></i>&nbsp;&nbsp;添加附件</a>
                                </div>
                                <table id="resultFileList"></table>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <%--参与人员列表--%>
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>参与人员列表</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="toolbardiv">
                        <a id="addNewEmployee" style='display:none' class="btn btn-success btn-sm" href="javascript:addEmployee();">
                            <i class='fa fa-plus'></i>&nbsp;&nbsp;添加员工</a>
                    </div>
                    <table id="employee"></table>
                </div>
            </div>

        </div>
    </div>
    <div class="row">
        <%--计划列表--%>
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>计划列表</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="toolbardiv" id="goodsToolBar">
                        <a id="addNewPlan" style = "display: none" class="btn btn-success btn-sm" href="javascript:beginEdit(-1);">
                            <i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>
                    </div>
                    <table id="plan"></table>
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
<script type="text/javascript">
    $(window).resize(function () {
        $("#task").datagrid("resize");
    });
    var _funcArray;
    $(document).ready(function () {
        createRichText();
        _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
        console.log(_funcArray);
        getTaskDic(function (taskTypeList,taskConditionList,taskProjTypeList){
            addSelectOption(taskTypeList, "task_type");
            addSelectOption(taskConditionList, "task_condition");
            addSelectOption(taskProjTypeList, "task_proj_type");
        });
        for (var i = 0; i < _funcArray.length; i++) {
            var funcObj = _funcArray[i];
            switch (funcObj) {
                case "addParticipants" :
                    $("#addNewEmployee").show();
                    break;
                case "addPlan" :
                    $("#addNewPlan").show();
                    break;
                default:
                    break;
            }
        }
    });
    var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {

        $scope.model = {};
        var url = '${root}/manage/task/getTaskInfoById/' + $("#task_id").val();
        $http.get(url).success(function (response) {
            $scope.model.task = response;
            if (!response.complete) {
                $("#task_complete").text("0%");
            } else {
                $("#task_complete").text(response.complete);
            }
            initPlanDetail();
            initEmployeeList();
            setReadOnly(response.task_condition_code);

            initResultFileList();
            //加载员工列表
            if (response.participants) {
                $('#employee').datagrid('loadData', JSON.parse(response.participants));
            }
/*            //初始化任务成果列表
            if (response.result_files) {
                $('#resultFileList').datagrid('loadData', JSON.parse(response.result_files));
            }
           /* consol*!/e.log(JSON.stringify(response));*/

            $("#task_type").val(response.task_type_code);
            $("#task_condition").val(response.task_condition_code);
            $("#task_proj_type").val(response.task_proj_type_code);
            $("#sup_project_name").val(response.sup_project_name);
            $("#sup_task_name").val(response.sup_task_name);
            $("#sup_module_name").val(response.sup_module_name);
            if (response.task_desc) {
                kindEditer1.html(response.task_desc);
            }
            if (response.check_desc) {
                kindEditer2.html(response.check_desc);
            }
            if (response.assigned_checker) {
                $("#assigned_checker").val(response.assigned_checker);
            }
            if (response.assigned_checker_id) {
                $("#assigned_checker_id").val(response.assigned_checker_id);
            }
            if (response.checker) {
                $("#checker").val(response.checker);
            }
            $("input[name='report_cycle'][value='" + response.report_cycle + "']").attr("checked", 'true');
            $("input[name='urgency'][value='" + response.urgency + "']").attr("checked", 'true');
            $("input[name='importance'][value='" + response.importance + "']").attr("checked", 'true');
            controlButs($scope, $compile);
            initRequired();
            $(".progress-bar").css("width", $scope.model.task.complete);
        });
        $scope.processForm = function (funcCode) {
            if (!validateForm()) {
                return;
            }
            /**
             *判断保存或提交
             *
             * */
            var msg = "";
            switch (funcCode) {
                case "SAVE":
                    msg = "保存";
                    if ($scope.model.task.task_condition_code != "CG") {
                        $scope.model.task.task_condition_code = "DTJ";
                    }
                    break;
                case "TJ":
                    msg = "提交";
                    $scope.model.task.task_condition_code = "DSH";
                    if (!$("#assigned_checker").val()) {
                        layer.tips('请选择指定审核人', '#assigned_checker_icon');
                        return;
                    }
                    break;
                case "CXTJ":
                    msg = "提交给另一个人审核";
                    $scope.model.task.task_condition_code = "DSH";
                    if (!$("#assigned_checker_id").val() || $("#assigned_checker_id").val() == $("#cur_user_id").val()) {
                        layer.tips('请重新选择指定审核人', '#assigned_checker_icon');
                        return;
                    }
                    break;
                case "TG":
                    msg = "同意该任务申请?";
                    $scope.model.task.task_condition_code = "YSH";
                    break;
                case "BTG":
                    msg = "不同意该任务申请?";
                    if (!$("#check_desc").val()) {
                        layer.msg("请在审核意见一栏输入不同意原因！");
                        $("#check_desc").focus();
                        return;
                    }
                    $scope.model.task.task_condition_code = "SHBTG";
                    break;
                case "XFRW" :
                    msg = "确定下发任务?";
                    $scope.model.task.task_condition_code = "YXF";
                    break;
                case "ZJXF":
                    msg = "确定不提交审核，直接下发任务？";
                    $scope.model.task.task_condition_code = "ZJXF";
                    break;
                default:
                    break;
            }

            var planList = $('#plan').datagrid('getData').rows;
            var planLists = new Array();
            if (planList && planList.length) {
                for (var i = 0; i < planList.length; i++) {
                    planLists.push(planList[i]);
                }
                $scope.model.planList = JSON.stringify(planLists);
            }
            $scope.model.task.sup_project_name = $("#sup_project_name").val();
            $scope.model.task.sup_module_name = $("#sup_module_name").val();
            $scope.model.task.sup_task_name = $("#sup_task_name").val();
            $scope.model.task.assigned_checker = $("#assigned_checker").val();
            $scope.model.task.task_type_code = $("#task_type").val();
            $scope.model.task.task_proj_type_code = $("#task_proj_type").val();
            $scope.model.task.task_desc = $("#task_desc").val();
            $scope.model.task.check_desc = $("#check_desc").val();
            $scope.model.task.complete = getSchedulePercent();
            $scope.model.task.report_cycle = $("input[name='report_cycle']:checked").val();
            $scope.model.task.urgency = $("input[name='urgency']:checked").val();
            $scope.model.task.importance = $("input[name='importance']:checked").val();

            var content = $('#employee').datagrid('getData').rows;
            $scope.model.task.participants = tableToString(content);

            if ($("#sup_project_id").val()) {
                $scope.model.task.sup_project_id = $("#sup_project_id").val();
                $scope.model.task.sup_module_id = $("#sup_module_id").val();
            } else {
                $scope.model.task.sup_project_id = null;
                $scope.model.task.sup_module_id = null;
            }
            if ($("#assigned_checker_id").val() != "") {
                $scope.model.task.assigned_checker_id = $("#assigned_checker_id").val();
            } else {
                $scope.model.task.assigned_checker_id = null;
            }
            if ($("#sup_task_id").val() != "") {
                $scope.model.task.sup_task_id = $("#sup_task_id").val();
            } else {
                $scope.model.task.sup_task_id = null;
            }
            console.log("task before save!!" + JSON.stringify($scope.model.task));
            console.log("planList before save!!" + JSON.stringify($scope.model.planList));

            layer.confirm('确定' + msg + '吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                $scope.model.task = JSON.stringify($scope.model.task);
                var url = "${root}/manage/task/saveTaskAndPlan?oprCode=" + funcCode;
                layer.close(index);
                $.blockUI();
                $http({
                    method: 'POST',
                    url: encodeURI(encodeURI(url)),
                    data: $scope.model,
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                }).success(function (response) {
                    $.unblockUI();
                    $scope.model.task = response.task;//刷新
                    $("#task_condition").val($scope.model.task.task_condition_code);
                    setReadOnly($("#task_condition").val());//设置字段能否编辑
                    controlButs($scope, $compile);//更新按钮显示
                    $(".progress-bar").css("width", $scope.model.task.complete);
                    $("#task_id").val($scope.model.task.id);
                    initPlanDetail();//重新加载计划列表
                    layer.close(index);
                    layer.msg(response.msgDesc);
                });
            }, function (index) {
                layer.close(index);
            });
        };
        $scope.closeForm = function () {
            layer.confirm('确定关闭窗口吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                parent.closeCurTab();
                layer.close(index);
            }, function (index) {
                layer.close(index);
            });
        };
    });
    setModuleRequest(myform);

    function initPlanDetail() {

        var options = {
            url: getUrl(),
            sortable: true,
            singleSelect: true,
            pagination: false,
            height: 'auto',
            width: 'auto',
            striped: true,
            remoteSort: true,
            columns: [[
                {
                    field: "act",
                    title: "操作",
                    width: 120,
                    resizable: true,
                    headalign: "center",
                    align: "center",
                    formatter: editf
                },
                {field: "id", title: "计划ID", hidden: true},
                {
                    field: "plan_name",
                    title: "计划名称",
                    width: 300,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {field: "task_id", title: "任务ID", hidden: true},
                {
                    field: "plan_desc",
                    title: "计划描述",
                    width: 300,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: "period",
                    title: "计划预计完成周期",
                    width: 300,
                    resizable: true,
                    headalign: "center",
                    align: "center",
                    formatter: function (value, row) {
                        return row.start_date + '~' + row.end_date;
                    }
                },
                {
                    field: "actual_period",
                    title: "计划实际完成周期",
                    width: 300,
                    resizable: true,
                    headalign: "center",
                    align: "center",
                    formatter: function (value, row) {
                        var actual_start_time=row.actual_start_time;
                        var actual_end_time=row.actual_end_time;
                        if(typeof (row.actual_start_time)=="undefined"||row.actual_start_time==null||row.actual_start_time==''){
                            actual_start_time='';
                        }
                        if(typeof(row.actual_end_time)=="undefined"||row.actual_end_time==null||row.actual_end_time==''){
                            actual_end_time='';
                        }
                        if(actual_start_time==""&&actual_end_time==""){
                            return;
                        }else{
                            return actual_start_time + '~' + actual_end_time;
                        }
                    }
                },
                {
                    field: "anticipation",
                    title: "预期目标",
                    hidden: true,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: "employee_name",
                    title: "执行人员",
                    width: 200,
                    resizable: true,
                    headalign: "center",
                    align: "center",
                    formatter: getNameArr
                },

                {
                    field: "complete",
                    title: "完成情况",
                    width: 100,
                    hidden: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: 'complete_type',
                    title: "计划完成情况",
                    width: 100,
                    resizable: true,
                    headalign: "center",
                    align: "center"

                },
                {field: "start_date", title: "开始日期", hidden: true},
                {field: "end_date", title: "结束日期", hidden: true},
                {field: "actual_start_time", title: "实际开始日期",hidden: true},
                {field: "actual_end_time", title: "实际结束日期",hidden: true},
                {field: "participants", title: "参与人员信息", hidden: true},
                {
                    field: "is_cancel",
                    title: "是否注销",
                    width: 100,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: "create_time",
                    title: "创建时间",
                    width: 150,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: "modify_time",
                    title: "修改时间",
                    width: 120,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {
                    field: "delay_reason",
                    title: "延期原因",
                    width: 150,
                    resizable: true,
                    headalign: "center",
                    align: "center"
                },
                {field: "modified_flag", title: "修改标志", hidden: true}


            ]],
            onDblClickRow: function (rowIndex) {
                beginEdit(rowIndex);
            }

        };
        $('#plan').datagrid(options);
        $('#plan').datagrid({
            rowStyler: function (index, row) {
                if (row.modified_flag == 1) {
                    return 'background-color:lightpink ;color:maroon ;font-weight:bold;';
                }
            }
        });
    }

    function initEmployeeList() {
        $("#employee").datagrid({
            sortable: true,
            remoteSort: false,
            singleSelect: true,
            pagination: false,
            height: 'auto',
            width: $(window).width() - 100,
            striped: true,
            nowrap: false,
            showFooter: true,
            columns: [[
                {
                    field: "id",
                    title: "员工id",
                    hidden: true
                },
                {
                    field: "act",
                    title: "操作",
                    resizable: true,
                    width: 120,
                    headalign: "center",
                    align: "center",
                    formatter: editEmployee
                },
                {
                    field: "name",
                    title: "员工姓名",
                    resizable: true,
                    width: 180,
                    headalign: "center",
                    align: "center",
                    sortable: true
                },
                {
                    field: "mobilephone_number",
                    title: "员工手机号",
                    resizable: true,
                    width: 200,
                    headalign: "center",
                    align: "center",
                    sortable: true
                }
            ]]
        });
    }

    function initResultFileList(){
        $("#resultFileList").datagrid({
            url: getFileUrl(),
            sortable: true,
            remoteSort: false,
            singleSelect: true,
            pagination: false,
            height: 'auto',
            width: 'auto',
            striped: true,
            nowrap: false,
            showFooter: true,
            columns: [[
                {
                    field: "id",
                    title: "id",
                    hidden: true
                },
                {
                    field: "file_name",
                    title: "文件名",
                    resizable: true,
                    width: 180,
                    headalign: "center",
                    align: "center",
                    sortable: true,
                    formatter: addShowLink
                },
                {
                    field: "file_path",
                    title: "文件路径",
                    resizable: true,
                    width: 180,
                    headalign: "center",
                    align: "center",
                    sortable: true,
                    hidden:true
                },
                {
                    field: "file_id",
                    title: "文件id",
                    resizable: true,
                    width: 180,
                    headalign: "center",
                    align: "center",
                    sortable: true,
                    hidden:true
                },
                {
                    field: "act",
                    title: "操作",
                    resizable: true,
                    width: 120,
                    headalign: "center",
                    align: "center",
                    formatter: editFileList
                }
            ]]
        });
    }
    function getFileUrl(){
        var url ="";
        url +="${root}/manage/file/queryFileList/?business_id=" + $("#task_id").val()+
            "&business_type_code=RWGL";
        return url;
    }
    function addEmployee() {
        if ($("#task_type").val() == "XMRW" && $("#sup_project_id").val() == "") {
            layer.msg("请先选择项目！");
            return;
        }
        getParticipantsIdList(function (employeeIdList) {

            if ($("#task_type").val() == "XMRW" && employeeIdList == "") {
                layer.msg("该项目没有添加参与人员！");
                return;
            } else if ($("#task_type").val() == "XMRW" && employeeIdList == "-1") {
                layer.msg("获取项目参与人员id失败");
                return;
            }
            else {
                var width = '800px';
                var height = '70%';
                var url = "${root}/manage/employee/selectEmployee?_curModuleCode=" + $("#_curModuleCode").val()
                    + "&idList=" + employeeIdList;
                url = encodeURI(encodeURI(url));
                f_open("newWindow", "添加员工", width, height, url, true);
            }

        });

    }
    /**
     * 从后台读取项目的员工idList
     * @returns {string}
     */
    function getParticipantsIdList(func) {
        var str = $("#sup_project_id").val();
        if (!str){
            str = null;
        }
        if ($("#task_type").val() != "XMRW" && !str)
        {
            func("");//从所有员工中选


        }
        else{
            var url = "${root}/manage/task/getParticipantsIdList?projectId=" + str;
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: true,
                success: function (result) {
                    func(listToString(result.idList));
                },
                error: function () {
                    func(-1);
                }
            });
        }
    }

    function setEmployeeInfo(object) {
        if (object._curModuleCode == "RWGL") {
            var rows = $('#employee').datagrid('getRows');//选择参与人员
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].id == object.employee_id) {
                    layer.msg("已经选择了该员工！");
                    return;
                }
            }
            appendRowEmployee();
            var grid_index = rows.length - 1;
            $('#employee').datagrid('updateRow', {
                index: grid_index,
                row: {
                    name: object.employee_name,
                    mobilephone_number: object.mobilephone_number,
                    id: object.employee_id,
                    photo: object.photo
                }
            });
        } else if (object._curModuleCode == "XZZDSHR") {//选择指定审核人
            if (object.user_id == "" || typeof (object.user_id) == "undefined") {
                layer.msg("该员工还没有绑定用户信息！");
                return;
            } else {
                $("#assigned_checker_id").val(object.user_id);
                $("#assigned_checker").val(object.employee_name);
            }

        }
    }
    function listToString(list) {
        var ids = [];
        for (var i = 0; i < list.length; i++) {
            ids.push(list[i].employee_id);
        }
        return ids.join(',');
    }

    function editEmployee(value, row, index) {
        var html = "";
        html += '[<a href="###" onclick="delRowEmployee(' + index + ' )" style="color:red;" class="xg">删除</a>]';
        return html;
    }

    function editFileList(value, row, index) {
        var html = "";
        html += '[<a href="###" onclick="downloadResultFile(' + index + ' )" style="color:red;" class="xg">下载</a>]';
        html += '[<a href="###" onclick="delRowFile(' + index + ' )" style="color:red;" class="xg">删除</a>]';
        return html;
    }

    function  downloadResultFile(index){
        var rows = $("#resultFileList").datagrid('getData').rows;
        var url = "${root}/manage/file/downloadFile?filePath="+rows[index].file_path+
                "&fileName="+rows[index].file_name+"&fileId="+rows[index].file_id;
        window.location.href=encodeURI(encodeURI(url));
    }

    function delRowEmployee(index) {
        var rows = $("#employee").datagrid('getData').rows;
        $("#employee").datagrid('deleteRow', index);
        for (var k = index; k < rows.length; k++) {
            $('#employee').datagrid('refreshRow', k);
        }
    }
    function delRowFile(index) {
        var rows = $("#resultFileList").datagrid('getData').rows;
        var url = "${root}/manage/task/delResultFile/"+rows[index].id;
        url = encodeURI(encodeURI(url));
        $.ajax({
            url: url,
            type: 'post',
            async : false,
            success: function (result) {
                layer.msg(result.msgDesc);
            }
        });
        $("#resultFileList").datagrid('deleteRow', index);
        for (var k = index; k < rows.length; k++) {
            $('#resultFileList').datagrid('refreshRow', k);
        }

    }
    function appendRowEmployee() {
        $('#employee').datagrid('appendRow', {});
    }
    function appendRowFile() {
        $('#resultFileList').datagrid('appendRow', {});
    }

    function getNameArr(value, row, index) {
        var employees = JSON.parse(row.participants);
        return connectNameStrArr(employees);
    }

    function getUrl() {
        var url;
        url = "${root}/manage/task/queryPlanList/?task_id=" + $("#task_id").val();
        url = encodeURI(encodeURI(url));
        return url;
    }
    function createRichText() {
        var elements = $('.richtext');
        var eObj1 = elements[0];
        var eObj2 = elements[1];
        kindEditer1 = createY(eObj1.id);
        kindEditer2 = createY(eObj2.id);
    }
    function appendRowPlan() {
        $('#plan').datagrid('appendRow', {
            /*                plan_name:'',
             plan_desc:'',
             anticipation:'',
             report_cycle:'',
             complete:'',
             start_date:'',
             end_date:'',*/
            participants: JSON.stringify([])
        });
    }
    function updateGrid(object, grid_index) {
        if (grid_index == -1) {
            appendRowPlan();
            grid_index = $('#plan').datagrid('getRows').length - 1;
        }
        var modified_flag = 0;
        if ($("#task_condition").val() != "CG") {
            modified_flag = 1;
        }
        if (object.participants) {
            var employees = JSON.parse(object.participants);
            var employee_name = connectNameStrArr(employees);
        } else {
            var employee_name = "";
        }

        $('#plan').datagrid('updateRow', {
            index: grid_index,
            row: {
                start_date: object.start_date,
                end_date: object.end_date,
                participants: object.participants,
                complete: object.complete,
                plan_desc: object.plan_desc,
                plan_name: object.plan_name,
                employee_name: employee_name,
                is_cancel: object.is_cancel,
                task_id: $("#task_id").val(),
                create_time: object.create_time,
                modify_time: object.modify_time,
                modified_flag: modified_flag,
                complete_type: object.complete_type
            }
        });

        $("#task_complete").text(getSchedulePercent());
        $(".progress-bar").css("width", $("#task_complete").text());


    }
    function connectNameStrArr(arr) {
        var names = [];
        for (var i = 0; i < arr.length; i++) {
            names.push(arr[i].name);
        }
        return names.join(',');
    }


    function editf(value, row, index) {
        var html = '';
        for (var i = 0; i < _funcArray.length; i++) {
            var funcObj = _funcArray[i];
            switch (funcObj) {
                case "planInfo" :
                    if ($("#task_condition").val() == "CG") {
                        html += '[<a href="###" onclick="beginEdit(' + index + ' )" style="color:red;" class="xg">修改</a>]';
                    } else {
                        html += '[<a href="###" onclick="beginEdit(' + index + ' )" style="color:red;" class="xg">详情</a>]';
                    }
                    break;
                case "addPlan" :
                    html += '[<a href="###" onclick="copyPlan(' + index + ')" style="color:blue;">复制</a>]';
                    break;
                default:
                    break;
            }
        }

        if (row.is_cancel == "未注销") {
            html += '[<a href="###" onclick="cancel(' + index + ')" style="color:red;">注销</a>]';
        }

        return html;
    }
    function cancel(index) {
        /*            layer.confirm('确定注销此计划吗?此操作不可撤回!', {
         btn: ['确定','取消'], //按钮
         shade: false //不显示遮罩
         }, function(index){*/
        $('#plan').datagrid('updateRow', {
            index: index,
            row: {
                is_cancel: "已注销"
            }
        });
        /*                layer.close(index);
         },function(index){
         layer.close(index);
         });*/


    }
    function copyPlan(index) {
        var url;
        var width = '80%';
        var height = '80%';
        var idList = getSelectedEmployeeIds();
        url = "${root}/manage/task/initPlanInfo?gridIndex=" + index + "&_curModuleCode=" + $("#_curModuleCode").val() + "&idList=" + idList
            + "&projectId=" + $("#sup_project_id").val() + "&taskCondition=" + $("#task_condition").val()
            + "&isCopy=copy";
        f_open("newWindow", "计划详情", width, height, url, true);
    }

    function beginEdit(rowIndex) {
        var url;
        var width = '80%';
        var height = '80%';
        var idList = getSelectedEmployeeIds();
        url = "${root}/manage/task/initPlanInfo?gridIndex=" + rowIndex + "&_curModuleCode=" + $("#_curModuleCode").val() + "&idList=" + idList
            + "&projectId=" + $("#sup_project_id").val() + "&taskCondition=" + $("#task_condition").val()
            + "&isCopy=notCopy";
        f_open("newWindow", "计划详情", width, height, url, true);
    }

    function getSelectedEmployeeIds() {
        var list = [];
        var rows = $('#employee').datagrid('getData').rows;
        for (var i = 0; i < rows.length; i++) {
            list.push(rows[i].id);
        }
        return list.join(','); //已选员工ids组装成sql所需的(1,2,3)形式；
    }
    function getGrid(rowIndex) {
        if (rowIndex != "") {
            var rows = $('#plan').datagrid('getData').rows;
            var task_detail = rows[rowIndex];
            return JSON.stringify(task_detail);
        }
    }

    function trim(str) {
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }
    //对有required=required属性的表单元素，进行必填校验
    function validateForm() {
        var flag = true;
        var es = $("#myform *[required='true']").each(function () {
            var e = $(this);
            if ($.trim($(e).val()) == "") {
                if (($(e).attr("name")) == "richtext") {
                    layer.tips('该字段必填', '#' + $(e).attr("id") + '_div');
                } else {
                    layer.tips('该字段必填', '#' + $(e).attr("id"));
                }
                $("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
                flag = false
            }
        });
        return flag;
    }
    /**
     * 保存和关闭
     * */
    function controlButs($scope, $compile) {
        var html = "";
        var funcFlag=new Array(7);
        for (var i=0;i<funcFlag.length;i++){
            funcFlag[i]=false;
        }
        for (var i = 0; i < _funcArray.length; i++) {
            var funcObj = _funcArray[i];
            switch (funcObj) {
                case "saveTask" :
                    if ($scope.model.task.task_condition_code != "DSH" && $scope.model.task.creator_id == $("#cur_user_id").val()) {
                        funcFlag[0]=true;
                    }
                    break;
                case "submitTask":
                    //自己创建的不是待审核的 或者 指定审核人是自己是待审核状态的

                    if ($scope.model.task.task_condition_code != "DSH" && $scope.model.task.creator_id == $("#cur_user_id").val()) {
                        funcFlag[1]=true;
                    }
                    break;
                case "passCheck" :
                    if ($scope.model.task.task_condition_code == "DSH" && $scope.model.task.assigned_checker_id == $("#cur_user_id").val()) {
                        kindEditer2.readonly(false);
                        funcFlag[2]=true;
                    }

                    break;
                case "noPassCheck":
                    if ($scope.model.task.task_condition_code == "DSH" && $scope.model.task.assigned_checker_id == $("#cur_user_id").val()) {
                        kindEditer2.readonly(false);
                        funcFlag[3]=true;
                    }
                    break;
                case "distriTask":
                    if ($scope.model.task.task_condition_code == "YSH" && $scope.model.task.creator_id == $("#cur_user_id").val()) {
                        funcFlag[4]=true;
                    }
                    break;
                case "directDistribute":
                    if ($scope.model.task.task_condition_code == "CG" && $scope.model.task.creator_id == $("#cur_user_id").val()) {
                        funcFlag[5]=true;
                    }
                    break;
                case "againSubmit":
                    // 待审核状态提交是重新提交给另外一个人审核
                    if ($scope.model.task.task_condition_code == "DSH" && $scope.model.task.assigned_checker_id == $("#cur_user_id").val()) {
                        funcFlag[6]=true;
                    }
                    break;
                default :
                    break;
            }
        }
        if (funcFlag[0]){html += "<span id = 'bc'><a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[1]){html += "<span id = 'tj'><a  class='btn btn-success btn-sm' href='###' ng-click='processForm(\"TJ\")'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[2]){html += "<span id = 'shtg'><a id = 'shtg' class='btn btn-success btn-sm' href='###' ng-click='processForm(\"TG\")'><i class='fa fa-check'></i>&nbsp;&nbsp;通过审核</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[3]){html += "<span id = 'shbtg'><a  class='btn btn-warning btn-sm' href='###' ng-click='processForm(\"BTG\")'><i class='fa fa-remove'></i>&nbsp;&nbsp;不通过审核</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[4]){ html += "<span id = 'xfrw'><a  class='btn btn-warning btn-sm' href='###' ng-click='processForm(\"XFRW\")'><i class='fa fa-send'></i>&nbsp;&nbsp;下发任务</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[5]){html += "<span id = 'zjxf'><a  class='btn btn-danger btn-sm' href='###' ng-click='processForm(\"ZJXF\")'><i class='fa fa-send'></i>&nbsp;&nbsp;直接下发</a>&nbsp;&nbsp;</span>";
        }
        if (funcFlag[6]){html += "<span id = 'cxtj'><a  class='btn btn-warning btn-sm' href='###' ng-click='processForm(\"CXTJ\")'><i class='fa fa-check'></i>&nbsp;&nbsp;重新提交</a>&nbsp;&nbsp;</span>";
        }
        html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
        var template = angular.element(html);
        var element = $compile(template)($scope);
        angular.element("#operator").empty();
        angular.element("#operator").append(element);
    }


    function getTaskDic(func) {
        var url = "${root}/manage/task/getTaskDic";
        url = encodeURI(encodeURI(url));
        $.ajax({
            url: url,
            type: 'post',
            async : false,
            success: function (result) {
                func(result.taskTypeList,result.taskConditionList,result.taskProjTypeList);
            }
        });
    }
    /**
     * 子页面调用消息
     * @param str
     */
    function layMsg(str) {
        layer.msg(str);
    }
    function selectChecker() {
        var url = "";
        var width = '800px';
        var height = '60%';
        var _curModuleCode = "XZZDSHR";//选择指定审核人
        url = "${root}/manage/employee/selectEmployee?_curModuleCode=" + _curModuleCode;
        url = encodeURI(encodeURI(url));
        f_open("newWindow", "选择指定审核人", width, height, url, true);
    }


    function selectProject() {
        $("#sup_module_name").val("");
        $("#sup_module_id").val(null);
        var url = "${root}/manage/project/initSelectProjectList";
        var width = "80%";
        var height = "80%";
        f_open("newWindow", "选择项目", width, height, url, true);
    }
    function setProjectInfo(object) {
        $("#sup_project_name").val(object.project_name);
        $("#sup_project_id").val(object.project_id);
    }
    function selectModule() {
        if ($("#sup_project_name").val() === "") {
            layer.msg("请先选择项目");
            return;
        }
        var url = '${root}/manage/projectModule/choseProjModule?_chkStyle=radio&projectId=' + $('#sup_project_id').val();
        windowName = "moduleWindow";
        windowTitle = "选择模块";
        width = "20%";
        height = "80%";
        f_open(windowName, windowTitle, width, height, url, true);
    }
    function setModule(moduleList) {
        if (moduleList == null || moduleList == "")
            return;
        $("#sup_module_name").val(moduleList[0].moduleName);
        $("#sup_module_id").val(moduleList[0].id);
    }
    function selectSupTask() {
        var url = '${root}/manage/task/selectTask';
        f_open('newWindow', '选择项目', '80%', '80%', url, true);
    }
    function setTaskInfo(obj) {
        $("#sup_task_id").val(obj.task_id);
        $("#sup_task_name").val(obj.task_name);
        var url = '${root}/manage/task/getTaskInfoById/' + $("#sup_task_id").val();
        $.ajax({
            url: url,
            type: 'post',
            success: function (result) {
                $("#sup_project_id").val(result.sup_project_id);
                $("#sup_project_name").val(result.sup_project_name);
                $("#sup_module_id").val(result.sup_module_id);
                $("#sup_module_name").val(result.sup_module_name);
                $("#task_proj_type").val(result.task_proj_type_code);
                $("#task_type").val(result.task_type_code);
            }
        });

    }
    function removeSuptask() {
        $("#sup_task_id").val(null);
        $("#sup_task_name").val("");
        $("#sup_project_id").val(null);
        $("#sup_project_name").val("");
        $("#sup_module_id").val(null);
        $("#sup_module_name").val("");
        $("#task_proj_type").val("");
        $("#task_type").val("");
    }
    function setRequiredAttr(val) {
        document.getElementById("sup_project_name").setAttribute("required", val);
        document.getElementById("sup_module_name").setAttribute("required", val);
        document.getElementById("task_proj_type").setAttribute("required", val);
    }
    function projectHide() {
        $('.id_name').val(null);
        $('#employee').datagrid('loadData', { total: 0, rows: [] });
        initRequired()
    }
    function initRequired(){
        if ($('#task_type').val() != "XMRW") {
            $('.proj_head_hide').hide();
            $('.proj_required_icon').hide();
            setRequiredAttr(false)
        }
        else {
            setRequiredAttr(true);
            $('.proj_head_hide').show();
            $('.proj_required_icon').show();
        }
    }
    function getSchedulePercent() {
        var planList = $('#plan').datagrid('getData').rows;
        var percent = "0%";
        var complete = 0;
        var total = 0;
        if (planList) {
            for (var i = 0; i < planList.length; i++) {
                if (planList[i].is_cancel != "已注销") {
                    total += 1;
                    if (planList[i].complete == "已完成") {
                        complete += 1;
                    }
                }
            }
        }
        if (total != 0) {
            percent = Math.round(complete * 100 / total) + "%";
        }
        return percent;
    }

    function setReadOnly(condition) {
        //待审核状态不可修改
        if (condition == "DSH") {
            $(".rdlActive").attr("readonly", "true");
            $(".rdlActive").attr("disabled", "disabled");
            kindEditer1.readonly();
            kindEditer2.readonly();
            $(".check_info").show();//审核信息
            $(".search_icon").hide();//隐藏按钮
            $("#addNewPlan").hide();
            $("#addNewEmployee").hide();
            $("#plan").datagrid("hideColumn", "act");
            $("#employee").datagrid("hideColumn", "act");

        }
        //草稿可以修改
        else if (condition == "CG") {
            $(".rdlActive").removeAttr("readonly");
            $(".rdlActive").removeAttr("disabled");
            kindEditer1.readonly(false);
            kindEditer2.readonly();
            $(".check_info").hide();//审核信息
            $("#addNewPlan").show();
            $("#addNewEmployee").show();
            $("#plan").datagrid("showColumn", "act");
            $("#employee").datagrid("showColumn", "act");
        }
        //其他状态不能修改计划
        else {
            $(".rdlActive").removeAttr("readonly");
            $(".rdlActive").removeAttr("disabled");
            kindEditer1.readonly(false);
            kindEditer2.readonly();
            $(".check_info").show();//审核信息
            $("#addNewPlan").show();
            $("#addNewEmployee").show();
            $("#plan").datagrid("showColumn", "act");
            $("#employee").datagrid("showColumn", "act");
        }
    }

    function addResultFile(){
        var url = "${root}/manage/task/uploadResultFile?id="+$("#task_id").val()+"&_module="+"RWGL";
        var width = '50%';
        var height ='70%';
        f_open("newWindow", "上传文件", width, height, url, true);
    }

    function tableToString(content){
        if (content) {
            var contents = new Array();
            for (var i = 0; i < content.length; i++) {
                contents.push(content[i]);
            }
            return JSON.stringify(contents);
        }
        else{
            return "";
        }
    }

    function addShowLink(value, row, index){
        return '<a href="###" onclick="showResultFile('+index+')" style="color:red;" class="xg">'+value+'</a>'

    }

    function showResultFile(index){
        var rows = $('#resultFileList').datagrid('getRows');
        var row = rows[index];
        var url;
        var width = '80%';
        var height = '80%';
        url = "${root}/manage/file/initFileShow?filePath=" + "upload/RWGL" + "&fileId=" + row.file_id;
        console.log(url);
        f_open("newWindow", "任务成果文件展示", width, height, url, true);
    }
</script>
</body>
</html>

