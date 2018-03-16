<%--
  Created by IntelliJ IDEA.
  User: ccr
  Date: 2017/8/23
  Time: 15:48
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>管理</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

    <script type="text/javascript">
        var height=$(window).height()-55;
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        $(document).ready(function(){
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-success btn-sm' href='javascript:doAdd();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:false,
                remoteSort:true,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                showFooter: true,
                onDblClickRow:function (index,row) {
                    editInfo(index);
                },
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                columns:[[
                    {field:"id",title : "id",hidden : true},
                    {field:"act",title:"操作", resizable:true,width:100,headalign:"center",align:"center",formatter:editf},
                    {field:"materials_type",title:"物品类别 ", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"dictionary_code",title:"字典码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"model",title:"型号", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"price",title:"单价(元)", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"count",title:"数量", resizable:true,width:60,headalign:"center",align:"left",sortable:true},
                    {field:"unit",title:"单位", resizable:true,width:50,headalign:"center",align:"left",sortable:true}
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



        function getUrl() {
            var url="${root}/manage/materials/queryDictionaryList"+ getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?materials_type="+$('#materials_type').val()
                +"&model="+$('#model').val()
            return url;
        }
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        /**
         * 获取“操作”列的内容
         * @param value 字段的值
         * @param row 行的记录数据
         * @param index 行的索引
         * @returns {string}
         */
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
                e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
            return e ;
        }
        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var count = rows[index].count;
            var width="85%";
            var height="60%";
            var url="${root}/manage/materials/initDictionaryInfo/"+id+"/"+count;
            parent.addTab("物品详情",url);
        }

        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/materials/delDictionaryInfoById/"+id;
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


        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }

        function doAdd() {
            var width="85%";
            var height="60%";
            var url="${root}/manage/materials/initDictionaryInfo/"+0+"/"+1;
            parent.addTab("新增物品字典",url);
        }
    </script>
</head>
<body>
<%--<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>--%>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">


                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">物品类别:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="materials_type" name="materials_type">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">型号:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="model" name="model">
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



