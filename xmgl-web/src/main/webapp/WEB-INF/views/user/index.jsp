<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String menu = (String) request.getAttribute("menu");
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta http-equiv="Cache-Control" content="no-siteapp" />
<title>全高项目管理系统</title>
 
<!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->

<link rel="shortcut icon" href="../logo/favicon.ico"> 
<link rel="icon" type="image/gif" href="../logo/animated_favicon1.gif" >
<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>
<style type="text/css">

body{
    height: 100%;
}
</style>
</head>

<body class="fixed-sidebar full-height-layout gray-bg"
	style="overflow: hidden">
	<div id="wrapper">
		<!--左侧导航开始-->
		<nav class="navbar-default navbar-static-side" role="navigation">
			<div class="nav-close">
				<i class="fa fa-times-circle"></i>
			</div>
			<div class="sidebar-collapse">
				<ul class="nav" id="side-menu">
					<li class="nav-header" id="nav-header">
						<div class="dropdown profile-element">
							<span><img alt="image" class="img-circle"
								src="${pageContext.request.contextPath}/res/hplus/img/profile_small.jpg" /></span>
							<a data-toggle="dropdown" class="dropdown-toggle" href="#"> <span
								class="clear"> <span class="block m-t-xs"><strong
										class="font-bold" id="userName">Admin</strong></span> <span
									class="text-muted text-xs block" id="userRole">超级管理员<b class="caret"></b></span>
							</span>
							</a> 
						</div>
						<div class="logo-element">TMS</div>
					</li> 

				</ul>
			</div>
		</nav>
		<!--左侧导航结束-->
		<!--右侧部分开始-->
		<div id="page-wrapper" class="gray-bg dashbard-1">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation"
					style="margin-bottom: 0">
					<div class="navbar-header">
						<a class="navbar-minimalize minimalize-styl-2 btn btn-primary "
							href="#"> <i class="fa fa-bars"></i>
						</a>
						<h1>全高项目管理系统</h1>
					</div> 
					<ul class="nav navbar-top-links navbar-right">
						 <li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-bell"></i> <span class="label label-primary" ><div id = "reminderCount"></div></span>
                            </a>
                            <ul class="dropdown-menu dropdown-alerts" id="isShow">
                                <li id = "HT">
                                    <a class="J_menuItem" id = "reminder">
                                        <div>
                                        <i class="fa fa-file">
                                        </i>
                                        <div id = "news"></div>
                                        </div>
                                    </a>
                                </li>
                                 <li id="THDDD">
                                    <a class="J_menuItem" id = "reminderTHDDD">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsTHDDD"></div>
                                        </div>
                                    </a>
                                </li>
                                
                                 <li id="YSDDD">
                                    <a class="J_menuItem" id = "reminderYSDDD">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsYSDDD"></div>
                                        </div>
                                    </a>
                                </li>
                                 <li id="PSDDD">
                                    <a class="J_menuItem" id = "reminderPSDDD">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsPSDDD"></div>
                                        </div>
                                    </a>
                                </li>
                             <!--     <li id="WTDDD">
                                    <a class="J_menuItem" id = "reminderWTDDD">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsWTDDD"></div>
                                        </div>
                                    </a>
                                </li> -->
                                <li id="DD">
                                    <a class="J_menuItem" id = "reminderDD">
                                        <div>
                                        <i class="fa fa-file">
                                        </i>
                                        <div id = "newsDD"></div>
                                        </div>
                                    </a>
                                </li>
                                <li id="THYDXX">
                                    <a class="J_menuItem" id = "reminderTHYDXX">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsTHYDXX"></div>
                                        </div>
                                    </a>
                                </li>
                                <li id="YSYDXX">
                                    <a class="J_menuItem" id = "reminderYSYDXX">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsYSYDXX"></div>
                                        </div>
                                    </a>
                                </li>
                                <li id="PSYDXX">
                                    <a class="J_menuItem" id = "reminderPSYDXX">
                                        <div>
                                        <i class="fa fa-truck">
                                        </i>
                                        <div id = "newsPSYDXX"></div>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </li>
						<li class="dropdown hidden-xs"><a
							class="right-sidebar-toggle" aria-expanded="false"> <i
								class="fa fa-tasks"></i> 主题
						</a></li>
					</ul>
				</nav>
			</div>
			<div class="row content-tabs">
				<button class="roll-nav roll-left J_tabLeft">
					<i class="fa fa-backward"></i>
				</button>
				<nav class="page-tabs J_menuTabs">
					<div class="page-tabs-content">
						<a href="javascript:void(0);" class="active J_menuTab"
							data-id="${pageContext.request.contextPath}/indexPage.action" target="iframe0">首页</a>
					</div>
				</nav>
				<button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
                </button>
                <div class="btn-group roll-nav roll-right">
                    <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>

                    </button>
                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
                        <li class="J_tabShowActive"><a>定位当前选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                        </li>
                        <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                        </li>
                    </ul>
                </div>
				<a class="roll-nav roll-right J_tabExit" id="exit"><i
					class="fa fa fa-sign-out"></i> 退出</a>
			</div>
			<div class="row J_mainContent" id="content-main">
				<iframe class="J_iframe" name="iframe0" width="100%" height="100%"
					src="${pageContext.request.contextPath}/indexPage.action" frameborder="0"
					data-id="${pageContext.request.contextPath}/indexPage.action" seamless></iframe>
			</div>
			<div class="footer">
				<div class="pull-right">
					&copy; 2016-2017   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    技术支持： 025-84411350</div>
				</div>
			</div>
		</div>
		<!--右侧部分结束-->
		<!--右侧边栏开始-->
		<div id="right-sidebar">
			<div class="sidebar-container">

				<ul class="nav nav-tabs navs-3">

					<li class="active"><a data-toggle="tab" href="#tab-1"> <i
							class="fa fa-gear"></i> 主题
					</a></li>
				</ul>

				<div class="tab-content">
					<div id="tab-1" class="tab-pane active">
						<div class="sidebar-title">
							<h3>
								<i class="fa fa-comments-o"></i> 主题设置
							</h3>
							<small><i class="fa fa-tim"></i>
								你可以从这里选择和预览主题的布局和样式，这些设置会被保存在本地，下次打开的时候会直接应用这些设置。</small>
						</div>
						<div class="skin-setttings">
							<div class="title">主题设置</div>
							<div class="setings-item">
								<span>收起左侧菜单</span>
								<div class="switch">
									<div class="onoffswitch">
										<input type="checkbox" name="collapsemenu"
											class="onoffswitch-checkbox" id="collapsemenu"> <label
											class="onoffswitch-label" for="collapsemenu"> <span
											class="onoffswitch-inner"></span> <span
											class="onoffswitch-switch"></span>
										</label>
									</div>
								</div>
							</div>
							<div class="setings-item">
								<span>固定顶部</span>

								<div class="switch">
									<div class="onoffswitch">
										<input type="checkbox" name="fixednavbar"
											class="onoffswitch-checkbox" id="fixednavbar"> <label
											class="onoffswitch-label" for="fixednavbar"> <span
											class="onoffswitch-inner"></span> <span
											class="onoffswitch-switch"></span>
										</label>
									</div>
								</div>
							</div>
							<div class="setings-item">
								<span> 固定宽度 </span>

								<div class="switch">
									<div class="onoffswitch">
										<input type="checkbox" name="boxedlayout"
											class="onoffswitch-checkbox" id="boxedlayout"> <label
											class="onoffswitch-label" for="boxedlayout"> <span
											class="onoffswitch-inner"></span> <span
											class="onoffswitch-switch"></span>
										</label>
									</div>
								</div>
							</div>
							<div class="title">皮肤选择</div>
							<div class="setings-item default-skin nb">
								<span class="skin-name "> <a href="#" class="s-skin-0">
										默认皮肤 </a>
								</span>
							</div>
							<div class="setings-item blue-skin nb">
								<span class="skin-name "> <a href="#" class="s-skin-1">
										蓝色主题 </a>
								</span>
							</div>
							<div class="setings-item yellow-skin nb">
								<span class="skin-name "> <a href="#" class="s-skin-3">
										黄色/紫色主题 </a>
								</span>
							</div>
						</div>
					</div>
					
				</div>

			</div>
		</div>
		<!--右侧边栏结束--> 
	<script
		src="${pageContext.request.contextPath}/res/hplus/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/res/hplus/js/plugins/pace/pace.min.js"></script>
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/res/private/js/index/menu.index_new.js"
		charset="UTF-8"></script>
</body>
<script type="text/javascript">
var _reminderCount = 0;
var _menus=<%=menu%>;

if(typeof(_menus.menus)=="undefined")
{
	parent.location.href="${pageContext.request.contextPath}login_new.jsp";
}
$(function() {  
	InitLeftMenu("${pageContext.request.contextPath}");
	//时间显示
	//clockon();
	//设置用户名		
	setUserInfo(); 
	setReminderCntOverInfo();
	setReminderTHDDDYJInfo();
	setReminderTHYDXXInfo();
	setReminderYSYDXXInfo();
	setReminderPSYDXXInfo();
	setReminderYSDDDYJInfo();
	setReminderPSDDDYJInfo();
//	setReminderWTDDDYJInfo();
	setReminderDDYJInfo();
	//退回系统       
	$("#exit")
			.click(
					function() {
						/* if (confirm("您确定要退出本次登录吗？")) {
							window.location = '${pageContext.request.contextPath}/logout.action';
						} */
						
						parent.layer.confirm('您确定要退出系统吗？', {
						    btn: ['确定','取消'], //按钮
						    shade: false //不显示遮罩
						}, function(){
							window.location = '${pageContext.request.contextPath}/logout.action';
						}, function(){
							return
						});
					})
	$("#reminder")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/cnt/indexCntList.action?_reminder=HTGQTX";
						parent.addTab("合同管理", url);
					})
	$("#reminderTHDDD")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/dispatchPickUp/initDispatchList.action?_reminder=THDDDYJ"+"&_curModuleCode=DDDGL";
						parent.addTab("提货调度单管理", url);
					})
	$("#reminderYSDDD")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/dispatchTransport/initDispatchList.action?_reminder=YSDDDYJ"+"&_curModuleCode=DDDGL";
						parent.addTab("运输调度单管理", url);
					})
	$("#reminderPSDDD")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/dispatchDelivery/initDispatchList.action?_reminder=PSDDDYJ"+"&_curModuleCode=DDDGL";
						parent.addTab("派送调度单管理", url);
					})
	$("#reminderWTDDD")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/dispatchEntrust/initDispatchList.action?_reminder=WTDDDYJ"+"&_curModuleCode=DDDGL";
						parent.addTab("委托调度单管理", url);
					})
	$("#reminderDD")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/order/initOrderList.action?_reminder=DDYJ"+"&_curModuleCode=DDGL";
						parent.addTab("订单管理", url);
					})
	$("#reminderTHYDXX")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=TH&_reminder=index";
						parent.addTab("提货运单管理", url);
					})
	$("#reminderYSYDXX")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=YS&_reminder=index";
						parent.addTab("运输运单管理", url);
					})
	$("#reminderPSYDXX")
			.click(
					function() {
						var url = "${pageContext.request.contextPath}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=PS&_reminder=index";
						parent.addTab("派送运单管理", url);
					})
	// 通过遍历给菜单项加上data-index属性
	$(".J_menuItem").each(function(index) {
		if (!$(this).attr('data-index')) {
			$(this).attr('data-index', index);
		}
	});
	$('.J_menuItem').on('click', menuItem);
	$('.J_menuTabs').on('click', '.J_menuTab i', closeTab);
	$('.J_menuTabs').on('click', '.J_menuTab', activeTab);
	$('.J_menuTabs').on('dblclick', '.J_menuTab', refreshTab);

	// 左移按扭
	$('.J_tabLeft').on('click', scrollTabLeft);

	// 右移按扭
	$('.J_tabRight').on('click', scrollTabRight);
	$('.J_tabCloseOther').on('click', closeOtherTabs);
	$('.J_tabShowActive').on('click', showActiveTab);
	// 关闭全部
	$('.J_tabCloseAll').on(
			'click',
			function() {
				$('.page-tabs-content').children("[data-id]").not(":first").each(
						function() {
							$('.J_iframe[data-id="' + $(this).data('id') + '"]')
									.remove();
							$(this).remove();
						});
				$('.page-tabs-content').children("[data-id]:first").each(
						function() {
							$('.J_iframe[data-id="' + $(this).data('id') + '"]')
									.show();
							$(this).addClass("active");
						});
				$('.page-tabs-content').css("margin-left", "0");
			});
});
function setUserInfo() {
	var userName = '<s:property value="#session.curUser.userName" />';
	var displayName = '<s:property value="#session.curUser.displayName" />';
	var userDesc = '<s:property value="#session.curUser.mainRole" />';
	$('#userName').html(userName+"/"+displayName);
	$('#userRole').html(userDesc);
}
function setReminderCntOverInfo(){
	var url = "${pageContext.request.contextPath}/cnt/queryCntListWillOverCount.action";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#news").html('您有<span style=\"color:red\">'+response.count+'</span>条合同即将过期');
			_reminderCount = response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#HT").hide();
			}
		}
	});
}
function setReminderTHDDDYJInfo(){
	var url = "${pageContext.request.contextPath}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=THDDDYJ"+"&_curModuleCode=DDDGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsTHDDD").html('您有<span style=\"color:red\">'+response.count+'</span>条提货调度单超出预计到达时间');
			_reminderCount += response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#THDDD").hide();
			}
		}
	});
}
function setReminderTHYDXXInfo(){
	var url = "${pageContext.request.contextPath}/waybillManage/getComingWaybillCount.action?_bussinessType=TH&_curModuleCode=YDXXGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsTHYDXX").html('您有<span style=\"color:red\">'+response+'</span>条提货运单即将到达!');
			_reminderCount += response;
			$("#reminderCount").html(_reminderCount);
			if(response==0){
				$("#THYDXX").hide();
			}
		}
	});
}
function setReminderYSYDXXInfo(){
	var url = "${pageContext.request.contextPath}/waybillManage/getComingWaybillCount.action?_bussinessType=YS&_curModuleCode=YDXXGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsYSYDXX").html('您有<span style=\"color:red\">'+response+'</span>条运输运单即将到达!');
			_reminderCount += response;
			$("#reminderCount").html(_reminderCount);
			if(response==0){
				$("#YSYDXX").hide();
			}
		}
	});
}
function setReminderPSYDXXInfo(){
	var url = "${pageContext.request.contextPath}/waybillManage/getComingWaybillCount.action?_bussinessType=PS&_curModuleCode=YDXXGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsPSYDXX").html('您有<span style=\"color:red\">'+response+'</span>条派送运单即将到达!');
			_reminderCount += response;
			$("#reminderCount").html(_reminderCount);
			if(response==0){
				$("#PSYDXX").hide();
			}
		}
	});
}


function setReminderYSDDDYJInfo(){
	var url = "${pageContext.request.contextPath}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=YSDDDYJ"+"&_curModuleCode=DDDGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsYSDDD").html('您有<span style=\"color:red;\">'+response.count+'</span>条运输调度单超出预计到达时间');
			_reminderCount += response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#YSDDD").hide();
			}
		}
	});
}
function setReminderPSDDDYJInfo(){
	var url = "${pageContext.request.contextPath}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=PSDDDYJ"+"&_curModuleCode=DDDGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsPSDDD").html('您有<span style=\"color:red\">'+response.count+'</span>条派送调度单超出预计到达时间');
			_reminderCount += response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#PSDDD").hide();
			}
		}
	});
}
function setReminderWTDDDYJInfo(){
	var url = "${pageContext.request.contextPath}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=WTDDDYJ"+"&_curModuleCode=DDDGL";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsWTDDD").html('您有<span style=\"color:red\">'+response.count+'</span>条委托调度单超出预计到达时间');
			_reminderCount += response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#WTDDD").hide();
			}
		}
	});
}
function setReminderDDYJInfo(){
	var url = "${pageContext.request.contextPath}/order/queryCntListWillDDYJCount.action";
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			$("#newsDD").html('您有<span style=\"color:red\">'+response.count+'</span>条订单超出要求到达时间');
			_reminderCount += response.count;
			$("#reminderCount").html(_reminderCount);
			if(response.count==0){
				$("#DD").hide();
			}
		}
	});
}
</script>
<script
		src="${pageContext.request.contextPath}/res/hplus/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
		src="${pageContext.request.contextPath}/res/hplus/js/hplus.js?v=4.1.0"></script> 
<script
		src="${pageContext.request.contextPath}/res/hplus/js/contabs.js"></script> 
		
</html>
