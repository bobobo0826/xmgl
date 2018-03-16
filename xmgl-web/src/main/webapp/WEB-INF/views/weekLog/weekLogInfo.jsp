<%--
  Created by IntelliJ IDEA.
  User: mjq
  Date: 2017/7/4
  Time: 10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html>
<head>
    <title>每周任务</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/thirdparty/ke/kindeditor.jsp" %>

    <script type="text/javascript">
        $(window).resize(function () {
            $("#task").datagrid("resize");
        });
        $(document).ready(function () {
            createRichText();
            if("${addOrComments}" == "comments"){
                $("#_comments").focus();
            }
        });
        var _funcArray = getFunctions('${pageContext.request.contextPath}','${curModuleCode}');
        var log_id='';
        var my_comments='';
        var creator_id="";
        var creator="";
        var work_date="";
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {

            $scope.model = {};
            var url = "${root}/manage/weekLog/getWeekLogInfo/" + $("#log_id").val() + '/MZJH' + '/0';
            getThisModday();
            getThisSunday();
            $http.get(url).success(function (response) {
                $scope.model.weekLog = response.weekLog;
                log_id=response.weekLog.id;
                my_comments=response.comments;
                creator_id=response.weekLog.creator_id;
                creator=response.weekLog.creator;
                work_date = response.weekLog.task_start_date;
                var imageUrl=$("#imageUrl").val();
                initGlanceBrowse(response.GlanceOverList,imageUrl);
                initThumbsBrowse(response.ThumbsUpList,imageUrl);
                addSelectOption(response.logCreateTypeList, "create_type");//添加下拉选择
                if ($("#log_id").val() != -1) {
                    $("#create_type").attr("disabled", "disabled");
                    $("#task_start_date").attr("readonly", "true");
                    $("#task_end_date").attr("readonly", "true");
                    kindEditer1.html(response.weekLog.week_summary);
                    kindEditer2.html(response.weekLog.next_plan);
                    if (response.weekLog.work_explain !== null) {
                        kindEditer3.html(response.weekLog.work_explain);
                    }
                }

                $("#create_type").val(response.weekLog.create_type);
                controlButs($scope, $compile);
                if ($scope.model.weekLog.status_code == "YTJ") {
                    $("#week_summary").attr("readonly", "true");
                    $("#next_plan").attr("readonly", "true");
                    $("#work_explain").attr("readonly", "true");
                    $('#addNewTask').hide();
                } else {
                    $('#addNewTask').show();
                }
                $("#status_name").val(response.statusName);
                initTaskDetail();
                if (typeof($scope.model.weekLog.content) != 'undefined' && $scope.model.weekLog.content != null) {
                    $('#task').datagrid('loadData', JSON.parse($scope.model.weekLog.content));
                }
                myComments(log_id, my_comments, creator_id, creator)
            });


            $scope.processForm = function (funcCode) {
                if ($scope.model.weekLog.status_code == "已提交") {
                    layer.confirm("已提交状态不能修改！关闭窗口？", {
                        btn: ['确定', '取消'], //按钮
                        shade: false //不显示遮罩
                    }, function (index) {
                        parent.closeCurTab();
                        layer.close(index);
                    })
                    return;
                }
                if (!validateForm()) {
                    return;
                }
                var msg = "";
                var tjWarning = "";
                switch (funcCode) {
                    case 'infoSave':
                        msg = "保存";
                        break;
                    case 'infoSubmit':
                        msg = "提交";
                        tjWarning = "  提交后将不能修改!";
                        break;
                    default:
                        break;
                }
                layer.confirm('确定' + msg + '吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {

                    var url = "${root}/manage/weekLog/saveWeekLogInfo?oprCode=" + funcCode;
                    var taskContent = $('#task').datagrid('getData').rows;
                    var taskContents = new Array();
                    if (taskContent != "" && taskContent != null) {
                        for (var i = 0; i < taskContent.length; i++) {
                            updateActions(i);
                            taskContents.push(taskContent[i]);
                        }
                        $scope.model.weekLog.content = JSON.stringify(taskContents);
                    }

                    $scope.model.weekLog.task_start_date = $("#task_start_date").val();
                    $scope.model.weekLog.task_end_date = $("#task_end_date").val();
                    if (funcCode == 'infoSubmit') {
                        $scope.model.weekLog.status_code = "YTJ";
                        saveWeekSummary2MonthLog();
                        for (var x in JSON.parse($scope.model.weekLog.content))
                        {
                            if(x=="remove"){
                                continue;
                            }
                            var content = JSON.parse($scope.model.weekLog.content)[x];
                            if(content.plan_actual_start_time==="" && content.isPlan==="计划"){
                                saveActualStartTime2Plan(content.plan_id, content.task_end_time, content.task_start_time, content.complete,content.delayReason);
                                saveComplete2task(content.task_id)
                            }else if(content.complete==="已完成" && content.isPlan==="计划"){
                                saveComplete2Plan(content.plan_id, content.task_end_time, content.delayReason);
                                saveComplete2task(content.task_id)
                            }else if(content.complete==="未完成"&& content.isPlan==="计划"){
                                saveUnComplete2Plan(content.plan_id, content.task_end_time, $("#work_date").val());

                            }
                        }
                    }

                    if (($('#task_start_date').val() >= getThisModday()) && ($('#task_end_date').val() <= getThisSunday())) {
                        $('#create_type').val("ZCLR");
                    } else {
                        $('#create_type').val("BL");
                    }
                    $scope.model.weekLog.create_type = $('#create_type').val();
                    $scope.model.weekLog.week_summary = $('#week_summary').val();
                    $scope.model.weekLog.next_plan = $('#next_plan').val();
                    $scope.model.weekLog.work_explain = " ";
                    if ($('#work_explain').val() !== null && $('#work_explain').val() !== "") {
                        $scope.model.weekLog.work_explain = $('#work_explain').val();
                    }
                    layer.close(index);
                    $.blockUI();
                    $http({
                        method: 'POST',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.weekLog,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                        $.unblockUI();
                        $("#log_id").val(response.weekLog.id);
                        $scope.model.weekLog = response.weekLog;
                        //$("#status_name").val($scope.model.statusName);
                        $("#status_name").val(response.statusName);
                        initTaskDetail();
                        if ($("#status_name").val() == "已提交") {
                            $('#tj').hide();
                            $('#bc').hide();
                            $('#addNewTask').hide();
                        }
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

        function saveComplete2task(task_id)
        {
            var url = "${root}/manage/task/getTaskSchedulePercent?taskId=" + task_id;
            url = encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type: 'post',
                       async: false,
                       success: function (response) {}
                   });
        }

        function saveActualStartTime2Plan(plan_id,end_time,start_time,complete,delayReason)
        {
            var url = "${root}/manage/weekLog/saveActualStartTime2Plan?plan_id=" + plan_id
                      +"&actual_end_time=" + end_time
                      +"&actual_start_time=" + start_time
                      +"&complete=" + complete
                + "&delay_reason=" + delayReason;
            url = encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type: 'post',
                       async: false,
                       success: function (response) {}
                   });
        }

        function saveComplete2Plan(plan_id,end_time,delayReason)
        {
            var url = "${root}/manage/weekLog/saveComplete2Plan?plan_id=" + plan_id
                      +"&actual_end_time="+end_time
                + "&delay_reason=" + delayReason;
            url = encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type: 'post',
                       async: false,
                       success: function (response) {}
                   });
        }
        function saveUnComplete2Plan(plan_id,end_time,work_date)
        {
            var url = "${root}/manage/weekLog/saveUnComplete2Plan?plan_id=" + plan_id
                +"&actual_end_time="+end_time
                +"&work_date="+work_date;
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (response) {}
            });
        }

        /**
         * 未完成的复制一条记录
         */
        function copy(index)
        {
            var width = '80%';
            var height = '80%';
            var url = "${root}/manage/weekLog/initTaskPlanInfo?_rowIndex=" + index + "&isCopy=copy" ;
            f_open("newWindow", "任务详情", width, height, url, true);
        }

        function saveWeekSummary2MonthLog()
        {
            var url = "${root}/manage/weekLog/saveWeekSummary2MonthLog?task_start_date=" + $("#task_start_date").val()
                      +"&task_end_date=" + $("#task_end_date").val()
                      +"&week_summary=" + $("#week_summary").val();
            url = encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type: 'post',
                       async: false,
                       success: function (response) {
                       }
                   });
        }

        function initTaskDetail() {
            $("#task").datagrid({
                sortName: 'task_start_time',
                sortOrder: 'asc',
                sortable: true,
                remoteSort: false,
                singleSelect: true,
                pagination: false,
                height: 'auto',
                width: 'auto',
                striped: true,
                showFooter: true,
                nowrap: false,
                fitcolumns: true,
                columns: [[
                    {
                        field: "action",
                        title: "操作",
                        resizable: true,
                        width: 120,
                        headalign: "center",
                        align: "center",
                        formatter: editTask
                    },
                    {
                        field: "start_and_end_time",
                        title: "起止时间",
                        resizable: true,
                        width: 100,
                        headalign: "center",
                        align: "center",
                        sortable: true,
                        formatter: function (value, row) {
                            if(row.period_start=="" || row.period_start==null){
                                return ""
                            }
                            return row.period_start + '<br>~<br>' + row.period_end;
                        }
                    },
                    {
                        field: "task_start_time",
                        title: "开始时间",
                        hidden: true
                    },
                    {
                        field: "task_name",
                        title: "日志记录名称",
                        resizable: true,
                        width: 200,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "task_type",
                        title: "任务类别",
                        resizable: true,
                        width: 100,
                        headalign: "center",
                        align: "center",
                        formatter: transToName,
                        sortable: true
                    },
                    {
                        field: "mission_name",
                        title: "任务名称",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "plan_name",
                        title: "计划名称",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "period",
                        title: "任务计划周期",
                        resizable: true,
                        width: 100,
                        headalign: "center",
                        align: "center",
                        sortable: true,
                        formatter: function (value, row) {
                            if(row.period_start=="" || row.period_start==null){
                                return ""
                            }
                            return row.period_start + '<br>~<br>' + row.period_end;
                        }
                    },
                    {
                        field: "sup_project",
                        title: "所属项目",
                        resizable: true,
                        width: 130,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "sup_module",
                        title: "所属模块",
                        resizable: true,
                        width: 130,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "record",
                        title: "工作记录",
                        resizable: true,
                        width: 300,
                        headalign: "center",
                        align: "left",
                        sortable: true
                    },
                    {
                        field: "complete",
                        title: "计划完成情况",
                        resizable: true,
                        width: 100,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "incomplete_explain",
                        title: "未完成情况描述",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        align: "left",
                        sortable: true
                    },
                    {
                        field: "delayReason",
                        title: "延时原因",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        align: "left",
                        sortable: true
                    }
                ]],
                    onDblClickRow: function (rowIndex, rowData) {
                        beginEdit(rowIndex);
                    },
                    onBeforeEdit: function (index, rowData) {
                        rowData.editing = true;
                        updateActions(index);
                    },
                    onAfterEdit: function (index, rowData, changes) {
                        rowData.editing = false;
                        updateActions(index);
                        $('#task').datagrid('refreshRow', index);
                    }
            });
        }

        function trim(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }

        //对有required=required属性的表单元素，进行必填校验
        function validateForm() {
            var es = $("#myform *[required='true']");
            if (es.length > 0) {
                for (var i = 0; i < es.length; i++) {
                    var e = es[i];
                    if ($.trim($(e).val()) == "") {
                        if(($(e).attr("name")) == "richtext"){
                            layer.tips('该字段必填', '#' + $(e).attr("id")+'_div');
                        }else{
                            layer.tips('该字段必填', '#' + $(e).attr("id"));
                        }
                        $("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
                        return false
                    }
                }
            }
            return true;
        }

        function addEditor(field, boxObj) {
            var col = $('#task').datagrid('getColumnOption', field);
            col['editor'] = boxObj;
        }

        function beginEdit(rowIndex) {
            var rows = $('#task').datagrid('getData').rows;
            var task_detail = rows[rowIndex];
            var url;
            var width = '80%';
            var height = '80%';
            url = "${root}/manage/weekLog/initTaskPlanInfo?_rowIndex=" + rowIndex + "&isCopy=notCopy";
            f_open("newWindow", "任务详情", width, height, url, true);
            //updateActions(rowIndex);

        }

        function getGrid(rowIndex) {
            if (rowIndex != "") {
                var rows = $('#task').datagrid('getData').rows;
                var task_detail = rows[rowIndex];
                return JSON.stringify(task_detail);
            }
        }

        /**
         * 更新编辑
         * */
        function updateActions(i) {
            $('#task').datagrid('endEdit', i);
            $('#task').datagrid('updateRow', {
                index: i,
                row: {}
            });
        }

        /**
         * 保存和关闭
         * */
        function controlButs($scope, $compile) {
            var html = "";
            if ($scope.model.weekLog.status_code != "YTJ") {
                html += "<a id = 'bc' class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"infoSave\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                html += "<a id = 'tj' class='btn btn-success btn-sm' href='###' ng-click='processForm(\"infoSubmit\")'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;";
            }
            html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }

        function appendRowTask() {
            $('#task').datagrid('appendRow', {
                task_start_time: '',
                task_end_time: '',
                task_name: '',
                task_type: '',
                sup_project: '',
                sup_module: '',
                record: '',
                complete: '',
                incomplete_explain: '',
                sup_project_id: '',
                sup_module_id: '',
                mission_name: '',
                plan_name: '',
                period_start: '',
                period_end: '',
                isPlan: '',
                delayReason: ''
            });
            var rowIndex = $('#task').datagrid('getRows').length - 1;
        }

        function editTask(value, row, index) {
            var html = '';
            html += '[<a href="###" onclick="beginEdit(' + index + ' )" style="color:red;" class="xg">详情</a>]';
            if ($('#status_name').val() != "已提交") {
                html += '[<a href="###" onclick="delRowGoods(' + index + ')" style="color:red;">删除</a>]';
                if(row.complete=="未完成"){
                    html += '[<a href="###" onclick="copy(' +"'"+index+"'" + ')" style="color:blue;">复制</a>]';
                }
            }
            return html;
        }

        /**
         * 删除行
         * @param index
         */
        function delRowGoods(index) {
            var rows=$("#task").datagrid('getData').rows;
            $("#task").datagrid('deleteRow', index);
            for(var k=index;k<rows.length;k++){
                $('#task').datagrid('refreshRow', k);
            }
        }

        /**
         * 获取详情页面表格数据
         * */
        function updateGrid(object, grid_index) {
            if (grid_index == -1) {
                appendRowTask();
                grid_index = $('#task').datagrid('getRows').length - 1;
            }
            $('#task').datagrid('updateRow', {
                index: grid_index,
                row: {
                    task_start_time: object.start_time,
                    task_end_time: object.end_time,
                    task_type: object.task_type,
                    sup_project: object.sup_project,
                    sup_module: object.sup_module,
                    record: object.record,
                    complete: object.complete,
                    incomplete_explain: object.incomplete_explain,
                    sup_project_id: object.sup_project_id,
                    sup_module_id: object.sup_module_id,
                    task_name: object.task_name,
                    mission_name: object.mission_name,
                    plan_name: object.plan_name,
                    period_start: object.period_start,
                    period_end: object.period_end,
                    plan_id:object.plan_id,
                    task_id:object.task_id,
                    plan_actual_start_time:object.plan_actual_start_time,
                    isPlan:object.isPlan,
                    delayReason: object.delayReason
                }
            });
        }
        /**
         * 项目类别显示中文
         * */
        function transToName(value, row, index) {
            var taskName;
            switch (value) {
                case "NBGL":
                    taskName = "内部管理";
                    break;
                case "JSXX":
                    taskName = "技术学习";
                    break;
                case "RJYF":
                    taskName = "软件研发";
                    break;
                case "YGPX":
                    taskName = "员工培训";
                    break;

                case "cleaning":
                    taskName = "打扫卫生";
                    break;
                case "fixing":
                    taskName = "修理设备";
                    break;
                case "discussion":
                    taskName = "项目业务讨论";
                    break;
                case "supporting":
                    taskName = "项目技术支持";
                    break;
                case "others":
                    taskName = "其他";
                    break;
                case "project_meeting":
                    taskName = "项目例会";
                    break;
                case "company_meeting":
                    taskName = "公司例会";
                    break;
                case "maintaining":
                    taskName = "项目日常维护";
                    break;
                default :
                    taskName = value;
                    break;
            }
            return taskName
        }
        /**
         * 获取状态名，供子页面读取
         * */
        function getStatusName() {
            return $('#status_name').val();
        }
        /**
         * 获取本周一日期
         * */
        function getThisModday() {
            Date.prototype.Format = function (fmt) { //author: meizz
                var o = {
                    "M+": this.getMonth() + 1, //月份
                    "d+": this.getDate(), //日
                    "h+": this.getHours(), //小时
                    "m+": this.getMinutes(), //分
                    "s+": this.getSeconds(), //秒
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                    "S": this.getMilliseconds() //毫秒
                };
                if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for (var k in o)
                    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                return fmt;
            }
            var now = new Date();
            var nowTime = now.getTime();
            var day = now.getDay();
            var oneDayLong = 24 * 60 * 60 * 1000;
            var MondayTime = nowTime - (day - 1) * oneDayLong;
            var monday = new Date(MondayTime).Format("yyyy-MM-dd");
            return monday;
        }
        /**
         * 获取本周日日期
         * */
        function getThisSunday() {
            Date.prototype.Format = function (fmt) { //author: meizz
                var o = {
                    "M+": this.getMonth() + 1, //月份
                    "d+": this.getDate(), //日
                    "h+": this.getHours(), //小时
                    "m+": this.getMinutes(), //分
                    "s+": this.getSeconds(), //秒
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                    "S": this.getMilliseconds() //毫秒
                };
                if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for (var k in o)
                    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                return fmt;
            }
            var now = new Date();
            var nowTime = now.getTime();
            var day = now.getDay();
            var oneDayLong = 24 * 60 * 60 * 1000;
            var SundayTime = nowTime + (7 - day) * oneDayLong;
            var sunday = new Date(SundayTime).Format("yyyy-MM-dd");
            return sunday;
        }
        /**
         * 获取今天日期
         * */

        function createRichText() {
            var elements = $(".richtext");
            var eObj1 = elements[0];
            var eObj2 = elements[1];
            var eObj3 = elements[2];
            kindEditer1 = createY(eObj1.id);
            kindEditer2 = createY(eObj2.id);
            kindEditer3 = createY(eObj3.id);

        }

        function myComments(logId, comments, creator_id, creator)
        {
            var html = "";
            if (comments.total==0){
                html +='<div class="social-comment">暂无评论</div>';
            }else{
                for (var i = 0; i < comments.total; i++) {
                    $("#_parent_id").val(0);
                    var commentator_name = '';
                    var commentator_photo = '';
                    var commentator_id = comments.rows[i].commentator_id;
                    var comment_type_head = comments.rows[i].comment_type;
                    if(comments.rows[i].comment_type =='GK'){
                        commentator_name = comments.rows[i].commentator_name;
                        commentator_photo = $("#imageUrl").val() + comments.rows[i].commentator_photo;
                    }else if(comments.rows[i].comment_type == 'NM' && comments.rows[i].commentator_id == $("#UserId").val() ){
                        commentator_name = comments.rows[i].commentator_name + '(匿名评论)';
                        commentator_photo = $("#imageUrl").val() + comments.rows[i].commentator_photo;
                    }else if(comments.rows[i].comment_type == 'NM') {
                        commentator_name = '匿名';
                        commentator_photo = $("#imageUrl").val() + "upload\\YGZP\\anonymous.jpg";
                    }else if(comments.rows[i].comment_type =='SX' && comments.rows[i].commentator_id == $("#UserId").val()){
                        commentator_name = comments.rows[i].commentator_name + '(私信)';
                        commentator_photo = $("#imageUrl").val() + comments.rows[i].commentator_photo;
                    } else if(comments.rows[i].comment_type =='SX' && creator_id == $("#UserId").val()) {
                        commentator_name = comments.rows[i].commentator_name + '(私信)';
                        commentator_photo = $("#imageUrl").val() + comments.rows[i].commentator_photo;
                    }else if(comments.rows[i].comment_type =='SX'){
                        continue;
                    }
                    $("#_parent_id").val(comments.rows[i].id);

                    if(commentator_photo==($("#imageUrl").val()+"null") || commentator_photo==$("#imageUrl").val() || commentator_photo==($("#imageUrl").val() + "undefined")){
                        commentator_photo="/res/public/img/icons/tx.png"
                    }

                    html += '<div class="social-comment">' +
                            '<div class="pull-left">' +
                            '<img alt="image" style="width: 50px;height: 50px" src="' + commentator_photo + '">' +
                            '</div>' +
                            '<div class="media-body">' +
                            '<a>' + commentator_name + '： ' + '</a>' +
                            '<small class="text-muted">' + comments.rows[i].comment_time+ '</small>' +
                            '<button class="btn btn-white btn-xs" onclick="myReply(' +"'"+ comments.rows[i].commentator_name +"'" + "," + $("#_parent_id").val() + "," + commentator_id + "," + "'"+comment_type_head+"'"+"," +"'"+comment_type_head+"'"+","+"'"+comment_type_head+"'"+')"><i class="fa fa-comments"></i> 回复</button>';
                    if(comments.rows[i].commentator_id == $("#UserId").val()) {
                        html+= '<button class="btn btn-white btn-xs" onclick="deleteComments(' + comments.rows[i].id + ')"><i class="fa fa-trash"></i> 删除</button>'
                    }
                    html+= '<br>' + comments.rows[i].content + '</div>';

                    var reply = comments.rows[i].children;
                    var replier_name = '';
                    var replier_photo = '';
                    var commentator_name2 = '';
                    if (reply==undefined){
                        reply = new Array();
                    }
                    for (var j = 0; j < reply.length; j++) {
                        if (reply[j].reply_type == 'GK') {
                            replier_name = reply[j].replier_name;
                            replier_photo = $("#imageUrl").val() + reply[j].replier_photo;
                        } else if (reply[j].reply_type == 'NM' && reply[j].replier_id == $("#UserId").val()) {
                            replier_name = reply[j].replier_name + '(匿名)';
                            replier_photo = $("#imageUrl").val() + reply[j].replier_photo;
                        } else if (reply[j].reply_type == 'NM') {
                            replier_name = '匿名';
                            replier_photo = $("#imageUrl").val() + "upload\\YGZP\\anonymous.jpg";
                        } else if (reply[j].reply_type == 'SX' && reply[j].replier_id == $("#UserId").val()) {
                            replier_name = reply[j].replier_name + '(私信)';
                            replier_photo = $("#imageUrl").val() + reply[j].replier_photo;
                        } else if (reply[j].reply_type == 'SX' && reply[j].commentator_id == $("#UserId").val()) {
                            replier_name = reply[j].replier_name + '(私信)';
                            replier_photo = $("#imageUrl").val() + reply[j].replier_photo;
                        } else if (reply[j].reply_type == 'SX') {
                            continue;
                        }

                        if (reply[j].comment_type == 'NM' && reply[j].commentator_id == $("#UserId").val()) {
                            commentator_name2 = reply[j].commentator_name + '(匿名)'
                        } else if (reply[j].comment_type == 'NM') {
                            commentator_name2 = '匿名'
                        } else {
                            commentator_name2 = reply[j].commentator_name
                        }

                        if(replier_photo==($("#imageUrl").val()+"null") || replier_photo==$("#imageUrl").val() || replier_photo==($("#imageUrl").val() + "undefined")){
                            replier_photo="/res/public/img/icons/tx.png"
                        }

                        html += '<div class="social-comment">' +
                            '<div class="pull-left">' +
                            '<img alt="image" style="width: 50px;height: 50px" src="' + replier_photo + '">' +
                            '</div>' +
                            '<div class="media-body">' +
                            '<a>' + replier_name + '</a>' + ' 回复 ' + '<a>' + commentator_name2 + '</a>' +
                            '<small class="text-muted">' + reply[j].comment_time + '</small>' +
                            '<button class="btn btn-white btn-xs" onclick="myReply(' + "'" + reply[j].replier_name + "'" + "," + $("#_parent_id").val() + "," + reply[j].replier_id + "," + "'" + comment_type_head + "'" + "," + "'" + reply[j].comment_type + "'" + "," + "'" + reply[j].reply_type + "'" + ')"><i class="fa fa-comments"></i> 回复</button>';
                        if (reply[j].replier_id == $("#UserId").val()) {
                            html += '<button class="btn btn-white btn-xs" onclick="deleteComments(' + reply[j].id + ')"><i class="fa fa-comments"></i> 删除</button>'
                        }
                        html += '<br>' + reply[j].content + '</div></div>';
                    }
                    html += '</div>';

                }
            }
            if (html == "") {
                html += '<div class="social-comment">暂无评论</div>';
            }
            $("#my_comments").html(html);
        }

        function myReply(commentator_name, parent_id, commentator_id, comment_type_head, comment_type, reply_type)
        {
            var str='';
            if(reply_type=='NM'){
                str="回复" + "匿名" + "：";
            }else{
                str="回复" + commentator_name + "：";
            }
            $("#_comments").attr("placeholder",str);
            $("#saveComments").attr("style","display: none");
            $("#saveReply").attr("style","display:");
            $("#_parent_id").val(parent_id);
            $("#commentator_name").val(commentator_name);
            $("#commentator_id").val(commentator_id);
            $("#_comment_type").val(reply_type);
            $("#comment_original").attr("style","display:");

            if(comment_type=='SX'){
                $("input[name='comment_type'][value='SX']").attr("checked",true);
                $("#type1").attr("style","display: none");
                $("#type2").attr("style","display: none");
                $("#type3").attr("style","display: none");
            }else{
                $("#type1").attr("style","display:");
                $("#type2").attr("style","display:");
                $("#type3").attr("style","display:");
            }

            if(reply_type=='SX'){
                $("input[name='comment_type'][value='SX']").attr("checked",true);
                $("#type1").attr("style","display: none");
                $("#type2").attr("style","display: none");
                $("#type3").attr("style","display: none");
            }else{
                $("#type1").attr("style","display:");
                $("#type2").attr("style","display:");
                $("#type3").attr("style","display:");
            }
        }

        function commentsUpdate(logId)
        {
            var comments={};
            var url = "${root}/manage/comments/getComments/" + logId + "/" +  0 + "/MZJH" + "/" + 0;
            url=encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type : 'post',
                       async : false,
                       success: function(result) {
                           comments = result.reply
                       }
                   });
            return comments
        }

        function getReply(logId, comments_id, creator_id)
        /*
         logId是该日志的id
         comments_id是父评论的id
         creator_id是日志创建人的id
         */
        {
            var reply = {};
            var url = "${root}/manage/comments/getReply/" + logId + "/" +  comments_id + "/MZJH" + "/" + creator_id;
            url=encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type : 'post',
                       async : false,
                       success: function(result) {
                           reply = result.reply
                       }
                   });
            return reply
        }

        function saveComments()
        {
            if($("#_comments").val()=="" || $("#_comments").val()==null){
                layer.confirm('不能评论空白信息', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                });
            }else{
                layer.confirm('确定评论吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    var url = "${root}/manage/comments/saveComments/MZJH/" +log_id + "/" + creator_id + "/" + work_date + "/" + $("input[name='comment_type']:checked").val() + "/" + creator;
                    url=encodeURI(encodeURI(url));
                    $.ajax({
                               url: url,
                               type : 'post',
                               async : false,
                               data: {
                                   comment_type:$("input[name='comment_type']:checked").val(),
                                   business_type:"MZJH",
                                   business_id:$("#log_id").val(),
                                   content:$("#_comments").val(),
                                   parent_id:0
                               },
                               success:function(response){
                                   myComments(log_id, commentsUpdate(log_id), creator_id, creator);
                                   if (response.msgCode == 1) {
                                   }
                                   layer.msg(response.msgDesc);
                               }
                           });
                });
            }
        }
        function saveReply()
        {
            if($("#_comments").val()=="" || $("#_comments").val()==null){
                layer.confirm('不能回复空白信息', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                });
            }else{
                layer.confirm('确定回复吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    var url = "${root}/manage/comments/saveReply/MZJH/" + log_id + "/" + $("#commentator_id").val() + "/" + work_date + "/" +$("input[name='comment_type']:checked").val()+ "/" + $("#commentator_name").val();
                    url=encodeURI(encodeURI(url));
                    $.ajax({
                               url: url,
                               type : 'post',
                               async : false,
                               data: {
                                   commentator_name: $("#commentator_name").val(),
                                   commentator_id: $("#commentator_id").val(),
                                   comment_type: $("#_comment_type").val(),//不对
                                   reply_type: $("input[name='comment_type']:checked").val(),
                                   business_type: "MZJH",
                                   business_id: $("#log_id").val(),
                                   content: $("#_comments").val(),
                                   parent_id: $("#_parent_id").val()
                               },
                               success:function(response){
                                   myComments(log_id, commentsUpdate(log_id), creator_id, creator);
                                   if (response.msgCode == 1) {
                                   }
                                   layer.msg(response.msgDesc);
                               }});
                });
            }
        }

        function deleteComments(comments_id){
            layer.confirm('确定删除吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/comments/delComments?id=' + comments_id;
                $.ajax({
                           url: url,
                           type: 'post',
                           cache: false,
                           async: false,
                           success: function (response) {
                               myComments(log_id, commentsUpdate(log_id), creator_id, creator);
                               if (response.msgCode == 1) {
                               }
                               layer.msg(response.msgDesc);
                           }
                       });
            }, function (index) {
                layer.close(index);
            });
        }

    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="log_id" value="${id}"/>
<input type="hidden" id="UserId" value="${UserId}"/>
<input type="hidden" id="imageUrl" value="${imageUrl}"/>
<input type="hidden" id="_comment_type" />
<input type="hidden" id="commentator_name" />
<input type="hidden" id="commentator_id" />
<input type="hidden" id="_parent_id" />
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>

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
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务开始日期：</label>
                            <div class="col-sm-6">

                                <input ng-model="model.weekLog.task_start_date" type="text" class="form-control"
                                       id="task_start_date" name="task_start_date" required='true' onclick="laydate()"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务结束日期：</label>
                            <div class="col-sm-6">

                                <input ng-model="model.weekLog.task_end_date" type="text" class="form-control"
                                       id="task_end_date" name="task_end_date" required='true' onclick="laydate()"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div id="status_name_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="status_name" name="status_name"
                                       readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入类别：</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="create_type" readonly="true">
                                </select>
                            </div>
                            <div class="col-sm-2">
                                <span></span>
                            </div>
                        </div>
                    </div>
                    <div id="creator_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.weekLog.creator" type="text" class="form-control" id="creator"
                                       name="creator" readonly="true"/>

                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.weekLog.create_date" type="text" class="form-control"
                                       id="create_date" name="create_date" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.weekLog.modifier" type="text" class="form-control" id="modifier"
                                       name="modifier" readonly="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.weekLog.modify_date" type="text" class="form-control"
                                       id="modify_date" name="modify_date" readonly/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <%--任务列表--%>
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>任务列表</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="toolbardiv" id="goodsToolBar">
                        <a id="addNewTask" style="display :none" class="btn btn-success btn-sm"
                           href="javascript:beginEdit(-1);"><i
                                class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>
                    </div>
                    <table id="task"></table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-9">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>总结信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>

                <div class="ibox-content">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">每周总结：</label>
                            <div class="col-sm-9" id="week_summary_div">
                                <textarea type="text" ng-model="model.weekLog.week_summary" class="richtext"
                                          id="week_summary" name="richtext" required='true' rows='5'></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 ">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">下周计划：</label>
                            <div class="col-sm-9" id="next_plan_div">
                                <textarea type="text" ng-model="model.weekLog.next_plan" class="richtext"
                                          id="next_plan" name="richtext" required='true' rows='5'></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-12 ">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">事项说明：</label>
                            <div class="col-sm-9">
                                <textarea type="text" ng-model="model.weekLog.work_explain" class="richtext"
                                          id="work_explain" name="richtext" rows='5'></textarea>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <div class="col-sm-3" style="height: 470px;">

            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>浏览记录</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-sm-12">
                        <div title="浏览记录" style="overflow:auto;padding:4px;">
                            <div class="scroll">
                                <div class="imgs" id="glance" style="height:80px">
                                </div>

                                <ul class="tip" id="lljl">
                                </ul>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <div class="col-sm-3" style="height: 230px;">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>点赞记录</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-sm-12">
                        <div title="点赞记录" style="overflow:auto;padding:4px;">
                            <div class="scroll">
                                <div class="imgs" id="thumbs" style="height:80px">
                                </div>
                                <ul class="tip" id="dz">
                                </ul>
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
                    <a class="collapse-link">
                        <div class="ibox-title">
                            <h5>评论信息</h5>
                            <div class="ibox-tools">
                                <i class="fa fa-chevron-up"></i>
                            </div>
                        </div>
                    </a>
                    <div class="col-sm-9">
                        <div class="ibox-content">
                            <div class="col-sm-12 ">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"></label>
                                    <div class="col-sm-9">
                                        <div class="social-feed-box ">
                                            <div class="social-footer">
                                                <div id="my_comments"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"></label>
                                    <div class="col-sm-9">
                                        <textarea type="text"  id="_comments" name="_comments" rows='5' cols="152" placeholder="评论这条日志......"></textarea>
                                        <div align="center">
                                            <a id="saveComments" class='btn btn-primary btn-sm' href='###' onclick="saveComments()"><i class='fa fa-check'></i>&nbsp;&nbsp;评论</a>&nbsp;&nbsp;
                                            <a id="saveReply" style="display: none" class='btn btn-primary btn-sm' href='###' onclick="saveReply()"><i class='fa fa-check'></i>&nbsp;&nbsp;回复</a>&nbsp;&nbsp;
                                            <div id="type1" class="radio radio-info radio-inline">
                                                <input type="radio" id="open" value="GK" name="comment_type" checked="">
                                                <label for="open"> 公开 </label>
                                            </div>
                                            <div id="type2" class="radio radio-warning radio-inline">
                                                <input type="radio" id="anonymous" value="NM" name="comment_type">
                                                <label for="anonymous"> 匿名</label>
                                            </div>
                                            <div id="type3" class="radio radio-danger radio-inline">
                                                <input type="radio" id="private" value="SX" name="comment_type">
                                                <label for="private"> 私信</label>
                                            </div>
                                            <a id="comment_original" style="display: none" class='btn btn-warning btn-sm' href='###' onclick="saveComments()"><i class='fa fa-comments'></i>&nbsp;&nbsp;评论原日志</a>&nbsp;&nbsp;
                                            <div align="right">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
</body>
</html>
