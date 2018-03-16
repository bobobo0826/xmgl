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
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>

    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        $(document).ready(function(){
            var height=$(window).height()-55; //浏览器当前窗口可视区域高度
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-success btn-sm' href='javascript:doAdd();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";

            $("#operator").html(html);

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
                    {field:"id",title : "id",hidden : true},
                    {field:"act",title:"操作", resizable:true,width:80,headalign:"center",align:"center",formatter:editf},
                    {field:"logistics_company_name",title:"公司名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"interface_name",title:"接口名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"interface_type_code",hidden :true,title:"接口类型编号", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"interface_type_name",title:"接口类型名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"interface_mark",title:"接口描述", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"interface_url",title:"接口链接", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"logistics_company_id" , hidden:true, title:"物流公司ID", resizable:true,width:120,headalign:"center",align:"left",sortable:true}
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
        });

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        function getUrl() {
            var url="${root}/manage/inter/getInterfaceList/"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?logistics_company_name="+$('#logistics_company_name').val()
                +"&interface_name="+$("#interface_name").val()
                +"&interface_type_name="+$("#interface_type_name").val();;
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
            var url="${root}/manage/inter/initInterInfo/"+id;
            parent.addTab("接口详情", url);
        }

        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/inter/delInterface/"+id;
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
            var url="${root}/manage/inter/initInterInfo/0";
            parent.addTab("接口添加", url);
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
                            <label class="col-sm-4 control-label">公司名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="logistics_company_name"
                                       name="logistics_company_name">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="interface_name"
                                       name="interface_name">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">接口类型名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="interface_type_name"
                                       name="interface_type_name">
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
</body>
</html>