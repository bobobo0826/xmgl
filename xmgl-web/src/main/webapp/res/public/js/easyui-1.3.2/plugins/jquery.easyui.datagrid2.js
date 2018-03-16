/**
 * datagrid列表头居中
 */
$.extend($.fn.datagrid.defaults,{  
	 onLoadSuccess : function() {  
	     var target = $(this);  
	     var opts = $.data(this, "datagrid").options;  
		 var panel = $(this).datagrid("getPanel");  
		 var fields=$(this).datagrid('getColumnFields',false);
		 var headerTds =panel.find(".datagrid-view2 .datagrid-header .datagrid-header-inner table tr:first-child").children();
		 headerTds.each(function (i, obj) {
			 var col = target.datagrid('getColumnOption',fields[i]);
			 if (!col.hidden && !col.checkbox) {
			     var headalign=col.headalign||col.align||'left';
			     $("div:first-child", obj).css("text-align", headalign);
			 }
		 });
	}  
}); 