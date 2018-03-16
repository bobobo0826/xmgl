<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<title>返回值管理</title>
<%@include file="/res/public/easyui_lib.jsp" %>
<jsp:include page="/res/public/float_div.jsp"></jsp:include>
<link href="${root}/res/ui/css/style.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
<script type="text/javascript">
var toolBar=[{
	text:"新增",
	iconCls:'icon-add',
	handler:addInfo
}];

/*****初始化列表*******/
$(document).ready(function(){
	$("#tt").datagrid({
		url:'${root}/permission/tcMapRetValueList.action',
		sortable:true,
		singleSelect:true,
		remoteSort:false,
		pagination:true,
		height:'auto',
		width:'auto',
		columns:[[
		    {field:"retValueId",title:"返回值ID",resizable:true,width:150,headalign:"center",sortable:true
			},
			{field:"retValue",title:"返回值",resizable:true,width:200,headalign:"center",sortable:true
			},
			
			{field:"retValueDesc",title:"描述",resizable:true,width:300,headalign:"center",sortable:true	    
			},
			{field:"action",title:"操   作", resizable:true,width:150,align:"center",formatter:editf}
		]],
		toolbar:toolBar,
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
	       //  param.keepstr =  pagination.keepstr;
	         $('#tt').datagrid('options').queryParams=param;
	         $('#tt').datagrid('options').url="${root}/permission/tcMapRetValueList.action";
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


//动态加载操作栏下面的按钮
function editf(value,row,index){   
	var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">修改</a>]';  
	var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delStatus('+index+')">删除</a>]';  
	var total=e+" "+c;
	return total ;   
}

function editInfo(index){
	var rows=$('#tt').datagrid('getData').rows;
	var retValueId = rows[index].retValueId;
	var width = $(document).width() * 0.4;
	var height = $(document).height() * 0.4;
	url = "${root}/permission/tcMapRetValueInfo.action?id="+retValueId;
	f_open("editInfo", "返回值管理", width, height, url, true);
}

function addInfo(){
	   var width = $(document).width() * 0.4;
	   var height = $(document).height() * 0.4;
	   url = "${root}/permission/tcMapRetValueInfo.action?";
	  f_open("editInfo", "返回值管理", width, height, url, true);
}
function delStatus(index)
{
	var rows=$('#tt').datagrid('getData').rows;
	var retValueId = rows[index].retValueId;
  
   $.messager.confirm('提示','您确认要删除该条数据吗？', function(f) {
  	 	if (f) {
  	 	    url="${root}/permission/tcMapRetValuedel.action?id="+retValueId;
  			$.ajax({
  			 	type : 'post',
  			 	cache : false,
  				url : url,
  				success : function(result) {
  					if(result.flag!=null && result.flag==true) {
  				    	$('#tt').datagrid('load');
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
	<table id="tt" class="easyui-datagrid"></table>
</div>
</div>
</body>
</html>

 