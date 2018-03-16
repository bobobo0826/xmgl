<%--
  Created by IntelliJ IDEA.
  User: QG-YKM
  Date: 2017-05-24
  Time: 10:23 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>文件列表</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>

    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });

        $(document).ready(function(){

            var height=$(window).height()-55; //浏览器当前窗口可视区域高度

            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";



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
                singleSelect:true,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                showFooter: true,
                columns:[[
                    {field : "id",title : "id",hidden : true},
                    {field:"act",title:"操作", resizable:true,width:120,headalign:"center",align:"center",formatter:editf},
                    {field:"file_id",title:"文件编号", resizable:true,width:330,headalign:"center",align:"left",sortable:true},
                    {field:"file_name",title:"文件名称", resizable:true,width:140,headalign:"center",align:"left",sortable:true},
                    {field:"file_path",title:"文件路径", resizable:true,width:640,headalign:"center",align:"left",sortable:true},
                    {field:"business_name",title:"业务名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"creator",title:"创建人", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"create_date",title:"创建日期", resizable:true,width:130,headalign:"center",align:"left",sortable:true},
                ]],
                onDblClickRow: function (rowIndex, rowData) {
                    editInfo(rowIndex);
                }
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

        function getUrl() {
            var url;
            url="${root}/manage/file/queryFileList/"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function getQueryCondition(){
            var url="?file_name="+$('#file_name').val()
                +"&business_name="+$("#business_name").val();
            return url;

        }

        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
            var d= '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
            return e+" "+d;
        }

        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url="${root}/manage/file/initFileInfo?_id="+id;
            parent.addTab("文件详情", url);
        }

        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/file/delFileInfoById?_id="+id;
            layer.confirm(_DELETE_ONE_MSG, {
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
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
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
                            <label class="col-sm-4 control-label">文件名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="file_name" name="file_name">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">业务名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="business_name" name="business_name">
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