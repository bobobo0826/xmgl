<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@page import="com.qgbest.xmgl.user.api.entity.TcUser"%>
<% 
	String menu = (String) request.getAttribute("menu");
	//String
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

<link rel="shortcut icon" href="../../logo/favicon.ico">
<link rel="icon" type="image/gif" href="../../logo/animated_favicon1.gif" >
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
						<div class="dropdown profile-element" style="text-align:center;">
							<span><img alt="image" class="img-circle"
								src="${root}/res/hplus/img/profile_small.jpg" id="photoImg" style="width:64px;height:64px"/></span>
							<a data-toggle="dropdown" class="dropdown-toggle" href="#"> <span
								class="clear"> <span class="block m-t-xs"><strong
										class="font-bold" id="userName">Admin</strong></span> <span
									class="text-muted text-xs block" id="userRole">超级管理员<b class="caret"></b></span>
							</span>
							</a> 
						</div>
						<div class="logo-element">全高</div>
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
						<li class="dropdown hidden-xs" >
							<a id="navigationSearch" class="dropdown-toggle count-info" data-toggle="dropdown" aria-expanded="false" href="#">
								<i class="glyphicon glyphicon-search"></i>
							</a>
							<ul class="dropdown-menu dropdown-alerts" id="isShows" style="width:380px;">
								<%@ include file="/WEB-INF/views/navigation/navigation.jsp" %>
							</ul>
						</li>
						<li class="dropdown">
							<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
								更新日志 <span class="label label-primary" ></span>
							</a>
							<ul class="dropdown-menu dropdown-messages">
								<li class="m-t-xs">
									<div class="dropdown-messages-box" id="updateLog" style="white-space:normal;height:200px;width:235px;overflow-x:hidden;overflow-y:auto;line-height: 12px">

									</div>
								</li>
							</ul>
						</li>

						 <li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-bell"></i> <span class="label label-primary" ><div id = "reminderCount"></div></span>
                            </a>

							 <ul class="dropdown-menu dropdown-messages" id="newMessage" style="height: 268px;overflow-x:hidden;overflow-y:auto;">

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
							data-id="${root}/manage/index/indexPage" target="iframe0">首页</a>
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
					src="${root}/manage/index/indexPage" frameborder="0"
					data-id="${root}/manage/index/indexPage" seamless allowfullscreen mozallowfullscreen msallowfullscreen webkitallowfullscreen></iframe>
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
		src="${root}/res/hplus/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script
		src="${root}/res/hplus/js/plugins/pace/pace.min.js"></script>
	<script type="text/javascript"
		src="${root}/res/private/js/index/menu.index_new.js"
		charset="UTF-8"></script>
	<input type="hidden" id="photo" value="${photo}"/>
	<input  type="hidden" id="imageUrl"   value="${imageUrl}" />
</body>
<script type="text/javascript">
var _reminderCount = 0;
var userId ;

var _menus=<%=menu%>;


if(typeof(_menus.menus)=="undefined")
{
	parent.location.href="${root}login_new.jsp";
}
$(function() {
    getUpdateLog();
	InitLeftMenu("${root}");




	//时间显示
	//clockon();
	//设置用户名		
	setUserInfo();
	setReminderCntOverInfo();
//	setReminderTHDDDYJInfo();
//	setReminderTHYDXXInfo();
//	setReminderYSYDXXInfo();
//	setReminderPSYDXXInfo();
//	setReminderYSDDDYJInfo();
//	setReminderPSDDDYJInfo();
////	setReminderWTDDDYJInfo();
//	setReminderDDYJInfo();
	//退回系统       
	$("#exit")
			.click(
					function() {
						parent.layer.confirm('您确定要退出系统吗？', {
						    btn: ['确定','取消'], //按钮
						    shade: false //不显示遮罩
						}, function(){
							window.location = '${root}/manage/index/logout';
						}, function(){
							return
						});
					})
	<%--$("#reminder")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/cnt/indexCntList.action?_reminder=HTGQTX";--%>
						<%--parent.addTab("合同管理", url);--%>
					<%--})--%>
	<%--$("#reminderTHDDD")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/dispatchPickUp/initDispatchList.action?_reminder=THDDDYJ"+"&_curModuleCode=DDDGL";--%>
						<%--parent.addTab("提货调度单管理", url);--%>
					<%--})--%>
	<%--$("#reminderYSDDD")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/dispatchTransport/initDispatchList.action?_reminder=YSDDDYJ"+"&_curModuleCode=DDDGL";--%>
						<%--parent.addTab("运输调度单管理", url);--%>
					<%--})--%>
	<%--$("#reminderPSDDD")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/dispatchDelivery/initDispatchList.action?_reminder=PSDDDYJ"+"&_curModuleCode=DDDGL";--%>
						<%--parent.addTab("派送调度单管理", url);--%>
					<%--})--%>
	<%--$("#reminderWTDDD")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/dispatchEntrust/initDispatchList.action?_reminder=WTDDDYJ"+"&_curModuleCode=DDDGL";--%>
						<%--parent.addTab("委托调度单管理", url);--%>
					<%--})--%>
	<%--$("#reminderDD")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/order/initOrderList.action?_reminder=DDYJ"+"&_curModuleCode=DDGL";--%>
						<%--parent.addTab("订单管理", url);--%>
					<%--})--%>
	<%--$("#reminderTHYDXX")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=TH&_reminder=index";--%>
						<%--parent.addTab("提货运单管理", url);--%>
					<%--})--%>
	<%--$("#reminderYSYDXX")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=YS&_reminder=index";--%>
						<%--parent.addTab("运输运单管理", url);--%>
					<%--})--%>
	<%--$("#reminderPSYDXX")--%>
			<%--.click(--%>
					<%--function() {--%>
						<%--var url = "${root}/waybillManage/indexWaybillBaseList.action?_curModuleCode=YDXXGL&_bussinessType=PS&_reminder=index";--%>
						<%--parent.addTab("派送运单管理", url);--%>
					<%--})--%>
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
function getUpdateLog(){
    var url = "${root}/manage/updateLogManage/getLatestUpdateLog";
    $.ajax({
        url:url,
        type:'post',
        cache:false,
        async:false,
        success:function(data){
           // alert(JSON.stringify(data));
			var response = data.updateLogList;
            var html="";
            for(var i=0;i<response.length;i++){
                if(i==0){
                    html+='<p><strong id="updateDate" style="font-size: 15px;">'+response[i].update_date+'</strong>&nbsp;&nbsp;' +
						'<strong id="updateTitle" style="font-size: 15px">'+response[i].title+'</strong></p>' +
						'<p><strong></strong><span id="updateContent" style="font-size: 12px">'+response[i].content+'</span></p> ' +
						'<div class="link-block" style="right:0px;position:absolute;top:10px;">' +
						'<a class="J_menuItem" id="more" style="font-size: 12px" onclick="initLeftLog(1)">更多</a>' +
						'<a class="J_menuItem" id="less" style="font-size: 12px;display:none" onclick="initLeftLog(2)">收缩</a></div>';
				}else{
                    html+='<div class="leftLog"  style="display:none;margin-top:20px;"><p><strong id="updateDate" style="font-size: 15px;">'+response[i].update_date+'</strong>&nbsp;&nbsp;' +
                        '<strong id="updateTitle" style="font-size: 15px">'+response[i].title+'</strong></p>' +
                        '<p><strong></strong><span id="updateContent" style="font-size: 12px">'+response[i].content+'</span></p> </div>' ;
				}
			}
			$("#updateLog").html(html)


        }
    });
}
function initLeftLog(type){
    $(".leftLog").toggle(300);
    if(type==1){
        $("#more").hide();
        $("#less").show();
	}else{
        $("#more").show();
        $("#less").hide();
	}
}
function setUserInfo() {
	<% TcUser user = (TcUser)session.getAttribute("curUser");%>
	userId = '<%=user.getId()%>';
	var userName = '<%=user.getUserName()%>';
	var displayName = '<%=user.getDisplayName()%>';
	var userDesc = '<%=user.getUserDesc()%>';
	if(userDesc==null||userDesc=="null"){
		userDesc="";
	}
	$('#userName').html(userName+"/"+displayName);
	$('#userRole').html(userDesc);
	if($("#photo").val()!=""){
		$("#photoImg").attr('src',$("#imageUrl").val()+$("#photo").val());
	}
}
function setReminderCntOverInfo(){
	var url = "${root}/manage/message/getMessageList?is_checked=0&receiver_id="+userId;//查询未读消息
	$.ajax({
		url:url,
		type:'post',
		cache:false,
		async:false,
		success:function(response){
			_reminderCount = response.length;
			$("#reminderCount").html(_reminderCount);
			if(response.length==0){
				$("#newMessage").hide();
			}else if(response.length==1){
                document.getElementById("newMessage").style.height="164px";
			}else if(response.length==2){
                document.getElementById("newMessage").style.height="268px";
            }
            var html="";
			for(var i=0;i<response.length;i++){
				if(i==0||i==1){
					html+='<li><div class="dropdown-messages-box">'+
						'<div class="media-body ">'+
						'<a style="padding:0px"><strong onclick="checkMessage(\''+response[i].business_type+'\','+response[i].business_id+','+response[i].id+')">'+response[i].remind_title+'</strong></a><br>'+
						'<p>'+response[i].remind_content+'</p>'+
						'<small class="pull-right text-navy">'+response[i].timeDiff+' '+response[i].remind_time+'</small>'+
						'</div> </div> </li>'+
						'<li class="divider"></li>';
				}else{
					html+='<div class="newMessage" style="display:none;margin-top:20px">' +
						'<li><div class="dropdown-messages-box">'+
						'<div class="media-body ">'+
						'<a style="padding:0px"><strong onclick="checkMessage(\''+response[i].business_type+'\','+response[i].business_id+','+response[i].id+')">'+response[i].remind_title+'</strong></a><br>'+
						'<p>'+response[i].remind_content+'</p>'+
						'<small class="pull-right text-navy">'+response[i].timeDiff+' '+response[i].remind_time+'</small>'+
						'</div> </div> </li>'+
						'<li class="divider"></li></div>';
				}

			}

			html+='<li> <div class="text-center link-block">'+
                '<a class="J_menuItem"  data-index="88" id="markAllMessage" onclick="markAllMessage()"><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span><strong> 全部标为已读</strong></a>'+
                '<a class="J_menuItem"  data-index="88" id="moreMessage" onclick="initMoreMessage(1)"><span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span><strong> 展开</strong></a>' +
                '<a class="J_menuItem"  data-index="88" id="lessMessage" onclick="initMoreMessage(2)" style="display: none"><span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span><strong> 收缩</strong></a>'+
				'</div></li>';
            $("#newMessage").html(html);

        }
	});
}
function initMoreMessage(type){
    $(".newMessage").toggle(300);
    if(type==1){
        $("#moreMessage").hide();
        $("#lessMessage").show();
    }else{
        $("#moreMessage").show();
        $("#lessMessage").hide();
    }
}
function checkMessage(log_type, log_id, message_id ){
    var url1;
    if(log_type=="MRJH"){
        url1="${root}/manage/dayLog/initDayLogInfo/"+log_id+"/comments/MRJH";
	}
	if(log_type=="MZJH"){
        var url1 = "${root}/manage/weekLog/weekLogInfoIndex/"+log_id+"/comments/MZJH";
    }
    if(log_type=="MYJH"){
        var url1 = "${root}/manage/monthLog/monthLogInfo/"+log_id+"/comments/MYJH";
    }
    url1=encodeURI(encodeURI(url1));
    parent.addTab("日志详情", url1);


	var url2 = "${root}/manage/message/checkMessage?id="+message_id;
	url2=encodeURI(encodeURI(url2));
	$.ajax({
		url: url2,
		type : 'post',
		async : false,
		success: function(result) {
		    if(result.msgCode == 1){
                setReminderCntOverInfo();//刷新提醒消息
			}
		}
	});
}

function markAllMessage() {
    var checkType = "markAllMessage";
    var url = "${root}/manage/message/checkMessage?receiver_id="+userId+"&checkType="+checkType;
    url=encodeURI(encodeURI(url));
    $.ajax({
        url: url,
        type : 'post',
        async : false,
        success: function(result) {
            if(result.msgCode == 1){
                setReminderCntOverInfo();//刷新提醒消息
            }
        }
    });

}

function setReminderTHDDDYJInfo(){
	var url = "${root}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=THDDDYJ"+"&_curModuleCode=DDDGL";
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
	var url = "${root}/waybillManage/getComingWaybillCount.action?_bussinessType=TH&_curModuleCode=YDXXGL";
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
	var url = "${root}/waybillManage/getComingWaybillCount.action?_bussinessType=YS&_curModuleCode=YDXXGL";
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
	var url = "${root}/waybillManage/getComingWaybillCount.action?_bussinessType=PS&_curModuleCode=YDXXGL";
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
	var url = "${root}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=YSDDDYJ"+"&_curModuleCode=DDDGL";
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
	var url = "${root}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=PSDDDYJ"+"&_curModuleCode=DDDGL";
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
	var url = "${root}/typCommondispatch/queryCntListWillDDDYJCount.action?_reminder=WTDDDYJ"+"&_curModuleCode=DDDGL";
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
	var url = "${root}/order/queryCntListWillDDYJCount.action";
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
		src="${root}/res/hplus/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
		src="${root}/res/hplus/js/hplus.js?v=4.1.0"></script>
<script
		src="${root}/res/hplus/js/contabs.js"></script>
		
</html>
