<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>首页</title>
<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>

<script>
	$(document).ready(function() {
		//入库
		setStoreInInfo();
		//出库
		setStoreOutInfo();
		//异常
		setExceptionInfo();
	});
	function getExceptionInfoUrl() {
		var url="${pageContext.request.contextPath}/exceptionManage/queryExceptionBaseList.action?_condition.exception_status=WJJ&_condition.curModuleCode=YCGL&_condition.exceptionCode=CRK";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setExceptionInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getExceptionInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#wjjExceptionAccount").text(result.total);
			}
		});
	}
	function tzExceptionList() {
		var url = '${pageContext.request.contextPath}/exceptionManage/indexExceptionBaseList.action?_curModuleCode=YCGL&_exceptionStatusCode=WJJ';
		url=encodeURI(encodeURI(url));
		parent.addTab("出入库异常管理", url);
	}
	
	function getStoreInInfoUrl() {
		var url="${pageContext.request.contextPath}/storeInBaseManage/queryStoreInBaseList.action?_condition.curModuleCode=HPRKGL&_condition.storeInStatusCode=DRK";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setStoreInInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getStoreInInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#storeInTotal").text(result.total);
			}
		});
	}
	function tzStoreInList() {
		var url = '${pageContext.request.contextPath}/storeInBaseManage/indexStoreInBaseList.action?_curModuleCode=HPRKGL&_storeInStatusCode=DRK';
		url=encodeURI(encodeURI(url));
		parent.addTab("货品入库管理", url);
	}
	
	
	function getStoreOutInfoUrl() {
		var url="${pageContext.request.contextPath}/storeOutBaseManage/queryStoreOutBaseList.action?_condition.curModuleCode=HPCKGL&_condition.storeOutStatusCode=DCK";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setStoreOutInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getStoreInInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#storeOutTotal").text(result.total);
			}
		});
	}
	function tzStoreOutList() {
		var url = '${pageContext.request.contextPath}/storeOutBaseManage/indexStoreOutBaseList.action?_curModuleCode=HPCKGL&_storeOutStatusCode=DCK';
		url=encodeURI(encodeURI(url));
		parent.addTab("货品出库管理", url);
	}
</script>
</head>
<body class="gray-bg">
<body class="gray-bg">
	<div class="row">
		<div class="col-sm-12">

			<div class="ibox-content m-b-sm border-bottom">
				<div class="p-xs">
					<div class="pull-left m-r-md">
						<i class="fa fa-truck text-navy mid-icon"></i>
					</div>
					<h2>欢迎使用 TMS-运输管理系统</h2>
					<span>你可以方便的进行工作管理。</span>
				</div>
			</div>
		</div>
		<div class="col-sm-12">
			<div class="wrapper wrapper-content">
				<div class="row animated fadeInRight">
					<div class="col-sm-12">
						<div class="ibox float-e-margins">
							<div class="" id="ibox-content">
								<div id="vertical-timeline"
									class="vertical-container light-timeline">
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon red-bg">
											<i class="fa fa-file-text"></i>
										</div>

										<div class="vertical-timeline-content">
											<h2>待入库数量</h2>
											<hr/>
											<div class="row">
												<div class="col-sm-5">
													<h4 >总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="storeInTotal"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onClick="tzStoreInList()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon red-bg">
											<i class="fa fa-file-text"></i>
										</div>
										<div class="vertical-timeline-content">
											<h2>待出库数量</h2>
											<hr/>
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="storeOutTotal" ></h4>
												</div>
											</div>  
											<a href="javascript:void(0);" onClick="tzStoreOutList()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon red-bg">
											<i class="fa fa-file-text"></i>
										</div>

										<div class="vertical-timeline-content">
											<h2>待处理异常</h2>
											<hr/>
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="wjjExceptionAccount"></h4>
												</div>
											</div>    
											<a href="javascript:void(0);" onclick="tzExceptionList()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
									</div>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</body>

</html>
