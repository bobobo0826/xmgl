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
  
	        taskMenuEnt1 = new TaskMenu("Ȩ�޹���",true);

	 	    itemEnt10= new TaskMenuItem("��ɫ����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQueryRole.action'");
	 	    itemEnt20= new TaskMenuItem("ģ�����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQueryModule.action'");
	 	    itemEnt30= new TaskMenuItem("ģ���ɫ����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsMRQuery.action'");
	 	    itemEnt4 = new TaskMenuItem("ģ��˵�������","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/mmQuery.action'");
	 	    itemEnt5 = new TaskMenuItem("�˵�������","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/indexHtml.action'");
	 	    itemEnt60= new TaskMenuItem("�������","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcOprIndexList.action'");
	 	    itemEnt70= new TaskMenuItem("������ʼ��","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcOprIndex.action'");
	 	    itemEnt71 = new TaskMenuItem("״̬����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcQueryStatus.action'");
	 	    itemEnt72 = new TaskMenuItem("���ż������","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcQueryDeptLevel.action'");
	 	    itemEnt73 = new TaskMenuItem("��ϵͳ����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsQuerySubSys.action'");
	 	    itemEnt8 = new TaskMenuItem("Xml�ļ�����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/menuList.action'");
	 	   	itemEnt11 = new TaskMenuItem("ģ���ɫ����״̬","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tsMROQuery.action'");
	 	  	itemEnt12= new TaskMenuItem("����ֵ����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/tcMapRetValue.action'");
	 	  	itemEnt13= new TaskMenuItem("��ϵͳ�˵�ģ�����","${root}/images/options.gif","parent.mainFrame.location.href='${root}/permission/menuModuleList.action'");
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
