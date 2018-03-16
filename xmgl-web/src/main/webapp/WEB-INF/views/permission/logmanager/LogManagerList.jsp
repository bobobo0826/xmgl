<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>日志管理</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        $(document).ready(function(){
            doSelectValue($("#modelTypeList").val(),"modelTypes");
            var height=$(window).height()-55;
            var html="";
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            $("#tt").datagrid({
                url:getUrl(),
                //排序
                sortable:true,
                //单选
                singleSelect:true,
                //分页
                pagination:true,
                height:height-430,
                width:'auto',
                //隔行变色
                striped:true,
                rownumbers:true,
                showFooter: false,
                columns:[[
                    {field:"id",title : "id",hidden : true},
                    {field:"title",title:"关键字", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"formtypedesc",title:"模块类型", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"actiontype",title:"操作类型", resizable:true,width:120,headalign:"center",align:"left",sortable:true},
                    {field:"operatetime",title:"操作时间", resizable:true,width:180,headalign:"center",align:"left",sortable:true},
                    {field:"datapermission",title:"操作人", resizable:true,width:80,headalign:"center",align:"left",sortable:true},
                    {field:"operaterdescrip",title:"操作描述", resizable:true,width:500,headalign:"center",align:"left",sortable:true,formatter:showDetial}
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

        //按回车时执行
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });

        //判断截止日期是否大于开始日期
        function isStartGreaterEnd() {
            var start_time=$("#start_date").val();
            var end_time=$("#end_date").val();
            if (start_time>end_time){
                alert("结束时间需大于开始时间")
                return;
            }
        }

        //设置红色字体并设置点击事件
        function showDetial(value,row,index)
        {
            var e ="";
            if(value!=""){
                e ='<a href="###" style="text-decoration:none;color:red;" id="titlekey" title="'+value+'"  onclick="showLogDetial('+index+')">'+value+'</a>';
            }
            return e;
        }

        //点击操作描述显示弹框
        function showLogDetial(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var operaterdescrip=rows[index].operaterdescrip;
            var url="${pageContext.request.contextPath}/manage/log/indexLogInfo?_logInfoStr="+operaterdescrip;
            var windoeName="LogInfoWindow";
            var  windowTitle="操作详情";
            width="55%";
            height="70%";
            f_open(windoeName,windowTitle,width,height,url,true)
        }

        //获得url
        function getUrl() {
            var url="${root}/manage/log/getLogList"+getQueryLog();
            url=encodeURI(encodeURI(url));
            return url;
        }

        function getQueryLog() {
            var url="?title="+$('#title').val()
                +"&datapermission="+$("#datapermission").val()
                +"&formtypedesc=" +$("#modelTypes").find("Option:selected").text()
                +"&actiontype="+$("#operateTypes").find("Option:selected").text()
            +"&start_date="+$("#start_date").val()
            +"&end_date="+$("#end_date").val();
            return url;
        }

        //  根据模块类型，查询到的操作类型
        function doSelect(){
            var id = $("#modelTypes").select().val();
            var url="${root}/manage/log/getOperate/"+id;
            var httpReqest = new HttpRequest();
            var result = new Array();
            result.push(httpReqest.sendRequest(url).operateTypeList);
            $("#operateTypesl").val(result);
            doSelectValue($("#operateTypesl").val(),"operateTypes");
        }

        //查询时调用
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
    </script>

    <script>
        var start = {
            elem: '#start_date',
            format: 'YYYY/MM/DD hh:mm:ss',
            min: '2017-03-16 23:59:59', //设定最小日期为当前日期
            max: '2099-06-16 23:59:59', //最大日期
            istime: true,
            istoday: false,
            choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            elem: '#end_date',
            format: 'YYYY/MM/DD hh:mm:ss',
            min:  '2017-03-16 23:59:59',
            max: '2099-06-16 23:59:59',
            istime: true,
            istoday: false,
        };

    </script>
</head>
<body>
<input type="hidden" id="modelTypeList" value="${modelTypeList}"/>
<input type="hidden" id="operateTypesl" value="${operateTypeList}"/>
<input type="hidden" id="getTableIdList" value="${tableid}">
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" >
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">关键字:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="title"
                                       name="title">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作人:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="datapermission" name="datapermission">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">模块类型:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="modelTypes" id="modelTypes"
                                         onchange="doSelect()"
                                ></select>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">操作类型:</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="operateTypes" id="operateTypes"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">时间从:</label>
                            <div class="col-sm-6">
                                <input type="text" class="laydate-icon form-control" name="start_date" id="start_date"
                                       onclick="laydate(start)"
                                       <%--onclick="laydate({format:'YYYY-MM-DD hh:mm:ss',istime: false,istoday: false})"--%>
                                />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">时间到:</label>
                            <div class="col-sm-6">
                                <input type="text" class="laydate-icon form-control"    name="end_date" id="end_date"
                                onclick="laydate(end)"/>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%--查询和清空--%>
<div align="center" id="operator">
</div>
<div id="tt"></div>
</body>
</html>
