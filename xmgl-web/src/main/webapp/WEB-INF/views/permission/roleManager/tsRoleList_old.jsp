<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title> 
<%@include file="/res/public/easyui_lib.jsp" %>
<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<script type="text/javascript" src="/pnly/res/public/js/verification.js" charset="UTF-8"></script>
<script type="text/javascript">
/*****初始化列表*******/
$(window).resize(function(){ $("#tt").datagrid("resize"); });
var _pageSize = '<s:property value="_pageSize" />';

$(document).ready(function(){
	$("#tt").datagrid({
		url:'${root}/permission/tsQueryRoleList.action',
		sortable:true,
		singleSelect:true,
		remoteSort:false,
		pagination:true,
		height:'auto',
		width:'auto',
		columns:[[
		    {field:"roleID",title:"角色编号",resizable:true,width:100,headalign:"center",sortable:true 
			},
			{field:"roleName",title:"角色名",resizable:true,width:300,headalign:"center",sortable:true
			},
			{field:"roleDesc",title:"描   述",resizable:true,width:300,headalign:"center",sortable:true	    
			},
			
			{field:"action",title:"操   作", resizable:true,width:110,align:"center",formatter:editf}
		]]	,
		onDblClickRow: function(index,row){
			editInfo(index);
		}
		});
	 $('#tt').datagrid('getPager').pagination({
	    	pageList:[20,40,60],
	        afterPageText:'页  共{pages}页',
	        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
	        onSelectPage:function(pageNumber, pageSize){
	         var pagination= $('#tt').datagrid('getData').pagination;
	         var param=new Object();
	         param.cpage = pageNumber;
	         param.len = pageSize;
	         $('#tt').datagrid('options').queryParams=param;
	         $('#tt').datagrid('options').url="${root}/permission/tsQueryRoleList.action";
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
function doQuery()
{
	var url=getUrl();
	url=encodeURI(encodeURI(url));
	$('#tt').datagrid('options').url = url;
	$('#tt').datagrid('load');
}
function getUrl()
{
	var	url='${root}/permission/tsQueryRoleList.action'+getQueryCondtion();
	return url;
}
function getQueryCondtion()
{
	var url="?roleId="+$('#roleId').val()
			+"&roleName="+$('#roleName').val();
	return url;
}

//动态加载操作栏下面的按钮
function editf(value,row,index){   
	var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">修改</a>]';  
	var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delRole('+index+')">删除</a>]';
	
	var total=e+"  "+c;
  return total ;   
}  
//弹出窗口选择添加
function addInfo()
{
	var width = $(document).width() * 0.4;
	var height = $(document).height() *  0.4;
	url="${root}/permission/tsRoleInfo.action";
	f_open("editRoleInfo", "角色管理", width, height, url, true);
}
function editInfo(index){
	var width = $(document).width() *  0.4;
	var height = $(document).height() *  0.4;
	var rows=$('#tt').datagrid('getData').rows;
	var roleId = rows[index].roleID;
	var url = "${root}/permission/tsUpdRole.action?module.roleID="+roleId;
	f_open("editRoleInfo", "角色管理", width, height, url, true);
}

//删除
function delRole(index)
{	 
	var rows=$('#tt').datagrid('getData').rows;
	var roleId = rows[index].roleID;
	url = "${root}/permission/tsDelRole.action?module.roleID="+roleId;
	$.messager.confirm('提示','确定删除',function(f) {
 		if (f) {
			$.ajax({ 
				url: url,
				type : 'post',
				cache : false,
				async : false,
				success:function(result) {  
					if(null !=result.flag && result.flag==false)
					{
						$.messager.show({
							title:'提示',
							msg:'删除失败',
							timeout:2000,
							showType:'slide'
						});
					}
					else
					{
						$.messager.show({
							title:'提示',
							msg:'删除成功',
							timeout:2000,
							showType:'slide'
						});
						$('#tt').datagrid('load');
					}
				}
			 });
 		}
 	});
} 
</script>

</head>
<body >
<div class="box_01">
<div class="inner6px">
<div class="cell">
<table>
	<tr>
     	<th width="14%">角色编号</th>
        <td width="19%">
        	<input class="form_text" style="width:180px;heigth:20px" maxLength="50"  name="roleId" id="roleId" />
        </td>
        <th width="14%">角色名</th>
       	<td width="19%" >
       		<input class="form_text" style="width:180px;heigth:20px"  maxLength="50" name="roleName" id="roleName" />
        </td>    
        
     </tr>
     <tr>
		<td colspan="6" align="center">
		<a class="btn_01" href="javascript:doQuery();"  >查 询<b></b></a>
		<a class="btn_01" href="###" onclick="javascript:addInfo();"  >新  增<b></b></a>
		<a class="btn_01" href="javascript:doClear();"  >清 空<b></b></a>
	
		</td>
	</tr>
</table>
 </div>
</div>
</div>

<form name="myform" method="post">

<div class="box_01" style="margin-bottom:20px ">
<div class="inner6px">
	<table id="tt"  ></table>
</div>
</div>

</form>

</body>
</html>