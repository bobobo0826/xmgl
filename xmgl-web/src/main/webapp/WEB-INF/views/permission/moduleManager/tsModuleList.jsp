<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>模块管理</title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<script type="text/javascript">
		$(window).resize(function(){ $("#tt").datagrid("resize"); });
		var _pageSize='<%=request.getParameter("_pageSize")%>';
		$(document).ready(function(){
			var height=$(window).height()-55; //浏览器当前窗口可视区域高度
			var html="";
			html+="<a class='btn btn-primary btn-sm' href='javascript:doQuery();'><i class='fa fa-search'></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;";
			html+="<a class='btn btn-warning btn-sm' href='javascript:doClear();'><i class='fa fa-refresh'></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;";
			html+="<a class='btn btn-success btn-sm' href='javascript:doAdd();'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;";
			$("#operator").html(html);
			$("#tt").datagrid({
				url:getUrl(),
				sortable:true,
				singleSelect:true,
				remoteSort:false,
				pagination:true,
				height:height,
				width:'auto',
				striped:true,
				rownumbers:true,
				columns:[[
					{field:"action",title:"操作", resizable:true,width:90,align:"center",formatter:editf},
					{field:"moduleid",title:"模块编号",resizable:true,width:90,headalign:"center",sortable:true
					},
					{field:"modulename",title:"模块名",resizable:true,width:100,headalign:"center",sortable:true
					},
					{field:"moduledesc",title:"描   述",resizable:true,width:120,headalign:"center",sortable:true
					},
					{field:"oprset",title:"操作集",resizable:true,width:90,headalign:"center",sortable:true
					},
					{field:"callmethod",title:"调用",resizable:true,width:260,headalign:"center",sortable:true
					},
					{field:"modulecallargs",title:"调用参数",resizable:true,width:200,headalign:"center",sortable:true
					}
				]],
				onDblClickRow: function (rowIndex, rowData) {
					editInfo(rowIndex);
				}
			});
			$('#tt').datagrid('getPager').pagination({
				pageList:[20,30,40,100,200],
				pageSize:_pageSize,
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
		function getUrl(){
			var url="${root}/manage/module/tsQueryModuleList"+getQueryCondtion();
			console.log("url="+url);
			url=encodeURI(encodeURI(url));
			return url;
		}
		function getQueryCondtion()
		{

			var url="?moduleName="+$("#moduleName").val()
					+"&moduleId="+$("#moduleId").val();
			return url;
		}
		function doQuery(){
			$('#tt').datagrid('options').url=getUrl();
			$('#tt').datagrid('load');
		}

		function editf(value,row,index){
			var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="editInfo('+index+')">详情</a>]';
			var b = '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteInfo('+index+')">删除</a>]';
			return e+" "+b;
		}
		function editInfo(index){
			var rows=$('#tt').datagrid('getData').rows;
			var moduleId = rows[index].moduleid;
			var url="${root}/manage/module/tsUpdModule?moduleId="+moduleId;
			console.log(parent)
			parent.addTab("编辑模块信息", url);
		}
		function deleteInfo(index){
			var rows=$('#tt').datagrid('getData').rows;
			var moduleid = rows[index].moduleid;
			var url = "${root}/manage/module/delTsModuleInfo?moduleid="+moduleid;
			layer.confirm(_DELETE_ONE_MSG, {
				btn: ['确定','取消'], //按钮
				shade: false //不显示遮罩
			}, function(index){
				$.ajax({
					url: url,
					type : 'post',
					success: function(response) {

						if(response.msgCode==1) {
							$('#tt').datagrid('reload');
						}
						layer.msg(response.msgDesc);
					},
					error:function(result) {
						layer.msg("系统异常，请联系系统管理员");
					}
				});
			}, function(index){
				layer.close(index);
			});
		}
		function doAdd(){
			var url="${root}/manage/module/tsUpdModule";
			parent.addTab("模块信息", url);
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
							<label class="col-sm-4 control-label">模块名称：</label>
							<div class="col-sm-8">
								<input class="form-control" id="moduleName" name="moduleName"/>
							</div>
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块编号：</label>
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
<div id="tt"></div>
</body>
</html>