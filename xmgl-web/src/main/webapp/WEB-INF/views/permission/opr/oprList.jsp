<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>操作管理</title>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            getModuleList();
            var html = "";
            html += "<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-success btn-sm' href='javascript:addInfo();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-info btn-sm' href='javascript:mutiSelectOpr();' id='dc'><i class='fa fa-check'></i>&nbsp;&nbsp;批量选择</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-info btn-sm' href='javascript:mutiUnSelectOpr();' id='dc'><i class='fa fa-check'></i>&nbsp;&nbsp;批量不选择</a>&nbsp;&nbsp;";
            $("#operator").html(html);

            $("#tt").datagrid({
                url: getUrl(),
                sortable: true,
                singleSelect: false,
                remoteSort: false,
                pagination: true,
                height: 'auto',
                width: 'auto',
                columns: [
                    [
                        {
                            field: "ck",
                            checkbox: true
                        },
                        {
                            field: "action",
                            title: "操   作",
                            resizable: true,
                            width: 100,
                            align: "center",
                            formatter: editf
                        },
                        {
                            field: "oprid",
                            title: "操作编号",
                            resizable: true,
                            width: 100,
                            headalign: "center",
                            sortable: true
                        },
                        {
                            field: "sup_module",
                            title: "所属模块",
                            resizable: true,
                            width: 250,
                            headalign: "center",
                            sortable: true
                        },
                        {
                            field: "oprname",
                            title: "操作名称",
                            resizable: true,
                            width: 250,
                            headalign: "center",
                            sortable: true
                        },
                        {
                            field: "opralias",
                            title: "操作别名",
                            resizable: true,
                            width: 250,
                            headalign: "center",
                            sortable: true
                        },
                        {
                            field: "oprdesc",
                            title: "操作描述",
                            resizable: true,
                            width: 300,
                            headalign: "center",
                            sortable: true
                        },
                        {
                            field: "oprused",
                            title: "是否选择",
                            resizable: true,
                            width: 150,
                            headalign: "center",
                            sortable: true,
                            formatter: formatterValue
                        },
                        {
                            field: "url",
                            title: "url",
                            resizable: true,
                            width: 300,
                            headalign: "center",
                            sortable: true
                        }
                    ]
                ],
                onDblClickRow: function (index, row) {
                    editInfo(index);
                }
            });
            $('#tt').datagrid('getPager').pagination({
                pageList: [20, 40, 60],
                afterPageText: '页  共{pages}页',
                displayMsg: '当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage: function (pageNumber, pageSize) {
                    var pagination = $('#tt').datagrid(
                        'getData').pagination;
                    var param = new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams = param;
                    $('#tt').datagrid('options').url = getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams = null;
                }
            });
        });
        $(document).keyup(function (event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        //动态加载操作栏下面的按钮
        function editf(value, row, index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">修改</a>]';
            var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delInfo(' + index + ')">删除</a>]';
            var total = e + " " + c;
            return total;
        }
        function editInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var oprId = rows[index].oprid;
            var width = "85%";
            var height = "60%";
            url = "${root}/manage/opr/tcOprInfoIndex?oprId=" + oprId;
            f_open("newWindows", "编辑操作管理", width, height, url, true);
        }

        function addInfo() {
            var width = "85%";
            var height = "60%";
            var url = "${root}/manage/opr/tcOprInfoIndex?oprId=";
            f_open("newWindows", "新增操作管理", width, height, url, true);
        }

        function delInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var oprId = rows[index].oprid;
            var supModule = rows[index].sup_module;
            layer.confirm('确定删除吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/opr/delOprInfo/' + oprId;
                $.ajax({
                    url: url,
                    type: 'post',
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                            updateModuleOperateSetByModuleName(supModule)
                        }
                    },
                    error: function (result) {
                        layer.msg("系统异常，请联系系统管理员");
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function mutiSelectOpr() {
            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            if (!isEmpty(selectedRows)) {
                for (var i = 0; i < selectedRows.length; i++) {
                    var oprused = selectedRows[i].oprused;
                    if (oprused == '1') {
                        layer.alert("选择的操作中有选择状态的操作");
                        return;
                    }
                    idsStr += selectedRows[i].oprid + ",";
                }
            }
            layer.confirm('确定批量选择吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/opr/mutiSelectOpr/' + idsStr;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function mutiUnSelectOpr() {
            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            if (!isEmpty(selectedRows)) {
                for (var i = 0; i < selectedRows.length; i++) {
                    var oprused = selectedRows[i].oprused;
                    if (oprused == '0') {
                        layer.alert("选择的操作中有未选择状态的操作");
                        return;
                    }
                    idsStr += selectedRows[i].oprid + ",";
                }
            }
            layer.confirm('确定批量不选择吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/opr/mutiUnSelectOpr/' + idsStr;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function formatterValue(value, row, index) {
            if (value == "0") {
                return "未选择";
            } else {
                return "已选择";
            }
        }

        function getQueryCondtion() {
            var url = "?oprName=" + $("#oprName").val()
                + "&oprAlias=" + $("#oprAlias").val()
                + "&oprUsed=" + $("#oprUsed option:selected").val()
                + "&supModule=" + $("#sup_module").val();
            return url;
        }

        function doQuery() {
            var url = getUrl();
            url = encodeURI(encodeURI(url));
            $('#tt').datagrid('options').url = url;
            $('#tt').datagrid('load');
        }

        function getUrl() {
            var url = "${root}/manage/opr/tcOprQueryList" + getQueryCondtion();
            return url;
        }

        function getModuleList(def) {
            var moduleId = document.getElementById("sup_module");
            var url = '${root}/manage/menuModule/getModuleIdList';
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                success: function (result) {
                    moduleId.options.length = 0;
                    var fOpt = new Option("", "");
                    moduleId.options.add(fOpt);
                    if (null != result) {
                        for (var i = 0; i < result.length; i++) {
                            var opt = document.createElement("option");
                            opt.value = result[i].modulename;
                            opt.text = result[i].modulename;
                            moduleId.options.add(opt);
                        }
                        moduleId.value = def;
                    }
                },
                error: function () {
                    alert("出错!请联系管理员!");
                }
            });
        }

        function updateModuleOperateSetByModuleName(moduleName) {
            var url = '${root}/manage/module/updateModuleOperateSetByModuleName?moduleName=' + moduleName;
            $.ajax({
                type: 'post',
                url: url,
                success: function (result) {}
            });
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea">
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="oprName" name="oprName">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作别名:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="oprAlias" name="oprAlias">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">所属模块:</label>
                            <div class="col-sm-6">
                                <select name="sup_module" id="sup_module" emptyOption="true" class="form-control" required='true'></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">是否选择:</label>
                            <div class="col-sm-6">
                                <select id="oprUsed" class="form-control">
                                    <option value=""></option>
                                    <option value=0>未选择</option>
                                    <option value=1>已选择</option>
                                </select>
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
</body>
</html>

 