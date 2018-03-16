<%--
  Created by wjy
  Date: 2017/7/21
  Time: 17:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>选择关联账户</title>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/common.jsp"%>
    <jsp:include page="/res/public/float_div.jsp"></jsp:include>
    <script type="text/javascript">
        $(window).resize(function(){ $("#tt").datagrid("resize"); });
        var height=$(window).height()-120; //浏览器当前窗口可视区域高度
        $(document).ready(function(){
            var options = {
                url:getUrl(),
                sortable:true,
                singleSelect:false,
                remoteSort:false,
                pagination:true,
                width:"auto",
                height:height,
                showFooter:true,
                rownumbers:true
            };
            options.columns = [[
                {field:"id",title:"系统ID",width:8,hidden:true},
                {field:"action",title:"选择",width:130,align:"center",resizable:true,formatter:editf},
                {field:"user_name",title:"用户名",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"display_name",title:"姓名",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"dept_name",title:"部门",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"role_name",title:"角色",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"user_status",title:"启用",width:50,align:"center",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"creator_name",title:"创建人",width:60,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
                {field:"create_date",title:"创建日期",width:120,align:"left",sortable:true,hidden:false,resizable:false,headalign:"center"},
                {field:"update_user_name",title:"最新修改人",width:80,align:"left",sortable:true,resizable:true,headalign:"center"},
                {field:"update_date",title:"最新修改日期",width:120,align:"left",sortable:true,resizable:true,headalign:"center"},
                {field:"user_desc",title:"用户描述",width:140,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"}
            ]];
            $("#tt").datagrid(options);
            $('#tt').datagrid('getPager').pagination({
                pageList : [ 20, 40, 60,80,100,200 ],
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录&nbsp;&nbsp;',
                onSelectPage:function(pageNumber, pageSize){
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

        //查询url
        function getUrl(){
            var url='${root}/manage/user/queryUserList'+getQueryCondtion();
            url=encodeURI(encodeURI(url));
            return url;
        }
        function editf(value,row,index) {
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="confirm('+index+')">选择</a>]'
            return e;
        }

        function confirm(index){
            var rows=$('#tt').datagrid('getData').rows;
            var user_id=rows[index].id;
            setEmployeeUserId(user_id);

        }
        function setEmployeeUserId(userId){
/*            layer.confirm('确定关联该账户？', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            },function(index){*/
                var url = "${root}/manage/employee/setEmployeeUserId?employeeId="+$("#employeeId").val()+"&userId="+userId;
                url=encodeURI(encodeURI(url));
                $.ajax({
                    url: url,
                    type : 'post',
                    async : false,
                    success: function(result) {
                        parent.layer.msg(result.msg);
                        if (result.success){
                            parent.setUserId(userId);
                        }
                    },
                    error: function () {
                        parent.layer.msg("操作失败！");
                    }
                });
          var url = "${root}/manage/user/setUserHeadPhotoById?headPhoto="+$("#head_photo").val()+"&userId="+userId;
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                success: function(result) {
                }
            });
            f_close("connectAccount");
        }
        function getQueryCondtion()
        {
            var url="?userName="+$('#userName').val();
            url+="&displayName="+$('#displayName').val();
            url+="&deptId=-1";//所有员工
            url+="&deptName="+$("#deptName").val();
            url+="&roleName="+$("#roleName").val();
            url+="&userStatus="+$("#userStatus option:selected").val();
            return url;
        }
        //查询
        function doQuery(){
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        function choseDept()
        {
            var url = '${root}/manage/dept/choseDept';
            url=encodeURI(encodeURI(url));
            windowName="deptWindow";
            windowTitle="选择部门";
            width = "20%";
            height = "80%";
            f_open(windowName, windowTitle, width,height, url, true);
        }
        function choseRole(){
            var url = '${root}/manage/permission/choseRoleWithId?_chkStyle=radio';
            windowName="roleWindow";
            windowTitle="选择角色";
            width = "20%";
            height = "80%";
            f_open(windowName, windowTitle, width,height, url, true);
        }
    </script>
</head>
<body>
<input  type="hidden" id="_deptId"   value="${_deptId}"/>
<input  type="hidden" id="employeeId"   value="${employeeId}"/>
<input  type="hidden" id="_roleCode" value="${_roleCode}"/>
<input  type="hidden" id="_displayName"   value="${displayName}"/>
<input  type="hidden" id="_deptName"   value="${deptName}"/>
<input  type="hidden" id="_roleName"   value="${roleName}"/>
<input  type="hidden" id="userId"   value="${id}"/>
<input  type="hidden" id="head_photo"   value="${head_photo}"/>


<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content" id="searchArea">
                <form method="post" class="form-horizontal">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">部门：</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="deptName" name="deptName" placeholder="请单击选择部门"
                                       onclick="choseDept()"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">用户名：</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="userName" name="userName" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">姓名：</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="displayName" name="displayName" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">角色：</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="roleName" name="roleName" placeholder="请单击选择角色"
                                       onclick="choseRole()"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">启用：</label>
                            <div class="col-sm-9">
                                <select id="userStatus" class="form-control">
                                    <option value=""></option>
                                    <option value="是">是</option>
                                    <option value="否">否</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div align="center" id="operator">
    <a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>查询</a>
    <a class='btn btn-warning btn-sm' href="javascript:doClearCondition();"><i class='fa fa-remove'></i>清空</a>
    <a class='btn btn-success btn-sm' href="javascript:doAdd();"><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>
</div>
<div id="tt"></div>
</body>
</html>