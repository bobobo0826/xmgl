<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>项目任务日志查询</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-time.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>
    <script type="text/javascript">

        var height=$(window).height()-140; //浏览器当前窗口可视区域高度
        $(window).resize(function(){ $("#tt").datagrid("resize"); });

        $(document).ready(function(){
            doSelect($("#periodList").val(),"period");
            getCompleteStatusListDic();
            initDatagrid();

        });

            function initDatagrid(){
                var url = "${root}/manage/commonWorkLog/getGridStyle?_curModuleCode="+$("#_curModuleCode").val();
                var httpReqest=new HttpRequest();
                datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
                var options = {
                    url:getUrl(),
                    sortable:true,
                    singleSelect:false,
                    pagination:true,
                    height:height,
                    width:'auto',
                    striped:true,
                    rownumbers:true,
                    singleSelect:false,
                    remoteSort:true,
                    nowrap:false,
                    remoteFilter:true,
                    filterDelay:2000,


                    onSortColumn: function (sort, order) {
                        datagridSort(sort, order,"tt",getUrl());
                    },
                    onRowContextMenu:function(e, rowIndex, rowData) {
                        e.preventDefault();
                        $('#cntMenu').menu({
                            onClick: function (item) {
                                oprHandle(item.id, rowData, rowIndex);
                            }
                        });
                        $('#cntMenu').menu('show', {
                            left: e.pageX,
                            top: e.pageY
                        }) ;
                    } ,
                    onHeaderContextMenu:function(e, rowIndex, rowData) {
                        e.preventDefault();
                        $('#cntMenu').menu({
                            onClick: function (item) {
                                oprHandle(item.id, rowData, rowIndex);
                            }
                        });
                        $('#cntMenu').menu('show', {
                            left: e.pageX,
                            top: e.pageY
                        }) ;
                    }
                };

                options.columns = eval(datagridStyleConfig);
                $("#tt").datagrid(options);
                $('#tt').datagrid('getPager').pagination({
                    pageList:[20,40,60,80,100,200],
                    pageSize:20,
                    afterPageText:'页  共{pages}页',
                    displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                    onSelectPage:function(pageNumber, pageSize) {
                        datagridPagination(pageNumber, pageSize,"tt",getUrl());
                    }
                });
                $('#tt').datagrid('enableFilter', [
                    {field:'action',type:'label' },
                    {field: 'complete', type: 'combobox',
                        options: {
                            panelHeight: 'auto', data: completeStatusList, valueField: "data_code",
                            textField: "data_name", editable: false,
                            onSelect: function (row) {
                                $('#tt').datagrid('addFilterRule', {field: "complete", value: row.data_code});
                                $('#tt').datagrid('doFilter')
                            }
                        }
                    }
                ]);
                $("input[name='modify_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
                $("input[name='task_start_time']").bind("click",function(){ShowTimeDiv('MyTimeDiv','fade',$(this).attr("name"))});
                $("input[name='task_end_time']").bind("click",function(){ShowTimeDiv('MyTimeDiv','fade',$(this).attr("name"))});
            }

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        function getUrl() {
            var url = "${root}/manage/taskLog/queryTaskLogList"+getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?project_name="+$('#projectName').val()
                +"&module_name="+$('#moduleName').val()
                +"&period="+$('#period').val();
            return url;
        }

        // 查询
        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }

        var completeStatusList
        function getCompleteStatusListDic(){
            var url = "${root}/manage/taskLog/getCompleteStatusListDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                async : false,
                success: function(result) {
                    completeStatusList=result.completeStatusList;
                }
            });
        }

         //去掉第一行空行的下拉列表
        function doSelect(selectListValue,selectKey){
            var arrayItem = selectListValue.split("],");
            $("#"+selectKey).empty();
            for(var i=0;i<arrayItem.length;i++){
                var item = arrayItem[i];
                item=item.replace("[[","");
                item=item.replace("[","");
                item=item.replace("]]","");
                item=item.replace("]","");
                var itemArray = item.split(",");
                var itemvalue="";
                if(itemArray[0]!="" && itemArray[0]!=null)
                    itemvalue=itemArray[0].replace(" ","");
                var itemText ="";
                if(itemArray[1]!="" && itemArray[1]!=null)
                    itemText=itemArray[1].replace(" ","");
                var option = $("<option>").val(itemvalue).text(itemText);

                $("#"+selectKey).append(option);
            }
        }
    </script>
</head>

<body>
<input type="hidden" id="periodList" value="${periodList}"/>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style="display:none" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">所属项目:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="projectName" name="projectName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">所属模块:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="moduleName" name="moduleName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">周期:</label>
                            <div class="col-sm-6">
                                <select  class="form-control" id="period" name="period" onchange="doQuery()"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator">
    <a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;
    <a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;
    <a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;
</div>
<div id="tt"></div>
</body>
</html>
