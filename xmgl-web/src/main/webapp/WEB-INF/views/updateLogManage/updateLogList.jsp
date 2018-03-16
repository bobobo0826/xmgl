<%--
  Created by fcy.
  User: quangao
  Date: 2017/7/21
  Time: 11:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>更新日志管理</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>
    <script type="text/javascript">
        var height=$(window).height()-140; //浏览器当前窗口可视区域高度
        var _funcArray;
        $(window).resize(function(){ $("#tt").datagrid("resize"); });

        $(document).ready(function(){
            _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());
            initOpr();
            initDatagrid();
        });

        function initDatagrid(){
         //   var url = "${root}/manage/project/getGridStyle.action?_curModuleCode="+$("#_curModuleCode").val();
            var httpReqest=new HttpRequest();
       //     datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
            var options = {
                columns : [[
                    {field:"ID",title:"ID",hidden:true},
                    {field:"action",title:"操作",resizable:true,width:140,headalign:"center",align:"left",sortable:true,formatter:editf},
                    {field:"title",title:"标题",resizable:true,width:200,headalign:"center",align:"left",sortable:true},
                    {field:"content",title:"内容",resizable:true,width:300,headalign:"center",align:"left",sortable:true},
                    {field:"status",title:"状态",resizable:true,width:150,headalign:"center",align:"left",sortable:true},
                    {field:"update_date",title:"更新日期",resizable:true,width:300,headalign:"center",align:"left",sortable:true},
                    {field:"create_date",title:"创建时间",resizable:true,width:300,headalign:"center",align:"left",sortable:true},
                    {field:"creator",title:"创建人",resizable:true,width:150,headalign:"center",align:"left",sortable:true},
                    {field:"modifier",title:"修改人",resizable:true,width:150,headalign:"center",align:"left",sortable:true},
                    {field:"modify_date",title:"修改时间",resizable:true,width:300,headalign:"center",align:"left",sortable:true}

                ]],
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

                onDblClickRow: function(index,row) {
                    editInfo(index);
                },
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

            ]);

            $("input[name='create_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
            $("input[name='update_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});

        }
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function editf(value,row,index) {
            var t='';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'updateLogInfo':

                             t += '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
                            break;
                        // var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow('+index+')">删除</a>]';
                        case 'publishUpdateLog':
                            if (row.status != "已发布") {

                                 t += '[<a href="###" style="text-decoration:none;color:red;" onclick="publishInfo(' + index + ')">发布</a>]';
                            } else {
                                 t += '[<a href="###" style="text-decoration:none;color:red;" onclick="unPublishInfo(' + index + ')">撤销发布</a>]';
                            }
                            break;
                        default:
                            break;
                    }
                }
            }




//            var t =u+" "+c;
            return t;
        }
        function unPublishInfo(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url="${root}/manage/updateLogManage/unPublishUpdateLog?id="+id;
            layer.confirm("确定要撤销发布吗？", {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(response) {

                        if(response.msgCode==1) {
                            $('#tt').datagrid('reload');
                        }
                        layer.msg(response.msgDesc);
                    },
                    error:function(result) {
                        layer.msg("系统异常，请联系系统管理员");
                    }
                });
            }, function(index){
                layer.close(index);
            });

        }
        function publishInfo(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url="${root}/manage/updateLogManage/publishUpdateLog?id="+id;
            layer.confirm("确定要发布吗？", {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(response) {

                        if(response.msgCode==1) {
                            $('#tt').datagrid('reload');
                        }
                        layer.msg(response.msgDesc);
                    },
                    error:function(result) {
                        layer.msg("系统异常，请联系系统管理员");
                    }
                });
            }, function(index){
                layer.close(index);
            });

        }
        function delRow(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/updateLogManage/delUpdateLogInfo?id="+id;
            layer.confirm(_DELETE_ONE_MSG, {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'delete',
                    success: function(response) {

                        if(response.msgCode==1) {
                            $('#tt').datagrid('reload');
                        }
                        layer.msg(response.msgDesc);
                    },
                    error:function(result) {
                        layer.msg("系统异常，请联系系统管理员");
                    }
                });
            }, function(index){
                layer.close(index);
            });
        }
        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url="${root}/manage/updateLogManage/initUpdateLogInfo?id="+id+ "&_curModuleCode=" + $("#_curModuleCode").val();
            parent.addTab("更新日志详情", url);
        }
        function getUrl() {
            var url = "${root}/manage/updateLogManage/queryUpdateLogList"+getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?title="+$('#title1').val()
                +"&query_update_date_begin="+$('#query_update_date_begin').val()
                +"&query_update_date_end="+$('#query_update_date_end').val()
                +"&content="+$('#content').val();
//                +"&update_date="+$('#update_date').val();

            return url;

        }

        // 查询
        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        function addNew()
        {
            var url="${root}/manage/updateLogManage/initUpdateLogInfo?id=0";
            parent.addTab("新增更新日志", url);
        }

        function initOpr() {
            var html = '';
            html += '<a class="btn btn-danger btn-sm" href="javascript:doHideOrShowPrint();" id="hideOrShowBt"><i class="fa fa-arrow-up"></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'updateQuery':
                            html += '<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;';
                            html += '<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;';
                            break;
                        case 'addUpdateLog':
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
<div class="row" >
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style='display:none'>
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">标题:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="title1" name="title1"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">内容:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="content" name="content"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">更新日期:</label>
                            <div class="col-sm-6">
                                <%--<input class="form-control" id="update_date" name="update_date"/>--%>
                                    <div class="col-sm-12 input-group">
                                        <input  onclick="laydate()" class="form-control"   name="query_update_date_begin" id="query_update_date_begin"/>
                                        <span class="input-group-addon"></span>
                                        <input  onclick="laydate()" class="form-control"  name="query_update_date_end" id="query_update_date_end"/>
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
    <%--<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;--%>
    <%--<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;--%>
    <%--<a class='btn btn-success btn-sm' href='javascript:addNew();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;--%>
    <%--<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;--%>
</div>
<div id="tt"></div>

</body>
</html>
