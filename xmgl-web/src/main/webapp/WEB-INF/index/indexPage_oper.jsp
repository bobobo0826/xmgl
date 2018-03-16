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
		CheckDiapatchInfoTH();
		CheckDiapatchInfoYS();
		CheckDiapatchInfoPS();
		//CheckDiapatchInfoWT();
		setDispatchInfoTH();
		setDispatchInfoYS();
		setDispatchInfoPS();
		//setDispatchInfoWT();
		setOrderInfo();
	});
	function getOrderInfoUrl() {
		var url="${pageContext.request.contextPath}/order/getOrderList.action?_condition.curModuleCode=DDGL&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	function setOrderInfo(){
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getOrderInfoUrl(),
	        async : true,
	        success : function(result) {
	        	$("#orderTotal").text(result.total);
	        	var SXAccount=0;
	    		var ZTAccount=0;
	    		var YQSAccount=0;
	        	for(i=0;i<result.total; i++){
					if (result.rows[i].order_status_code == "YQR") {
						SXAccount += 1;
					}
					if (result.rows[i].order_status_code == "ZT") {
						ZTAccount += 1;

					}
					if (result.rows[i].order_status_code == "YQS") {
						YQSAccount += 1;
					}
				}
				$("#SXAccount").text(SXAccount);
				$("#ZTAccount").text(ZTAccount);
				$("#YQSAccount").text(YQSAccount);
			}
		});
	}
	function tzOrderList(orderStatus) {
		var url = '${pageContext.request.contextPath}/order/initOrderList.action?_curModuleCode=DDGL'+"&_orderStatusFromIndex="+orderStatus;
		url=encodeURI(encodeURI(url));
		parent.addTab("订单管理", url);
	}
	
	//提货待调度
	function getCheckDiapatchInfoUrlTH() {
		var url = "${pageContext.request.contextPath}/dispatchPickUp/queryCheckDispatchPickUp.action?_condition._curModuleCode=DTHXX&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	function CheckDiapatchInfoTH() {
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getCheckDiapatchInfoUrlTH(),
	        async : true,
	        success : function(result) {
	        	$("#dddTotalTH").text(result.total);
	        }
	       }); 
	}
	function tzCheckDiapatchListTH(){
		var url='${pageContext.request.contextPath}/dispatchPickUp/indexCheckDispatchPickUpList.action?_curModuleCode=DTHXX';
		url=encodeURI(encodeURI(url));
		parent.addTab("提货待调度信息", url);
	}
	//运输待调度
	
	function getCheckDiapatchInfoUrlYS() {
		var url = "${pageContext.request.contextPath}/dispatchTransport/queryCheckDispatchTransport.action?_condition._curModuleCode=DYSXX&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	function CheckDiapatchInfoYS() {
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getCheckDiapatchInfoUrlYS(),
	        async : true,
	        success : function(result) {
	        	$("#dddTotalYS").text(result.total);
	        }
	       }); 
	}
	function tzCheckDiapatchListYS(){
		var url='${pageContext.request.contextPath}/dispatchTransport/indexCheckDispatchTransportList.action?_curModuleCode=DYSXX';
		url=encodeURI(encodeURI(url));
		parent.addTab("运输待调度信息", url);
	}
	//派送待调度
	function getCheckDiapatchInfoUrlPS() {
		var url = "${pageContext.request.contextPath}/dispatchDelivery/queryCheckDispatchDelivery.action?_condition._curModuleCode=DPSXX&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	function CheckDiapatchInfoPS() {
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getCheckDiapatchInfoUrlPS(),
	        async : true,
	        success : function(result) {
	        	$("#dddTotalPS").text(result.total);
	        }
	       }); 
	}
	function tzCheckDiapatchListPS(){
		var url='${pageContext.request.contextPath}/dispatchDelivery/indexCheckDispatchDeliveryList.action?_curModuleCode=DPSXX';
		url=encodeURI(encodeURI(url));
		parent.addTab("派送待调度信息", url);
	}
	//委托待调度
	function getCheckDiapatchInfoUrlWT() {
		var url = "${pageContext.request.contextPath}/dispatchEntrust/queryCheckDispatchEntrust.action?_condition._curModuleCode=DWTXX&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	function CheckDiapatchInfoWT() {
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getCheckDiapatchInfoUrlWT(),
	        async : true,
	        success : function(result) {
	        	$("#dddTotalWT").text(result.total);
	        }
	       }); 
	}
	function tzCheckDiapatchListWT(){
		var url='${pageContext.request.contextPath}/dispatchEntrust/indexCheckDispatchEntrustList.action?_curModuleCode=DWTXX';
		url=encodeURI(encodeURI(url));
		parent.addTab("委托待调度信息", url);
	}
	//提货调度
	function setDispatchInfoTH() {
		var YCYWCAccount=0;
		var YCZAccount=0;
		var ZZZXAccount=0;
		var WZXAccount=0;
		var YJWCAccount=0;
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getDispatchInfoUrlTH(),
	        async : true,
	        success : function(result) {
	        	$("#dispatchTotalTH").text(result.total);
	        	for(i=0;i<result.total; i++){
	      
				if (result.rows[i].exception_code == "YCYWC") {
						YCYWCAccount += 1;
					}
					if (result.rows[i].exception_code == "YCZ") {
						YCZAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "ZZZX") {
						ZZZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "WZX") {
						WZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "YJWC") {

						YJWCAccount += 1;
					}
				}
	        	$("#YCYWCAccountTH").text(YCYWCAccount);
	        	$("#YCZAccountTH").text(YCZAccount);
	        	$("#ZZZXAccountTH").text(ZZZXAccount);
	        	$("#WZXAccountTH").text(WZXAccount);
	        	$("#YJWCAccountTH").text(YJWCAccount);
			}
		});
	}
	function getDispatchInfoUrlTH() {
		var url = "${pageContext.request.contextPath}/dispatchPickUp/queryDispatchList.action?_condition._curModuleCode=DDDGL&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	
	function tzDispatchListTH(disValue,excepValue){
		var url='${pageContext.request.contextPath}/dispatchPickUp/initDispatchList.action?_curModuleCode=DDDGL'+"&_dispatchStatusFromIndex="+disValue+"&_exceptionCodeFromIndex="+excepValue;
		url=encodeURI(encodeURI(url));
		parent.addTab("提货调度单管理", url);
	}
//运输调度
	function setDispatchInfoYS() {
		var YCYWCAccount=0;
		var YCZAccount=0;
		var ZZZXAccount=0;
		var WZXAccount=0;
		var YJWCAccount=0;
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getDispatchInfoUrlYS(),
	        async : true,
	        success : function(result) {
	        	$("#dispatchTotalYS").text(result.total);
	        	for(i=0;i<result.total; i++){
	      
				if (result.rows[i].exception_code == "YCYWC") {
						YCYWCAccount += 1;
					}
					if (result.rows[i].exception_code == "YCZ") {
						YCZAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "ZZZX") {
						ZZZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "WZX") {
						WZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "YJWC") {

						YJWCAccount += 1;
					}
				}
	        	$("#YCYWCAccountYS").text(YCYWCAccount);
	        	$("#YCZAccountYS").text(YCZAccount);
	        	$("#ZZZXAccountYS").text(ZZZXAccount);
	        	$("#WZXAccountYS").text(WZXAccount);
	        	$("#YJWCAccountYS").text(YJWCAccount);
			}
		});
	}
	function getDispatchInfoUrlYS() {
		var url = "${pageContext.request.contextPath}/dispatchTransport/queryDispatchList.action?_condition._curModuleCode=DDDGL&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	
	function tzDispatchListYS(disValue,excepValue){
		var url='${pageContext.request.contextPath}/dispatchTransport/initDispatchList.action?_curModuleCode=DDDGL'+"&_dispatchStatusFromIndex="+disValue+"&_exceptionCodeFromIndex="+excepValue;
		url=encodeURI(encodeURI(url));
		parent.addTab("运输调度单管理", url);
	}
	//派送调度
	function setDispatchInfoPS() {
		var YCYWCAccount=0;
		var YCZAccount=0;
		var ZZZXAccount=0;
		var WZXAccount=0;
		var YJWCAccount=0;
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getDispatchInfoUrlPS(),
	        async : true,
	        success : function(result) {
	        	$("#dispatchTotalPS").text(result.total);
	        	for(i=0;i<result.total; i++){
	      
				if (result.rows[i].exception_code == "YCYWC") {
						YCYWCAccount += 1;
					}
					if (result.rows[i].exception_code == "YCZ") {
						YCZAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "ZZZX") {
						ZZZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "WZX") {
						WZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "YJWC") {

						YJWCAccount += 1;
					}
				}
	        	$("#YCYWCAccountPS").text(YCYWCAccount);
	        	$("#YCZAccountPS").text(YCZAccount);
	        	$("#ZZZXAccountPS").text(ZZZXAccount);
	        	$("#WZXAccountPS").text(WZXAccount);
	        	$("#YJWCAccountPS").text(YJWCAccount);
			}
		});
	}
	function getDispatchInfoUrlPS() {
		var url = "${pageContext.request.contextPath}/dispatchDelivery/queryDispatchList.action?_condition._curModuleCode=DDDGL&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	
	function tzDispatchListPS(disValue,excepValue){
		var url='${pageContext.request.contextPath}/dispatchDelivery/initDispatchList.action?_curModuleCode=DDDGL'+"&_dispatchStatusFromIndex="+disValue+"&_exceptionCodeFromIndex="+excepValue;
		url=encodeURI(encodeURI(url));
		parent.addTab("派送调度单管理", url);
	}
	//委托调度
	function setDispatchInfoWT() {
		var YCYWCAccount=0;
		var YCZAccount=0;
		var ZZZXAccount=0;
		var WZXAccount=0;
		var YJWCAccount=0;
		$.ajax({
	        type : 'post',
	        cache : false,
	        url : getDispatchInfoUrlWT(),
	        async : true,
	        success : function(result) {
	        	$("#dispatchTotalWT").text(result.total);
	        	for(i=0;i<result.total; i++){
	      
				if (result.rows[i].exception_code == "YCYWC") {
						YCYWCAccount += 1;
					}
					if (result.rows[i].exception_code == "YCZ") {
						YCZAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "ZZZX") {
						ZZZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "WZX") {
						WZXAccount += 1;

					}
					if (result.rows[i].dispatch_status_code == "YJWC") {

						YJWCAccount += 1;
					}
				}
	        	$("#YCYWCAccountWT").text(YCYWCAccount);
	        	$("#YCZAccountWT").text(YCZAccount);
	        	$("#ZZZXAccountWT").text(ZZZXAccount);
	        	$("#WZXAccountWT").text(WZXAccount);
	        	$("#YJWCAccountWT").text(YJWCAccount);
			}
		});
	}
	function getDispatchInfoUrlWT() {
		var url = "${pageContext.request.contextPath}/dispatchEntrust/queryDispatchList.action?_condition._curModuleCode=DDDGL&len=10000";
		url = encodeURI(encodeURI(url));
		return url;
	}
	
	
	function tzDispatchListWT(disValue,excepValue){
		var url='${pageContext.request.contextPath}/dispatchEntrust/initDispatchList.action?_curModuleCode=DDDGL'+"&_dispatchStatusFromIndex="+disValue+"&_exceptionCodeFromIndex="+excepValue;
		url=encodeURI(encodeURI(url));
		parent.addTab("委托调度单管理", url);
	}
</script>
</head>
<body class="gray-bg" >
	<div class="row">
		<div class="col-sm-12">

			<div class="ibox-content m-b-sm border-bottom">
				<div class="p-xs">
					<div class="pull-left m-r-md">
						<i class="fa fa-truck text-navy mid-icon"></i>
					</div>
					<h2>欢迎使用 全高项目管理系统</h2>
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
											<i class="fa fa-question"></i>
										</div>
										<div class="col-sm-3">
											<div class="vertical-timeline-content">
											<h2>待提货</h2>
											<hr />
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dddTotalTH"></h4>
												</div>
											</div>
											<a onClick="tzCheckDiapatchListTH()" href="javascript:void(0);" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<div class="col-sm-3">
											<div class="vertical-timeline-content">
											<h2>待运输</h2>
											<hr />
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dddTotalYS"></h4>
												</div>
											</div>
											<a onClick="tzCheckDiapatchListYS()" href="javascript:void(0);" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<div class="col-sm-3">
											<div class="vertical-timeline-content">
											<h2>待派送</h2>
											<hr />
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dddTotalPS"></h4>
												</div>
											</div>
											<a onClick="tzCheckDiapatchListPS()" href="javascript:void(0);" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<!-- <div class="col-sm-3">
											<div class="vertical-timeline-content">
											<h2>待委托</h2>
											<hr />
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dddTotalWT" ></h4>
												</div>
											</div>
											<a onClick="tzCheckDiapatchListWT()" href="javascript:void(0);" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div> -->
									</div>
									
									<div class="vertical-timeline-block">
									<div class="col-sm-3">
										<div class="vertical-timeline-icon lazur-bg">
											<i class="fa fa-truck"></i>
										</div >
										<div class="vertical-timeline-content">
											<h2>提货调度单</h2>
											<hr />
											<div class="row">
												<div class="col-sm-7">
													<h4>总数</h4>
												</div>
													<div class="col-sm-5 font-bold text-info">
													<h4 id="dispatchTotalTH" onclick="tzDispatchListTH()" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>未执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="WZXAccountTH" onClick="tzDispatchListTH('WZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>正在执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="ZZZXAccountTH" onClick="tzDispatchListTH('ZZZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常中</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCZAccountTH" onClick="tzDispatchListTH('','YCZ')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCYWCAccountTH" onClick="tzDispatchListTH('','YCYWC')" onmouseover="this.style.cursor='pointer'"></h4>
													
												</div>
												<div class="col-sm-7">
													<h4 >已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
														<h4 id="YJWCAccountTH" onClick="tzDispatchListTH('YJWC','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onclick="tzDispatchListTH()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<div class="col-sm-3">
										<div class="vertical-timeline-content">
											<h2>运输调度单</h2>
											<hr />
											<div class="row">
												<div class="col-sm-7 ">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
														<h4 id="dispatchTotalYS" onclick="tzDispatchListYS()" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>未执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
														<h4 id="WZXAccountYS" onclick="tzDispatchListYS('WZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>正在执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="ZZZXAccountYS" onclick="tzDispatchListYS('ZZZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常中</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCZAccountYS" onclick="tzDispatchListYS('','YCZ')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCYWCAccountYS" onclick="tzDispatchListYS('','YCYWC')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YJWCAccountYS" onclick="tzDispatchListYS('YJWC','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onclick="tzDispatchListYS()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<div class="col-sm-3">
										<div class="vertical-timeline-content">
											<h2>派送调度单</h2>
											<hr />
											<div class="row">
												<div class="col-sm-7">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dispatchTotalPS" onclick="tzDispatchListPS()" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>未执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="WZXAccountPS" onclick="tzDispatchListPS('WZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>正在执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="ZZZXAccountPS" onclick="tzDispatchListPS('ZZZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常中</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCZAccountPS" onclick="tzDispatchListPS('','YCZ')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCYWCAccountPS" onclick="tzDispatchListPS('','YCYWC')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YJWCAccountPS" onclick="tzDispatchListPS('YJWC','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onclick="tzDispatchListPS()" class="btn btn-sm btn-danger">查看所有</a>
										</div>
										</div>
										<div class="col-sm-3">
										<!-- <div class="vertical-timeline-content">
											<h2>委托调度单</h2>
											<hr />
											<div class="row">
												<div class="col-sm-7">
													<h4>总数</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="dispatchTotalWT" onclick="tzDispatchListWT()" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>未执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="WZXAccountWT" onclick="tzDispatchListWT('WZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4>正在执行</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="ZZZXAccountWT" onclick="tzDispatchListWT('ZZZX','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常中</h4>
												</div>
												<div class="col-sm-5 font-bold text-info" >
													<h4 id="YCZAccountWT" onclick="tzDispatchListWT('','YCZ')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >异常已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YCYWCAccountWT" onclick="tzDispatchListWT('','YCYWC')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-7">
													<h4 >已完成</h4>
												</div>
												<div class="col-sm-5 font-bold text-info">
													<h4 id="YJWCAccountWT" onclick="tzDispatchListWT('YJWC','')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onclick="tzDispatchListWT()" class="btn btn-sm btn-danger">查看所有</a>
										</div> -->
										</div>
									</div>
									<div class="vertical-timeline-block">
										<div class="vertical-timeline-icon navy-bg">
											<i class="fa fa-file-text"></i>
										</div>

										<div class="vertical-timeline-content">
											<h2>订单</h2>
											<hr />
											<div class="row">
												<div class="col-sm-5">
													<h4>总数</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="orderTotal" onclick="tzOrderList()" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-5">
													<h4 >已生效</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="SXAccount" onclick="tzOrderList('YQR')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-5">
													<h4>已在途</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="ZTAccount" onclick="tzOrderList('ZT')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
												<div class="col-sm-5 ">
													<h4>已完成</h4>
												</div>
												<div class="col-sm-7 font-bold text-info">
													<h4 id="YQSAccount" onclick="tzOrderList('YQS')" onmouseover="this.style.cursor='pointer'"></h4>
												</div>
											</div>
											<a href="javascript:void(0);" onclick="tzOrderList()" class="btn btn-sm btn-danger">查看所有</a>
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
