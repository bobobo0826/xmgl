<%@ page language="java" contentType="text/html; charset=GBK" %>
<html>
 <head>
   <meta http-equiv="Content-Type" content="text/html;   charset=gb2312">
	<script src="${root}/javascripts/taskMenu.js" type="text/javascript"></script>
    <script type="text/javascript">
		var taskMenuEnt;
		var taskMenuMontior;
		var taskMenuQuery;
		var taskMenuAuditing;
		
		var taskMenuSys; 
		var taskMenuAbout;
		
		TaskMenu.setStyle("${root}/css/blueStyle.css");
		window.onload = function()
		{
		
		    TaskMenu.setHeadMenuSpecial(false);
			TaskMenu.setScrollbarEnabled(true);
			TaskMenu.setAutoBehavior(true);
  
	        taskMenuEnt1 = new TaskMenu("权限管理",true);

	 	    itemEnt10= new TaskMenuItem("角色管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQueryRole.action'");
	 	    itemEnt20= new TaskMenuItem("模块管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQueryModule.action'");
	 	    itemEnt30= new TaskMenuItem("模块角色配置","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsMRQuery.action'");
	 	    itemEnt4 = new TaskMenuItem("模块菜单项配置","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/mmQuery.action'");
	 	    itemEnt5 = new TaskMenuItem("菜单树管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/indexHtml.action'");
	 	    itemEnt60= new TaskMenuItem("操作添加","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcOprIndexList.action'");
	 	    itemEnt70= new TaskMenuItem("操作初始化","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcOprIndex.action'");
	 	    itemEnt71 = new TaskMenuItem("状态管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcQueryStatus.action'");
	 	    itemEnt72 = new TaskMenuItem("部门级别管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcQueryDeptLevel.action'");
	 	    itemEnt73 = new TaskMenuItem("子系统管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQuerySubSys.action'");
	 	    itemEnt8 = new TaskMenuItem("Xml文件管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/menuList.action'");
	 	   	itemEnt11 = new TaskMenuItem("模块角色操作状态","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsMROQuery.action'");
	 	  	itemEnt12= new TaskMenuItem("返回值管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcMapRetValue.action'");
	 	  	itemEnt13= new TaskMenuItem("子系统菜单模块管理","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/menuModuleList.action'");
	        taskMenuEnt1.add(itemEnt10);
	        taskMenuEnt1.add(itemEnt20);
	        taskMenuEnt1.add(itemEnt30);
	        taskMenuEnt1.add(itemEnt4);
	        taskMenuEnt1.add(itemEnt5);
	        taskMenuEnt1.add(itemEnt60);
	        taskMenuEnt1.add(itemEnt70);
	        taskMenuEnt1.add(itemEnt71);
	        taskMenuEnt1.add(itemEnt72);
	        taskMenuEnt1.add(itemEnt73);
	        taskMenuEnt1.add(itemEnt8);
	        taskMenuEnt1.add(itemEnt11);
	        taskMenuEnt1.add(itemEnt12);
	        taskMenuEnt1.add(itemEnt13);
	        taskMenuEnt1.init();
		
		}
</script>
 </head>
</html>
