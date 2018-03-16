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
            var  businessType=$("#businessType").val();
            doSelectValue(businessType,"business_type");

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
                    {field:"data_code",title:"类型编码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"data_name",title:"类型名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"data_desc",title:"描述", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"business_type",title:"业务类型编码", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"business_name",title:"业务类型名称", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"is_used",title:"是否使用", resizable:true,width:120,headalign:"center",align:"left",formatter:formatterIsUsed}
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
            var url="${root}/manage/dic/getDic/"+getQueryCondition();
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

        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
            var d= '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
            return e +" "+ d;
        }

        function editInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            /*var url="${root}/manage/dic/initDicInfo/"+id;
            parent.addTab("字典详情", url);*/
            var width="85%";
            var height="60%";
            var url="${root}/manage/dic/initDicInfo/"+id;
            f_open("newWindows", "字典详情", width, height, url, true);
        }

        function deleteInfo(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/dic/deleteDic/"+id;
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
            /*var url="${root}/manage/dic/initDicInfo/0";
            parent.addTab("字典添加", url);*/

            var width="85%";
            var height="60%";
            var url="${root}/manage/dic/initDicInfo/0";
            f_open("newWindows", "新增字典", width, height, url, true);
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
                            <label class="col-sm-4 control-label">业务类型:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="business_type" id="business_type">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">类型名称:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="data_name"
                                       name="data_name">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">是否使用:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="is_used" id="is_used">
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