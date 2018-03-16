<%--
  Created by wjy
  Date: 2017/7/31
  Time: 8:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>选择任务</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        var _funcArray;
        var _queryConfig;
        $(document).ready(function(){
            getTaskDic();
            _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
            console.log(_funcArray);
            var height=$(window).height()-160; //浏览器当前窗口可视区域高度
            $("body").css("margin-bottom",'0px');
            var html="";
            html+="<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";

            $("#operator").html(html);
            initTaskList(height);
        });
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function initTaskList(height){
            var url = "${root}/manage/task/getGridStyle?_curModuleCode="+$("#_curModuleCode").val();
            var httpReqest=new HttpRequest();
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
                frozenColumns:[[
                    {field : "id",title : "id",hidden : true},
                    {field:"creator_id",hidden : true,title:"创建人ID"},
                    {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf}
                ]],
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                onDblClickRow: function(index,row){
                    confirm(index);
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
        }
        /**
         * 查询日志列表
         * @returns {string|*}
         */
        //右击菜单事件处理

        function getUrl() {
            var url;
            url="${root}/manage/task/selectTaskByEmployee/"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }
        /**
         * 获取查询条件
         * @returns {string}
         */
        function getQueryCondition(){
            var url="";
            url+="?task_type_code="+$("#task_type").val()+
                "&task_condition_code="+$("#task_condition").val()+
                "&task_name="+$("#task_name").val()+
                "&sup_project_name="+$("#sup_project_name").val()+
                "&sup_module_name="+$("#sup_module_name").val()+
                "&query_create_date_begin="+$('#query_create_date_begin').val()+
                "&query_create_date_end="+$('#query_create_date_end').val();

            return url;
        }
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="confirm('+index+')">选择</a>]';
            return e ;
        }
/*
选择任务列表
 */
        function confirm(index){
            var rows=$('#tt').datagrid('getData').rows;
            var obj=new Object();
            obj.task_id=rows[index].id;
            obj.task_name=rows[index].task_name;
            obj.task_type=rows[index].task_type;
            obj.task_condition=rows[index].task_condition;
            obj.complete=rows[index].complete;
            obj.sup_project_id=rows[index].sup_project_id;
            obj.sup_project_name=rows[index].sup_project_name;
            obj.sup_module_id=rows[index].sup_module_id;
            obj.sup_module_name=rows[index].sup_module_name;
            obj.task_desc=rows[index].task_desc;
            parent.setTaskInfo(obj);
            f_close("new_window");
        }
        /**
         * 执行查询
         */
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }

        var taskTypeList;
        var taskConditionList;
        function getTaskDic(){
            var url = "${root}/manage/task/getTaskDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                success: function(result) {
                    console.log(JSON.stringify(result));
                    addSelectOption(result.taskTypeList,"task_type");
                    taskTypeList=result.taskTypeList;
                    addSelectOption(result.taskConditionList,"task_condition");
                    taskConditionList=result.taskConditionList;
                }
            });
        }
    </script>
</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务类型：</label>
                            <div class="col-sm-6">
                                <div class="input-group col-sm-12">
                                    <select type="text" class="form-control" id="task_type"
                                            name="task_type" >
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务状态：</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="task_condition" id="task_condition">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div  class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务名称：</label>
                            <div class="col-sm-6">
                                <input  type="text" class="form-control"  name="task_name" id="task_name" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称：</label>
                            <div class="col-sm-6">
                                <input type="text" id="sup_project_name" class="form-control"  />

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">模块名称：</label>
                            <div class="col-sm-6">
                                <input  class="form-control"  name="sup_module_name" id="sup_module_name"/>
                            </div>
                        </div>
                    </div>                    <div class="col-sm-4">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">创建人：</label>
                        <div class="col-sm-6">
                            <input  class="form-control"  name="creator" id="creator"/>
                        </div>
                    </div>
                </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input  onclick="laydate()" class="form-control"   name="query_create_date_begin" id="query_create_date_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input  onclick="laydate()" class="form-control"  name="query_create_date_end" id="query_create_date_end"/>
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
    <div id="saveGridStyle" class ='rightMenu'>保存列表样式</div>
    <div class="menu-sep"></div>
    <div id="showColumns">显示(隐藏)列</div>
    <div class="menu-sep"></div>
    <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>
</div>
</body>
</html>
