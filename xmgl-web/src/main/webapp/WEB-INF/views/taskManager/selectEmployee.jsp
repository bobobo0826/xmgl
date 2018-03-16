<%--
  Created by wjy
  Date: 2017/8/2
  Time: 16:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>选择员工</title>
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
            getEmploymentStatusDic();
            _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
            console.log(_funcArray);
            $("body").css("margin-bottom",'0px');
            var html="";
            html+="<a class='btn btn-warning btn-sm' href='javascript:multiSelect();'><i class='fa fa-check'></i>&nbsp;&nbsp;批量选择</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            initEmployeeList();
        });

        function initEmployeeList(){
            var options = {
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                height:'auto',
                width:'auto',
                striped:true,
                rownumbers:true,
                remoteSort:true,
                columns:[[
                    {field : "employee_id",title : "id",hidden : true},
                    {field:"photo",hidden : true,title:"照片"},
                    {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf},
                    {field:"participant_name",title:"员工姓名", width:150,resizable:true,headalign:"center",align:"center"},
                    {field:"gender",title:"员工性别", width:80,resizable:true,headalign:"center",align:"center"},
                    {field:"participant_tel",title:"员工手机号",width:200, resizable:true,headalign:"center",align:"center"},
                    {field:"participant_type",title:"员工岗位",width:200, resizable:true,headalign:"center",align:"center"}
                ]],
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                onDblClickRow: function(index,row){
                    confirm(index);
                }
            };
            $("#tt").datagrid(options);
        }
        function getUrl() {
            var url;
            url="${root}/manage/project/queryParticipantList?projectId="+$("#project_id").val()+"&idList="+$("#idList").val();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="confirm('+index+')">选择</a>]';
            return e ;
        }

        function confirm(index){
            var rows=$('#tt').datagrid('getData').rows;
            console.log(JSON.stringify(rows));
            var obj=new Object();
            obj.employee_id=rows[index].employee_id;
            obj.mobilephone_number=rows[index].participant_tel;
            obj.employee_name=rows[index].participant_name;
            obj.position_name=rows[index].participant_type;
            obj.gender=rows[index].gender;
            parent.setEmployeeInfo(obj);
            f_close("new_window");
        }
        /**
         * 执行查询
         */
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
        var employmentStatusList;
        function getEmploymentStatusDic(){
            var url = "${root}/manage/employee/getEmploymentStatusDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                async : false,
                success: function(result) {
                    console.log(JSON.stringify(result));
                    addSelectOption(result.employmentStatusDic,"employment_status");
                    employmentStatusList=result.employmentStatusDic;
                }
            });
        }
    </script>
</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="project_id" value="${projectId}"/>
<input type="hidden" id="idList" value="${idList}"/>
<div align="center" id="operator"></div>
<div id="tt"></div>
<div id="cntMenu" class="easyui-menu" style="width:150px;">
    <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>
</div>
</body>
</html>

