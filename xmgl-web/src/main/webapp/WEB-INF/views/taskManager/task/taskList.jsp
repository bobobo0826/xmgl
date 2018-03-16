<%--
  Created by wjy
  Date: 2017/7/26
  Time: 15:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>任务信息列表</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp"></jsp:include>

</head>
<body>

<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="cur_user_id" value="${user_id}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style='display:none'>
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务类型：</label>
                            <div class="col-sm-6">
                                <div class="input-group col-sm-12">
                                    <select type="text" class="form-control" id="task_type"
                                            name="task_type">
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务状态：</label>
                            <div class="col-sm-6">
                                <select class="form-control" name="task_condition" id="task_condition">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" name="task_name" id="task_name"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称：</label>
                            <div class="col-sm-6">
                                <input type="text" id="sup_project_name" class="form-control"/>

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">模块名称：</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="sup_module_name" id="sup_module_name"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="creator" id="creator"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="query_create_date_begin"
                                           id="query_create_date_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="query_create_date_end"
                                           id="query_create_date_end"/>
                                </div>
                            </div>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(window).resize(function () {
        $("#tt").datagrid("resize");
    });
    var _funcArray;
    var _queryConfig;
    $(document).ready(function () {
        getTaskDic();
        _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
        console.log(_funcArray);
        var height = $(window).height() - 75; //浏览器当前窗口可视区域高度
        $("body").css("margin-bottom", '0px');
        var html = "";
        html += "<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
        /*        var funcFlag={listQuery :false, addTask:false, multiSubmit:false, multiCheck:false, multiDistribute:false};*/
        var funcFlag=new Array(5);
        for (var i=0;i<funcFlag.length;i++){
            funcFlag[i]=false;
        }
        for (var i = 0; i < _funcArray.length; i++) {
            var funcObj = _funcArray[i];
            switch (funcObj) {
                case 'listQuery':
                    funcFlag[0]=true;
                    break;
                case 'addTask':
                    funcFlag[1]=true;
                    break;
                case 'multiSubmit':
                    funcFlag[2]=true;
                    break;
                case 'multiCheck':
                    funcFlag[3]=true;
                    break;
                case 'multiDistribute':
                    funcFlag[4]=true;
                    break;
                default:
                    break;
            }
        }
        if (funcFlag[0]){ html += "<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
        }
        if (funcFlag[1]){html += "<a class='btn btn-success btn-sm' href='javascript:addNew();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
        }
        if (funcFlag[2]){html += "<a class='btn btn-success btn-sm' href='javascript:multiSubmit();'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;";
        }
        if (funcFlag[3]){html += "<a class='btn btn-success btn-sm' href='javascript:multiCheck();'><i class='fa fa-check'></i>&nbsp;&nbsp;审核</a>&nbsp;&nbsp;";
        }
        if (funcFlag[4]){html += "<a class='btn btn-warning btn-sm' href='javascript:multiDistribute();'><i class='fa fa-send'></i>&nbsp;&nbsp;下发任务</a>&nbsp;&nbsp;";
        }
        $("#operator").html(html);
        initTaskList(height);
    });
    $(document).keyup(function (event) {
        if (event.keyCode == 13) {
            doQuery();
        }
    });
    function initTaskList(height) {
        var url = "${root}/manage/task/getGridStyle?_curModuleCode=" + $("#_curModuleCode").val();
        var httpReqest = new HttpRequest();
        var datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
        var options = {
            url: getUrl(),
            sortable: true,
            singleSelect: false,
            pagination: true,
            height: height,
            width: 'auto',
            striped: true,
            rownumbers: true,
            view: detailview,
            detailFormatter: detailFormatter,
            onExpandRow: onExpandRow,
            remoteSort: true,
            remoteFilter: true,
            filterDelay: 2000,
            filterStringify: function (data) {
                _filterRule = JSON.stringify(data);
                return JSON.stringify(data);
            },
            frozenColumns: [[
                {field: "id", title: "id", hidden: true},
                {field: "creator_id", hidden: true, title: "创建人ID"},
                {field: "ck", checkbox: true},
                {
                    field: "act",
                    title: "操作",
                    width: 80,
                    resizable: true,
                    headalign: "center",
                    align: "center",
                    formatter: editf
                }
            ]],
            onDblClickRow: function (rowIndex) {
                editInfo(rowIndex);
            },
            onSortColumn: function (sort, order) {
                datagridSort(sort, order, "tt", getUrl());
            },
            onRowContextMenu: function (e, rowIndex, rowData) {
                e.preventDefault();
                $('#cntMenu').menu({
                    onClick: function (item) {
                        oprHandle(item.id, rowData, rowIndex);
                    }
                });
                $('#cntMenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            },
            onHeaderContextMenu: function (e, rowIndex, rowData) {
                e.preventDefault();
                $('#cntMenu').menu({
                    onClick: function (item) {
                        oprHandle(item.id, rowData, rowIndex);
                    }
                });
                $('#cntMenu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }

        };
        options.columns = eval(datagridStyleConfig);
        $("#tt").datagrid(options);
        $('#tt').datagrid('getPager').pagination({
            pageList: [20, 40, 60, 80, 100, 200],
            pageSize: 20,
            afterPageText: '页  共{pages}页',
            displayMsg: '当前显示第{from}~{to}条记录，共{total}条记录',
            onSelectPage: function (pageNumber, pageSize) {
                datagridPagination(pageNumber, pageSize, "tt", getUrl());
            }
        });

        $('#tt').datagrid('enableFilter', [
            {field: 'act', type: 'label'},
            {field: 'complete', type: 'label'},
            {
                field: 'task_type', type: 'combobox',
                options: {
                    panelHeight: 'auto', data: taskTypeList, valueField: "data_code",
                    textField: "data_name", editable: false,
                    onSelect: function (row) {
                        $('#tt').datagrid('addFilterRule', {field: "task_type", value: row.data_code});
                        $('#tt').datagrid('doFilter')
                    }
                }
            },
            {
                field: 'task_condition', type: 'combobox',
                options: {
                    panelHeight: 'auto', data: taskConditionList, valueField: "data_code",
                    textField: "data_name", editable: false,
                    onSelect: function (row) {
                        $('#tt').datagrid('addFilterRule', {field: "task_condition", value: row.data_code});
                        $('#tt').datagrid('doFilter')
                    }
                }
            },
            {
                field: 'report_cycle', type: 'combobox',
                options: {
                    panelHeight: 'auto', data: reportCycleList, valueField: "data_code",
                    textField: "data_name", editable: false,
                    onSelect: function (row) {
                        $('#tt').datagrid('addFilterRule', {field: "report_cycle", value: row.data_code});
                        $('#tt').datagrid('doFilter')
                    }
                }
            }
        ]);
        $("input[name='create_time']").bind("click", function () {
            ShowDiv('MyDiv', 'fade', $(this).attr("name"))
        });
        $("input[name='modify_time']").bind("click", function () {
            ShowDiv('MyDiv', 'fade', $(this).attr("name"))
        });
    }

    function oprHandle(itemId, rowData, rowIndex) {
        switch (itemId) {
            case "saveGridStyle":
                saveGridStyle("tt", "${root}/manage/task/saveGridStyle?_curModuleCode=" + $("#_curModuleCode").val());
                break;
            case "showColumns":
                var url = "${root}/manage/task/showGridColumn";
                showOrHiddenColumns("tt", url, 0);
                break;
            default:
                break;
        }
    }
    /**
     * 设置紧急和重要的颜色
     * */
    function setColor(value, row, index) {
        if (value == "紧急" || value == "重要") {
            return '<span style="color:red">' + value + '</span>';
        }
        else {
            return value;
        }
    }

    function getUrl() {
        var url;
        url = "${root}/manage/task/queryTaskList/" + getQueryCondition();
        url = encodeURI(encodeURI(url));
        return url;
    }

    /**
     * 获取查询条件
     * @returns {string}
     */
    function getQueryCondition() {
        var url = "";
        url += "?task_type=" + $("#task_type").val() +
            "&task_condition=" + $("#task_condition").val() +
            "&task_name=" + $("#task_name").val() +
            "&sup_project_name=" + $("#sup_project_name").val() +
            "&sup_module_name=" + $("#sup_module_name").val() +
            "&query_create_date_begin=" + $('#query_create_date_begin').val() +
            "&query_create_date_end=" + $('#query_create_date_end').val();

        return url;
    }

    function editf(value, row, index) {

        var e = '';
        for (var i = 0; i < _funcArray.length; i++) {
            var funcObj = _funcArray[i];
            switch (funcObj) {
                case 'deleteTask':
                    if (row.task_condition == "草稿" && row.creator_id == $("#cur_user_id").val()) {
                        e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
                    }
                    break;
                case 'taskInfo':
                    e += '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
                    break;
                default:
                    break;
            }
        }
        return e;
    }

    /**
     * 进入日志的详情，进行编辑
     * @param index 行的索引
     *
     */
    function editInfo(index) {
        var rows = $('#tt').datagrid('getData').rows;
        var id = rows[index].id;
//            var creator_id = rows[index].creator_id;
        var url;
        url = "${root}/manage/task/initTaskInfo?id=" + id + "&_curModuleCode=" + $("#_curModuleCode").val();
        parent.addTab("任务信息详情", url);
    }

    function deleteInfo(index) {
        var rows = $('#tt').datagrid('getData').rows;
        var id = rows[index].id;
        var url = "${root}/manage/task/delTask/" + id;
        layer.confirm(_DELETE_ONE_MSG, {
            btn: ['确定', '取消'], //按钮
            shade: false //不显示遮罩
        }, function (index) {
            $.ajax({
                url: url,
                type: 'post',
                success: function (response) {
                    /**
                     * 操作成功
                     */
                    if (response.msgCode == 1) {
                        $('#tt').datagrid('reload');
                    }
                    layer.msg(response.msgDesc);
                },
                error: function (result) {
                    layer.msg("系统异常，请联系系统管理员");
                }
            });
        }, function (index) {
            layer.close(index);
        });
    }

    /**
     * 执行查询
     */
    function doQuery() {
        $('#tt').datagrid('options').url = getUrl();
        $('#tt').datagrid('load');
    }

    /**
     * 新建任务
     */
    function addNew() {
        var url = "${root}/manage/task/initTaskInfo?id=-1&_curModuleCode=" + $("#_curModuleCode").val();
        parent.addTab("新增任务", url);
    }
    /**
     *
     * 批量提交任务
     * */
    function multiSubmit() {
        var selectedRows = $('#tt').datagrid('getSelections');
        if (selectedRows.length == 0) {
            layer.msg("未选中行");
            return;
        }
        var flag = false;
        var num = 0;
        for (var i = 0; i < selectedRows.length; i++) {
            if (selectedRows[i].creator_id == $("#cur_user_id").val() && (selectedRows[i].task_condition == "待提交" || selectedRows[i].task_condition == "草稿")) {
                flag = false;
                num++;
            } else {
                flag = true;
            }
        }
        if (num == 0) {
            layer.msg("所选项中没有可以提交的任务,请重新选择！");
            return;
        }
        if (flag) {
            msg = "选择项中有不符合要求的任务，不能提交这些任务。提交符合的任务？";
        } else {
            msg = "确定提交这些任务吗？"
        }
        layer.confirm(msg, {
            btn: ['确定', '取消'],
            shade: false
        }, function (index) {
            var _curModuleCode = "XZZDSHR";//选择指定审核人
            var url = "${root}/manage/employee/selectEmployee?_curModuleCode=" + _curModuleCode;
            f_open("newWindow", "选择指定审核人", '800px', '50%', url, true);
            layer.close(index);
        }, function (index) {
            layer.close(index);
        })

    }
    /**
     * 批量审核
     * */
    function multiCheck() {
        var selectedRows = $('#tt').datagrid('getSelections');
        if (!selectedRows || selectedRows.length == 0) {
            layer.msg("未选中行");
            return;
        }
        var taskIdListStr = "";
        var flag = false;
        var num = 0;
        for (var i = 0; i < selectedRows.length; i++) {
            if (selectedRows[i].assigned_checker_id == $("#cur_user_id").val() && selectedRows[i].task_condition == "待审核") {
                taskIdListStr += "," + selectedRows[i].id;
                flag = false;
                num++;
            } else {
                flag = true;
            }
        }
        if (num == 0) {
            layer.msg("所选项中没有可以审核的任务,请重新选择！");
            return;
        }
        if (flag) {
            msg = "选择项中有不符合要求的任务，不能审核这些任务。审核符合的任务？";
        } else {
            msg = "确定审核这些任务吗？"
        }
        layer.confirm(msg, {
            btn: ['确定', '取消'],
            shade: false
        }, function (index) {
            var url = "${root}/manage/task/multiCheck?taskIdListStr=" + taskIdListStr;
            f_open("newWindow", "输入审核意见", '1000px', '600px', url, true);
            layer.close(index);
        }, function (index) {
            layer.close(index);
        });
    }
    /**批量提交界面调用
     * 设定指定审核人
     * */
    function setEmployeeInfo(object) {
        var selectedRows = $('#tt').datagrid('getSelections');
        if (selectedRows.length == 0) {
            layer.msg("未选中行");
            return;
        }
        var taskIdListStr = "";
        for (var i = 0; i < selectedRows.length; i++) {
            if (selectedRows[i].creator_id == $("#cur_user_id").val() && (selectedRows[i].task_condition == "待提交" || selectedRows[i].task_condition == "草稿")) {
                taskIdListStr += "," + selectedRows[i].id;
            }
        }
        var url = "${root}/manage/task/multiSubmit?assignedCheckerId=" + object.user_id + "&taskIdListStr=" + taskIdListStr + "&assignedChecker=" + object.employee_name;
        $.ajax({
            url: url,
            type: 'put',
            success: function (result) {
                layer.msg(result.msgDesc);
            }
        });
        doQuery();
    }
    /**
     *
     * 批量下发任务
     * */
    function multiDistribute() {
        var selectedRows = $('#tt').datagrid('getSelections');
        if (selectedRows.length == 0) {
            layer.msg("未选中行");
            return;
        }
        var taskIdListStr = "";
        var flag = false;
        var num = 0;
        for (var i = 0; i < selectedRows.length; i++) {
            if (selectedRows[i].creator_id == $("#cur_user_id").val() && selectedRows[i].task_condition == "已审核") {
                taskIdListStr += "," + selectedRows[i].id;
                flag = false;
                num++;
            } else {
                flag = true;
            }
        }
        if (num == 0) {
            layer.msg("所选项中没有可以下发的任务,请重新选择！");
            return;
        }
        if (flag) {
            msg = "选择项中有不符合要求的任务，不能下发这些任务。下发符合的任务？";
        } else {
            msg = "确定下发这些任务吗？"
        }
        layer.confirm(msg, {
            btn: ['确定', '取消'],
            shade: false
        }, function (index) {
            var url = "${root}/manage/task/multiDistribute?taskIdListStr=" + taskIdListStr;
            $.ajax({
                url: url,
                type: 'put',
                success: function (result) {
                    layer.msg(result.msgDesc);
                }
            });
            doQuery();
            layer.close(index);
        }, function (index) {
            layer.close(index);
        });
    }

    var taskTypeList;
    var taskConditionList;
    var reportCycleList;
    function getTaskDic() {
        var url = "${root}/manage/task/getTaskDic";
        url = encodeURI(encodeURI(url));
        $.ajax({
            url: url,
            type: 'post',
            async: false,
            success: function (result) {
                addSelectOption(result.taskTypeList, "task_type");
                taskTypeList = result.taskTypeList;
                addSelectOption(result.taskConditionList, "task_condition");
                taskConditionList = result.taskConditionList;
                reportCycleList = result.reportCycleList;
            }
        });
    }

    function detailFormatter(rowIndex, rowData) {
        //var html=getLabelInfo(rowIndex,rowData);
        var html = "";
        html += '<div  id="detail' + rowIndex + '">';
        html += '</div>';
        return html;
    }
    function onExpandRow(rowIndex, rowData) {
        getLabelInfo(rowIndex, rowData,function (html){
            if (html)
                document.getElementById('detail' + rowIndex).innerHTML = html;
            //解决高度问题
            setTimeout(function () {
                $('#tt').datagrid('fixDetailRowHeight', rowIndex);//在加载爷爷列表明细（即：父列表）成功时，获取此时整个列表的高度，使其适应变化后的高度，此时的索引
                $('#tt').datagrid('fixRowHeight', rowIndex);//防止出现滑动条
            }, 0);
        });
    }
    function getLabelInfo(rowIndex, rowData , func) {
        var html = "";
        var url = "${root}/manage/task/queryPlanList?task_id=" + rowData.id;
        $.ajax({
            type: 'post',
            cache: false,
            url: url,
            async: true,
            success: function (response) {
                var planList = response;
                var statusColor = "";
                var status = "";
                var weight = "";
                var plan_desc = "";
                var plan_name = "";
                var start_date = "";
                var end_date = "";
                var start_end_date = "";
                if (planList && planList.length > 0) {
                    html += '<table  style="text-align: left;">';
                    for (var i = 0; i < planList.length; i++) {
                        var employee_name = "";
                        if (planList[i].participants) {
                            var employees = JSON.parse(planList[i].participants);
                            employee_name = connectNameStrArr(employees);
                        }
                        status = getStatus(planList[i].complete, planList[i].is_cancel);
                        if (planList[i].plan_desc) {
                            plan_desc = planList[i].plan_desc;
                        }
                        if (planList[i].plan_name) {
                            plan_name = planList[i].plan_name;
                        }
                        if (planList[i].start_date) {
                            if (planList[i].end_date !== null && typeof (planList[i].end_date) !== "undefined") {
                                start_date = planList[i].start_date;
                                end_date = planList[i].end_date;
                                start_end_date = start_date + '<br>' + end_date;
                            }
                        }


                        if (status == "已注销") {
                            weight = 600;
                        } else {
                            weight = "";
                        }
                        statusColor = getStatusColor(status);
                        html += '<tr> <td style="width:161px; text-align: center;">'
                            + start_end_date
                            + '</td> <td style="width:845px; padding:5px 20px 0px 20px">'
                            + '<span style="float:right; font-weight:' + weight + '; color:' + statusColor + '">' + status + '</span>'
                            + '<p><strong>计划名称：</strong>' + plan_name + '&nbsp;&nbsp;&nbsp;&nbsp;</p>'
                            + '<p><strong>参与人员：</strong>' + employee_name + '&nbsp;&nbsp;&nbsp;&nbsp;</p>'
                            + '</p></td>'
                            + '<td  style="width:945px; padding:5px 20px 0px 20px"><p><strong>计划描述：</strong>' + plan_desc + '</p></td></tr>';
                    }
                    html += '<tr><td style="text-align: center;" ><strong>任务描述</strong></td>';
                    if (rowData.task_desc !== null && typeof(rowData.task_desc) !== "undefined") {
                        html += '<td colspan="2">' + rowData.task_desc + '</td>';
                    }
                    html += '</tr>';
                    html += '<tr><td style="text-align: center;" ><strong>审核意见</strong></td>';
                    if (rowData.check_desc !== null && typeof(rowData.check_desc) !== "undefined") {
                        html += '<td colspan="2">' + rowData.check_desc + '</td>';
                    }
                    html += '</tr>';
                }
                func(html);
            },
            error: function () {
                alert("出错!请联系管理员!");
                func(html);
            }
        });
    }
    function connectNameStrArr(arr) {
        var names = [];
        for (var i = 0; i < arr.length; i++) {
            names.push(arr[i].name);
        }
        return names.join(',');
    }
    function getStatusColor(str) {
        var color = '';
        if (str == "已完成") {
            color = "#09990f";
        } else if (str == "未完成") {
            color = "#ed5666";
        } else if (str == "已注销") {
            color = "#ed5565"
        }
        return color;
    }
    /**
     * 状态：已注销，已完成，未完成。
     */
    function getStatus(complete, is_cancel) {
        var str = "";
        if (is_cancel == "已注销") {
            str = is_cancel;
        } else {
            str = complete;
        }
        return str;
    }
    //分支测试

</script>
<div align="center" id="operator"></div>
<div id="tt"></div>
<div id="cntMenu" class="easyui-menu" style="width:150px;">
    <div id="saveGridStyle" class='rightMenu'>保存列表样式</div>
    <div class="menu-sep"></div>
    <div id="showColumns">显示(隐藏)列</div>
    <div class="menu-sep"></div>
    <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"
            charset="UTF-8"></script>


</div>
</body>
</html>
