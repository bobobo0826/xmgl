<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/res/public/hplus.jsp"%>
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/common.jsp"%>
<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script> <!-- 工具 -->
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<script type="text/javascript" src="${root}/thirdparty/My97DatePicker/WdatePicker.js" charset="UTF-8"></script> <!-- 日期 -->
<script type="text/javascript" src="${root}/res/public/js/constant.js" charset="UTF-8"></script>
<script type="text/javascript">
$(window).resize(function(){ $("#tt").datagrid("resize"); });
$(document).ready(function(){
	var html="";
	html+="<a class='btn_01' href='javascript:doHideOrShow();' id='hideOrShowBt'>隐藏条件</a>&nbsp;&nbsp;";
	html+="<a class='btn_01' href='javascript:doQuery();'>查询</a>&nbsp;&nbsp;";
	html+="<a class='btn_01' href='javascript:doClear();'>清空</a>&nbsp;&nbsp;";
	html+="<a class='btn_01' href='javascript:doAdd();' id='doAdd'>新增</a>&nbsp;&nbsp;";
	$("#operator").html(html);
	$("#tt").datagrid({
		url:getUrl(),
		sortable:true,
		singleSelect:true,
		pagination:true,
		height:'auto',
		width:'auto',
		striped:true,
	    rownumbers:true,
	    remotesort:true,
		columns:[[
			{field:"act",title:"操作", resizable:true,width:120,headalign:"center",align:"center",formatter:editf},
			{field:"id",hidden:true},
			{field:"dept_name",title:"部门", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
			{field:"data_name",title:"岗位", resizable:true,width:100,headalign:"center",align:"center",sortable:true},
			{field:"position_level",title:"岗位等级", resizable:true,width:150,headalign:"center",align:"center",sortable:true},
			{field:"is_used",title:"是否启用", resizable:true,width:100,headalign:"center",align:"center",sortable:true}
		]],
	 		onDblClickRow: function (rowIndex, rowData) { 
        	 	editInfo(rowIndex);
     }
	});
	if($('#_deptId').val() < 0)
	{
		$('#doAdd').hide();	
	}
	$('#tt').datagrid('getPager').pagination({
		 	pageList:[20,30],
	        afterPageText:'页  共{pages}页',
	        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录', 
	        onSelectPage:function(pageNumber, pageSize) {
	         	var param = new Object();
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

function getUrl() {
	var url="${root}/dataConfig/queryList.action?_deptId="+$('#_deptId').val()+getQueryCondition();
	url=encodeURI(encodeURI(url));
	return url;
}

function getQueryCondition() {
	var url="&_condition.position="+$('#position').val()
			+"&_condition.positionLevel="+$('#positionLevel').val()
			+"&_condition.isUsed="+$('#isUsed').val();
	return url;
}

function doQuery() {
	$('#tt').datagrid('options').url=getUrl();
	$('#tt').datagrid('load');
}

function editf(value,row,index) {
	var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
	var d = '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
	return e +" "+ d;
}

function editInfo(index) {
	var rows=$('#tt').datagrid('getData').rows;
	var id = rows[index].id;
	window.parent.editInfo(id);
}

function deleteInfo(index){
	var rows=$('#tt').datagrid('getData').rows;
	var id = rows[index].id; 
	var url = "${root}/dataConfig/deleteInfo.action?_id="+id;
	$.messager.confirm('提示',_DELETE_ONE_MSG,function(f) {
 		if (f) {
			$.ajax({ 
				url: url,
				type : 'post',
				success: function(result) {  
					if(result.success) {
						$('#tt').datagrid('load');
					}
				},
				error:function(r) {
					alert("系统异常，请联系系统管理员");
				}
			 });
 		}
 	});
}

function doAdd()
{
	var _deptId = $('#_deptId').val();
	window.parent.addInfo(_deptId);	
}
function doClear() {
	$("select").val('');
	$(":text").val('');
	$(".combo-value").val('');
	/*$('.combo-text validatebox-text').val('');*/
}
</script>
</head>
<body>
<s:hidden name="_deptId" id="_deptId"/>
<form>
<div class="box_01">
	<div class="inner6px">
		<div id="searchArea" class="cell" style="display:block;width:100%">
			<table>
				<tr>
					<th width="14%">岗位:</th>
					<td width="19%">
						<input  class="form_list"  id="position" name="position" />
					</td>
					<th width="14%">岗位等级:</th>
					<td width="19%">
						<input  class="form_list" id="positionLevel" name="positionLevel" />
					</td>
					<th width="14%">是否启用:</th>
					<td width="19%">
						<%--<s:select list="#{'1':'是','0':'否'}"  ng-model="model._positionDept.isUsed" id="isUsed" name="isUsed" emptyOption="true"  class="form_list" />--%>
					</td>
				</tr>
			</table>
		</div>
		<div class="cell" id="operator" style="text-align:center;height:30px;line-height:30px;">
		</div>
	</div>
	<div class="inner6px">
		<table id="tt"></table>
	</div>
</div>
</form>
</body>
</html>