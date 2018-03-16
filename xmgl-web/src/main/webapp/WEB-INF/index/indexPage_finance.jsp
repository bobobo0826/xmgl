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
	});
	function getOrderPayRecordInfoUrl() {
		var url="${pageContext.request.contextPath}/orderPayRecordManage/queryOrderPayRecordList.action?_condition.statusCode=DQR";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setOrderPayRecordInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getOrderPayRecordInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#orderPayRecordAccount").text(result.total);
			}
		});
	}
	function tzOrderPayRecordList() {
		var url = '${pageContext.request.contextPath}/orderPayRecordManage/indexOrderPayRecordList.action?_curModuleCode=DDSFJL&_payRecordStatus=DQR';
		url=encodeURI(encodeURI(url));
		parent.addTab("订单收费记录管理", url);
	}
	
	function getOrderPaySureInfoUrl() {
		var url="${pageContext.request.contextPath}/order/getOrderList.action?_condition.curModuleCode=DDFYQRGL";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setOrderPaySureInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getOrderPaySureInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#orderPaySureAccount").text(result.total);
			}
		});
	}
	function tzOrderPaySureList() {
		var url = '${pageContext.request.contextPath}/order/initOrderPriceConfirmList.action?_curModuleCode=DDFYQRGL';
		url=encodeURI(encodeURI(url));
		parent.addTab("订单费用确认管理", url);
	}
	
	function getDispatchPaySureInfoUrl() {
		var url = "${pageContext.request.contextPath}/typCommondispatch/queryDispatchList.action?_condition._curModuleCode=CYFYQRGL";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setDispatchPaySureInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getDispatchPaySureInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#dispatchPaySureAccount").text(result.total);
			}
		});
	}
	function tzDispatchPaySureList() {
		var url = '${pageContext.request.contextPath}/typCommondispatch/indexCarrierPriceConfirmList.action?_curModuleCode=CYFYQRGL';
		url=encodeURI(encodeURI(url));
		parent.addTab("承运费用确认管理", url);
	}
	
	function getChargeBillInfoUrl() {
		var url = "${pageContext.request.contextPath}/chargeBillManage/queryChargeBillList.action?_condition._curModuleCode=BYYSKGL";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setChargeBillInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getChargeBillInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#chargeBillAccount").text(result.total);
			}
		});
	}
	function tzChargeBillList() {
		var url = '${pageContext.request.contextPath}/chargeBillManage/indexChargeBillList.action?_curModuleCode=BYYSKGL';
		url=encodeURI(encodeURI(url));
		parent.addTab("包月应收管理", url);
	}
	
</script>
</head>
<body class="gray-bg">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox-content m-b-sm border-bottom">
				<div class="p-xs">
					<div class="pull-left m-r-md">
						<i class="fa fa-truck text-navy mid-icon"></i>
					</div>
					<h2>欢迎使用 全高员工日志管理系统</h2>
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
										<div class="col-sm-6">
											<div class="vertical-timeline-content">
												<h2>我的每日计划</h2>
												<hr/>
												<div class="row">
												</div>
												<a href="javascript:void(0);" onclick="tzOrderPaySureList()" class="btn btn-sm btn-danger">查看所有</a>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="vertical-timeline-content">
												<h2>我的每周计划</h2>
												<hr/>
												<div class="row">
												</div>
												<a href="javascript:void(0);" onclick="tzDispatchPaySureList()" class="btn btn-sm btn-danger">查看所有</a>
											</div>
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon red-bg">
											<i class="fa fa-file-text"></i>
										</div>
										<div class="vertical-timeline-content">
											<h2>我的每月计划</h2>
											<hr/>
											<div class="row">
											</div>
											<a href="javascript:void(0);" onclick="tzOrderPayRecordList()" class="btn btn-sm btn-danger">查看所有</a>
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
