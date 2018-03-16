<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>项目管理</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp"></jsp:include>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"
            charset="UTF-8"></script>
    <script type="text/javascript">
        var _funcArray;
        var projectTypeList;
        var projectStatusList;
        var height = $(window).height() - 140; //浏览器当前窗口可视区域高度
        $(window).resize(function () {
            $("#tt").datagrid("resize");
        });

        $(document).ready(function () {
            _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
            initOpr();

            projectTypeList = getDictionaryList("project_type");
            addSelectOption(projectTypeList, "projectType");
            projectStatusList = getDictionaryList("project_status");
            addSelectOption(projectStatusList, "projectStatus");

            initDatagrid();
        });

        function initDatagrid() {
            var url = "${root}/manage/project/getGridStyle.action?_curModuleCode=" + $("#_curModuleCode").val();
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
                singleSelect: false,
                remoteSort: true,
                nowrap: false,
                remoteFilter: true,
                filterDelay: 2000,

                onDblClickRow: function (index, row) {
                    editInfo(index);
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
                {field: 'action', type: 'label'},
                {
                    field: 'project_type', type: 'combobox',
                    options: {
                        panelHeight: 'auto', data: projectTypeList, valueField: "data_code",
                        textField: "data_name", editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "project_type_code", value: row.data_code});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                },
                {
                    field: 'project_status', type: 'combobox',
                    options: {
                        panelHeight: 'auto', data: projectStatusList, valueField: "data_code",
                        textField: "data_name", editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "project_status_code", value: row.data_code});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                }
            ]);

            $("input[name='create_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='modify_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='develop_start_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='develop_end_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='maintain_start_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='maintain_end_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });

        }
        $(document).keyup(function (event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function editf(value, row, index) {
            var t = '';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'projectInfo':
                            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
                            break;
                        case 'projectDelete':
                            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow(' + index + ')">删除</a>]';
                            break;
                        default:
                            break;
                    }
                }
            }
            return t;
        }
        function delRow(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/project/delProjectInfoById?id=" + id;
            layer.confirm(_DELETE_ONE_MSG, {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                $.ajax({
                    url: url,
                    type: 'delete',
                    success: function (response) {

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
        function getUrl() {
            var url = "${root}/manage/project/queryProjectList" + getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition() {
            var url = "?project_name=" + $('#projectName').val()
                + "&project_abbr=" + $('#projectAbbr').val()
                + "&project_type_code=" + $('#projectType').val()
                + "&develop_start_time_begin=" + $('#develop_start_time_begin').val()
                + "&develop_start_time_end=" + $('#develop_start_time_end').val()
                + "&develop_end_time_begin=" + $('#develop_end_time_begin').val()
                + "&develop_end_time_end=" + $('#develop_end_time_end').val()
                + "&maintain_start_time_begin=" + $('#maintain_start_time_begin').val()
                + "&maintain_start_time_end=" + $('#maintain_start_time_end').val()
                + "&maintain_end_time_begin=" + $('#maintain_end_time_begin').val()
                + "&maintain_end_time_end=" + $('#maintain_end_time_end').val();
            return url;
        }

        // 查询
        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        function addNew() {
            var url = "${root}/manage/project/initProjectInfo?id=0&_curModuleCode=" + $("#_curModuleCode").val() + "&oprCode=newProject";
            parent.addTab("新增项目", url);
        }
        function editInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url = "${root}/manage/project/initProjectInfo?id=" + id + "&_curModuleCode=" + $("#_curModuleCode").val() + "&oprCode=projectInfo";
            parent.addTab("项目详情", url);
        }
        /*
         function getProjectTypeList() {
         var url = "${root}/manage/project/getProjectTypeList";
         url = encodeURI(encodeURI(url));
         $.ajax({
         url: url,
         type: 'get',
         async: false,
         success: function (result) {
         addSelectOption(result.projectTypeList, "projectType");
         projectTypeList = result.projectTypeList;

         }
         });
         }
         */
        function getDictionaryList(businessCode) {
            var dictionaryList = "";
            var url = "${root}/manage/project/getDicListByBusinessCode?businessCode=" + businessCode;
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: false,
                success: function (result) {
                    dictionaryList = result.dictionaryList;
                }
            });
            return dictionaryList;
        }
        function initOpr() {
            var html = '';
            html += '<a class="btn btn-danger btn-sm" href="javascript:doHideOrShowPrint();" id="hideOrShowBt"><i class="fa fa-arrow-up"></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'listQuery':
                            html += '<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;';
                            html += '<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;';
                            break;
                        case 'newProject':
                            html += '<a class="btn btn-success btn-sm" href="javascript:addNew();"><i class="fa fa-plus"></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;';
                            break;
                        default:
                            break;
                    }
                }
            }
            $("#operator").html(html);
        }
    </script>
</head>

<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style="display:none">
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="projectName" name="projectName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目简称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="projectAbbr" name="projectAbbr"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目类型:</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="projectType" name="projectType"
                                        onchange="doQuery()"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目状态:</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="projectStatus" name="projectStatus"
                                        onchange="doQuery()"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开发开始时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="develop_start_time_begin"
                                           id="develop_start_time_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="develop_start_time_end"
                                           id="develop_start_time_end"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开发结束时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="develop_end_time_begin"
                                           id="develop_end_time_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="develop_end_time_end"
                                           id="develop_end_time_end"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">维护开始时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="maintain_start_time_begin"
                                           id="maintain_start_time_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="maintain_start_time_end"
                                           id="maintain_start_time_end"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">维护结束时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="maintain_end_time_begin"
                                           id="maintain_end_time_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="maintain_end_time_end"
                                           id="maintain_end_time_end"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator">
</div>
<div id="tt"></div>
</body>
</html>
