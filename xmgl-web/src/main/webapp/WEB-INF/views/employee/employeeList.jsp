<%--
  Created by wjy
  Date: 2017/7/18
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>员工信息列表</title>
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp" ></jsp:include>
    <jsp:include page="/res/public/datagrid-date.jsp" ></jsp:include>

</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input type="hidden" id="cur_user_id" value="${user_id}"/>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea" style="display:none">
                <form method="get" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">姓名：</label>
                            <div class="col-sm-6">
                                <div class="input-group col-sm-12">
                                    <input type="text" class="form-control" id="employee_name"
                                           name="employee_name" >
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">性别：</label>
                            <div class="col-sm-6">
                                <select  class="form-control"  name="gender" id="gender">
                                    <option ></option>
                                    <option value="男">男</option>
                                    <option value="女">女</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div  class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">部门：</label>
                            <div class="col-sm-6">
                                <input  type="text" class="form-control"  name="dpt_name" id="dpt_name" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">岗位：</label>
                            <div class="col-sm-6">
                                <input type="text" id="position_name" class="form-control"  />

                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">就职状态：</label>
                            <div class="col-sm-6">
                                <select id="employment_status" class="form-control"  >

                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input  class="form-control"  name="creator" id="creator"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <div class="col-sm-12 input-group">
                                    <input  onclick="laydate()" class="form-control"   name="query_create_date_begin" id="query_create_date_begin"/>
                                    <span class="input-group-addon"></span>
                                    <input  onclick="laydate()" class="form-control"  name="query_create_date_end" id="query_create_date_end"/>
                                </div>
                            </div>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js" charset="UTF-8"></script>

<script type="text/javascript">
    $(window).resize(function(){ $("#tt").datagrid("resize"); });
    var _funcArray;
    var _queryConfig;
    $(document).ready(function(){
        getEmploymentStatusDic();
        _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
        console.log(_funcArray);
        var height=$(window).height()-160; //浏览器当前窗口可视区域高度
        $("body").css("margin-bottom",'0px');
        var html="";
        html+="<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
        html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
        html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";

        for(var i=0;i<_funcArray.length;i++)
        {
            var funcObj=_funcArray[i];
            switch(funcObj)
            {
                case 'initEmployeeInfo':
                    html+="<a class='btn btn-success btn-sm' href='javascript:addNew();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
                    break;
                default:
                    break;
            }
        }
        $("#operator").html(html);
        initEmployeeList(height);
    });
    $(document).keyup(function(event) {
        if (event.keyCode == 13) {
            doQuery();
        }
    });
    function initEmployeeList(height){
        var url = "${root}/manage/employee/getGridStyle?_curModuleCode="+$("#_curModuleCode").val();
        var httpReqest=new HttpRequest();
        var datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;
        var options = {
            url:getUrl(),
            sortable:true,
            singleSelect:true,
            pagination:true,
            height:height,
            width:'auto',
            striped:true,
            rownumbers:true,
            remoteSort:true,
            remoteFilter:true,
            filterDelay:2000,
            filterStringify:function(data){
                _filterRule=JSON.stringify(data);
                return JSON.stringify(data);
            },
            frozenColumns:[[
                {field : "id",title : "id",hidden : true},
                {field:"creator_id",hidden : true,title:"创建人ID"},
                {field:"modifier_id",hidden : true,title:"修改人ID"},
                {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf}
            ]],
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
            },
            onDblClickRow: function (rowIndex, rowData) {
                editInfo(rowIndex);
            }

        };
        options.columns = eval(datagridStyleConfig);
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
            {field:'act',type:'label' },
            {field:'gender',  type:'combobox',
                options:{
                    panelHeight:'auto',data:[{"data_name":"男","data_code":"男"},{"data_name":"女","data_code":"女"}],  valueField: "data_code",
                    textField: "data_name" ,editable:false,
                    onSelect: function (row){$('#tt').datagrid('addFilterRule',{field: "gender" ,value: row.data_code});$('#tt').datagrid('doFilter')}
                }
            },
            {field:'employment_status',  type:'combobox',
                options:{
                    panelHeight:'auto',data:employmentStatusList,  valueField: "data_code",
                    textField: "data_name" ,editable:false,
                    onSelect: function (row){$('#tt').datagrid('addFilterRule',{field: "employment_code" ,value: row.data_code});$('#tt').datagrid('doFilter')}
                }
            }
        ]);
        $("input[name='entry_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
        $("input[name='leave_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});
        $("input[name='create_date']").bind("click",function(){ShowDiv('MyDiv','fade',$(this).attr("name"))});

    }

    function oprHandle(itemId,rowData,rowIndex) {
        switch (itemId) {
            case "saveGridStyle":
                saveGridStyle("tt","${root}/manage/employee/saveGridStyle?_curModuleCode="+$("#_curModuleCode").val());
                break;
            case "showColumns":
                var url="${root}/manage/employee/showGridColumn" ;
                showOrHiddenColumns("tt",url,0);
                break;
            default:
                break;
        }
    }

    /**
     * 查询日志列表
     * @returns {string|*}
     */
    //右击菜单事件处理

    function getUrl() {
        var url;
        url="${root}/manage/employee/queryEmployeeList/"+getQueryCondition();
        url=encodeURI(encodeURI(url));
        return url;
    }
    /**
     * 获取查询条件
     * @returns {string}
     */
    function getQueryCondition(){

        var url="?employee_name="+$('#employee_name').val()
            +"&gender="+$('#gender').val()
            +"&creator="+$('#creator').val()
            +"&dept_name="+$('#dpt_name').val()
            +"&position_name="+$('#position_name').val()
            +"&_curModuleCode="+$("#_curModuleCode").val()
            +"&query_create_date_begin="+$('#query_create_date_begin').val()
            +"&query_create_date_end="+$('#query_create_date_end').val()
            +"&employment_code=" + $('#employment_status').val();
        return url;
    }
    function editf(value,row,index) {
        var e = '';
        for(var i=0;i<_funcArray.length;i++)
        {
            var funcObj=_funcArray[i];
            switch(funcObj)
            {
                case 'editEmployee':
                    e +='[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
                    break;
                default:
                    break;
            }
        }
        for(var i=0;i<_funcArray.length;i++)
        {
            var funcObj=_funcArray[i];
            switch(funcObj)
            {
                case 'delEmployee':
                    e += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo(' + index + ')">删除</a>]';
                    break;
                default:
                    break;
            }
        }

        return e ;
    }
    /**
     * 进入日志的详情，进行编辑
     * @param index 行的索引
     */
    function editInfo(index){
        var rows=$('#tt').datagrid('getData').rows;
        var id = rows[index].id;
        var url;
        url="${root}/manage/employee/initEmployeeInfo?id="+id+"&_curModuleCode="+$("#_curModuleCode").val();
        parent.addTab("员工信息详情", url);
    }
    function deleteInfo(index){
        var rows=$('#tt').datagrid('getData').rows;
        var id = rows[index].id;
        var url = "${root}/manage/employee/delEmployee/"+id;
        layer.confirm(_DELETE_ONE_MSG, {
            btn: ['确定','取消'], //按钮
            shade: false //不显示遮罩
        }, function(index){
            $.ajax({
                url: url,
                type : 'post',
                success: function(response) {
                    /**
                     * 操作成功
                     */
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
    /**
     * 执行查询
     */
    function doQuery() {
        $('#tt').datagrid('options').url=getUrl();
        $('#tt').datagrid('load');
    }
    /**
     * 新建日志
     */
    function addNew(){
        var url = "${root}/manage/employee/initEmployeeInfo?id=-1&_curModuleCode="+$("#_curModuleCode").val();
        parent.addTab("新增员工", url);
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
                addSelectOption(result.employmentStatusDic,"employment_status");
                employmentStatusList=result.employmentStatusDic;
            }
        });
    }
</script>
<div align="center" id="operator"></div>
<div id="tt"></div>
<div id="cntMenu" class="easyui-menu" style="width:150px;">
    <div id="saveGridStyle" class ='rightMenu'>保存列表样式</div>
    <div class="menu-sep"></div>
    <div id="showColumns">显示(隐藏)列</div>
    <div class="menu-sep"></div>
    <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>
</div>
</body>
</html>
