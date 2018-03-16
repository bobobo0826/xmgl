<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/5/22
  Time: 16:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>状态列表</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>

    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        var _funcArray;
        var _queryConfig;
        $(document).ready(function(){

            var height=$(window).height()-55; //浏览器当前窗口可视区域高度

            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-info btn-sm' href='javascript:addNewStatus();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";

            $("#operator").html(html);
            initStatusDetail(height);
        });

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function initStatusDetail(height){
            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                showFooter: true,
                columns:[[
                    {field:"act",title:"操作", resizable:true,width:80,headalign:"center",align:"center",formatter:editf},
                    {field:"statusid",title:"状态ID", resizable:true,width:120,headalign:"center",align:"center",sortable:true},
                    {field:"statusname",title:"状态名", resizable:true,width:120,headalign:"center",align:"center",sortable:true},
                    {field:"stalias",title:"状态别名", resizable:true,width:120,headalign:"center",align:"center",sortable:true},
                    {field:"stdesc",title:"描述", resizable:true,width:120,headalign:"center",align:"center",sortable:true},

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
        }

        function closeForm(){
            f_close("priceDetail");
        }

        function getUrl() {
            var url;
            url="${root}/manage/status/queryStatusList/"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function getQueryCondition(){
            var url="?statusname="+$('#statusname').val()
                +"&stalias="+$("#stalias").val()
                +"&statusid="+$("#statusid").val();
            console.log(url)
            return url;

        }
        function appendRowStatus(data){
            console.log('新增一行');
            var object =data;
            $('#tt').datagrid('appendRow', {
                statusid: object.statusId,
                statusname: object.statusName,
                stalias: object.stalias,
                stdesc: object.stdesc
            });
            var rowIndex=$('#tt').datagrid('getRows').length-1;
            /* beginEdit(rowIndex);*/
        }

        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';

            var d= '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
            return e +" "+ d;
        }
        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].statusid;
            var url;
            url="${root}/manage/status/initStatusInfo/"+id;
            parent.addTab("状态详情", url);
        }
        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].statusid;
            var url = "${root}/manage/status/delStatus/"+id;

            layer.confirm(_DELETE_ONE_MSG, {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(response) {
                        /**
                         * 操作成功
                         */
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

        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
        function addNewStatus(){
            var url = "${root}/manage/status/initStatusInfo/-1";
            parent.addTab("新增状态", url);
        }
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
                            <label class="col-sm-4 control-label">状态名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="statusname"
                                       name="statusname">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态别名:</label>
                            <div class="col-sm-6">
                                <input  class="form-control"  name="stalias" id="stalias">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态ID:</label>
                            <div class="col-sm-6">
                                <input  class="form-control"  name="statusid" id="statusid">
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
