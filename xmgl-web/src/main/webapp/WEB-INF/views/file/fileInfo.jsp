<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<title>文件详情</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<!--hplus-->
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<%@ include file="/res/public/common.jsp"%>

	<script type="text/javascript">
		var _funcArray;
		var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {

			$scope.model = {};
			var url = '${root}/manage/file/getFileInfoById?id='+ $("#_id").val();
			$http.get(url).success(function(response) {
				$scope.model.fileBase = response.fileBase;
				controlButs($scope,$compile);
				initAttsDataGrid();
			});
			$scope.closeForm = function() {
				layer.confirm('确定关闭窗口吗?', {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
						parent.closeCurTab();
					layer.close(index);
				}, function(index){
					layer.close(index);
				});
			};
		});
        setModuleRequest(myform);

		function controlButs($scope,$compile){
			var html="";
			html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";
			var template = angular.element(html);
			var element =$compile(template)($scope);
			angular.element("#operator").empty();
			angular.element("#operator").append(element);
		}

		//对有required=required属性的表单元素，进行必填校验
		function validateForm() {
				var es = $("#myform *[required='true']");
				if (es.length > 0) {
					for (var i = 0; i < es.length; i++) {
						var e = es[i];
						if ($.trim($(e).val()) == "") {
							layer.tips('该字段必填', '#' + $(e).attr("id"));
							$("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
							return false
						}
					}
				}
			return true;
		}
		//上传下载文件
		function initAttsDataGrid(){
			$("#attstt").datagrid({
				url:getAttsUrl(),
				sortable:true,
				singleSelect:true,
				remoteSort:false,
				pagination:false,
				height:'auto',
				width:'auto',
				striped:true,
				rownumbers:true,
				columns:[[
					{field:"act",title:"操作",width:130, headalign:"center", align:"center", formatter:editfAtts},
					{field:"file_name",title:"文件名",resizable:true, width:400,headalign:"center",align:"center",sortable:true},
					{field:"file_size",title:"文件大小",resizable:true, width:100,headalign:"center",align:"center",sortable:true},
					{field:"file_type",title:"文件类型",resizable:true, width:100,headalign:"center",align:"center",sortable:true},
					{field : "file_path",title : "路径",hidden : true},
					{field : "file_id",title : "file_id",hidden : true}

				]]
			});
			$('#attstt').datagrid('getPager').pagination({
				pageList:[20,30,40,100,200],
				pageSize:20,
				afterPageText:'页  共{pages}页',
				displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
				onSelectPage:function(pageNumber, pageSize) {
					var param = new Object();
					param.cpage = pageNumber;
					param.len = pageSize;
					$('#tt').datagrid('options').queryParams=param;
					$('#tt').datagrid('options').url=getAttsUrl();
					$('#tt').datagrid('reload');
					$('#tt').datagrid('options').queryParams=null;
				}
			});
		}
		function getAttsUrl()
		{
			if($('#_id').val() == null || typeof $('#_id').val() == "undefined")
			{
				return url = "";
			}else{
				var url ='${root}/manage/file/queryFileList?id='+2;
				return url;
			}
		}
		function editfAtts(value, row, index)
		{
			var m = '[<a href="###" style="text-decoration:none;color:red;" onclick="downLoadAtt('+index+')">下载</a>]&nbsp&nbsp';
			m += '[<a href="###" style="text-decoration:none;color:red;" onclick="deleteAtt('+index+')">刪除</a>]&nbsp&nbsp';
			return m;
		}
		//下载文档
		function downLoadAtt (index)
		{
            //showFilePdf();

			var rows=$('#attstt').datagrid('getData').rows;
			var fileId = rows[index].file_id;
			var filePath = rows[index].file_path;
			var fileName = rows[index].file_name;
			console.log(fileId);
			console.log(filePath);
			console.log(fileName);
			var url = "${root}/manage/file/downloadFile?fileId="+fileId+"&filePath="+filePath+"&fileName="+fileName;
           // var url = "${root}/manage/file/downloadFile";
			window.location.href=encodeURI(encodeURI(url));
		}
		//删除附件
		function deleteAtt(index) {
			var rows=$('#attstt').datagrid('getData').rows;
			var id = rows[index].id;
			var url="${root}/manage/file/delFileInfoById?_id="+id;
			layer.confirm(_DELETE_ONE_MSG, {
				btn : [ '确定', '取消' ], //按钮
				shade : false
				//不显示遮罩
			}, function(index) {
				$.ajax({
					url : encodeURI(encodeURI(url)),
					type : 'post',
					cache : false,
					async : false,
					success : function(result) {
						if (result.msgCode=1) {
							$('#attstt').datagrid('load');
						}
						layer.close(index);
						layer.msg(result.msgDesc);
					}
				});
			}, function(index) {
				layer.close(index);
			});
		}
		function callbackPretrialfile(){
			var url = "${root}/manage/file/uploadInfo?id="+$("#_id").val()+"&_module="+"file";
			var width = '50%';
			var height ='70%';
			f_open("newWindow", "上传文件", width, height, url, true);
		}
        function showFilePdf() {
            var width = '60%';
            var height = '80%';
            var url = "${root}/manage/file/initFileShow?filePath=/upload" + "&fileId=1.pdf" ;
            f_open("newWindow", "文件预览", width, height, url, true);
        }
	</script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="_id" value="${id}">
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate enctype="multipart/form-data">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >文件名称：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.fileName" type="text" class="form-control"
									   id="fileName" name="fileName"  required='true'  />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">文件编号：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.fileId" type="text" class="form-control"
									   id="fileId" name="fileId"  required='true'/>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">文件路径：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.filePath" type="text" class="form-control"
									   id="filePath" name="filePath"   />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">文件大小：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.fileSize" type="text" class="form-control"
									   id="fileSize" name="fileSize"   />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">文件类型：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.fileType" type="text" class="form-control"
									   id="fileType" name="fileType"   />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">业务名称：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.businessName" type="text" class="form-control"
									   id="businessName" name="businessName"  required='true'  />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">业务编号：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.businessId" type="text" class="form-control"
									   id="businessId" name="businessId"   />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">业务类型码：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.businessTypeCode" type="text" class="form-control"
									   id="businessTypeCode" name="businessTypeCode"   />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >创建人：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.creator" type="text" class="form-control"
									   id="creator" name="creator"  required='true'  />
							</div>
							<div class="col-sm-2">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >创建人编号：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.creatorId" type="text" class="form-control"
									   id="creatorId" name="creatorId"  />
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<label class="col-sm-4 control-label" >创建日期：</label>
							<div class="col-sm-6">
								<input ng-model="model.fileBase.createDate" type="text" class="form-control"
									   id="createDate" name="createDate"  />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row"  >
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-title">
					<h5>文件上传</h5>
					<div class="ibox-tools">
						<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
					</div>
				</div>
				<div class="ibox-content">
					<div class="col-sm-12">
						<div class="toolbardiv" id="addInfo">
							<a class="btn btn-success btn-sm"  href="javascript:callbackPretrialfile();"><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>
						</div>
						<div id="attstt"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg" id="operator">

	</div>
</div>
</body>
</html>
