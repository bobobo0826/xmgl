<%--
  Created by IntelliJ IDEA.
  User: ccr
  Date: 2017/8/10
  Time: 16:08
  To change this template use File | Settings | File Templates.

--%>


<%@ page  contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>工作记录字典管理</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
    <%--<jsp:include page="/res/public/float_div.jsp" ></jsp:include>--%>
    <%--<jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>--%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

    <script type="text/javascript">
        var height=$(window).height()-140;
        $(window).resize(function () {$("tt").datagrid("resize");});
        $(document).ready(function () {
            getBusinessTypeList();
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
                onDblClickRow:function (index,row) {
                    editInfo(index);
                },
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                columns:[[
                    {field:"id",title : "id",hidden : true},
                    {field:"act",title:"操作", resizable:true,width:100,headalign:"center",align:"center",formatter:editf},
                    {field:"business_name",title:"业务类型名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"business_type",title:"业务类型编码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"data_name",title:"数据类型名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"data_code",title:"数据类型编码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"data_desc",title:"数据描述", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"is_used",title:"是否使用", resizable:true,width:120,headalign:"center",align:"left",formatter:formatterIsUsed,type:'combobox'}
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
        /**
         * 获取“操作”列的内容
         * @param value 字段的值
         * @param row 行的记录数据
         * @param index 行的索引
         * @returns {string}
         */
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
            if(row.is_used != "1") {
                e += '[<a href="###" style="text-decoration:none;color:green;"onclick="enabled('+index+')">启用</a>]';
                e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
            }
            if(row.is_used != "0"){
                e += '[<a href="###" style="text-decoration:none;color:red;"onclick="forbidden('+index+')">禁用</a>]';
            }
            return e ;
        }
        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var width="85%";
            var height="60%";
            var url="${root}/manage/dictionary/initLogDictionaryInfo/"+id;
            parent.addTab("工作记录字典详情",url);
        }
        function enabled(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/dictionary/startLogDictionaryById/"+id;
            layer.confirm('确定启用此字典吗?', {
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
        function forbidden(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/dictionary/forbiddenLogDictionaryById/"+id;
            layer.confirm('确定禁用此字典吗?', {
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
        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/dictionary/delLogDictionaryInfoById/"+id;
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
        function getUrl() {
            var url="${root}/manage/dictionary/queryLogDictionaryList"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function getQueryCondition(){
            var url="?business_type="+$('#business_type').val()
                +"&is_used="+$("#is_used").val()
                +"&data_name="+$("#data_name").val();;
            return url;
        }
        function  formatterIsUsed(value,row,index){
            if(value=='1'){
                return "是";
            }else if(value=='0'){
                return "否";
            }
        }
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
        function doAdd() {
            var width="85%";
            var height="60%";
            var url="${root}/manage/dictionary/initLogDictionaryInfo/"+0;
            parent.addTab("新增工作记录字典",url);
        }
        var businessTypeList;
        function getBusinessTypeList(){
            var url = "${root}/manage/dictionary/getLogBusinessTypeList";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url:url,
                type:'get',
                async:false,
                success:function(result){
                    addSelectOption(result.businessTypeList,"business_type");
                    businessTypeList=result.businessTypeList;
                }
            })
        }
    </script>
</head>
<body>
<input  type="hidden" id="businessType" value="${businessType}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">业务类型名称:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="business_type" id="business_type" onchange="doQuery()">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">数据类型名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="data_name" name="data_name">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">是否使用:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="is_used" id="is_used" onchange="doQuery()">
                                    <option value=""></option>
                                    <option value="1">是</option>
                                    <option value="0">否</option>
                                </select>
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
