<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
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
        {field:"action",title:"操作",width:130,align:"center",resizable:true,formatter:editf},
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
function getQueryCondtion()
{
   var url="?userName="+$('#userName').val();
   url+="&displayName="+$('#displayName').val();
   url+="&deptId="+$("#_deptId").val();
   url+="&deptName="+$("#deptName").val();
    url+="&roleCode="+$("#_roleCode").val();
   url+="&roleName="+$("#roleName").val();
   url+="&userStatus="+$("#userStatus option:selected").val();
   return url;
}
//查询
function doQuery(){
   $('#tt').datagrid('options').url = getUrl();
   $('#tt').datagrid('load');
}

function editf(value, row, index) {
   var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
   var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delUser('+index+')">删除</a>]';
   var g = '[<a href="###" style="text-decoration:none;color:red;" onclick="resetPsw('+index+')">重置密码</a>]';
    return e + " " +c+ " " +g;
}

function resetPsw(index){
   var rows=$('#tt').datagrid('getData').rows;
   var id = rows[index].id;
   var url="${root}/manage/user/resetPsw?id="+id;
    parent.layer.confirm('是否确定重置密码?', {
               btn: ['确定','取消'], //按钮
               shade: false //不显示遮罩
           }, function(index){
               $.ajax({
               url: url,
               type : 'post',
               cache : false,
               async : true,
               success:function(result) {
                   if(result.success) {
                	   parent.layer.msg(result.msg);
                   }
                   else {
                	   parent.layer.msg(result.msg);
                   }
               }
            });

           }, function(index){
        	   parent.layer.close(index);
           });
}
//编辑
function editInfo(index){
   var rows=$('#tt').datagrid('getData').rows;
   var id = rows[index].id;
   window.parent.editUserInfo(id);
}
//添加用户
function doAdd()
{
   window.parent.addUserInfo();
}
//删除
function delUser(index){
   var rows=$('#tt').datagrid('getData').rows;
   var id = rows[index].id;
   var url="${root}/manage/user/delUserInfo?id="+id;
   parent.layer.confirm('是否确定删除吗?', {
          btn: ['确定','取消'], //按钮
          shade: false //不显示遮罩
      }, function(index){
           $.ajax({
           url: url,
           type : 'post',
           cache : false,
           async : true,
           success:function(response) {
               if(response.success) {
            	   $('#tt').datagrid('load');
            	   parent.layer.close(index);
               }
               else {
            	   parent.layer.alert(response.msg)
                   parent.layer.close(index);
               }
           }
        });

       }, function(index){
    	   parent.layer.close(index);
      });
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
function setDept(deptInfo){
    if(deptInfo==null || deptInfo=="")
        return;
    $("#deptName").val(deptInfo.dept_name);
    $("#_deptId").val(deptInfo.id);
}
function choseRole(){
    var url = '${root}/manage/permission/choseRoleWithId?_chkStyle=radio&_selCodes=' + $('#_roleCode').val();
    windowName="roleWindow";
    windowTitle="选择角色";
    width = "20%";
    height = "80%";
    f_open(windowName, windowTitle, width,height, url, true);
}

function setRole(roleList){
    if(roleList==null || roleList=="")
        return;
    $("#roleName").val(roleList[0].roleName);
    $("#_roleCode").val(roleList[0].roleCode);
}

function doClearCondition(){
    $("#_deptId").val("");
    $("#_roleCode").val("");
    doClear();
}
</script>
</head>
<body>
<input  type="hidden" id="_deptId"   value="${_deptId}"/>
<input  type="hidden" id="_roleCode" name="roleCode"/>
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