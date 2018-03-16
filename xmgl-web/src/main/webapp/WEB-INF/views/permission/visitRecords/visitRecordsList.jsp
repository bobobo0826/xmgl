<%--
  Created by IntelliJ IDEA.
  User: quangao-Lutianle
  Date: 2017/8/16
  Time: 9:53
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp"></jsp:include>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"
            charset="UTF-8"></script>
    <title>访问记录</title>

    <script type="text/javascript">
        var _funcArray;
        var _curModuleCode = "${_curModuleCode}";
        var height = $(window).height() - 140; //浏览器当前窗口可视区域高度
        $(window).resize(function () {
            $("#tt").datagrid("resize");
        });
        var _pageSize = '<%=request.getParameter("_pageSize")%>';
        $(document).ready(function () {
            _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);
            initOpr();

            $("#tt").datagrid({
                url: getUrl(),
                sortable: true,
                singleSelect: true,
                remoteSort: false,
                pagination: true,
                height: height,
                width: 'auto',
                striped: true,
                rownumbers: true,
                nowrap: true,
                columns: [[
                    {field: "id", title: "id", hidden: true},
                    {field: "action", title: "操作", resizable: true, width: 100, align: "center", formatter: edit},
                    {field: "user_name", title: "用户", resizable: true, width: 150, headalign: "center", sortable: true},
                    {field: "user_ip", title: "用户IP", resizable: true, width: 150, headalign: "center", sortable: true},
                    {
                        field: "visit_name",
                        title: "访问名称",
                        resizable: true,
                        width: 300,
                        headalign: "center",
                        sortable: true
                    },
                    {field: "path", title: "访问路径", resizable: true, width: 300, headalign: "center", sortable: true},

                    {
                        field: "parameter",
                        title: "参数",
                        resizable: true,
                        width: 600,
                        headalign: "center",
                        sortable: true,
                        formatter: remarkFormater
                    },
                    {
                        field: "visit_date",
                        title: "访问时间",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        sortable: true
                    },
                    {
                        field: "time_consuming",
                        title: "访问耗时",
                        resizable: true,
                        width: 150,
                        headalign: "center",
                        sortable: true
                    }

                ]],
            });

            $('#tt').datagrid('getPager').pagination({
                pageList: [20, 30, 40, 100, 200],
                pageSize: _pageSize,
                afterPageText: '页  共{pages}页',
                displayMsg: '当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage: function (pageNumber, pageSize) {
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

        function remarkFormater(value, row, index) {
            console.log("value=" + value + "  index=" + index);
            var content = '';
            var abValue = value + '';
            if (value != undefined) {
                if (value.length >= 100) {
                    abValue = value.substring(0, 97) + "...";
                    content = "<a href='javascript:;' data-html='false'  title='" + value + "' data-toggle='tooltip'>" + abValue + "</a>";
                } else {
                    content = "<a href='javascript:;' data-html='false'  title='" + value + "' data-toggle='tooltip'>" + value + "</a>";
                }
            }
            return content;
        }

        function delRow(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/permission/delVisitRecordById?id=" + id;
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
        function doQuery() {
            var url = getUrl();
            url = encodeURI(encodeURI(url));
            $('#tt').datagrid('options').url = url;
            $('#tt').datagrid('load');
        }

        function getUrl() {
            var url = "${root}/manage/permission/queryVisitRecordList" + getQueryCondtion();
            return url;
        }
        function getQueryCondtion() {
            var url = "?visit_name=" + $('#visitName').val()
                + "&user_name=" + $('#userName').val()
                + "&query_visit_date_begin=" + $('#queryVisitDateBegin').val()
                + "&query_visit_date_end=" + $('#queryVisitDateEnd').val();
            return url;
        }

        function edit(value, row, index) {
            var t = '';
            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow(' + index + ')">删除</a>]';
            return t;
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
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style="display:none">
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">访问名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="visitName" name="visitName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">用户:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="userName" name="userName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">访问时间:</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input onclick="laydate()" class="form-control" name="queryVisitDateBegin"
                                           id="queryVisitDateBegin"/>
                                    <span class="input-group-addon"></span>
                                    <input onclick="laydate()" class="form-control" name="queryVisitDateEnd"
                                           id="queryVisitDateEnd"/>
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
