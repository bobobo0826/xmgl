<%--
  Created by fcy.
  User: quangao
  Date: 2017/8/22
  Time: 14:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>物品管理</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>
    <script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>
    <script type="text/javascript">
        var height=$(window).height()-140; //浏览器当前窗口可视区域高度
        var _funcArray;
        $(window).resize(function(){ $("#tt").datagrid("resize"); });

        $(document).ready(function(){
            _funcArray = getFunctions('${pageContext.request.contextPath}', $("#_curModuleCode").val());

            initOpr();
            getGoodsStateList();
            initDatagrid();

        });

        function initDatagrid(){
            //   var url = "${root}/manage/project/getGridStyle.action?_curModuleCode="+$("#_curModuleCode").val();
            var httpReqest=new HttpRequest();
            //     datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
            var options = {
                columns : [[
                    {field: "ck", checkbox: true},
                    {field:"ID",title:"ID",hidden:true},
                    {field:"action",title:"操作",resizable:true,width:120,headalign:"center",align:"center",sortable:true,formatter:editf},
                    {field:"materials_code",title:"编号",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"dictionary_code",title:"字典码",resizable:true,width:100,headalign:"center",align:"center",sortable:true,hidden:true},
                    {field:"materials_type",title:"物品类别",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"model",title:"型号",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"unit",title:"单位",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"price",title:"单价",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"materials_location",title:"位置",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"buy_date",title:"买入日期",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"materials_status",title:"状态",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"employee_id",title:"当前员工id",resizable:true,width:50,headalign:"center",align:"center",sortable:true,hidden:true},
                    {field:"goods_info",title:"详细信息",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"employee_name",title:"员工姓名",resizable:true,width:100,headalign:"center",align:"center",sortable:true},
                    {field:"entry_person",title:"录入人",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"entry_date",title:"录入时间",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"modifier",title:"修改人",resizable:true,width:150,headalign:"center",align:"center",sortable:true},
                    {field:"modify_date",title:"修改时间",resizable:true,width:150,headalign:"center",align:"center",sortable:true}
                ]],
                url:getUrl(),
                sortable:true,
                singleSelect:false,
                pagination:true,
                height:height,
                width:'auto',
                striped:true,
                rownumbers:true,
                singleSelect:false,
                remoteSort:true,
                nowrap:false,
                remoteFilter:true,
                filterDelay:2000,

                onDblClickRow: function(index,row) {
                    editInfo(index);
                },
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                onRowContextMenu:function(e, rowIndex, rowData) {
                    e.preventDefault();
                    $('#cntMenu').menu({
                        onClick: function (item) {
                            oprHandle(item.id, rowData, rowIndex);
                        }
                    });
                    $('#cntMenu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }) ;
                } ,
                onHeaderContextMenu:function(e, rowIndex, rowData) {
                    e.preventDefault();
                    $('#cntMenu').menu({
                        onClick: function (item) {
                            oprHandle(item.id, rowData, rowIndex);
                        }
                    });
                    $('#cntMenu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    }) ;
                }
            };

            $("#tt").datagrid(options);
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60,80,100,200],
                pageSize:20,
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize) {
                    datagridPagination(pageNumber, pageSize,"tt",getUrl());
                }
            });
            $('#tt').datagrid('enableFilter', [
                {field:'action',type:'label' },
                {
                    field: 'materials_status', type: 'combobox',
                    options: {
                        panelHeight: 'auto', data: goodsStateList, valueField: "data_code",
                        textField: "data_name", editable: false,
                        onSelect: function (row) {
                            $('#tt').datagrid('addFilterRule', {field: "materials_status", value: row.data_name});
                            $('#tt').datagrid('doFilter')
                        }
                    }
                }

            ]);

            $("input[name='buy_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
            $("input[name='entry_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
            $("input[name='modifier_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});

        }

        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function editf(value,row,index) {
            var t='';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'goodsInfo':

                            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo(' + index + ')">详情</a>]';
                            break;
                        // var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow('+index+')">删除</a>]';
                        case 'delgoods':


                                t += '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow(' + index + ')">删除</a>]';

                            break;
                        default:
                            break;
                    }
                }
            }




//            var t =u+" "+c;
            return t;
        }

        function doRecovery() {

            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            if (!isEmpty(selectedRows)) {
                for (var i = 0; i < selectedRows.length; i++) {

                    idsStr += selectedRows[i].id + ",";
                }
            }
            layer.confirm('确定回收吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/materials/recoveryGoods/' + idsStr;

                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }
        function doScrap() {

            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            if (!isEmpty(selectedRows)) {
                for (var i = 0; i < selectedRows.length; i++) {

                    idsStr += selectedRows[i].id + ",";
                }
            }
            layer.confirm('确定报废吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                var url = '${root}/manage/materials/scrapGoods/' + idsStr;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function doAllot(){
            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            var url="${root}/manage/materials/selectEmployee?_curModuleCode=XMCYRY" ;
            var width="80%";
            var height="80%";
            f_open("newWindow","选择员工",width,height,url,true);
        }
        function setEmployeeInfo(object) {
               var employee_id = object.employee_id;
            var employee_name = object.employee_name;
           allot(employee_id,employee_name);
        }
        function allot(employee_id,employee_name) {

            var idsStr = "";
            var selectedRows = $('#tt').datagrid('getSelections');
            if (!isEmpty(selectedRows)) {
                for (var i = 0; i < selectedRows.length; i++) {

                    idsStr += selectedRows[i].id + ",";
                }
            }
            var urls= "&employee_id="+employee_id
                +"&employee_name="+employee_name;
            layer.confirm('确定分配吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                //var url = '${root}/manage/materials/allotGoods/' + idsStr+'/'+employee_id+'/'+employee_name;
//                var map={};
//                map.put("idsStr",idsStr);
//                map.put("employee_id",employee_id);
//                map.put("employee_name",employee_name);
                var url="${root}/manage/materials/allotGoods?idsStr="+idsStr+urls;
                $.ajax({
                    url: url,
                    type: 'post',
                    cache: false,
                    async: false,
                    success: function (data) {
                        if (data.msgCode == 1) {
                            $('#tt').datagrid('load');
                        }
                        layer.msg(data.msgDesc);
                    }
                });
            }, function (index) {
                layer.close(index);
            });
        }

        function delRow(index){
            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url = "${root}/manage/materials/delGoodsInfo?id="+id;
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
        function editInfo(index){

            var rows=$('#tt').datagrid('getData').rows;
            var id = rows[index].id;
            var url;
            url="${root}/manage/materials/initGoodsInfo?id="+id+ "&_curModuleCode=" + $("#_curModuleCode").val();
            parent.addTab("物品管理详情", url);
        }
        function getUrl() {
            var url = "${root}/manage/materials/queryGoodsList"+getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?materials_type="+$('#materials_type').val()
                +"&query_entry_date_begin="+$('#query_entry_date_begin').val()
                +"&query_entry_date_end="+$('#query_entry_date_end').val()
                +"&materials_code="+$('#materials_code').val()
                +"&employee_name="+$('#employee_name').val()
                + "&_curModuleCode=" + $("#_curModuleCode").val()
                +"&materials_status="+$('#materials_status option:selected').text();

//                +"&update_date="+$('#update_date').val();

            return url;

        }

        // 查询
        function doQuery() {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        function addNew()
        {
            var url="${root}/manage/materials/initGoodsInfo?id=0&_curModuleCode=" + $("#_curModuleCode").val();
            parent.addTab("新增物品", url);
        }
        var goodsStateList;
        function getGoodsStateList() {

            var url = "${root}/manage/materials/getGoodsStateList";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: false,
                success: function (result) {
                    addSelectOption(result.goodsStateList, "materials_status");
                    goodsStateList = result.goodsStateList;

                }
            });
        }


        function initOpr() {
            var html = '';
            html += '<a class="btn btn-danger btn-sm" href="javascript:doHideOrShowPrint();" id="hideOrShowBt"><i class="fa fa-arrow-up"></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;';

            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'goodsQuery':
                            html += '<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;';
                            html += '<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;';
                            break;
                        case 'addGoods':
                            html += '<a class="btn btn-success btn-sm" href="javascript:addNew();"><i class="fa fa-plus"></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;';
                            break;
                        case 'goodsAssignment':
                            html += '<a class="btn btn-info btn-sm" href="javascript:doAllot();" id="Allot"><i class="fa fa-check"></i>&nbsp;&nbsp;分配</a>&nbsp;&nbsp;';
                            break;
                        case 'recoveryGoods':
                            html += '<a class="btn btn-info btn-sm" href="javascript:doRecovery();" id="recovery"><i class="fa fa-check"></i>&nbsp;&nbsp;回收</a>&nbsp;&nbsp;';
                            break;
                        case 'scrapGoods':
                            html += '<a class="btn btn-info btn-sm" href="javascript:doScrap();" id="Scrap"><i class="fa fa-check"></i>&nbsp;&nbsp;报废</a>&nbsp;&nbsp;';
                            break;

                        default:
                            break;
                    }
                }
            }
            $("#operator").html(html);
        }


    </script>
</head>

<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<div class="row" >
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style='display:none'>
                <form method="get" class="form-horizontal">

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">物品类别:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="materials_type" name="materials_type"/>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">状态:</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="materials_status" name="materials_status"
                                        onchange="doQuery()"></select>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">录入时间:</label>
                            <div class="col-sm-6">
                                <%--<input class="form-control" id="update_date" name="update_date"/>--%>
                                <div class="col-sm-12 input-group">
                                    <input  onclick="laydate()" class="form-control"   name="query_entry_date_begin" id="query_entry_date_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input  onclick="laydate()" class="form-control"  name="query_entry_date_end" id="query_entry_date_end"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">编号:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="materials_code" name="materials_code"/>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">员工姓名:</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="employee_name" name="employee_name"/>
                            </div>
                        </div>
                    </div>



                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator">
    <%--<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;--%>
    <%--<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;--%>
    <%--<a class='btn btn-success btn-sm' href='javascript:addNew();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;--%>
    <%--<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;--%>
</div>
<div id="tt"></div>

</body>
</html>
