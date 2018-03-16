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
            html+="<a class='btn btn-primary btn-sm' href='javascript:doConfirm();'><i class='fa fa-check'></i>&nbsp;&nbsp;确认选择</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-danger btn-sm' href='javascript:close();'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";

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
                height:height,
                width:'auto',
                striped:true,
                showFooter: true,
                columns:[[
                    {field:"id",title : "id",hidden : true},
                    {field:"ck",checkbox : true},
                    {field:"role_code",title:"角色代号", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"role_name",title:"角色名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"role_desc",title:"角色描述", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
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

        function getUrl() {
            var url;

            url="${root}/manage/query/getRoleList";

            url=encodeURI(encodeURI(url));
            return url;
        }

        function close() {
            f_close("selectRole");
        }

        function doConfirm(){
            var codes = [];
            var names = [];
            var rows = $('#tt').datagrid('getSelections');
            for(var i=0; i<rows.length; i++){
                codes.push(rows[i].role_code);
                names.push(rows[i].role_name);
            }
            parent.setRoles(codes,names);
            f_close("selectRole");
        }

    </script>
</head>
<body>
<div style="height: 15px"></div>
<div align="center" id="operator"></div>

<div id="tt"></div>
</body>
</html>