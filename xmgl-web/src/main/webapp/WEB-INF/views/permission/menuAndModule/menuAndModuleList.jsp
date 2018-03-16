<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<title>菜单模块管理</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<jsp:include page="/res/public/float_div.jsp"></jsp:include> 
<%@ include file="/res/public/msg.jsp"%>
<link href="${pageContext.request.contextPath}/res/ui/css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/common.js"  charset="UTF-8"></script>
<script type="text/javascript">

$(document).ready(function(){
	$("#mt").datagrid({
		url:'${pageContext.request.contextPath}/permission/menuModuleQueryList.action',
		sortable:true,
		singleSelect:true,
		remoteSort:false,
		pagination:true,
		height:'auto',
		width:'auto',
		columns:[[
			{field:"subSysId",hidden:true	
			},
			{field:"subSysName",title:"子系统菜单",resizable:true,width:800,headalign:"center",sortable:true
			},
			{field:"action",title:"操   作", resizable:true,width:110,align:"center",formatter:editf}
		]],
		onDblClickRow: function(index,row){
			editInfo(index);
		}
		});
	 $('#mt').datagrid('getPager').pagination({
			 pageList:[20,40,60],
	        afterPageText:'页  共{pages}页',
	        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
	        onSelectPage:function(pageNumber, pageSize){
	         var pagination= $('#mt').datagrid('getData').pagination;
	         var param=new Object();
	         param.cpage = pageNumber;
	         param.len = pageSize;
	       //  param.keepstr =  pagination.keepstr;
	         $('#mt').datagrid('options').queryParams=param;
	         $('#mt').datagrid('options').url="${pageContext.request.contextPath}/permission/menuModuleQueryList";
	         $('#mt').datagrid('reload');
	         $('#mt').datagrid('options').queryParams=null;
	        }
	    });
});

/**
 * 浮框
 */
function showDetails(value,row,index) {
	return showContent(value,50);
}


//动态加载操作栏下面的按钮
function editf(value,row,index){   
	var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">修改</a>]';  
	var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delSubSys('+index+')">删除</a>]';
	
	var total=e+"  "+c;
  return total ;   
}  

function editInfo(index){
	var rows=$('#mt').datagrid('getData').rows;
	var sysId = rows[index].subSysId;
	var sysName = rows[index].subSysName;
	url="${pageContext.request.contextPath}/permission/menuTreeIndex.action?_sysId="+sysId;
   parent.addTab("编辑菜单模块",url,"");
}

/**
 * 删除子系统
 */
function delSubSys(index)
{
   var rows=$('#mt').datagrid('getData').rows;
   var sysId = rows[index].subSysId;
  
   $.messager.confirm('提示','您确认要删除该条数据吗？', function(f) {
 	 	if (f) {
 	 	    url="${pageContext.request.contextPath}/permission/delMenuModule.action?id="+sysId;
 			$.ajax({
 			 	type : 'post',
 			 	cache : false,
 				url : url,
 				success : function(result) {
 					if(result.flag!=null && result.flag==true) {
 				    	$('#mt').datagrid('load');
 				    	$.messager.show({
 							title:'提示',
 							msg:'删除成功',
 							timeout:2000,
 							showType:'slide'
 						});
 				    	return;
 					} 
 					else {
 						$.messager.alert("提示", "删除失败");
 						return;
 					}
 				},
 			 	error : function() {
 					
 					return;
 				}
 		   }); 
 	 	}
 	});
}
</script>
</head>
<body>
<div class="box_01" style="margin-bottom:20px ">
<div class="inner6px">
	<table id="mt" class="easyui-datagrid"></table>
</div>
</div>
</body>
</html>

 