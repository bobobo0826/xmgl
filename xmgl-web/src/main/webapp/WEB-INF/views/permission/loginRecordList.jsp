<%--
  Created by IntelliJ IDEA.
  User: liubo
  Date: 2017/8/14
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>登录信息</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@include file="/res/public/easyui_lib.jsp" %><%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <link href="${root}/res/ui/css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
    <script type="text/javascript">
        /*****初始化列表*******/
        $(document).ready(function(){
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-success btn-sm' href='javascript:addInfo();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
            //$("#operator").html(html);

            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                remoteSort:false,
                pagination:true,
                height:'auto',
                width:'auto',
                columns:[[
                    {field:"action",title:"操作", resizable:true,width:90,align:"center",formatter:editf},
                    {field:"user_id",title:"登录人ID",hidden:true,width:120,headalign:"center",align:"center",sortable:true},
                    {field:"user_name",title:"登录人名称",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"role_code",title:"角色Code",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"role_name",title:"角色名称",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"dept_id",title:"部门ID",hidden:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"dept_name",title:"部门名称",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"login_time",title:"登录时间",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"ip",title:"IP",resizable:true,width:150,headalign:"center",align:"center",sortable:true}
                ]]
            });
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60],
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize){
                    var pagination= $('#tt').datagrid('getData').pagination;
                    var param=new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams=param;
                    $('#tt').datagrid('options').url=getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams=null;
                }
            });
            if($('#userId').val()!=2&&$('#userId').val()!=25&&$('#userId').val()!=41&&$('#userId').val()!=27&&$('#userId').val()!=29&&$('#userId').val()!=28){
            $('#tt').datagrid('hideColumn', 'action');
            }
        });

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        //动态加载操作栏下面的按钮
        function editf(value,row,index){
            var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delInfo('+index+')">删除</a>]';
            return c ;
        }

        function delInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = [rows[index].id];
            layer.confirm('确定删除吗?', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                var url = '${root}/manage/loginRecord/delLoginRecord?id=' + id;
                $.ajax({
                    url: url,
                    type : 'post',
                    cache : false,
                    async : false,
                    success:function(data){
                        if(data.msgCode==1)
                        {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function(index){
                layer.close(index);
            });
        }
        function doQuery()
        {
            var url=getUrl();
            $('#tt').datagrid('options').url = url;
            $('#tt').datagrid('load');
        }

        function getUrl()
        {
            var url = "${root}/manage/loginRecord/loginRecordQueryList";
            url=encodeURI(encodeURI(url));
            return url;
        }
    </script>
</head>
<body>
<input type="hidden" id="userId" value="${userId}"/>
<div align="center" id="operator"></div>
<div id="tt"></div>
</body>
</html>



