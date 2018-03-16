<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<title>模块角色管理</title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
<script type="text/javascript">

$(document).ready(function(){
	var html="";
	html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
	html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
	html+="<a class='btn btn-success btn-sm' href='javascript:doAdd();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
	$("#operator").html(html);
	$("#mt").datagrid({
		url:getUrl(),
		sortable:true,
		singleSelect:true,
		remoteSort:false,
		pagination:true,
		height:'auto',
		width:'auto',
		columns:[[
		    {field:"roleCode",title:"角色编号",resizable:true,width:100,headalign:"center",sortable:true
			},
			{field:"roleName",title:"角色名称",resizable:true,width:200,headalign:"center",sortable:true,formatter:doLink
			},
			{field:"moduleName",title:"模块",resizable:true,width:590,headalign:"center",sortable:true,formatter:showDetails
			}
		]],
		onDblClickRow: function(index,row){
			editDetail(index);
		}
		});
	 $('#mt').datagrid('getPager').pagination({
			 pageList:[20,40,60],
	        afterPageText:'页  共{pages}页',
	        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
	        onSelectPage:function(pageNumber, pageSize){
	         var param=new Object();
	         param.cpage = pageNumber;
	         param.len = pageSize;
	         $('#mt').datagrid('options').queryParams=param;
	         $('#mt').datagrid('options').url=getUrl();
	         $('#mt').datagrid('reload'); 
	        }
	    });
});


$(document).keyup(function(event) {
	if (event.keyCode == 13) {
		doQuery();
	}
});

/**
 * 浮框
 */
function showDetails(value,row,index) {
	return showNewContent(value,50);
}
/**
 * 添加角色超链接
 */
function doLink(value,row,index){   
	var rows  = $('#mt').datagrid('getData').rows;
	var roleCode = rows[index].roleCode;
	var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editDetail(\''+roleCode+'\')">'+value+'</a>]';  
  	return e ;   
}  
function editDetail(roleCode){
	var url = '${root}/manage/moduleRole/tsMRIndex?roleCode='+roleCode;
	parent.addTab("模块角色管理详情",url,true);
	//window.open(url);
}

//添加
function doAdd()
{
	var url = "${root}/manage/moduleRole/tsMRIndex?roleCode=";
	parent.addTab("新增模块角色", url,"");
}
function doQuery()
{
	var url=getUrl();
	url=encodeURI(encodeURI(url));
	$('#mt').datagrid('options').url = url;
	$('#mt').datagrid('load');
}
function getUrl()
{
	var	url='${root}/manage/moduleRole/tsMRQueryList'+getQueryCondtion();
	return url;
}
function getQueryCondtion()
{
	var url="?_moduleId="+$('#moduleId').val()
			+"&_roleName="+$('#roleName').val();
	return url;
}
</script>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="ibox float-e-margins">
			<div class="ibox-content" id="searchArea" >
				<form method="post" encType="multipart/form-data" class="form-horizontal">
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色名称：</label>
							<div class="col-sm-8">
								<input class="form-control" id="roleName" name="roleName"/>
							</div>
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色编号：</label>
							<div class="col-sm-8">
								<input class="form-control" id="moduleId" name="moduleId"/>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<div align="center" id="operator"></div>
<div id="mt"></div>
</body>
</html>
