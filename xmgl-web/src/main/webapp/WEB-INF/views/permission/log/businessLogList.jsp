<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务日志查询</title>
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<%@ include file="/res/public/easyui_lib.jsp" %>
<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/faxibox/style/jquery-foxibox-0.2.css" />
<script type="text/javascript" src="${root}/thirdparty/My97DatePicker/WdatePicker.js"  charset="UTF-8"></script>
<script type="text/javascript" src="${root}/res/public/js/faxibox/script/jquery-foxibox-0.2.js"  charset="UTF-8"></script>
<script type="text/javascript"> 
$(window).resize(function(){
	$("#tt").datagrid("resize");
});
$(document).ready(function(){
	$("#tt").datagrid({
		url : getQueryUrl(),
		sortable : true,
		remoteSort : false,
		singleSelect : true,
		pagination : true,
		noneSelect : true,
		striped : true,
		rownumbers : true,
		width : "auto",
		height : "auto", 
		columns : [[
		    		 {field:"ID",title:"ID",hidden:true},
					{field:"FORMTYPEDESC",title:"模块名称",resizable:true,width:200,headalign:"center",align:"left",sortable:true},
					{field:"ACTIONTYPE",title:"操作类别",resizable:true,width:100,headalign:"center",align:"left",sortable:true},
					{field:"OPERATERDESCRIP",title:"操作描述",resizable:true,width:300,headalign:"center",align:"left",sortable:true},
					{field:"DATAPERMISSION",title:"操作人",resizable:true,width:150,headalign:"center",align:"left",sortable:true},
					{field:"OPERATETIME",title:"操作时间",resizable:true,width:150,headalign:"center",align:"left",sortable:true},
					{field:"action",title:"操作",resizable:true,width:100,headalign:"center",align:"left",sortable:true,formatter:editf}
					]]
	});
	$('#tt').datagrid('getPager').pagination({
		pageList:[20,30,40],
        afterPageText:'页  共{pages}页',
        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
        onSelectPage:function(pageNumber, pageSize){
	        var pagination=$('#tt').datagrid('getData').pagination;
	        var param=new Object();
	        param.cpage=pageNumber;
	        param.len=pageSize;
	        param.keepstr=pagination.keepstr;
	        $('#tt').datagrid('options').queryParams=param;
	        $('#tt').datagrid('options').url=getQueryUrl();
	        $('#tt').datagrid('reload');
	        $('#tt').datagrid('options').queryParams=null;
	  	}
	});
	document.onkeydown = keydown;
	function keydown() {
		if(window.event.keyCode == 13) {
			doQuery();
		}
	}
});

function getQueryUrl()
{
	
	var url = "${root}/log/queryBusinessLogList.action?_formType="+$("#_formType").val()+"&_operator="+$("#_operator").val()+"&_beginDate="+$("#_beginDate").val()+"&_endDate="+$("#_endDate").val();
	url = encodeURI(encodeURI(url));
	return url;
}
function editf(value,row,index)
{   
	 var e;
	 if(row.ACTIONTYPE=="修改")
	 	e = '<a href="javascript:;" style="text-decoration:none;" onclick="seeChange('+index+')">[查看]</a>';   
	 else
		 e="";	
     return e ;   
}  
//查看
function seeChange(index){
	var rows=$('#tt').datagrid('getData').rows;
	var id = rows[index].ID;
	url = "${root}/log/showBusinessLog.action?_id="+parseInt(id);
	parent.addTab("业务日志字段比较",url,"");
} 
//删除
function deleteByDate() {
	var beginDate=$("#_beginDate").val();
	var endDate=$("#_endDate").val();
	if(isEmpty(beginDate)&&isEmpty(endDate))
	{
		alert("请先选择删除的日期!");
		return;
	}
	if(confirm("确认删除?")){
		var url = "${root}/log/delBusinessLogByDate.action?_beginDate="+beginDate+"&_endDate="+endDate;
		$.ajax({
			type:"post",
			url:url,
			cache : false,
	 		async:false,
			success: function(msg){
				if(msg!=null && msg.success==true){
					alert("删除成功！");
					doQuery();
				}else{
					alert("删除失败！");
				}			
			},
			error : function(msg) {
				alert('系统调用失败，联系管理员');
				return;
			}
		});
	}
} 
//查询
function doQuery() {
	$('#tt').datagrid('options').url = getQueryUrl();
  	$('#tt').datagrid('load');
}
</script>
</head>

<body>
<div class="box_01">
<div class="inner6px">
<div class="cell">
<table id="queryTable">
 	<tr>		 
		<th class="label">操作模块:</th><td>
		<select  list="_formList" listKey="ID" listValue="TEXT" id="_formType" name="_formType" cssStyle="width:150px;"/>
		</td>
		<th class="label">操作人:</th>
		<td><input class="form_text" name="_operator" id="_operator" style="width:150px;" /></td>
	</tr>
	<tr>	
		<th width="10%">操作开始日期：</th>
		<td  width="20%">
		<input class="form_text form_date" name="_beginDate" id="_beginDate" style="width:150px;" onclick="var endDate=$dp.$('_endDate');WdatePicker({onpicked:function(){endDate.focus();},maxDate:'#F{$dp.$D(\'_endDate\')}'})"  readonly>
		</td>
		<th width="10%">操作结束日期：</th>
		<td width="20%">
		<input class="form_text form_date" name="_endDate" id="_endDate" style="width:150px;" onclick="WdatePicker({minDate:'#F{$dp.$D(\'_beginDate\')}'})"  readonly>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
		<a href="javascript:doQuery();" class="btn_01" >查 询<b></b></a> 
		<a href="javascript:deleteByDate();" class="btn_01" >按时间删除<b></b></a>
		<a href="javascript:doClear();" class="btn_01" >清空<b></b></a>
		</td>
	</tr>
</table>
</div><!-- end cell -->
</div><!-- end inner6px -->
</div><!-- end box_01 -->

<div class="box_01">
<div class="inner6px">
	<div>
	<table id="tt"></table>
	</div>	
</div><!-- end inner6px -->
</div><!-- end box_01 -->
</body>
</html>