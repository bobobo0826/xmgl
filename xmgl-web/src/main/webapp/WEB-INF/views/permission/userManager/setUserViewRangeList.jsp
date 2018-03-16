<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>
<!--easyui-->
<%@ include file="/res/public/easyui_lib.jsp"%>
<!--common-->
<%@ include file="/res/public/common.jsp"%>
 <script type="text/javascript" src="${root}/res/public/js/Map.js"  charset="UTF-8"></script>
<jsp:include page="/res/public/float_div.jsp"></jsp:include>
 
<%@ include file="/res/public/msg.jsp"%> 
<script type="text/javascript">
$(window).resize(function(){ $("#tt").datagrid("resize"); });
var _datagridStyleConfig="";
$(document).ready(function(){
	var array=parent.getCurCanVIewUserArrary();
	initselectedUser(array); 
	$("#tt").datagrid({
		url:getUrl(),
        sortable:true,
        singleSelect:false,
        remoteSort:false,
        pagination:true, 
        width:"auto",
        height:"auto", 
        showFooter:true,
        rownumbers:true,
		columns:[[
			{field:"ck",width:50,align:"left",checkbox:true},
	        {field:"id",title:"系统ID",width:8,hidden:true},
	        {field:"user_name",title:"用户名",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"display_name",title:"姓名",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"dept_name",title:"部门",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"role_name",title:"角色",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"user_status",title:"启用",width:50,align:"center",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"creator_name",title:"创建人",width:80,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"},
	        {field:"create_date",title:"创建日期",width:120,align:"left",sortable:true,hidden:false,resizable:false,headalign:"center"},
	        {field:"update_user_name",title:"最新修改人",width:80,align:"left",sortable:true,resizable:true,headalign:"center"},
	        {field:"update_date",title:"最新修改日期",width:120,align:"left",sortable:true,resizable:true,headalign:"center"},
	        {field:"user_desc",title:"用户描述",width:140,align:"left",sortable:true,hidden:false,resizable:true,headalign:"center"}
		]],
		 onLoadSuccess:function(data){
			 var rows=$('#tt').datagrid('getData').rows;
			 for(var i=0;i<rows.length;i++){
				 for(var k=0;k<array.length;k++){
					 if(rows[i].id==array[k].user_id){
						 $('#tt').datagrid("selectRow", i);
					 }
				 }
			 }
			    		
		},
		onCheck:function(rowIndex,rowData){
			array=parent.getCurCanVIewUserArrary();
			var arrayStr=JSON.stringify(array);
			if(arrayStr.indexOf(rowData.id)<0){
				var html=document.getElementById("user").innerHTML;
				html+='<div class="col-sm-1 control-label" id="'+rowData.id+'">'+rowData.display_name+'';
				html+='<span name="deleteimage" style="margin-left:5px"><img  src="${root}/res/public/img/form/label_03.png" onclick="delLabel('+rowData.id+','+rowIndex+');" class="label-pic" ></span></div>';
				parent.put(rowData.id,rowData.display_name);
				document.getElementById("user").innerHTML=html;
			}
		},
		onUncheck:function(rowIndex,rowData){
			if(typeof(rowData)!="undefined"){
				parent.remove(rowData.id);
				delLabel(rowData.id);
			}
		},
		onCheckAll:function(rowDatas){
			for(var i=0;i<rowDatas.length;i++){
				array=parent.getCurCanVIewUserArrary();
				var arrayStr=JSON.stringify(array);
				if(arrayStr.indexOf(rowDatas[i].id)<0){
					var html=document.getElementById("user").innerHTML;
					 html+='<div class="col-sm-1 control-label" id="'+rowDatas[i].id+'">'+rowDatas[i].display_name+'';
					 html+='<span name="deleteimage" style="margin-left:5px"><img  src="${root}/res/public/img/form/label_03.png" onclick="delLabel('+rowDatas[i].id+','+i+');" class="label-pic" ></span></div>';
					 parent.put(rowDatas[i].id,rowDatas[i].display_name);
					 document.getElementById("user").innerHTML=html;
				}
			}
		},
		onUncheckAll:function(rowDatas){
			for(var i=0;i<rowDatas.length;i++){
				delLabel(rowDatas[i].id,i);
			}
		}
	
	});
    $('#tt').datagrid('getPager').pagination({
    	pageList : [ 20, 40, 60 ],
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
             $('.datagrid-header-check input').attr("checked",false)
        }
    }); 
    
});
   
$(document).keyup(function(event) {
   if (event.keyCode == 13) {
       doQuery();
   }
});
function check(value,row,index){
}
function showAuxDept(value,row,index){
   if(value==undefined)
       value="";
    return showContent(value,30);
}
function delLabel(userId,rowindex){
	$("#"+userId+"").remove();
	$("#tt").datagrid("unselectRow", rowindex);
	parent.remove(userId);
}
function initselectedUser(array){
	for(var i=0;i<array.length;i++){
		var html=document.getElementById("user").innerHTML;
		html+='<labe class="col-sm-1 control-label" id="'+array[i].user_id+'">'+array[i].display_name+'';
		html+='<span name="deleteimage" style="margin-left:5px"><img  src="${root}/res/public/img/form/label_03.png" onclick="delLabel('+array[i].user_id+');" class="label-pic" ></span></label>';
		document.getElementById("user").innerHTML=html;
	}
}
function showAuxRole(value,row,index){
   if(value==undefined)
       value="";
    return showContent(value,30);
}
//查询url
function getUrl(){
   var url='${root}/permission/queryUserList.action'+getQueryCondtion();
   url=encodeURI(encodeURI(url));
   return url;
}
function getQueryCondtion()
{
   var url="?_condition.userName="+$('#userName').val();
   url+="&_condition.displayName="+$('#displayName').val();
   url+="&_condition.deptId="+$("#_deptId").val();
   url+="&_condition.deptName="+$("#deptName").val();
   url+="&_condition.roleName="+$("#roleName").val();
   return url;
}
//查询
function doQuery(){
   $('#tt').datagrid('options').url = getUrl();
   $('#tt').datagrid('load');
}
function editf(value, row, index) {
   var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';   
  
    return e ;
}  

//编辑
function editInfo(index){ 
   var rows=$('#tt').datagrid('getData').rows;
   var id = rows[index].id;
   window.parent.editUserInfo(id);    
} 

function doConfirm(){
	parent.doComfirmSelect();
}
</script>
</head>
<body>
<s:hidden name="_deptId" id="_deptId"/>
<div class="row">
   <div class="col-sm-12">
       <div class="ibox float-e-margins"> 
           <div class="ibox-content" id="searchArea">
               <form method="get" class="form-horizontal">
                   <div class="col-sm-4">
                       <div class="form-group">
                           <label class="col-sm-3 control-label">部门：</label>
                           <div class="col-sm-9">
                                <input type="text" class="form-control" id="deptName" name="deptName" />
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
                               <input type="text" class="form-control" id="roleName" name="roleName" />
                           </div>
                       </div>
                   </div>
                   <div class="col-sm-4">
                       <div class="form-group">
                           <label class="col-sm-3 control-label">启用：</label>
                           <div class="col-sm-9"> 
                               <select list="{'是':'是','否':'否'}"  class="form-control" id="userStatus"   emptyOption="true"  />
                           </div>
                       </div>
                   </div>
           </form>
           </div>
       </div>
     </div>
 </div>
 <div align="center" id="operator">
       <a class='btn btn-danger btn-sm' href='javascript:doHideOrShow();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件</a>&nbsp;&nbsp;
       <a class='btn btn-primary btn-sm' href="javascript:doQuery();"><i class='fa fa-search'></i>查询</a>
       <a class='btn btn-warning btn-sm' href="javascript:doClear();"><i class='fa fa-remove'></i>清空</a>
       <a class='btn btn-primary btn-sm' href='javascript:doConfirm()' ><i class='fa fa-check'></i>&nbsp;&nbsp;确认</a>&nbsp;&nbsp;
</div>
<div id="tt"></div>
<div class="row">
	<div class="col-sm-12">
    	<div class="ibox">
   			<div class="ibox-title">
	 			<h5>已选中用户</h5>
   				<div class="ibox-tools">
	 				<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
   				</div>
   			</div>
				<div class="col-md-12">
					<div class="form-group">
						<div class="col-sm-12" id="user" style="height:34px">
						</div>
						
					</div>
				</div>
   		</div>
    </div>
</div>
</body>
</html>