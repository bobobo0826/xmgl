<%--
  Created by IntelliJ IDEA.
  User: quangao
  Date: 2017/7/28
  Time: 11:55
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
        var multiSelectAble = true; // 是否为多选界面常量

        $(document).ready(function(){
            _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
            if ($("#isSingleSelect").val()!=""){
                if ($("#isSingleSelect").val()=="1"){
                    multiSelectAble=false;
                }else if ($("#isSingleSelect").val()=="0"){
                    multiSelectAble=true;
                }else {
                    multiSelectAble=false;
                }
            }else{
                multiSelectAble = getMultiSelectAble($("#_curModuleCode").val());
            }
            var height=$(window).height()-160; //浏览器当前窗口可视区域高度
            $("body").css("margin-bottom",'0px');
            var html="";
            html+="<a class='btn btn-danger btn-sm' href='javascript:doHideOrShowPrint();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;显示条件</a>&nbsp;&nbsp;";
            if (multiSelectAble){
                html+="<a class='btn btn-primary btn-sm' href='javascript:multiSelect();'><i class='fa fa-check-square-o'></i>&nbsp;&nbsp;确定</a>&nbsp;&nbsp;";
            }
            html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
            html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
            $("#operator").html(html);
            initEmployeeList(height);

            /**
             *判断操作列显示隐藏
             *  */

            if (!multiSelectAble){
                $("#tt").datagrid("hideColumn","ck");
                $("#tt").datagrid("showColumn","act");
            }else{
                $("#tt").datagrid("showColumn","ck");
                $("#tt").datagrid("hideColumn","act");
            }

        });
        $(document).keyup(function(event) {

            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function initEmployeeList(height){
            var str='';
            if($("#_curModuleCode").val()!=""){
                str=$("#_curModuleCode").val();
            }else{
                str='XZYG';
            }
            var url = "${root}/manage/employee/getGridStyle?_curModuleCode="+str;
            var httpReqest=new HttpRequest();
            var datagridStyleConfig = httpReqest.sendRequest(url).gridStyle;

            var options = {
                url:getUrl(),
                sortable:true,
                singleSelect:false,
                pagination:true,
                height:'auto',
                width:'auto',
                striped:true,
                rownumbers:true,
                remoteSort:true,
                frozenColumns:[[
                    {field : "id",title : "id",hidden : true},
                    {field:"ck", checkbox:true},
                    {field:"act",title:"操作", resizable:true,headalign:"center",align:"center",formatter:editf},
                    {field:"creator_id",hidden : true,title:"创建人ID"},
                    {field:"modifier_id",hidden : true,title:"修改人ID"},
                    {field:"user_id",hidden : true,title:"用户ID"},
                    {field:"photo",hidden : true,title:"照片"}
                ]],
                onSortColumn: function (sort, order) {
                    datagridSort(sort, order,"tt",getUrl());
                },
                onDblClickRow:function(rowIndex){
                    if(!multiSelectAble){
                        singleConfirm(rowIndex);
                    }
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
        }
        function getUrl() {
            var url;
            url="${root}/manage/employee/selectEmployeeList/"+getQueryCondition();
            url=encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?employee_name="+$('#employee_name').val()
                +"&gender="+$('#gender').val()
                +"&dept_name="+$('#dpt_name').val()
                +"&position_name="+$('#position_name').val()
                +"&_curModuleCode="+$("#_curModuleCode").val()
                +"&idList="+$("#idList").val();
            return url;
        }
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="singleConfirm('+index+')">选择</a>]';
            return e ;
        }
        /**
         * 单选操作
         *  */
        function singleConfirm(index){
            var rows=$('#tt').datagrid('getData').rows;

            confirm (rows[index]);
            f_close("new_window");
        }
        function confirm(row){
            var obj=new Object();
            obj.employee_id=row.id;
            obj.user_id=row.user_id;
            obj.mobilephone_number=row.mobilephone_number;
            obj.employee_name=row.employee_name;
            obj.dpt_name=row.dpt_name;
            obj.position_name=row.position_name;
            obj.employment_status=row.employment_status;
            obj.gender=row.gender;
            obj.photo=row.photo;
            obj._curModuleCode=$("#_curModuleCode").val();
            parent.setEmployeeInfo(obj);

        }
        /**
         * 执行查询
         */
        function doQuery() {
            $('#tt').datagrid('options').url=getUrl();
            $('#tt').datagrid('load');
        }
        /**
         * 多选确定
         * */
        function multiSelect(){
            var selectedRows=$('#tt').datagrid('getSelections');
            if(selectedRows.length==0){
                layer.msg("未选中行");
                return;
            }
            for(var i=0;i<selectedRows.length;i++){
                confirm(selectedRows[i]);
            }
            f_close("new_window");
        }
        /**
         * 判断是否可以多选
         */

        function getMultiSelectAble(moduleCode){
            switch (moduleCode){
                case "XZYG"://选择员工，多选
                    return true;
                    break;
                case "XMCYRY"://项目选择参与人员，单选
                    return false;
                    break;
                case "XZZDSHR"://选择指定审核人，单选
                    return false;
                    break;
                case "RWGL":
                    return true;
                    break;
                default :
                    return false;
            }
        }

    </script>
</head>
<body>
<input type="hidden" id="_curModuleCode" value="${_curModuleCode}"/><%--当前模块名--%>
<input type="hidden" id="idList" value="${idList}"/><%--员工id查询条件--%>
<input type="hidden" id="projectId" value="${projectId}"/>
<input type="hidden" id="isSingleSelect" value="${isSingleSelect}"/>
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
<%--                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">就职状态：</label>
                            <div class="col-sm-6">
                                <select id="employment_status" class="form-control"  >

                                </select>
                            </div>
                        </div>
                    </div>--%>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator"></div>
<div id="tt"></div>
<div id="cntMenu" class="easyui-menu" style="width:150px;">
    <div id="doClear" href='javascript:doClear();'>清空查询条件</div>
    <div class="menu-sep"></div>
    <div id="nouse"></div>
</div>
</body>
</html>

