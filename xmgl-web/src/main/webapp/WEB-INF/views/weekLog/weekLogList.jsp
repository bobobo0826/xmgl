<%--
  Created by IntelliJ IDEA.
  User: mjq
  Date: 2017/7/4
  Time: 10:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>周计划表</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp"></jsp:include>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"
            charset="UTF-8"></script>
    <script type="text/javascript">
        //这个是根据窗口的大小来调整table的大小
        $(window).resize(function () {
            $("#tt").datagrid("resize");
        });
        var _funcArray;
        var new_query_date = "";
        var _queryConfig;
        $(document).ready(function () {
            _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
            var height = $(window).height() - 75; //浏览器当前窗口可视区域高度
            getLogCreateTypeDic();
            getLogStatusTypeDic();
            if ($("#_curModuleCode").val() === "MY_MZJH") {
                $('#creator_head').hide();
            } else {
                $('#status_type_head').hide();
            }
            $("body").css("margin-bottom", '0px');
            if ($("#isOrNotNew").val() && $("#isOrNotNew").val() === "isNew") {
                new_query_date = $("#dateOfMonday").val();
            }
            var html = "";
            html += "<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
            for (var i = 0; i < _funcArray.length; i++) {
                var funcObj = _funcArray[i];
                switch (funcObj) {
                    case 'listQuery':
                        html += "<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;"
                            + "<a class='btn btn-warning btn-sm' onclick='ClearNewQueryDate()' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
                        break;
                    case 'listAdd':
                        html += "<a class='btn btn-success btn-sm' href='javascript:addNew();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
                        break;
                    default:
                        break;
                }
            }
            $("#operator").html(html);
            initStaffLogList(height);
        });
        //获取列表
        function initStaffLogList(height) {
            var url = "${root}/manage/commonWorkLog/getGridStyle?_curModuleCode=" + $("#_curModuleCode").val();
            var httpReqest = new HttpRequest();
            var datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
            var options = {
                url: getUrl(),
                sortable: true,
                singleSelect: true,
                pagination: true,
                height: height,
                width: 'auto',
                striped: true,
                rownumbers: true,
                remoteSort: true,
                view: detailview,
                detailFormatter: detailFormatter,
                onExpandRow: onExpandRow,
                remoteFilter: true,
                filterDelay: 2000,
                filterStringify: function (data) {
                    _filterRule = JSON.stringify(data);
                    return JSON.stringify(data);
                },
                frozenColumns: [[
                    {field: "id", title: "id", hidden: true},
                    {field: "creator_id", hidden: true, title: "录入人ID"},
                    {field: "modifier_id", hidden: true, title: "修改人ID"},
                    {
                        field: "act",
                        title: "操作",
                        resizable: true,
                        headalign: "center",
                        align: "center",
                        formatter: editf
                    },
                    {
                        field: "interaction",
                        title: "互动",
                        resizable: true,
                        headalign: "center",
                        align: "center",
                        formatter: editHD
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
                pageList: [20, 40, 60],
                afterPageText: '页  共{pages}页',
                displayMsg: '当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage: function (pageNumber, pageSize) {
                    var pagination = $('#tt').datagrid('getData').pagination;
                    var param = new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams = param;
                    $('#tt').datagrid('options').url = getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams = null;
                }
            });

            $('#tt').datagrid('enableFilter', [
                {field: 'act', type: 'label'},
                {field: 'interaction', type: 'label'},
                {
                    field: 'status_name',
                    type: 'combobox',
                    options: {
                        panelHeight: 'auto',
                        data: statusList,
                        valueField: "data_code",
                        textField: "data_name",
                        editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "status_code", value: row.data_code});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                },
                {
                    field: 'create_type',
                    type: 'combobox',
                    options: {
                        panelHeight: 'auto',
                        data: createTypeList,
                        valueField: "data_code",
                        textField: "data_name",
                        editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "create_type", value: row.data_code});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                }

            ]);
            $("input[name='task_start_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='task_end_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='create_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='modify_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });


        }
        //右击菜单事件处理
        function oprHandle(itemId, rowData, rowIndex) {
            switch (itemId) {
                case "saveGridStyle":
                    saveGridStyle("tt", "${root}/manage/commonWorkLog/saveGridStyle?_curModuleCode=" + $("#_curModuleCode").val());
                    break;
                case "showColumns":
                    var url = "${root}/manage/commonWorkLog/showGridColumn";
                    showOrHiddenColumns("tt", url, 0);
                    break;
                default:
                    break;
            }
        }

        /**
         * 按下enter键，即执行查询
         */
        $(document).keyup(function (event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        //动态加载操作栏下面的按钮
        function editf(value, row, index) {
            var e = '';
            for (var i = 0; i < _funcArray.length; i++) {
                var funcObj = _funcArray[i];
                switch (funcObj) {
                    case 'listInfo':
                        e += '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
                        break;
                }
            }
            for (var j = 0; j < _funcArray.length; j++) {
                var funcObj = _funcArray[j];
                switch (funcObj) {
                    case 'listDelete':
                        if ("草稿" === row.status_name) {
                            e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
                        }
                        break;
                    default:
                        break;
                }
            }
            return e;
        }

        //获取详情页面
        function editInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = [rows[index].id];
            var url = "${root}/manage/weekLog/weekLogInfoIndex/" + id + "/add/" + $("#_curModuleCode").val();
            parent.addTab("每周任务详情", url);
        }
        //新增
        function addNew() {
            var url = "${root}/manage/weekLog/weekLogInfoIndex/-1/add/" + $("#_curModuleCode").val();
            parent.addTab("新增每周任务", url);
        }
        //删除
        function deleteInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = [rows[index].id];
            layer.confirm('确定删除吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/weekLog/delWeekLogInfo?id=' + id;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (response) {
                        if (response.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(response.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function getUrl() {
            var url = "${root}/manage/weekLog/weekLogQueryList/" + getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }
        /**
         * 获取查询条件
         * @returns {string}
         */
        function getQueryCondition() {
            var obj = document.getElementById("create_type");
            var create_type = $("#create_type").val();
            var status_type = $("#status_type").val();
            var url = "?query_work_date_begin=" + $('#query_work_date_begin').val()
                + "&query_work_date_end=" + $('#query_work_date_end').val()
                + "&creator=" + $('#creator').val()
                + "&create_type=" + create_type
                + "&status_code=" + status_type
                + "&_curModuleCode=" + $("#_curModuleCode").val()
                + "&query_create_date_begin=" + $('#query_create_date_begin').val()
                + "&query_create_date_end=" + $('#query_create_date_end').val()
                + "&new_query_date=" + new_query_date;

            return url;
        }

        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        /**
         * 清空本周新增查询日期
         */
        function ClearNewQueryDate() {
            new_query_date = "";
        }
        var createTypeList
        function getLogCreateTypeDic() {
            var url = "${root}/manage/weekLog/getLogCreateTypeDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.logCreateTypeList, "create_type");
                    createTypeList = result.logCreateTypeList;
                }
            });
        }
        var statusList
        function getLogStatusTypeDic() {
            var url = "${root}/manage/weekLog/getLogStatusDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.logStatusList, "status_type");
                    statusList = result.logStatusList;
                }
            });
        }
        function getCurModuleCode() {
            return $('#_curModuleCode').val();
        }
        /**
         * 详情显示格式
         * @param rowIndex
         * @param rowData
         * @returns {string}
         */
        function detailFormatter(rowIndex, rowData) {
            //var html=getLabelInfo(rowIndex,rowData);
            var html = "";
            html += '<div  id="detail' + rowIndex + '">';
            html += '</div>';
            return html;
        }
        /**
         *
         * @param rowIndex
         * @param rowData
         */
        function onExpandRow(rowIndex, rowData) {

            var html = getLabelInfo(rowIndex, rowData);
            if (html)
                document.getElementById('detail' + rowIndex).innerHTML = html;
            //解决高度问题
            setTimeout(function () {
                $('#tt').datagrid('fixDetailRowHeight', rowIndex);//在加载爷爷列表明细（即：父列表）成功时，获取此时整个列表的高度，使其适应变化后的高度，此时的索引
                $('#tt').datagrid('fixRowHeight', rowIndex);//防止出现滑动条
            }, 0);

        }
        /**
         * 详细列表展开
         * @param rowIndex
         * @param rowData
         * @returns {string}
         */
        function getLabelInfo(rowIndex, rowData) {
            ids = "";
            var html = "";
            var url = "${root}/manage/weekLog/getWeekLogContentListById/" + rowData.id;
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                async: false,
                success: function (response) {
                    var task_content = response.weekLogTaskList;
                    var week_summary = response.week_summary;
                    var next_plan = response.next_plan;
                    var work_explain = "";
                    if (response.work_explain !== null && response.work_explain !== "") {
                        work_explain = response.work_explain;
                    }
                    if (task_content != null && task_content.length > 0) {
                        html += '<table style="text-align: left;">';
                        for (var i = 0; i < task_content.length; i++) {
                            var completeColor = getCompeleteColor(task_content[i].complete);
                            html += '<tr> <td style="width:  ; text-align: center;">'
                                + task_content[i].task_start_time + '<br>~<br>' + task_content[i].task_end_time
                                + '</td> <td style="width:1380px; padding:5px 20px 0px 20px"> <p>'
                                + '<strong>日志记录名称：</strong>' + task_content[i].task_name + '&nbsp;&nbsp;&nbsp;&nbsp;'
                                + '<strong>记录类别：</strong>' + transToName(task_content[i].task_type) + '&nbsp;&nbsp;&nbsp;&nbsp;';
                            if (task_content[i].plan_name != undefined) {
                                html += '<strong>任务名称：</strong>' + task_content[i].mission_name + '&nbsp;&nbsp;&nbsp;&nbsp;'
                                    + '<strong>计划名称：</strong>' + task_content[i].plan_name + '';
                                if (task_content[i].task_type == "RJYF") {
                                    html += '<strong>所属项目：</strong>' + task_content[i].sup_project + '&nbsp;&nbsp;&nbsp;&nbsp;'
                                        + '<strong>所属模块：</strong>' + task_content[i].sup_module + '&nbsp;&nbsp;&nbsp;&nbsp;';
                                }
                            } else if (task_content[i].task_type == "supporting" || task_content[i].task_type == "discussion"||task_content[i].task_type == "maintaining") {
                                html += '<strong>所属项目：</strong>' + task_content[i].sup_project + '&nbsp;&nbsp;&nbsp;&nbsp;'
                                    + '<strong>所属模块：</strong>' + task_content[i].sup_module + '&nbsp;&nbsp;&nbsp;&nbsp;';
                            }
                            html += '<span style="float:right; color:' + completeColor + '" >' + task_content[i].complete + '</span>'
                                + '</p><p><strong>工作记录：</strong>' + task_content[i].record + '</p>';
                            if(task_content[i].complete=="未完成"){
                                if (task_content[i].incomplete_explain == null && typeof(task_content[i].incomplete_explain) == "undefined") {
                                    task_content[i].incomplete_explain = "";
                                }
                                html += '<p><strong>未完成情况描述：</strong>' + task_content[i].incomplete_explain+'</p>';
                            }else if(task_content[i].delayReason != null&&typeof(task_content[i].delayReason) != "undefined"){
                                html += '<p><strong>延时原因：</strong>' + task_content[i].delayReason+'</p>';
                            }
                            html += '</td></tr>';
                        }
                        html += '</table>';
                        html += '<table style=" text-align: left;"><tr><td style=" width:568px;text-align: center;"> 每周总结 </td>'
                            + '<td style="width:502px;text-align: center;"> 下周计划 </td><td style=" width:569px;text-align: center;"> 事项说明 </td></tr>';
                        html += '<tr><td style="width:502px; padding:5px 20px 5px 20px">' + week_summary + '</td><td style=" width:568px;padding:5px 20px 5px 20px">' + next_plan +
                            '</td><td style="width:502px; padding:5px 20px 5px 20px">' + work_explain + '</td> </tr></table>';
                    } else {
                        html += '<table style="text-align: left;">';
                        html += '<tr><p style="text-align: center;margin-top: 10px;font-weight:bold;">暂无数据</p></tr></table>';


                    }
                },
                error: function () {
                    alert("出错!请联系管理员!");
                }
            });
            return html;
        }
        function transToName(value) {
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
        function getCompeleteColor(complete) {
            var color = '';
            if (complete == "已完成") {
                color = "#339933";
            } else if (complete == "未完成") {
                color = "#ed5666";
            }
            return color;
        }

        function editHD(value, row, index) {
            var rows = $('#tt').datagrid('getData').rows;
            var count = rows[index].count;
            var CommentsCount = rows[index].comments_count;
            var html = "";
            if (count == null) {
                count = 0;
            }
            if (CommentsCount == null) {
                CommentsCount = 0;
            }
            var thumbs_up_id = rows[index].thumbs_up_id;
            var UserId = $("#UserId").val();
            if (thumbs_up_id == UserId) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case ('thumpsUpCancel'):
                            html += '<a class="btn btn-xs btn-white" onclick="delThumbs_up(' + index + ');" style="border:1px solid lightskyblue"><i class="fa fa-thumbs-up"></i>取消赞(' + count + ')</a>';
                            break;
                        case ('listComments'):
                            html += '<a class="btn btn-xs btn-white" onclick="getComments(' + index + ');" style="border:1px solid lightskyblue"><i class="fa fa-comments"></i>&nbsp;&nbsp;&nbsp;评论&nbsp;&nbsp;(' + CommentsCount + ')</a>';
                            break;
                        default:
                            break;
                    }
                }
            } else {
                for (var j = 0; j < _funcArray.length; j++) {
                    var funcObj = _funcArray[j];
                    switch (funcObj) {
                        case ('thumbsUp'):
                            html += '<a class="btn btn-xs btn-white" onclick="getThumbs_up(' + index + ');" style="border:1px solid lightskyblue"><i class="fa fa-thumbs-up"></i>&nbsp;&nbsp;&nbsp;赞&nbsp;&nbsp;&nbsp;(' + count + ')</a>';
                            break;
                        case ('listComments'):
                            html += '<a class="btn btn-xs btn-white" onclick="getComments(' + index + ');" style="border:1px solid lightskyblue"><i class="fa fa-comments"></i>&nbsp;&nbsp;&nbsp;评论&nbsp;&nbsp;(' + CommentsCount + ')</a>';
                            break;
                        default:
                            break;
                    }
                }
            }
            return html
        }

        function getComments(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/weekLog/weekLogInfoIndex/" + id + "/" + "/comments/" + $("#_curModuleCode").val();
            parent.addTab("每周任务详情", url);
        }

        function getThumbs_up(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var type = "MZJH";
            $.ajax({
                type: "POST",
                async: false,
                url: "${root}/manage/thumbsUp/saveThumbsUpInfo",
                data: {

                    thumbs_up_type: type,
                    thumbs_up_subject_id: id

                },
                success: function (response) {
                    if (response.msgCode == 1) {
                        $('#tt').datagrid('load');
                        saveMessage(index, type);
                    }
                    layer.msg(response.msgDesc);
                }
            });
        }

        function delThumbs_up(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var type = "MZJH";
            layer.confirm('确定取消赞吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = "${root}/manage/thumbsUp/delThumbsUpInfo?id=" + id
                    + "&type=" + type;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (response) {
                        if (response.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(response.msgDesc);

                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }
        function saveMessage(index, type) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var creator_id = rows[index].creator_id;
            var task_start_date = rows[index].task_start_date;
            var creator = rows[index].creator;
            var url = "${root}/manage/thumbsUp/saveMessage/" + id + "/" + creator_id + "/" + type + "/" + task_start_date + "/" + creator;
            $.ajax({
                type: "POST",
                url: url,
                async: false,
                success: function (response) {
                }
            });
        }

    </script>
</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="UserId" value="${UserId}"/>
<input type="hidden" id="isOrNotNew" value="${isOrNotNew}"/>
<input type="hidden" id="dateOfMonday" value="${dateOfMonday}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style='display:none'>
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务起止日期:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class=" form-control" name="query_work_date_begin"
                                           id="query_work_date_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="query_work_date_end"
                                           id="query_work_date_end"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="creator_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入人:</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="creator" id="creator">

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入类别:</label>
                            <div class="col-sm-6">
                                <select id="create_type" class="form-control">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id="status_type_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态:</label>
                            <div class="col-sm-6">
                                <select class="form-control" name="status_type" id="status_type">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class=" form-control" name="query_create_date_begin"
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

</div>
</body>
</html>
