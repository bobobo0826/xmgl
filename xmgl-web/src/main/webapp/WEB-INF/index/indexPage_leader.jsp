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
	//客户
	setCustomerInfo();
	//承运商
	setCarrierInfo();
	//车辆
	setVehicleInfo();
	//司机
	setDriverInfo();
});
function getDriverInfoUrl() {
	var url="${pageContext.request.contextPath}/driverManage/queryDriverList.action?_condition.driveLicenseNum&_treeId=";
	url = encodeURI(encodeURI(url));
	return url;
}
function setDriverInfo(){
	$.ajax({
        type : 'post',
        cache : false,
        url : getDriverInfoUrl(),
        async : true,
        success : function(result) {
        	$("#driverTotal").text(result.total);
		}
	});
}
function tzDriverList() {
	var url = '${pageContext.request.contextPath}/cbm/indexCarrierTree.action?_curModuleCode=CYSGL&_tzDriverFlag=1';
	url=encodeURI(encodeURI(url));
	parent.addTab("承运商管理-所有司机", url);
}


function getVehicleInfoUrl() {
	var url="${pageContext.request.contextPath}/vehicleManage/queryVehicleList.action?_condition.licensePlateNum=&_treeId=";
	url = encodeURI(encodeURI(url));
	return url;
}
function setVehicleInfo(){
	$.ajax({
        type : 'post',
        cache : false,
        url : getVehicleInfoUrl(),
        async : true,
        success : function(result) {
        	$("#vehicleTotal").text(result.total);
		}
	});
}
function tzVehicleList() {
	var url = '${pageContext.request.contextPath}/cbm/indexCarrierTree.action?_curModuleCode=CYSGL&_tzVehicleFlag=1';
	url=encodeURI(encodeURI(url));
	parent.addTab("承运商管理-所有车辆", url);
}


function getCustomerInfoUrl() {
	var url="${pageContext.request.contextPath}/customerManage/queryCustomerList.action?_condition.name=";
	url = encodeURI(encodeURI(url));
	return url;
}
function setCustomerInfo(){
	$.ajax({
        type : 'post',
        cache : false,
        url : getCustomerInfoUrl(),
        async : true,
        success : function(result) {
        	$("#customerTotal").text(result.total);
		}
	});
}
function tzCustomerList() {
	var url = '${pageContext.request.contextPath}/customerManage/indexCustomerList.action?_curModuleCode=KHXXGL';
	url=encodeURI(encodeURI(url));
	parent.addTab("客户管理", url);
}

function getCarrierInfoUrl() {
	var url="${pageContext.request.contextPath}/cbm/queryCarrierBaseList.action";
	url = encodeURI(encodeURI(url));
	return url;
}
function setCarrierInfo(){
	$.ajax({
        type : 'post',
        cache : false,
        url : getCarrierInfoUrl(),
        async : true,
        success : function(result) {
        	$("#carrierTotal").text(result.total);
		}
	});
}
function tzCarrierList() {
	var url = '${pageContext.request.contextPath}/cbm/indexCarrierList.action?_curModuleCode=CYSXXGL';
	url=encodeURI(encodeURI(url));
	parent.addTab("承运商管理", url);
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
							<h2>欢迎使用 TMS-运输管理系统</h2>
							<span>你可以方便的进行工作管理。</span>
					</div>
				</div>
			</div>
			
			<div class="col-sm-12">
                    <div class="wrapper wrapper-content animated fadeInRight" >
                        <div class="ibox-content " >
                        <div class="forum-item" >
                                <div class="row " style="padding-left:10px" >
                                    <div class="col-sm-9" >
                                        <div class="forum-icon">
                                            <i class="fa fa-user-plus " style="color:#1ab394;margin-top:-2px"></i>
                                        </div>
                                        <a href="javascript:void(0);" onclick="tzCustomerList()" class="forum-item-title" style="vertical-align:center">客户</a>
                                    </div>
                                    <div class="col-sm-3">
                                        <a href="javascript:void(0);" onclick="tzCustomerList()" class="forum-item-title" style="vertical-align:center"><span class="views-number " style="color:red"  id="customerTotal">
                                        </span> </a>
                                    </div> 
                                </div>
                            </div>
                            <div class="forum-item">
                                <div class="row" style="padding-left:10px" >
                                    <div class="col-sm-9">
                                        <div class="forum-icon">
                                            <i class="fa fa-users " style="color:#1ab394;margin-top:-2px"></i>
                                        </div>
                                        <a href="javascript:void(0);" onclick="tzCarrierList()" class="forum-item-title" style="vertical-align:center">承运商</a>
                                    </div>
                                    <div class="col-sm-3">
                                        <a href="javascript:void(0);" onclick="tzCarrierList()" class="forum-item-title" style="vertical-align:center"><span class="views-number " style="color:red" id="carrierTotal" >
                                        </span> </a>
                                    </div> 
                                </div>
                            </div>
                            <div class="forum-item">
                                <div class="row" style="padding-left:10px">
                                    <div class="col-sm-9">
                                        <div class="forum-icon" >
                                            <i class="fa fa-truck " style="color:#1ab394;margin-top:-2px"></i>
                                        </div>
                                        <a style="vertical-align:middle" href="javascript:void(0);" onclick="tzVehicleList()" class="forum-item-title" style="vertical-align:center">车辆</a>
                                    </div>
                                    <div class="col-sm-3" >
                                        <a style="vertical-align:middle" href="javascript:void(0);" onclick="tzVehicleList()" class="forum-item-title" style="vertical-align:center"><span class="views-number " style="color:red"  id="vehicleTotal">
                                        </span> </a>
                                    </div> 
                                </div>
                            </div>
                            <div class="forum-item ">
                                <div class="row" style="padding-left:10px">
                                    <div class="col-sm-9">
                                        <div class="forum-icon">
                                            <i class="fa fa-user " style="color:#1ab394;margin-top:-2px"></i>
                                        </div>
                                        <a href="javascript:void(0);" onclick="tzDriverList()" class="forum-item-title" style="vertical-align:center">司机</a>
                                    </div>
                                    <div class="col-sm-3">
                                        <a href="javascript:void(0);" onclick="tzDriverList()" class="forum-item-title" style="vertical-align:center"><span class="views-number " style="color:red"  id="driverTotal">
                                        </span></a>
                                    </div> 
                                </div>
                            </div>
                        </div>
                    </div>
		</div>
	</div>
</body>

</html>
