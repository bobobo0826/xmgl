<%--
  Created by IntelliJ IDEA.
  User: liubo
  Date: 2017/9/21
  Time: 10:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>任务管理操作日志</title>
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
        var _queryConfig;

        /*****初始化列表*******/
        $(document).ready(function () {

            _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
            var height = $(window).height() - 75; //浏览器当前窗口可视区域高度
            $("body").css("margin-bottom", '0px');
            var html = "";
            html += "<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html += "<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            initStaffTaskList(height);
        });
        //获取列表
        function initStaffTaskList(height) {
            var url = "${root}/manage/myTask/getGridStyle?_curModuleCode=" + $("#_curModuleCode").val();
            var httpReqest = new HttpRequest();
            var datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
            var options = {
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                remoteSort:true,
                //view: detailview,
                //detailFormatter:detailFormatter,
                //onExpandRow:onExpandRow,点击加号加载详情
                remoteFilter:true,
                filterDelay:2000,
                filterStringify: function (data) {
                    _filterRule = JSON.stringify(data);
                    return JSON.stringify(data);
                },
                frozenColumns: [[
                    {field : "id",title : "id",hidden : true},
                    //{field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf}
                ]],
                onDblClickRow:function(rowIndex){
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
                //{field: 'act', type: 'label'},
            ]);

        }
        //右击菜单事件处理
        function oprHandle(itemId, rowData, rowIndex) {
            switch (itemId) {
                case "saveGridStyle":
                    saveGridStyle("tt", "${root}/manage/myTask/saveGridStyle?_curModuleCode=" + $("#_curModuleCode").val());
                    break;
                case "showColumns":
                    var url = "${root}/manage/myTask/showGridColumn";
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
        function getUrl() {
            var url = "${root}/manage/operateTaskLog/getTaskOperateLog/" + getQueryCondition();
            //var url = "${root}/manage/operateTaskLog/getTaskOperateLog/" ;
            url = encodeURI(encodeURI(url));
            return url;
        }
        /**
         * 获取查询条件
         * @returns {string}
         */
        function getQueryCondition() {
            var url = "?datapermission=" + $('#datapermission').val()
                + "&actiontype=" + $("#actiontype").val();

            return url;
        }

        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }


    </script>
</head>
<body>
<input  type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style='display:none'>
                <form method="get" class="form-horizontal">
                    <%--<div id="creator_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">标题:</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="title" id="title">
                            </div>
                        </div>
                    </div>--%>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作类别:</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="actiontype" id="actiontype">
                            </div>
                        </div>
                    </div>
                    <div id="status_type_head" class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作人:</label>
                            <div class="col-sm-6">
                                <input class="form-control" name="datapermission" id="datapermission">
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

