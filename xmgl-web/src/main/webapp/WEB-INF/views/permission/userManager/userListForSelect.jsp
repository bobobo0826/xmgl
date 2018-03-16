<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择用户</title>
<%@ include file="/res/public/hplus.jsp"%>
<%@ include file="/res/public/easyui_lib.jsp"%>
<%@ include file="/res/public/common.jsp"%>
<script type="text/javascript">
var _pageSize='<s:property value="_pageSize"/>';
$(document).ready(function(){
	var height=$(window).height()*0.75;
	$("#tt").datagrid({
		url:getUrl(),
		sortable:true,
		singleSelect:true,
		remoteSort:false,
		pagination:true,
		noneSelect:true,
		height:height,
		width:'auto', 
		 rownumbers:true,
		columns:[[
		    {field:"user_id",title:"系统id",hidden:true	    
			},
			{field:"user_name",title:"用户名",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			},	
			{field:"display_name",title:"中文名",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			},
			{field:"dept_name",title:"部门名称",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			},
			{field:"role_name",title:"岗位",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			},
			{field:"gender",title:"性别",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			},
			{field:"birth_date",title:"出生日期",resizable:false,width:100,headalign:"center",align:"center",sortable:true
			},
			{field:"id_card",title:"身份证号",resizable:false,width:100,headalign:"center",align:"right",sortable:true
			},
			{field:"mobile",title:"手机号",resizable:false,width:100,headalign:"center",align:"right",sortable:true
			},
			{field:"address",title:"联系地址",resizable:false,width:120,headalign:"center",align:"left",sortable:true
			},
			{field:"user_desc",title:"用户描述",resizable:false,width:100,headalign:"center",align:"left",sortable:true
			}
		]], 
		onDblClickRow:function(rowIndex, rowData)
        {
	    	selectUser(rowIndex, rowData);
	    } 
		});
	 $('#tt').datagrid('getPager').pagination({
	    	pageList:[20,40,60,80],
	    	pageSize:_pageSize,
	        afterPageText:'页  共{pages}页',
	        displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
	        onSelectPage:function(pageNumber, pageSize){
	         var pagination= $('#tt').datagrid('getData').pagination;
	         var param=new Object();
	         param.cpage = pageNumber;
	         param.len = pageSize;
	         param.keepstr =  pagination.keepstr;
	         $('#tt').datagrid('options').queryParams=param;
	         $('#tt').datagrid('options').url=getUrl();
	         $('#tt').datagrid('reload');
	         //$('#tt').datagrid('options').queryParams=null;
	        }
	    });  
}); 
$(document).keyup(function(event) {
	if (event.keyCode == 13) {
		doQuery();
	}
});
/**
 * 选择用户 回写父窗口的信息
 */
function selectUser(index,rowData){
	var userInfo =new Object();
	userInfo.id=rowData.user_id;
	userInfo.displayName=rowData.display_name;
	userInfo.role_name=rowData.role_name;
	userInfo.role_code=rowData.role_code;
	userInfo.dept_name=rowData.dept_name;
	userInfo.dept_id=rowData.dept_id;
	userInfo.gender=rowData.gender;
	userInfo.birth_date=rowData.birth_date;
	userInfo.id_card=rowData.id_card;
	userInfo.mobile=rowData.mobile;
	userInfo.address=rowData.address;
	parent.setUserInfo(userInfo);
	f_close("selectUserWindow");
}
function showOrgaContent(value,row,index) {
	return showContent(value,10);
}
//查询url
function getUrl(){
	var url='${root}/permission/getUserListForSelect.action'+getQueryCondtion()+"&_queryKind="+$("#_queryKind").val();
	url=encodeURI(encodeURI(url));
	return url;
}
function getQueryCondtion()
{
	var carrierId='<s:property value="_carrierId"/>';
    var belongsTypeId='<s:property value="_belongsTypeId"/>';
	var url="?_condition.userName="+$('#userName').val()
			+"&_condition.displayName="+$('#displayName').val()
			+"&_condition.carrierId="+carrierId
	        +"&_condition.belongsTypeId="+belongsTypeId;
	if(parent.$('#carrierName').val() != null&&$("#_userTypeFlag").val()!="czg")
	{
		url +="&_condition.carrierName="+ parent.$('#carrierName').val();
	}
	if(parent.$('#deptName').val() != null)
	{
		url +="&_condition.deptName="+ parent.$('#deptName').val();
	}
	return url;
}
//查询
function doQuery(){
	//$('#tt').datagrid('options').url = getUrl()+"&len="+$("#tt").datagrid('getPager').data("pagination").options.pageSize;
	$('#tt').datagrid('options').url = getUrl();
	$('#tt').datagrid('load');
}
 
 
function closeCurPage()
{
	f_close("selectUserWindow");
}
</script>
</head>
<body>
<%--<s:hidden name="_selectedUserIds" id="selectedUserIds"></s:hidden>
<s:hidden name="_userTypeFlag" id="_userTypeFlag"></s:hidden>
<s:hidden name="_userRoleCodes" id="_userRoleCodes"></s:hidden>
<s:hidden name="_queryKind" id="_queryKind"></s:hidden>--%>
<div class="row">
	<div class="col-sm-12">
		<div class="ibox float-e-margins"> 
			<div class="ibox-content" id="searchArea">
				<form method="get" class="form-horizontal">
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">用户名:</label>
							<div class="col-sm-8">
								 <input type="text" class="form-control"  id="userName" name="_model.userName"/>
							</div>
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">中文名称:</label>
							<div class="col-sm-8">
								  <input type="text" class="form-control"  id="displayName" name="displayName"/>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<div align="center" >
    <a class='btn btn-danger btn-sm' href='javascript:doHideOrShow();' id='hideOrShowBt'><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件</a>
	<a class="btn btn-primary btn-sm" href="javascript:doQuery();"><i class='fa fa-search'></i>&nbsp;&nbsp;查 询<b></b></a>
	<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class='fa fa-remove'></i>&nbsp;&nbsp;清 空<b></b></a>
	<a class="btn btn-danger btn-sm" href="javascript:closeCurPage();"><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭<b></b></a>
</div>
<div class="toolbardiv">
		<span class="label label-danger">提示：双击记录选择</span>
</div>
<div id="tt"></div>
</body>
</html>