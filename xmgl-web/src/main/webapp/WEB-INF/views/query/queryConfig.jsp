<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>供应商列表</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        $(document).ready(function(){

            var height=$(window).height()-55; //浏览器当前窗口可视区域高度

            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-success btn-sm' href='javascript:doAdd();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
           // html+="<a class='btn btn-danger btn-sm' href='javascript:doDelete();'><i class='fa fa-remove'></i>&nbsp;&nbsp;删除</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            initBCOfferDetail(height);

        });

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function initBCOfferDetail(height){
            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                MultipleSelect:true,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                showFooter: true,
                columns:[[
                    //{field:"ck",checkbox : true},
                    {field:"id",title : "id",hidden : true},
                    {field:"act",title:"操作", resizable:true,width:80,headalign:"center",align:"center",formatter:editf},
                    {field:"query_code",title:"查询代码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"query_name",title:"查询名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"query_expression",title:"查询表达式", resizable:true,width:320,headalign:"center",align:"left",sortable:true},
                    {field:"bizdata_code",title:"模块名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"role_code",title:"角色代号",hidden : true, resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"role_name",title:"角色名称", resizable:true,width:200,headalign:"center",align:"left",sortable:true}
                ]]

            });
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60,80,100,200],
                pageSize:20,
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize) {
                    datagridPagination(pageNumber, pageSize,"tt",getUrl());
                }
            });
            //$("#tt").datagrid('enableFilter');
        }

        function getUrl() {
            var url;

            url="${root}/manage/query/getQuery/"+getQueryCondition();

            url=encodeURI(encodeURI(url));
            return url;
        }
        function getQueryCondition(){
            var url="?query_code="+$('#query_code').val()
                +"&query_name="+$("#query_name").val()
                +"&bizdata_code="+$("#bizdata_code").val();;
            return url;

        }
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';

            var d= '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
            return e +" "+ d;
        }
        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var code=rows[index].role_code;
            var url="${root}/manage/query/initQueryInfo/"+id+"/"+code;

            parent.addTab("查询详情", url);
        }
        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/query/deleteQuery/"+id;
            layer.confirm(_DELETE_ONE_MSG, {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(response) {

                        if(response.msgCode=="success") {
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

        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
        function doAdd() {
                var url="${root}/manage/query/initAddQuery/0";
                parent.addTab("配置添加", url);
        }
        /*function doDelete() {
            var ids = [];
            var rows = $('#tt').datagrid('getSelections');
            for(var i=1;i<rows.length;i++){
                ids.push(rows[i].id);
            }
            alert(ids);
            var url = "${root}/manage/query/delList/"+ids;
            layer.confirm(_DELETE_ONE_MSG, {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(response) {

                        if(response.msgCode=="success") {
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
        }*/

    </script>
</head>
<body>

<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">模块名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="bizdata_code"
                                       name="bizdata_code">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">查询代码:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="query_code"
                                       name="query_code">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">查询名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="query_name"
                                       name="query_name">
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
    <div id="doClear">清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>

</div>
</body>
</html>