<%--
  Created by IntelliJ IDEA.
  User: wch
  Date: 2017-07-07
  Time: 8:49 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>选择项目</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>
    <script type="text/javascript">
        $(document).ready(function(){

            getProjectTypeList();

            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                remoteSort:false,
                pagination:true,
                rownumbers:true,
                height:'auto',
                width:'auto',
                columns:[[
                    {field : "id",title : "id",hidden : true},
                    {field:"action",title:"操作", resizable:true,width:100,headalign:"center",align:"center",formatter:editf},
                    {field:"project_name",title:"项目名称",resizable:true,width:150,headalign:"center",sortable:true },
                    {field:"project_abbr",title:"项目简称",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"project_type",title:"项目类型",resizable:true,width:100,headalign:"center",sortable:true },
                    {field:"project_desc",title:"项目描述",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"creator",title:"创建人",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"create_date",title:"创建日期",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"modifier",title:"修改人",resizable:true,width:80,headalign:"center",sortable:true },
                    {field:"modify_date",title:"修改日期",resizable:true,width:120,headalign:"center",sortable:true }
                ]],
                onDblClickRow: function(index,row){
                    confirm(index);
                }
            });
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60],
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize) {
                    var param=new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams=param;
                    $('#tt').datagrid('options').url=getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams=null;
                }
            });
        });
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="confirm('+index+')">选择</a>]'
            return e;
        }

        function confirm(index){
            var rows=$('#tt').datagrid('getData').rows;
            var object=new Object();
            object.project_id = rows[index].id;
            object.project_name = rows[index].project_name;
            object.project_abbr = rows[index].project_abbr;
            object.project_type=rows[index].project_type;
            object.project_desc=rows[index].project_desc;
            object.creator=rows[index].creator;
            object.create_date=rows[index].create_date;
            object.modifier=rows[index].modifier;
            object.modify_date=rows[index].modify_date;
            parent.setProjectInfo(object);
            f_close("newWindow")
        }

        function getUrl() {
            var url = "${root}/manage/project/queryProjectList"+getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?project_name="+$('#projectName').val()
                +"&project_abbr="+$('#projectAbbr').val()
                +"&project_type_code="+$('#projectType').val();
            return url;
        }

        // 查询
        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }

        function getProjectTypeList(){
            var url = "${root}/manage/project/getProjectTypeList";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'get',
                async : false,
                success: function(result) {
                    addSelectOption(result.projectTypeList,"projectType");
                    projectTypeList=result.projectTypeList;

                }
            });
        }
    </script>
</head>

<body>
<input type="hidden" id="projectTypeList" value="${projectTypeList}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="projectName" name="projectName"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目简称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="projectAbbr" name="projectAbbr"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目类型:</label>
                            <div class="col-sm-6">
                                <select  class="form-control" id="projectType" name="projectType"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator">
    <a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;
    <a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;
</div>
<div id="tt"></div>
</body>
</html>
