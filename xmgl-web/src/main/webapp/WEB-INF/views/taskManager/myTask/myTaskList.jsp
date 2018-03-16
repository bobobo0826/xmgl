<%--
  Created by IntelliJ IDEA.
  User: mjq
  Date: 2017/7/26
  Time: 14:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>我的任务管理</title>
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
            getTaskTypeDic();
            //getPlanCompleteDic();
            getCompleteTypeDic();
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
                    {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf}
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
            $('#tt').datagrid({
                rowStyler:function(index,row){
                    if (row.complete_type=="未开始"){
                        return 'background-color:#e1f5fe;color:black;font-weight:bold;';
                    }
                    if (row.complete_type=="正在实施"){
                        return 'background-color:#b3e5fc;color:black;font-weight:bold;';
                    }
                    if (row.complete_type=="提前完成"){
                        return 'background-color:#81d4fa;color:black;font-weight:bold;';
                    }
                    if (row.complete_type=="超时完成"){
                        return 'background-color:#4fc3f7;color:black;font-weight:bold;';
                    }
                }
            });
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
                {
                    field: 'task_type',
                    type: 'combobox',
                    options: {
                        panelHeight: 'auto',
                        data: taskTypeList,
                        valueField: "data_code",
                        textField: "data_name",
                        editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "task_type", value: row.data_code});
                            $('#tt').datagrid('doFilter')

                        }
                    }
                },
                {
                    field: 'complete_type',
                    type: 'combobox',
                    options: {
                        panelHeight: 'auto',
                        data: complete_type,
                        valueField: "data_code",
                        textField: "data_name",
                        editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "complete_type", value: row.data_code});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                }

            ]);
            $("input[name='start_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='end_date']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='actual_start_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });
            $("input[name='actual_end_time']").bind("click", function () {
                ShowDiv('MyDiv', 'fade', $(this).attr("name"))
            });

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
        //动态加载操作栏下面的按钮
        function editf(value, row, index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
            return e;
        }

        //获取详情页面
        function editInfo(index) {
            var rows = $('#tt').datagrid('getData').rows;
            var plan_id = rows[index].id;
            var task_id = rows[index].task_id;
            var url = "${root}/manage/myTask/initMyTaskInfo/" + plan_id + "/" + task_id ;
            parent.addTab("我的任务详情", url);
        }
        function getUrl() {
            var url = "${root}/manage/myTask/myTaskQueryList" +'/0'+ getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }
        /**
         * 获取查询条件
         * @returns {string}
         */
        function getQueryCondition() {
            var url = "?task_name=" + $('#task_name').val()
                + "&task_type=" + $("#task_type").val()
                + "&sup_project_name=" + $("#sup_project_name").val()
                + "&sup_module_name=" + $("#sup_module_name").val()
                + "&plan_name=" + $("#plan_name").val()
                + "&complete_type=" + $("#complete_type").val()
                + "&_curModuleCode=" + $("#_curModuleCode").val();
            return url;
        }

        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }

        var taskTypeList;
        function getTaskTypeDic() {
            var url = "${root}/manage/myTask/getMyTaskTaskTypeDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.taskTypeList, "task_type");
                    taskTypeList = result.taskTypeList;
                }
            });
        }

        var planComplete;
        function getPlanCompleteDic() {
            var url = "${root}/manage/myTask/getPlanCompleteDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.planComplete, "plan_complete");
                    planComplete = result.planComplete;
                }
            });
        }
        var complete_type;
        function getCompleteTypeDic() {
            var url = "${root}/manage/myTask/getCompleteTypeDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.complete_type, "complete_type");
                    complete_type = result.complete_type;
                }
            });
        }





    </script>
</head>
<body>
    <input  type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
    <input  type="hidden" id="UserId" value="${UserId}"/>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content" id="searchArea" style='display:none'>
                    <form method="get" class="form-horizontal">
                        <div id="creator_head" class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">任务名称:</label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="task_name" id="task_name">

                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">任务类型:</label>
                                <div class="col-sm-6">
                                    <select id="task_type" class="form-control" name="task_type">
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div id="status_type_head" class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">项目名称:</label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="sup_project_name" id="sup_project_name">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">模块名称:</label>
                                    <div class="col-sm-6">
                                        <input class="form-control" name="sup_module_name" id="sup_module_name">
                                    </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">任务计划名称:</label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="plan_name" id="plan_name">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">计划完成情况:</label>
                                <div class="col-sm-6">
                                    <select id="complete_type" class="form-control" name="complete_type">
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

